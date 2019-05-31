# How to use

The module deploys and AKS cluster using Advanced Networking (Azure CNI with Custom VNET) and deploys using Helm nginx-ingress and cert-manager to the cluster. To call the module correctly use the following sample:

```hcl
module "aks-nginx" {
  source = "github.com/evillgenius75/terraform-azurerm-aks-nginxingress"

        PROJECT="alt"
        INSTANCE="2"
        ENVIRONMENT="dev"
        REGION="southcentralUS"
        AKS_SSH_ADMIN_KEY="ssh-rsa AAAAB3NzaC1yc-----@----.local"
        ADMIN_USER="adminuser"
        NODE_COUNT="1"
        NODE_SIZE="Standard_D2s_v3"
        K8S_HELM_HOME="/Users/evill_genius/.helm"
        K8S_KUBE_CONFIG="/Users/evill_genius/.kube/test1"
        K8S_VER="1.13.5"
        VNET_NAME="aks-vnet"
}
```
There are more variables that are defaulted that can also be customized if needed such as(default Values shown):
```hcl
VNET_ADDR_SPACE="10.10.0.0/16"
DNS_SERVERS=[]
SUBNET_NAMES=["aks-subnet"]
SUBNET_PREFIXES=["10.10.1.0/24"]
SERVICE_CIDR="10.0.0.0/16"
DNS_IP="10.0.0.10"
DOCKER_CIDR="172.17.0.1/16"
TILLER_VER="2.14.0"
```

The module uses local-exec assuming you are running from a bash shell. Tp determine the proper path for the `K8S_HELM_HOME` and `K8S_KUBE_CONFIG` variables you can type:
`helm home` and the output should be the value for `K8S_HELM_HOME`.
Your `K8S_KUBE_CONFIG` path should be the path to where you want the kube-config stored. 
>NOTE: To prevent overwriting your existing kube config please create a unique name for the actual config file. i.e. `/Users/myUser/.kube/config-aks1`

To enable the cert issuer you will just need to log in to the cluster and deploy a LetsEncrypt cert issuer yaml such as this:
```yaml
apiVersion: certmanager.k8s.io/v1alpha1
kind: ClusterIssuer
metadata:
  name: letsencrypt-staging
spec:
  acme:
    # You must replace this email address with your own.
    # Let's Encrypt will use this to contact you about expiring
    # certificates, and issues related to your account.
    email: user@example.com
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      # Secret resource used to store the account's private key.
      name: example-issuer-account-key
    # Add a single challenge solver, HTTP01 using nginx
    solvers:
    - http01:
        ingress:
          class: nginx
```






Authors
Originally created by Edward Villalba

Contributing
This project welcomes contributions and suggestions. Most contributions require you to agree to a Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the Microsoft Open Source Code of Conduct. For more information see the Code of Conduct FAQ or contact opencode@microsoft.com with any additional questions or comments.
