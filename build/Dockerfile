FROM quay.io/operator-framework/helm-operator:v1.22.0

LABEL name="sematext-operator"
LABEL summary="Sematext Agent collects metrics about hosts (CPU, memory, disk, network, processes), containers (Podman, cri-o, Docker, containerd and rkt) and orchestrator platforms and ships that to Sematext Cloud."
LABEL description="This operator installs the Sematext Agent to all nodes in your cluster via a DaemonSet."
LABEL vendor="Sematext"

COPY LICENSE /licenses/

ENV HOME=/opt/helm

COPY helm-charts/ ${HOME}/helm-charts/
COPY watches.yaml ${HOME}/watches.yaml
WORKDIR ${HOME}
