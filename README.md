## Bringing up the cluster

1. `terraform init`
2. `terraform plan -output tfplan`
3. `terraform apply tfplan`
4. `aws eks update-kubeconfig --name "$cluster_name"`
5. `kubectl get nodes`

## Testing

1. `kubectl run test-pod --image nginx`
2. `kubectl get pods --watch`
3. Expected output:
```
  NAME        READY   STATUS    RESTARTS   AGE
  test-pod    1/1     Running   0          20m
```
