#**********************************************************
# Create K8s namespace
#**********************************************************

try {
    Write-Verbose "Creating Namespace" -Verbose

    # Get K8s manifest file path
    $AKS_CREATE_NAMESPACE_FILE = (Join-Path $SCRIPT_DIRECTORY "redis_namespace.yaml")
    Write-Verbose "AKS_CREATE_NAMESPACE_FILE: $AKS_CREATE_NAMESPACE_FILE" -Verbose

    # Show the the manifest file contents
    Write-Verbose "Contents of $AKS_CREATE_NAMESPACE_FILE :" -Verbose
    Write-Verbose (Get-Content -Path $AKS_CREATE_NAMESPACE_FILE | Out-String) -Verbose

    kubectl --kubeconfig "$KUBE_CONFIG_PATH" apply -f $AKS_CREATE_NAMESPACE_FILE

    Write-Verbose "Successfully Created Namespace" -Verbose
}
catch {
    $ERROR_MESSAGE = $_.Exception.Message
    Write-Verbose "Error while creating Namespace: " -Verbose
    Write-Error -Message "ERROR: $ERROR_MESSAGE" -ErrorAction Stop
}
