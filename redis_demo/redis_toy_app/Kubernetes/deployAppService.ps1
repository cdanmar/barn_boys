#**********************************************************
# Deploy the application service with ConfigMap
#**********************************************************

try {
    Write-Verbose "Deploying App Service" -Verbose

    # Get K8s manifest file path
    $AKS_DEPLOY_APP_FILE = (Join-Path $SCRIPT_DIRECTORY "sce-deploy-app.yaml")
    Write-Verbose "AKS_DEPLOY_APP_FILE: $AKS_DEPLOY_APP_FILE" -Verbose

    # Show the the manifest file contents
    Write-Verbose "Contents of $AKS_DEPLOY_APP_FILE :" -Verbose
    Write-Verbose (Get-Content -Path $AKS_DEPLOY_APP_FILE | Out-String) -Verbose

    kubectl --kubeconfig "$KUBE_CONFIG_PATH" apply -f $AKS_DEPLOY_APP_FILE

    Write-Verbose "Successfully Deployed App Service" -Verbose
}
catch {
    $ERROR_MESSAGE = $_.Exception.Message
    Write-Verbose "Error while deploying App Service: " -Verbose
    Write-Error -Message "ERROR: $ERROR_MESSAGE" -ErrorAction Stop
}
