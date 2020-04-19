#**********************************************************
# Deploy the Deny All App Network Policy
#**********************************************************

try {
    Write-Verbose "Deploying App Network Policy - Deny All Traffic Into Namespace" -Verbose

    # Get K8s manifest file path
    $NETWORK_POLICY_DENY_ALL_FILE = (Join-Path $SCRIPT_DIRECTORY "sce-network-policy-deny-all.yaml")
    Write-Verbose "NETWORK_POLICY_DENY_ALL_FILE: $NETWORK_POLICY_DENY_ALL_FILE" -Verbose

    # Show the the manifest file contents
    Write-Verbose "Contents of $NETWORK_POLICY_DENY_ALL_FILE :" -Verbose
    Write-Verbose (Get-Content -Path $NETWORK_POLICY_DENY_ALL_FILE | Out-String) -Verbose

    kubectl --kubeconfig "$KUBE_CONFIG_PATH" apply -f $NETWORK_POLICY_DENY_ALL_FILE

    Write-Verbose "Successfully Deployed App Network Policy - Deny All Traffic Into Namespace" -Verbose
}
catch {
    $ERROR_MESSAGE = $_.Exception.Message
    Write-Verbose "Error while deploying App Network Policy - Deny All Traffic Into Namespace: " -Verbose
    Write-Error -Message "ERROR: $ERROR_MESSAGE" -ErrorAction Stop
}

#**********************************************************
# Deploy the Allow External App Network Policy
#**********************************************************

try {
    Write-Verbose "Deploying App Network Policy - Allow All Traffic From Ingress Controller Into Namespace" -Verbose

    # Get K8s manifest file path
    $NETWORK_POLICY_ALLOW_INGRESS_NGINX_5000_FILE = (Join-Path $SCRIPT_DIRECTORY "sce-network-policy-allow-external.yaml")
    Write-Verbose "NETWORK_POLICY_ALLOW_INGRESS_NGINX_5000_FILE: $NETWORK_POLICY_ALLOW_INGRESS_NGINX_5000_FILE" -Verbose

    # Show the the manifest file contents
    Write-Verbose "Contents of $NETWORK_POLICY_ALLOW_INGRESS_NGINX_5000_FILE :" -Verbose
    Write-Verbose (Get-Content -Path $NETWORK_POLICY_ALLOW_INGRESS_NGINX_5000_FILE | Out-String) -Verbose

    kubectl --kubeconfig "$KUBE_CONFIG_PATH" apply -f $NETWORK_POLICY_ALLOW_INGRESS_NGINX_5000_FILE

    Write-Verbose "Successfully Deployed App Network Policy - Allow All Traffic From Ingress Controller Into Namespace" -Verbose
}
catch {
    $ERROR_MESSAGE = $_.Exception.Message
    Write-Verbose "Error while deploying App Network Policy - Allow All Traffic From Ingress Controller Into Namespace: " -Verbose
    Write-Error -Message "ERROR: $ERROR_MESSAGE" -ErrorAction Stop
}
