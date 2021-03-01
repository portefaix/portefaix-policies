# @title Pod must run without access to the host networking
#
# Pods that can access the host's network interfaces can potentially
# access and tamper with traffic the pod should not have access to.
#
# @kinds apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

package pod_host_network

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX_0012"

violation[msg] {
    pods.pod[pod]
    pod_host_network(pod)

    msg := core.format_with_id(sprintf("%s/%s: Pod must run without access to the host networking", [core.kind, core.name]), policyID)
}

pod_host_network(pod) {
    pod.spec.hostNetwork
}
