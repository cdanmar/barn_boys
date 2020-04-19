#**********************************************************
# Deploy the application route(s) for ingress controller
#**********************************************************
function Check-IngressIsUnique {
    param (
        [Parameter (Mandatory=$true)] [string] $AppNameSpace,
        [Parameter (Mandatory=$true)] [string] $AppRoute
    )
    
    $IsValidIngress = $false

    # Need all the ingresses from all the namespaces
    $AllIngressRoutes = kubectl --kubeconfig "$KUBE_CONFIG_PATH" get ingress --all-namespaces -o json | Convertfrom-json
    # Set both to lowercase before doing the check, to validate
    $AllMatchingPaths = $AllIngressRoutes.items | Where-Object {$_.spec.rules.http.paths.path.ToLower() -eq $AppRoute.ToLower()}
    If ($AllMatchingPaths)
    {
        $MatchingRouteDiffNameSpace = $AllMatchingPaths | Where-Object {$_.metadata.namespace -ne $AppNameSpace}
        If ($MatchingRouteDiffNameSpace)
        {
            # $IsValidIngress will be false
            # This will error out (i.e. Throw) outside the function upon completion
        }else{
            # New route to add for cluster
            # If a matching path already exists but in a different namespace then,
            #   it is same one we are trying to deploy
            Write-Verbose "WARNING: Overwriting existing ingress route to the cluster" -Verbose
            $IsValidIngress = $True 
        }
    }else{
        Write-Verbose "Unique ingress route being added to the cluster" -Verbose
        $IsValidIngress = $True
    }
    Return $IsValidIngress
}


if (($K8S_APP_ROUTE) -and ($K8S_APP_ROUTE.length -gt 0)) {   
    Write-Verbose "Found a value defined for the 'K8S_APP_ROUTE' variable" -Verbose
    try {
        Write-Verbose "Deploying Ingress Route" -Verbose

        $AKS_DEPLOY_INGRESS_ROUTE_FILE = (Join-Path $SCRIPT_DIRECTORY "sce-ingress-routes.yaml")
        Write-Verbose "AKS_DEPLOY_INGRESS_ROUTE_FILE: $AKS_DEPLOY_INGRESS_ROUTE_FILE" -Verbose

        $IsValidIngress = Check-IngressIsUnique -AppNameSpace $K8S_NAMESPACE -AppRoute $K8S_APP_ROUTE

        If ($IsValidIngress)
        {
            Write-Verbose "Contents of $AKS_DEPLOY_INGRESS_ROUTE_FILE :" -Verbose
            Write-Verbose (Get-Content -Path $AKS_DEPLOY_INGRESS_ROUTE_FILE | Out-String) -Verbose

            kubectl --kubeconfig "$KUBE_CONFIG_PATH" apply -f $AKS_DEPLOY_INGRESS_ROUTE_FILE

            Write-Verbose "Successfully Deployed Ingress Route" -Verbose
        }else{
            Throw "Intended ingress route is not unique, please ensure uniqueness: https://dev.azure.com/cunamutual/SecureCloudEnablement/_wiki/wikis/Atlas%20Wiki%20V2/1714/Namespace-Guidelines?anchor=general-suggestions"
        }
    }
    catch {
        $ERROR_MESSAGE = $_.Exception.Message
        Write-Verbose "Error while deploying app: " -Verbose
        Write-Error -Message "ERROR: $ERROR_MESSAGE" -ErrorAction Stop
    }
}
