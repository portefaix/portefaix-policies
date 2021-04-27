# @title Pod must run without access to the host PID namespace
#
# Pods that can access the host's process tree can view and attempt to
# modify processes outside of their namespace, breaking that security
# boundary.
#
# @kinds apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

package pod_host_pid

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-P0005"

violation[msg] {
	pods.pod[pod]
	pod_host_pid(pod)
	msg := core.format_with_id(sprintf("%s/%s: Pods must run without access to the host PID namespace", [core.kind, core.name]), policyID)
}

pod_host_pid(pod) {
	pod.spec.hostPID
}
