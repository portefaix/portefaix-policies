# @title PORTEFAIX-0002: Container do not use latest image tag
#
# See: https://kubernetes.io/docs/concepts/configuration/overview/#container-images

package container_image_tag

import data.lib.core # as konstraint_core
import data.lib.pods # as konstraint_pods

policyID := "PORTEFAIX-0002"

violation[msg] {
	pods.containers[container]
	has_latest_tag(container)

	msg := core.format_with_id(sprintf("%s/%s/%s: Images must not use the latest tag", [core.kind, core.name, container.name]), policyID)
}

has_latest_tag(c) {
	endswith(c.image, ":latest")
}

has_latest_tag(c) {
	contains(c.image, ":") == false
}
