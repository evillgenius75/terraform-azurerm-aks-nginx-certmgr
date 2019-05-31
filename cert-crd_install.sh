set -e

# Create the namespace for cert-manager
echo "creating kubernetes namespace cert-manager if needed"
if ! kubectl describe namespace cert-manager > /dev/null 2>&1; then
    if ! kubectl create namespace cert-manager; then
        echo "ERROR: failed to create kubernetes namespace cert-manager"
        exit 1
    fi
fi

# Label the cert-manager namespace to disable resource validation
echo "applying validation label to cert-manager namespace"
if ! kubectl get namespace cert-manager --show-labels | grep "validation=true" > /dev/null 2>&1; then
    if ! kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true; then
        echo "ERROR: failed to label kubernetes namespace cert-manager"
        exit 1
    fi
fi

# Install the CustomResourceDefinition resources separately
echo "Install CRD for Cert-Manager"
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.8/deploy/manifests/00-crds.yaml


echo "Veryifying CRDs are installed"

while :
do 
  if ! kubectl get crd | grep 'certmanager.k8s.io' > /dev/null 2>&1
  then
    echo "Sleeping for 10 seconds"
    sleep 10
    printf "."
  fi
    kubectl get crd | grep 'certmanager.k8s.io'
    break
done

echo "Sleeping for 5 seconds to for CRDs to register"
x=5
while [ $x -gt 0 ]
do
sleep 1s
printf "."
x=$(( $x - 1 ))
done