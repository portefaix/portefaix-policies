# @title Metadata should have portefaix.xyz annotations
#
# Annotations are:
# - portefaix.xyz/version

package k8s_annotations_portefaix

import data.lib.core # as konstraint_core

policyID := "PORTEFAIX-M0003"

warn[msg] {
	not recommended_portefaix_annotations_provided(core.resource.metadata)
	msg = core.format_with_id(sprintf("%s/%s: should have all the expected portefaix.xyz annotations", [core.kind, core.name]), policyID)
}

recommended_portefaix_annotations_provided(metadata) {
	metadata.annotations["portefaix.xyz/version"]
}
