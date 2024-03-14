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

# Install the sonarqube helm chart
helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo update
kubectl create namespace apps || true
helm upgrade -i sonarqube sonarqube/sonarqube -n apps --values sonarqube/values.yaml

# Install the dependency track helm chart
helm repo add evryfs-oss https://evryfs.github.io/helm-charts/
helm repo update
helm upgrade -i dependency-track evryfs-oss/dependency-track -n apps --values dependency-track/values.yaml

# Install the defect dojo helm chart
helm repo add defectdojo 'https://raw.githubusercontent.com/DefectDojo/django-DefectDojo/helm-charts'
helm repo update
helm upgrade -i defectdojo defectdojo/defectdojo -n apps --values defectdojo/values.yaml
