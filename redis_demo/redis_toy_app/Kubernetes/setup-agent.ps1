#**********************************************************
# Set RM Service Principal Variables
#**********************************************************

# Get the Account Subscription Id
$SUBSCRIPTION_ID = $(az account show --query id -o tsv)
Write-Verbose "SUBSCRIPTION_ID: $SUBSCRIPTION_ID" -Verbose
Write-Host "##vso[task.setvariable variable=SUBSCRIPTION_ID;]$SUBSCRIPTION_ID"

# Get the Tenant Id in which the Subscription exists
$TENANT_ID = $(az account show --query tenantId -o tsv)
Write-Verbose "TENANT_ID: $TENANT_ID" -Verbose
Write-Host "##vso[task.setvariable variable=TENANT_ID;]$TENANT_ID"

# Get the Subscription Name
$SUBSCRIPTION_NAME = $(az account show --query name -o tsv)
Write-Verbose "SUBSCRIPTION_NAME: $SUBSCRIPTION_NAME" -Verbose
Write-Host "##vso[task.setvariable variable=SUBSCRIPTION_NAME;]$SUBSCRIPTION_NAME"

# Get the name of the user who launched this script
$USER_NAME = $(az account show --query user.name -o tsv)
Write-Verbose "User Name: $USER_NAME" -Verbose
Write-Host "##vso[task.setvariable variable=USER_NAME;]$USER_NAME"

#**********************************************************
# Set Kubernetes Managed Service Identity Variables
#**********************************************************

# Get Kubernetes Application MSI Name and ensure it is lowercase
$K8S_APP_MSI_NAME = $(If ($env:K8S_APP_MSI_NAME) { "$env:K8S_APP_MSI_NAME".ToLower() } Else { Write-Verbose "K8S_APP_MSI_NAME is not defined. AAD Pod Identity will not be deployed." -Verbose }) 

if ($K8S_APP_MSI_NAME)
{
	# Kubernetes Application MSI Name
    Write-Verbose "K8S_APP_MSI_NAME: $K8S_APP_MSI_NAME" -Verbose
	$env:K8S_APP_MSI_NAME = $K8S_APP_MSI_NAME
	Write-Host "##vso[task.setvariable variable=K8S_APP_MSI_NAME;]$K8S_APP_MSI_NAME"

	# Get Kubernetes Application Resource Group Name
	$K8S_APP_RG_NAME = $(If ($env:K8S_APP_RG_NAME) { "$env:K8S_APP_RG_NAME" } Else { Write-Error -Message "ERROR: Missing value for 'K8S_APP_RG_NAME'" -ErrorAction Stop }) 
	Write-Verbose "K8S_APP_RG_NAME: $K8S_APP_RG_NAME" -Verbose

	# Get Kubernetes Application AAD Pod Identity Selector Name and ensure it is lowercase
	$K8S_APP_AAD_POD_IDENTITY_SELECTOR = "$K8S_APP_MSI_NAME-selector".ToLower()
	Write-Verbose "K8S_APP_AAD_POD_IDENTITY_SELECTOR: $K8S_APP_AAD_POD_IDENTITY_SELECTOR" -Verbose
	$env:K8S_APP_AAD_POD_IDENTITY_SELECTOR = $K8S_APP_AAD_POD_IDENTITY_SELECTOR
	Write-Host "##vso[task.setvariable variable=K8S_APP_AAD_POD_IDENTITY_SELECTOR;]$K8S_APP_AAD_POD_IDENTITY_SELECTOR"

	# Get Kubernetes Application AAD Pod Identity Binding Name and ensure it is lowercase
	$K8S_APP_AAD_POD_IDENTITY_BINDING = "$K8S_APP_MSI_NAME-aad-pod-identity-binding".ToLower()
	Write-Verbose "K8S_APP_AAD_POD_IDENTITY_BINDING: $K8S_APP_AAD_POD_IDENTITY_BINDING" -Verbose
	$env:K8S_APP_AAD_POD_IDENTITY_BINDING = $K8S_APP_AAD_POD_IDENTITY_BINDING
	Write-Host "##vso[task.setvariable variable=K8S_APP_AAD_POD_IDENTITY_BINDING;]$K8S_APP_AAD_POD_IDENTITY_BINDING"

	# Get Kubernetes Application MSI Resource ID
	$K8S_APP_MSI_RESOURCE_ID = $(az identity show --resource-group "$K8S_APP_RG_NAME" --name "$K8S_APP_MSI_NAME" --query "id" --output tsv)
	Write-Verbose "K8S_APP_MSI_RESOURCE_ID: $K8S_APP_MSI_RESOURCE_ID" -Verbose
	$env:K8S_APP_MSI_RESOURCE_ID = $K8S_APP_MSI_RESOURCE_ID
	Write-Host "##vso[task.setvariable variable=K8S_APP_MSI_RESOURCE_ID;]$K8S_APP_MSI_RESOURCE_ID"

	# Get Kubernetes Application MSI Client Id
	$K8S_APP_MSI_CLIENT_ID = $(az identity show --resource-group "$K8S_APP_RG_NAME" --name "$K8S_APP_MSI_NAME" --query "clientId" --output tsv)
	Write-Verbose "K8S_APP_MSI_CLIENT_ID: $K8S_APP_MSI_CLIENT_ID" -Verbose
	$env:K8S_APP_MSI_CLIENT_ID = $K8S_APP_MSI_CLIENT_ID
	Write-Host "##vso[task.setvariable variable=K8S_APP_MSI_CLIENT_ID;]$K8S_APP_MSI_CLIENT_ID"

	if (!$K8S_APP_MSI_CLIENT_ID -or !$K8S_APP_MSI_RESOURCE_ID){
		Write-Error "Unable to determine the ClientId or ResourceId of target MSI. This typically means your target MSI is either 
		inaccessible to the Service Principal used for this release or you have multiple MSIs with the same name. If the latter, 
		please remove any duplicates and/or create unique MSIs as duplicate MSIs is currently unsupported."
		Exit 1
	}
}


