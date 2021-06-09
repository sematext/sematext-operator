FROM quay.io/operator-framework/helm-operator:v1.8.0

LABEL name="sematext-operator"
LABEL summary="Sematext Agent collects metrics about hosts (CPU, memory, disk, network, processes), containers (both Docker and rkt) and orchestrator platforms and ships that to Sematext Cloud."
LABEL description="This operator installs the Sematext Agent to all nodes in your cluster via a DaemonSet."
LABEL vendor="Sematext"

COPY LICENSE /licenses/

COPY helm-charts/ ${HOME}/helm-charts/
COPY watches.yaml ${HOME}/watches.yaml
