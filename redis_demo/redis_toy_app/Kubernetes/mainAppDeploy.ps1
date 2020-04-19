#**********************************************************
# Get PowerSchell Script Execution Path
#**********************************************************

# Get the directory where the main script is executing
$SCRIPT_DIRECTORY = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
Write-Verbose "Script Directory: $SCRIPT_DIRECTORY" -Verbose

#**********************************************************
# Get Azure Devops RM Service Principal Variables
#**********************************************************

# Get the Account Subscription Id
$SUBSCRIPTION_ID = $(az account show --query id -o tsv)
Write-Verbose "SUBSCRIPTION_ID: $SUBSCRIPTION_ID" -Verbose

# Get the Tenant Id in which the Subscription exists
$TENANT_ID = $(az account show --query tenandId -o tsv)
Write-Verbose "TENANT_ID: $TENANT_ID" -Verbose

# Get the Subscription Name
$SUBSCRIPTION_NAME = $(az account show --query name -o tsv)
Write-Verbose "SUBSCRIPTION_NAME: $SUBSCRIPTION_NAME" -Verbose

# Get the name of the user who launched this script
$USER_NAME = $(az account show --query user.name -o tsv)
Write-Verbose "User Name: $USER_NAME" -Verbose

#**********************************************************
# Get Azure DevOps Release Pipeline Variables
#**********************************************************

. (Join-Path $SCRIPT_DIRECTORY "variables.ps1")

#**********************************************************
# Set location for creating kubernetes config file
#**********************************************************

# Relative path for kube config file
$KUBE_CONFIG_PATH = [IO.Path]::Combine($env:USERPROFILE, ".kube", "config")
Write-Verbose "KUBE_CONFIG_PATH: $KUBE_CONFIG_PATH" -Verbose

#**********************************************************
# Get AKS Cluster kubernetes credentials as admininstrator
#**********************************************************

try {
    Write-Verbose "Get credentials and set up for kubectl to use" -Verbose
    az aks get-credentials -g "$AKS_RG_NAME" `
        -n "$AKS_NAME" -a -f "$KUBE_CONFIG_PATH"

    Write-Verbose "Get kubectl version info" -Verbose
    kubectl --kubeconfig "$KUBE_CONFIG_PATH" version short
}
catch {
    $ERROR_MESSAGE = $_.Exception.Message
    Write-Verbose "Error while getting credentials and set up for kubectl to use: " -Verbose
    Write-Error -Message "ERROR: $ERROR_MESSAGE" -ErrorAction Stop
}

#**********************************************************
# Create namespace
#**********************************************************

. (Join-Path $SCRIPT_DIRECTORY "createNamespace.ps1")

#**********************************************************
# Deploy Network Policies
#**********************************************************

. (Join-Path $SCRIPT_DIRECTORY "deployNetworkPolicies.ps1")

#**********************************************************
# Deploy app permission, routes and services
#**********************************************************

if ($K8S_APP_MSI_NAME)
{
	. (Join-Path $SCRIPT_DIRECTORY "deployAadPodIdentity.ps1")
}

. (Join-Path $SCRIPT_DIRECTORY "deployAppIngressRoutes.ps1")

. (Join-Path $SCRIPT_DIRECTORY "deployConfigMap.ps1")

. (Join-Path $SCRIPT_DIRECTORY "deployAppService.ps1")

#**********************************************************
# Delete the kubernetes config file
#**********************************************************

if ("true" -eq "$(Test-Path -Path "$KUBE_CONFIG_PATH")".ToLower()) {
    Write-Verbose "Removing kubectl config file" -Verbose
    Remove-Item -Path "$KUBE_CONFIG_PATH"
}
else {
    Write-Verbose "kubectl config file does not exist" -Verbose
}
