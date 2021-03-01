# @title Pod must run without access to the host aliases
#
# Pods that can change aliases in the host's /etc/hosts file can
# redirect traffic to malicious servers.
#
# @kinds apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

package pod_host_alias

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-0010"

violation[msg] {
	pods.pod[pod]
	pod_host_alias(pod)
	msg := core.format_with_id(sprintf("%s/%s: Pod must not have hostAliases", [core.kind, core.name]), policyID)
}

pod_host_alias(pod) {
	pod.spec.hostAliases
}
