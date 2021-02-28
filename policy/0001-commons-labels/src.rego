# @title PORTEFAIX-0001: Common Kubernetes labels are set
#
# See: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels

package k8s_labels

import data.lib.core # as konstraint_core

policyID := "PORTEFAIX-0001"

recommended_labels(metadata) {
	metadata.labels["app.kubernetes.io/name"]
	metadata.labels["app.kubernetes.io/instance"]
	metadata.labels["app.kubernetes.io/version"]
	metadata.labels["app.kubernetes.io/component"]
	metadata.labels["app.kubernetes.io/part-of"]
	metadata.labels["app.kubernetes.io/managed-by"]
}

violation[msg] {
	not recommended_labels(core.resource.metadata)
	msg = core.format_with_id(sprintf("%s/%s: does not contain all the expected k8s labels", [core.kind, core.name]), "PORTEFAIX-0001")
}
