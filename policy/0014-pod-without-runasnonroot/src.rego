# @title Pod must run as non-root
#
# Pods running as root (uid of 0) can much more easily escalate privileges
# to root on the node. As such, they are not allowed.
#
# @kinds apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

package pod_run_as_nonroot

import data.lib.pods
import data.lib.core

policyID := "PORTEFAIX_0014"

violation[msg] {
    pods.pod[pod]
    not pod_run_as_non_root(pod)

    msg := core.format_with_id(sprintf("%s/%s: Pod must run as non-root", [core.kind, core.name]), policyID)
}

pod_run_as_non_root(pod) {
    pod.spec.securityContext.runAsNonRoot
}
