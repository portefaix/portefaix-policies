# @title Container must set readiness probe
#
# When Liveness and Readiness probes are pointing to the same endpoint,
# the effects of the probes are combined.
# When the app signals that it's not ready or live,
# the kubelet detaches the container from the Service and delete it at the same time.

# See: https://learnk8s.io/production-best-practices#application-development
#
# @kinds apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

package container_same_probes

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-C0007"

violation[msg] {
	pods.containers[container]
	not container_same_probe_provided(container)
	msg := core.format_with_id(sprintf("%s/%s/%s: Container liveness probe and readiness probe must be different", [core.kind, core.name, container.name]), policyID)
}

container_same_probe_provided(container) {
	container.livenessProbe
	container.readinessProbe
	container.livenessProbe == container.readinessProbe
}
