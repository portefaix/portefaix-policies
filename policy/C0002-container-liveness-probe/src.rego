# @title Container must set liveness probe
#
# Indicates whether the container is running
#
# See: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
#
# @kinds apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

package container_liveness_probe

import data.lib.core
import data.lib.pods

# policyID := "PORTEFAIX-C0002"

violation[msg] {
	pods.containers[container]
	not container_liveness_probe_provided(container)
	msg := core.format_with_id(sprintf("%s/%s/%s: Container liveness probe be specified", [core.kind, core.name, container.name]), "PORTEFAIX-C0002")
}

container_liveness_probe_provided(container) {
	core.has_field(container, "livenessProbe")
}
