FROM quay.io/operator-framework/helm-operator:v0.6.0

LABEL name="sematext-operator"
LABEL summary=""
LABEL description="This operator installs the Sematext Agent to all nodes in your cluster via a DaemonSet."
LABEL vendor="Sematext"

COPY LICENSE /licenses/

COPY helm-charts/ ${HOME}/helm-charts/
COPY watches.yaml ${HOME}/watches.yaml
