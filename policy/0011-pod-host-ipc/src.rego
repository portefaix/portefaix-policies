# @title Pod must run without access to the host IPC
#
# Pods that are allowed to access the host IPC can read memory of
# the other containers, breaking that security boundary.
#
# @kinds apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

package pod_host_ipc

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-0011"

violation[msg] {
	pods.pod[pod]
	pod_host_ipc(pod)
	msg := core.format_with_id(sprintf("%s/%s: Pod must run without access to the host IPC", [core.kind, core.name]), policyID)
}

pod_host_ipc(pod) {
	pod.spec.hostIPC
}
