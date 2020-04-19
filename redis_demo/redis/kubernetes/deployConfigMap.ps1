#**********************************************************
# Deploy the application ConfigMap
#**********************************************************

try {
    Write-Verbose "Deploying App ConfigMap" -Verbose

    # Get K8s manifest file path
    $AKS_DEPLOY_CONFIGMAP_FILE = (Join-Path $SCRIPT_DIRECTORY "sce-app-configmap.yaml")
    Write-Verbose "AKS_DEPLOY_CONFIGMAP_FILE: $AKS_DEPLOY_CONFIGMAP_FILE" -Verbose

    # Show the the manifest file contents
    Write-Verbose "Contents of $AKS_DEPLOY_CONFIGMAP_FILE :" -Verbose
    Write-Verbose (Get-Content -Path $AKS_DEPLOY_CONFIGMAP_FILE | Out-String) -Verbose

    kubectl --kubeconfig "$KUBE_CONFIG_PATH" apply -f $AKS_DEPLOY_CONFIGMAP_FILE

    Write-Verbose "Successfully Deployed App ConfigMap" -Verbose
}
catch {
    $ERROR_MESSAGE = $_.Exception.Message
    Write-Verbose "Error while deploying App ConfigMap: " -Verbose
    Write-Error -Message "ERROR: $ERROR_MESSAGE" -ErrorAction Stop
}