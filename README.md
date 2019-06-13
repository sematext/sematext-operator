# Sematext Operator

The Sematext Operator for Kubernetes provides an easy way to deploy Sematext Agent.

Sematext Agent collects metrics about hosts (CPU, memory, disk, network, processes), containers (both Docker and rkt) and orchestrator platforms and ships that to [Sematext Cloud](https://sematext.com/cloud). Sematext Cloud is available in the US and EU regions.

It installs the Sematext Agent to all nodes in your cluster via a `DaemonSet` resource.

## Quickstart

To run the operator and its dependencies run the following command:

```sh
kubectl apply -f https://raw.githubusercontent.com/sematext/sematext-operator/master/bundle.yaml
```

## Settings

This operator uses all the same options as the [Sematext Agent Helm Chart](https://hub.helm.sh/charts/stable/sematext-agent), please take a look to all the options in the following table:

|             Parameter            |            Description            |                  Default                  |
|----------------------------------|-----------------------------------|-------------------------------------------|
| `containerToken`                 | Sematext Container token          | `Nil` Provide your Container token        |
| `logsToken`                      | Sematext Logs token               | `Nil` Provide your Logs token             |
| `region`                         | Sematext region                   | `US` Sematext US or EU region             |
| `agent.image.repository`         | The image repository              | `sematext/agent`                          |
| `agent.image.tag`                | The image tag                     | `latest`                                  |
| `agent.image.pullPolicy`         | Image pull policy                 | `Always`                                  |
| `agent.service.port`             | Service port                      | `80`                                      |
| `agent.service.type`             | Service type                      | `ClusterIP`                               |
| `agent.resources`                | Agent resources                   | `{}`                                      |
| `logagent.image.repository`      | The image repository              | `sematext/logagent`                       |
| `logagent.image.tag`             | The image tag                     | `latest`                                  |
| `logagent.image.pullPolicy`      | Image pull policy                 | `Always`                                  |
| `logagent.resources`             | Logagent resources                | `{}`                                      |
| `logagent.extraHostVolumeMounts` | Extra mounts                      | `{}`                                      |
| `customUrl.serverBaseUrl`        | Custom Base URL                   | `Nil`                                     |
| `customUrl.logsReceiverUrl`      | Custom Logs receiver URL          | `Nil`                                     |
| `customUrl.eventsRecieverUrl`    | Custom Event receiver URL         | `Nil`                                     |
| `serviceAccount.create`          | Create a service account          | `true`                                    |
| `serviceAccount.name`            | Service account name              | `Nil` Defaults to chart name              |
| `rbac.create`                    | RBAC enabled                      | `true`                                    |
| `tolerations`                    | Tolerations                       | `[]`                                      |
| `nodeSelector`                   | Node selector                     | `{}`                                      |

For example, if you want to deploy Sematext Agent in EU region and provide YOUR_CONTAINER_TOKEN and YOUR_LOGS_TOKEN, create the following resource:

```yaml
apiVersion: sematext.com/v1alpha1
kind: SematextAgent
metadata:
  name: test-sematextagent
spec:
  region: "EU"
  containerToken: YOUR_CONTAINER_TOKEN
  logsToken: YOUR_LOGS_TOKEN
```

**NOTE:** You need to create [a new Docker app in Sematext Cloud](https://apps.sematext.com/ui/integrations/create/docker) to get relevant tokens.

Once you have created the above resource, you can apply this file with `kubectl apply -f`.

Then you can see you pods with the Sematext Agent deployed:

```sh
sematext-operator-58565cbf84-shbwx                                1/1     Running       0          3m
test-sematextagent-5nx9ybt86klqkrgcvzuaqpztk-sematext-agen7qpv7   2/2     Running       0          2m
test-sematextagent-5nx9ybt86klqkrgcvzuaqpztk-sematext-agen9gdkh   2/2     Running       0          2m
test-sematextagent-5nx9ybt86klqkrgcvzuaqpztk-sematext-agendvqpw   2/2     Running       0          2m
test-sematextagent-5nx9ybt86klqkrgcvzuaqpztk-sematext-agenntfzv   2/2     Running       0          2m
```

## Removal

Run the `kubectl delete` command to remove the operator and its dependencies:

```sh
kubectl delete -f https://raw.githubusercontent.com/sematext/sematext-operator/master/bundle.yaml
```
