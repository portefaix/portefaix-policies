# @title Container must set readiness probe
#
# Indicates whether the container is ready to respond to requests. If you don't set the readiness probe,
# the kubelet assumes that the app is ready to receive traffic as soon as the container starts.
#
# See: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes
#
# @kinds apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

package container_readiness_probe

import data.lib.core
import data.lib.pods

# policyID := "PORTEFAIX-C0003"

violation[msg] {
	pods.containers[container]
	not container_liveness_probe_provided(container)
	msg := core.format_with_id(sprintf("%s/%s/%s: Container readiness probe be specified", [core.kind, core.name, container.name]), "PORTEFAIX-C0003")
}

container_liveness_probe_provided(container) {
	core.has_field(container, "readinessProbe")
}
