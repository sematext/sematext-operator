# Sematext Operator

The Sematext Operator for Kubernetes provides an easy way to deploy Sematext Agent.

Sematext Agent collects metrics about hosts (CPU, memory, disk, network, processes, etc.), containers (Docker, Podman, containerd, etc.) and orchestrator platforms, and ships that to [Sematext Cloud](https://sematext.com/cloud). Sematext Cloud is available in the US and EU regions.

It installs the Sematext Agent to all nodes in your cluster via a `DaemonSet` resource.

## Quickstart

You need to create an Infra App in [Sematext Cloud US](https://apps.sematext.com/ui/monitoring-create/app/infra) or [Sematext Cloud EU](https://apps.eu.sematext.com/ui/monitoring-create/app/infra) to get your Infra App Token.

To run the operator and its dependencies run the following command:

```sh
kubectl apply -f https://raw.githubusercontent.com/sematext/sematext-operator/master/bundle.yaml
```

Once installed, you can create `SematextAgent` resource that deploys Sematext Agent to all nodes in your cluster via `DaemonSet` resource:

```yaml
apiVersion: sematext.com/v1alpha1
kind: SematextAgent
metadata:
  name: test-sematextagent
spec:
  region: <"US" or "EU">
  infraToken: YOUR_INFRA_TOKEN
```

## Removal

Run the `kubectl delete` command to remove the operator and its dependencies:

```sh
kubectl delete -f https://raw.githubusercontent.com/sematext/sematext-operator/master/bundle.yaml
```

## Docs

For more details refer to our [official Kubernetes Operator documentation](https://sematext.com/docs/agents/sematext-agent/kubernetes/operator/).
