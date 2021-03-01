# @title Container must mount secrets as volumes, not enviroment variables
#
# This is to prevent that the secret values appear in the command that was
# used to start the container, which may be inspected by individuals that
#  shouldn't have access to the secret values.
# 
# See: https://learnk8s.io/production-best-practices#application-development
#
# @kinds apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

package container_mount_secrets

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-0007"

violation[msg] {
	pods.containers[container]
	container_mount_secrets(container)
	msg := core.format_with_id(sprintf("%s/%s/%s: Container must mount secrets as volumes, not enviroment variables", [core.kind, core.name, container.name]), policyID)
}

container_mount_secrets(container) {
	env := container.env[_]
	env.valueFrom.secretKeyRef
}
