# k8s argo workflow

## Dependencies

- Docker
- Docker Compose
- Docker Desktop
- Kubernetes
- kubectx
- argo workflow
- direnv

## Setup

```sh
# edit .envrc
cp .envrc.sample .envrc
vi .envrc
direnv allow .

# use k8s on docker desktop
kubectx docker-desktop

# build images
docker compose build

# create namespace for argo workflow
kubectl create namespace argo
kubectl apply -n argo -f https://github.com/argoproj/argo-workflows/releases/download/${ARGO_WORKFLOWS_VERSION}/quick-start-minimal.yaml

# boot cluster
kubectl apply -f manifestfile.yaml
curl -v http://localhost:32660
```

## Usage

```sh
# switch kubenetes context
kubectx docker-desktop

# build image
docker compose build

# start
kubectl apply -f manifestfile.yaml

# stop
kubectl delete -f manifestfile.yaml

# access to rack pod
curl -v http://localhost:32660

# start argo workflow
kubectl apply -n argo -f https://github.com/argoproj/argo-workflows/releases/download/${ARGO_WORKFLOWS_VERSION}/quick-start-minimal.yaml

# stop argo workflow
kubectl delete -n argo -f https://github.com/argoproj/argo-workflows/releases/download/${ARGO_WORKFLOWS_VERSION}/quick-start-minimal.yaml

# boot argo workflow UI
kubectl -n argo port-forward service/argo-server 2746:2746

# open argo workflow UI
open https://localhost:2746

# submit workflow
argo submit -n argo --watch workflows/workflow.yaml

# register cron workflow
argo cron create -n argo workflows/cron_workflow.yaml

# delete cron workflow
argo cron delete -n argo cron-workflow

# list cron workflow
argo cron list -n argo

# register workflow template
argo template create -n argo workflows/workflow_template.yaml

# delete workflow template
argo template delete -n argo workflow-template
```

## References

- [Docker Desktop を使って学ぶ Kubernetes の基本的な仕組み - 30歳からのプログラミング](https://numb86-tech.hatenablog.com/entry/2023/09/19/211324)
- [Quick Start - Argo Workflows - The workflow engine for Kubernetes](https://argo-workflows.readthedocs.io/en/stable/quick-start/)
- [使いこなせ！Argo Workflows / How to use Argo Workflows - Speaker Deck](https://speakerdeck.com/makocchi/how-to-use-argo-workflows)
- [kind (Kubernetes IN Docker)におけるローカルイメージpull失敗とimagePullPolicyについて #Docker - Qiita](https://qiita.com/yokawasa/items/bba45ad775bbf8ac25c3)
- [hostPathとlocalのPersistentVolumeの違い #kubernetes - Qiita](https://qiita.com/sotoiwa/items/09d2f43a35025e7be782)

## Memo

### Default imagePullPolicy

- [Images | Kubernetes](https://kubernetes.io/docs/concepts/containers/images/#imagepullpolicy-defaulting)

> * if you omit the `imagePullPolicy` field, and the tag for the container image is `:latest`, `imagePullPolicy` is automatically set to Always;

> * if you omit the `imagePullPolicy` field, and you specify the tag for the container image that isn't `:latest`, the `imagePullPolicy` is automatically set to IfNotPresent.


### k8s volume - HostPath

- [ボリューム | Kubernetes](https://kubernetes.io/ja/docs/concepts/storage/volumes/#hostpath)
