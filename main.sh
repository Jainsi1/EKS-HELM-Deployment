#!/bin/bash
terraform init
terraform plan
terraform apply -auto-approve
aws eks update-kubeconfig --region `terraform output eks_cluster_arn | cut -d':' -f4` --name `terraform output eks_cluster_name | tr -d '"'`
export CLUSTER_NAME=`terraform output eks_cluster_name | tr -d '"'` && export AUTOSCALER_ROLE=`terraform output cluster-autosclaer-role-arn| tr -d '"'` && envsubst < cluster-autoscaler.yml > cluster-autoscaler-with-envs.yml
kubectl create namespace utilities || true
helm upgrade -i ingress-nginx ingress-nginx/ -n utilities 
kubectl apply -f cluster-autoscaler-with-envs.yml
kubectl patch deployment cluster-autoscaler \
  -n kube-system \
  -p '{"spec":{"template":{"metadata":{"annotations":{"cluster-autoscaler.kubernetes.io/safe-to-evict": "false"}}}}}'
kubectl set image deployment cluster-autoscaler \
  -n kube-system \
  cluster-autoscaler=registry.k8s.io/autoscaling/cluster-autoscaler:v1.25.0
helm upgrade -i metrics-server metrics-server/ -n utilities 

# Extract the names of the nodes
node_names=$(kubectl get nodes | awk 'NR>1 {print $1}')

# Extract the first node and label it as sonarqube=true
first_node=$(echo "$node_names" | head -n 1)
kubectl label nodes "$first_node" sonarqube="true"

# Install the sonarqube halm chart
helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo update
kubectl create namespace apps || true
helm upgrade -i sonarqube sonarqube/sonarqube -n apps --values sonarqube/values.yaml

# Extract the second node and label it as DefectDojo=true
second_node=$(echo "$node_names" | sed -n '2p')
kubectl label nodes "$second_node" DefectDojo="true"

# Extract the third node and label it as DependencyTrack=true
third_node=$(echo "$node_names" | sed -n '3p')
kubectl label nodes "$third_node" DependencyTrack="true"