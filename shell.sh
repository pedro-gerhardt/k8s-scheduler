# kind cria o cluster baseado no yaml com o master e os 3 workers
kind create cluster --config cluster-pro.yaml --name cluster-teste
echo "------------------------------- CLUSTER CRIADO -------------------------------"
# define cluster do kind recem criado para o kubectl
kubectl cluster-info --context kind-cluster-teste
echo "------------------------------- CONTEXTO SETADO -------------------------------"
# define cluster do kind recem criado para o kubectl
kubectl proxy &
echo "------------------------------- API ABERTA -------------------------------"
# aplica estrutura para inicializar metrics server
kubectl apply -f components.yaml 
echo "--------------------- COMPONENTS METRICS SERVICE SETADO ------------------------"
# # apaga processo que usaria porta do prometheus
pkill -f prometheus
# instala prometheus
helm upgrade --install --wait --timeout 15m \
  --namespace monitoring --create-namespace \
  --repo https://prometheus-community.github.io/helm-charts \
  kube-prometheus-stack kube-prometheus-stack --values - <<EOF
kubeEtcd:
  service:
    targetPort: 2381
EOF
# # redireciona porta do prometheus
kubectl port-forward -n monitoring svc/kube-prometheus-stack-prometheus 9090:9090 &
echo "--------------------------- PROMETHEUS CRIADO -----------------------------"


# cria custom scheduler 
kubectl create -f full_sched.yaml 
echo "----------------------------- SCHEDULER CRIADO -----------------------------"

# # cria pod e atribui a algum node
kubectl create namespace pod-namespace
kubectl create -f ./pod_stress.yaml
kubectl create -f ./pod_stress2.yaml
kubectl create -f ./pod_stress3.yaml
kubectl create -f ./pod_stress4.yaml
kubectl create -f ./pod_stress5.yaml
kubectl create -f ./pod_stress6.yaml
kubectl create -f ./pod_stress7.yaml
kubectl create -f ./pod_stress8.yaml
kubectl create -f ./pod_stress9.yaml
kubectl create -f ./pod_stress10.yaml
kubectl create -f ./pod_stress11.yaml
kubectl create -f ./pod_stress12.yaml
echo "------------------------------- PODS CRIADOS -------------------------------"
