while ! kubectl get endpoints cert-manager-webhook -n cert-manager | grep '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' > /dev/null 2>&1
do
    kubectl get endpoints cert-manager-webhook -n cert-manager | grep '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'
    echo "Waiting for cert-manager-webhook service to have endpoints"
    sleep 10
done
kubectl get endpoints cert-manager-webhook -n cert-manager | grep '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'
echo "Pausing to allow for Service Configuration"
sleep 10
