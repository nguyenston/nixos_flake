import KubernetesCluster from "../service/kubernetes"
import { createBinding } from "ags"

const k8s = KubernetesCluster.get_default()

export default function CurrentCluster() {
  return <box
    className="CurrentCluster"
  /* visible={createBinding(k8s, 'isProduction')} */
  >
    <icon icon="kubernetes" />
    <label label={createBinding(k8s, 'clusterName').as(cn => cn ?? 'Unknown')} />
  </box>
}
