#**********************************************************
# Deploy K8s Application AAD Pod Identity
#**********************************************************

try {
    Write-Verbose "Deploying K8s Application AAD Pod Identity" -Verbose

    # Get K8s manifest file path
    $AAD_POD_IDENTITY_FILE_PATH = (Join-Path $SCRIPT_DIRECTORY "aad-pod-identity.yaml")
    Write-Verbose "AAD_POD_IDENTITY_FILE_PATH: $AAD_POD_IDENTITY_FILE_PATH" -Verbose

    # Show the the manifest file contents
    Write-Verbose "Contents of $AAD_POD_IDENTITY_FILE_PATH :" -Verbose
    Write-Verbose (Get-Content -Path $AAD_POD_IDENTITY_FILE_PATH | Out-String) -Verbose

    kubectl --kubeconfig "$KUBE_CONFIG_PATH" apply -f $AAD_POD_IDENTITY_FILE_PATH

    Write-Verbose "Successfully Deployed K8s Application AAD Pod Identity" -Verbose
}
catch {
    $ERROR_MESSAGE = $_.Exception.Message
    Write-Verbose "Error while deploying K8s Application AAD Pod Identity: " -Verbose
    Write-Error -Message "ERROR: $ERROR_MESSAGE" -ErrorAction Stop
}

#**********************************************************
# Deploy K8s Application AAD Pod Identity Binding
#**********************************************************

try {
    Write-Verbose "Deploying K8s Application AAD Pod Identity Binding" -Verbose

    # Get K8s manifest file path
    $AAD_POD_IDENTITY_BINDING_FILE_PATH = (Join-Path $SCRIPT_DIRECTORY "aad-pod-identity-binding.yaml")
    Write-Verbose "AAD_POD_IDENTITY_BINDING_FILE_PATH: $AAD_POD_IDENTITY_BINDING_FILE_PATH" -Verbose

    # Show the the manifest file contents
    Write-Verbose "Contents of $AAD_POD_IDENTITY_BINDING_FILE_PATH :" -Verbose
    Write-Verbose (Get-Content -Path $AAD_POD_IDENTITY_BINDING_FILE_PATH | Out-String) -Verbose

    kubectl --kubeconfig "$KUBE_CONFIG_PATH" apply -f $AAD_POD_IDENTITY_BINDING_FILE_PATH

    Write-Verbose "Successfully Deployed K8s Application AAD Pod Identity Binding" -Verbose
}
catch {
    $ERROR_MESSAGE = $_.Exception.Message
    Write-Verbose "Error while deploying K8s Application AAD Pod Identity Binding: " -Verbose
    Write-Error -Message "ERROR: $ERROR_MESSAGE" -ErrorAction Stop
}

try{
	$problemString = '# aadpodidbinding'
	$goodString = 'aadpodidbinding'

	$targetFile = (Join-Path $SCRIPT_DIRECTORY "sce-deploy-app.yaml")
	$targetFileContents = Get-Content $targetFile

	# replace the problemString with goodString. Pipe this to set-content and update the file
	$targetFileContents -replace $problemString, $goodString | Set-Content $targetFile
}
catch{
    $ERROR_MESSAGE = $_.Exception.Message
    Write-Verbose "Error attempting to remove selector comment line: " -Verbose
    Write-Error -Message "ERROR: $ERROR_MESSAGE" -ErrorAction Stop
}
