<#
# The following two lines are only used when working remotely using the CMFG VPN.
$env:HTTP_PROXY = ""
$env:HTTPs_PROXY = ""
#>

# Only required when running on the corporate network or VPN
# Madison Firewall Proxy IP addresses are: 10.75.233.15 and 10.75.233.16 (think Laptops)
# Ashburn Firewall Proxy IP addresses are: 10.78.233.15 and 10.78.233.16 (think VDIs)
# Should the IP address shown below become unavailable, try switch to the other 
$proxyIP = '10.75.233.16:8080'

$env:HTTPS_PROXY = "http://${proxyIP}"
$env:HTTP_PROXY = "http://${proxyIP}"

# Required for workstations running Netskope
$cacertFile = 'C:\certs\cacert.pem'

# Tells Netskope where to find you 
$env:REQUESTS_CA_BUNDLE = $cacertFile

[System.Environment]::SetEnvironmentVariable("KUBECONFIG", $ENV:USERPROFILE +"\.kube\config" , "User")

# Relative path for kube config file
$KUBE_CONFIG_PATH = "$env:KUBECONFIG"
Write-Verbose "KUBE_CONFIG_PATH: $KUBE_CONFIG_PATH" -Verbose

# Before you begin - make sure you're logged into Azure using the Azure CLI
az login

# Ensure you specify your Azure subscription
# (if you have more than one subscription)
$SUBSCRIPTION_NAME = "Lending-NonProd Lending"

Write-Verbose "Set the default Azure subscription" -Verbose
az account set --subscription "$SUBSCRIPTION_NAME"

$SUBSCRIPTION_ID = $(az account show --query id -o tsv)
Write-Verbose "SUBSCRIPTION_ID: $SUBSCRIPTION_ID" -Verbose

$SUBSCRIPTION_NAME = $(az account show --query name -o tsv)
Write-Verbose "SUBSCRIPTION_NAME: $SUBSCRIPTION_NAME" -Verbose

$USER_NAME = $(az account show --query user.name -o tsv)
Write-Verbose "Service Principal Name or ID: $USER_NAME" -Verbose

$TENANT_ID = $(az account show --query tenantId -o tsv)
Write-Verbose "TENANT_ID: $TENANT_ID" -Verbose

# Tell PowerShell where it can find your Azure CLI
$env:path += ";C:\Program Files\Git\mingw64\bin;"

#**********************************************************
# Get this script's execution path
#**********************************************************

$SCRIPT_DIRECTORY = ($pwd).path
Write-Verbose "SCRIPT_DIRECTORY: $SCRIPT_DIRECTORY" -Verbose

$KUBERNETES_PATH = Join-Path $SCRIPT_DIRECTORY "src\IntergroupWeb\Kubernetes"
Write-Verbose "KUBERNETES_PATH: $KUBERNETES_PATH" -Verbose

$SCRIPT_DIRECTORY = $KUBERNETES_PATH

#**********************************************************
# (Optional) Build a local container and run it
#**********************************************************

# Get AKS Cluster Credentials
# Enter your AKS Cluster resource group and name in the following statement
az aks get-credentials --resource-group "RG-CMFG-NP2-Lending-Atlas" --name "AKS-NP1-Lending" -f "$KUBE_CONFIG_PATH"

Write-Verbose "Get kubectl version info"
kubectl --kubeconfig "$KUBE_CONFIG_PATH" version short

# The following kubectl command can be used to pin your session to 
# a specific namespace in your kubernetes cluster.
# IMPORTANT: Read the following:
# For the statement below, 'your_k8s_namespace' is only meant to be a placeholder
# You must replace it with your desired kubernetes namespace name
kubectl config set-context --current --namespace=your-namespace

# Stop all containers:
docker stop $(docker ps -aq)

# Remove all containers
docker rm $(docker ps -aq)

# Set variables for local docker container tests
$IMAGE_NAME = "intergroupweb"
$IMAGE_TAG = "v1.0.0"
$CONTAINER_NAME = "$IMAGE_NAME`:$IMAGE_TAG"
Write-Verbose "CONTAINER_NAME: $CONTAINER_NAME" -Verbose

$DOCKERFILE_DIRECTORY = (Join-Path ($pwd).path "src\IntergroupWeb")
Write-Verbose "DOCKERFILE_DIRECTORY: $DOCKERFILE_DIRECTORY" -Verbose

$DOCKERFILE_PATH = (Join-Path "$DOCKERFILE_DIRECTORY" "Dockerfile")
Write-Verbose "DOCKERFILE_PATH: $DOCKERFILE_PATH" -Verbose

# List all images
docker images -a

# Remove any previous image
docker rmi -f "$CONTAINER_NAME"

# Remove dangling images
docker images -f dangling=true

# Build the container
docker build -f $DOCKERFILE_PATH -t "$CONTAINER_NAME" .

# Run the image:cd
docker run -p 5000:5000 "$CONTAINER_NAME"

# Test the containerized application is working:
Start-Process http://localhost:5000
