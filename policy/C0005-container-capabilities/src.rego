# @title Container must drop all capabilities
#
# Granting containers privileged capabilities on the node makes it easier
# for containers to escalate their privileges.
#
# @kinds apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

package container_capabilities

import data.lib.core
import data.lib.pods
import data.lib.security

policyID := "PORTEFAIX-C0005"

violation[msg] {
	pods.containers[container]
	not container_dropped_all_capabilities(container)
	msg := core.format_with_id(sprintf("%s/%s/%s: Container must drop all capabilities", [core.kind, core.name, container.name]), policyID)
}

container_dropped_all_capabilities(container) {
	security.dropped_capability(container, "all")
}
