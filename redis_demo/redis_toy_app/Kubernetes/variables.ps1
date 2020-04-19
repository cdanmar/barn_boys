#**********************************************************
# Retrieve values from environment variables (Azure DevOps)
#**********************************************************

$ACR_DOMAIN_NAME = $(If ($env:ACR_DOMAIN_NAME) { "$env:ACR_DOMAIN_NAME" } Else { Write-Error -Message "ERROR: Missing value for 'ACR_DOMAIN_NAME'" -ErrorAction Stop }) 
Write-Verbose "ACR_DOMAIN_NAME: $ACR_DOMAIN_NAME" -Verbose

$ACR_IMAGE_TAG = $(If ($env:ACR_IMAGE_TAG) { "$env:ACR_IMAGE_TAG" } Else { Write-Error -Message "ERROR: Missing value for 'ACR_IMAGE_TAG'" -ErrorAction Stop }) 
Write-Verbose "ACR_IMAGE_TAG: $ACR_IMAGE_TAG" -Verbose

$ACR_REPOSITORY_NAME = $(If ($env:ACR_REPOSITORY_NAME) { "$env:ACR_REPOSITORY_NAME" } Else { Write-Error -Message "ERROR: Missing value for 'ACR_REPOSITORY_NAME'" -ErrorAction Stop }) 
Write-Verbose "ACR_REPOSITORY_NAME: $ACR_REPOSITORY_NAME" -Verbose

$REPOSITORY_IMAGE_NAME = "$ACR_DOMAIN_NAME/$ACR_REPOSITORY_NAME`:$ACR_IMAGE_TAG"
Write-Verbose "REPOSITORY_IMAGE_NAME: $REPOSITORY_IMAGE_NAME" -Verbose

$AKS_NAME = $(If ($env:AKS_NAME) { "$env:AKS_NAME" } Else { Write-Error -Message "ERROR: Missing value for 'AKS_NAME'" -ErrorAction Stop }) 
Write-Verbose "AKS_NAME: $AKS_NAME" -Verbose

$AKS_RG_NAME = $(If ($env:AKS_RG_NAME) { "$env:AKS_RG_NAME" } Else { Write-Error -Message "ERROR: Missing value for 'AKS_RG_NAME'" -ErrorAction Stop }) 
Write-Verbose "AKS_RG_NAME: $AKS_RG_NAME" -Verbose

$K8S_NAMESPACE = $(If ($env:K8S_NAMESPACE) { "$env:K8S_NAMESPACE" } Else { Write-Error -Message "ERROR: Missing value for 'K8S_NAMESPACE'" -ErrorAction Stop }) 
Write-Verbose "K8S_NAMESPACE: $K8S_NAMESPACE" -Verbose

$K8S_APP_NAME = $(If ($env:K8S_APP_NAME) { "$env:K8S_APP_NAME" } Else { Write-Error -Message "ERROR: Missing value for 'K8S_APP_NAME'" -ErrorAction Stop }) 
Write-Verbose "K8S_APP_NAME: $K8S_APP_NAME" -Verbose

$K8S_APP_ROUTE = $(If ($env:K8S_APP_ROUTE) { "$env:K8S_APP_ROUTE" }) 
Write-Verbose "K8S_APP_ROUTE: $K8S_APP_ROUTE" -Verbose

$K8S_APP_MSI_NAME = $(If ($env:K8S_APP_MSI_NAME) { "$env:K8S_APP_MSI_NAME" } Else { Write-Verbose -Message "Missing value for 'K8S_APP_MSI_NAME' AAD Pod Identity support will not be deployed." -Verbose }) 
Write-Verbose "K8S_APP_MSI_NAME: $K8S_APP_MSI_NAME" -Verbose

if ($K8S_APP_MSI_NAME)
{
	$K8S_APP_RG_NAME = $(If ($env:K8S_APP_RG_NAME) { "$env:K8S_APP_RG_NAME" } Else { Write-Error -Message "ERROR: Missing value for 'K8S_APP_RG_NAME'" -ErrorAction Stop }) 
	Write-Verbose "K8S_APP_RG_NAME: $K8S_APP_RG_NAME" -Verbose

	$K8S_APP_AAD_POD_IDENTITY_SELECTOR = $(If ($env:K8S_APP_AAD_POD_IDENTITY_SELECTOR) { "$env:K8S_APP_AAD_POD_IDENTITY_SELECTOR" } Else { Write-Error -Message "ERROR: Missing value for 'K8S_APP_AAD_POD_IDENTITY_SELECTOR'" -ErrorAction Stop }) 
	Write-Verbose "K8S_APP_AAD_POD_IDENTITY_SELECTOR: $K8S_APP_AAD_POD_IDENTITY_SELECTOR" -Verbose

	$K8S_APP_AAD_POD_IDENTITY_BINDING = $(If ($env:K8S_APP_AAD_POD_IDENTITY_BINDING) { "$env:K8S_APP_AAD_POD_IDENTITY_BINDING" } Else { Write-Error -Message "ERROR: Missing value for 'K8S_APP_AAD_POD_IDENTITY_BINDING'" -ErrorAction Stop }) 
	Write-Verbose "K8S_APP_AAD_POD_IDENTITY_BINDING: $K8S_APP_AAD_POD_IDENTITY_BINDING" -Verbose
}

$K8S_APP_KV_NAME = $(If ($env:K8S_APP_KV_NAME) { "$env:K8S_APP_KV_NAME" } Else { Write-Verbose "K8S_APP_KV_NAME is not defined. Application will not be able to retrieve secrets." -Verbose }) 
Write-Verbose "K8S_APP_KV_NAME: $K8S_APP_KV_NAME" -Verbose

# Uncomment and add entries for all environment variables specified in the ConfigMap file (sce-app-configmap.yaml)
<#
$DB_SERVER_NAME = $(If ($env:DB_SERVER_NAME) { "$env:DB_SERVER_NAME" } Else { Write-Error -Message "ERROR: Missing value for 'DB_SERVER_NAME'" -ErrorAction Stop }) 
Write-Verbose "DB_SERVER_NAME: $DB_SERVER_NAME" -Verbose

$DB_NAME = $(If ($env:DB_NAME) { "$env:DB_NAME" } Else { Write-Error -Message "ERROR: Missing value for 'DB_NAME'" -ErrorAction Stop }) 
Write-Verbose "DB_NAME: $DB_NAME" -Verbose
#>
