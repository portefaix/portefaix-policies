# @title Pod must use authorized registry
##
# @kinds apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

package pod_registry

import data.lib.core # as konstraint_core
import data.lib.pods # as konstraint_pods

policyID := "PORTEFAIX-P0001"

violation[{"msg": msg}] {
  container := input.review.object.spec.containers[_]
  image := container.image
  startswith(image, input.parameters.repos[_])
  msg := sprintf("container <%v> has an invalid image repo <%v>, disallowed repos are %v", [container.name, container.image, input.parameters.repos])
}

violation[{"msg": msg}] {
  container := input.review.object.spec.initContainers[_]
  image := container.image
  startswith(image, input.parameters.repos[_])
  msg := sprintf("initContainer <%v> has an invalid image repo <%v>, disallowed repos are %v", [container.name, container.image, input.parameters.repos])
}

violation[{"msg": msg}] {
  container := input.review.object.spec.ephemeralContainers[_]
  image := container.image
  startswith(image, input.parameters.repos[_])
  msg := sprintf("ephemeralContainer <%v> has an invalid image repo <%v>, disallowed repos are %v", [container.name, container.image, input.parameters.repos])
}
