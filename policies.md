# Policies

## Violations

* [PORTEFAIX-0001: Common Kubernetes labels are set](#portefaix-0001-common-kubernetes-labels-are-set)
* [PORTEFAIX-0002: Container must not use latest image tag](#portefaix-0002-container-must-not-use-latest-image-tag)
* [PORTEFAIX-0003: Container must define resource contraintes](#portefaix-0003-container-must-define-resource-contraintes)
* [PORTEFAIX-0004: Container must set liveness probe](#portefaix-0004-container-must-set-liveness-probe)
* [PORTEFAIX-0005: Container must set readiness probe](#portefaix-0005-container-must-set-readiness-probe)
* [PORTEFAIX-0006: Container must set readiness probe](#portefaix-0006-container-must-set-readiness-probe)
* [PORTEFAIX-0007: Container must mount secrets as volumes, not enviroment variables](#portefaix-0007-container-must-mount-secrets-as-volumes,-not-enviroment-variables)
* [PORTEFAIX-0008: Container must drop all capabilities](#portefaix-0008-container-must-drop-all-capabilities)
* [PORTEFAIX-0009: Container must not allow for privilege escalation](#portefaix-0009-container-must-not-allow-for-privilege-escalation)
* [PORTEFAIX-0010: Pod must run without access to the host aliases](#portefaix-0010-pod-must-run-without-access-to-the-host-aliases)
* [PORTEFAIX-0011: Pod must run without access to the host IPC](#portefaix-0011-pod-must-run-without-access-to-the-host-ipc)
* [PORTEFAIX-0012: Pod must run without access to the host networking](#portefaix-0012-pod-must-run-without-access-to-the-host-networking)
* [PORTEFAIX-0013: Pod must run without access to the host PID namespace](#portefaix-0013-pod-must-run-without-access-to-the-host-pid-namespace)
* [PORTEFAIX-0014: Pod must run as non-root](#portefaix-0014-pod-must-run-as-non-root)

## PORTEFAIX-0001: Common Kubernetes labels are set

**Severity:** Violation

**Resources:** Any Resource

See: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels

### Rego

```rego
package k8s_labels

import data.lib.core # as konstraint_core

policyID := "PORTEFAIX-0001"

violation[msg] {
	not recommended_labels_provided(core.resource.metadata)
	msg = core.format_with_id(sprintf("%s/%s: does not contain all the expected k8s labels", [core.kind, core.name]), "PORTEFAIX-0001")
}

recommended_labels_provided(metadata) {
	metadata.labels["app.kubernetes.io/name"]
	metadata.labels["app.kubernetes.io/instance"]
	metadata.labels["app.kubernetes.io/version"]
	metadata.labels["app.kubernetes.io/component"]
	metadata.labels["app.kubernetes.io/part-of"]
	metadata.labels["app.kubernetes.io/managed-by"]
}
```

_source: [policy/0001-commons-labels](policy/0001-commons-labels)_

## PORTEFAIX-0002: Container must not use latest image tag

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

See: https://kubernetes.io/docs/concepts/configuration/overview/#container-images

### Rego

```rego
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
```

_source: [policy/0002-container-image-tag](policy/0002-container-image-tag)_

## PORTEFAIX-0003: Container must define resource contraintes

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Resource constraints on containers ensure that a given workload does not take up more resources than it requires
and potentially starve other applications that need to run.

See: https://kubesec.io/basics/containers-resources-limits-cpu/

### Rego

```rego
package container_resource_constraints

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-0003"

violation[msg] {
	pods.containers[container]
	not container_resources_provided(container)
	msg := core.format_with_id(sprintf("%s/%s/%s: Container resource constraints must be specified", [core.kind, core.name, container.name]), policyID)
}

container_resources_provided(container) {
	container.resources.requests.cpu
	container.resources.requests.memory
	container.resources.limits.cpu
	container.resources.limits.memory
}
```

_source: [policy/0003-container-resources](policy/0003-container-resources)_

## PORTEFAIX-0004: Container must set liveness probe

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Indicates whether the container is running

See: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes

### Rego

```rego
package container_liveness_probe

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-0004"

violation[msg] {
	pods.containers[container]
	not container_liveness_probe_provided(container)
	msg := core.format_with_id(sprintf("%s/%s/%s: Container liveness probe be specified", [core.kind, core.name, container.name]), policyID)
}

container_liveness_probe_provided(container) {
	core.has_field(container, "livenessProbe")
}
```

_source: [policy/0004-container-liveness-probe](policy/0004-container-liveness-probe)_

## PORTEFAIX-0005: Container must set readiness probe

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Indicates whether the container is ready to respond to requests. If you don't set the readiness probe,
the kubelet assumes that the app is ready to receive traffic as soon as the container starts.

See: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes

### Rego

```rego
package container_readiness_probe

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-0005"

violation[msg] {
	pods.containers[container]
	not container_liveness_probe_provided(container)
	msg := core.format_with_id(sprintf("%s/%s/%s: Container readiness probe be specified", [core.kind, core.name, container.name]), policyID)
}

container_liveness_probe_provided(container) {
	core.has_field(container, "readinessProbe")
}
```

_source: [policy/0005-container-readiness-probe](policy/0005-container-readiness-probe)_

## PORTEFAIX-0006: Container must set readiness probe

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

When Liveness and Readiness probes are pointing to the same endpoint,
the effects of the probes are combined.
When the app signals that it's not ready or live,
the kubelet detaches the container from the Service and delete it at the same time.
See: https://learnk8s.io/production-best-practices#application-development

### Rego

```rego
package container_same_probes

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-0006"

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
```

_source: [policy/0006-container-same-probes](policy/0006-container-same-probes)_

## PORTEFAIX-0007: Container must mount secrets as volumes, not enviroment variables

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

This is to prevent that the secret values appear in the command that was
used to start the container, which may be inspected by individuals that
shouldn't have access to the secret values.

See: https://learnk8s.io/production-best-practices#application-development

### Rego

```rego
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
```

_source: [policy/0007-container-secret-not-env](policy/0007-container-secret-not-env)_

## PORTEFAIX-0008: Container must drop all capabilities

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Granting containers privileged capabilities on the node makes it easier
for containers to escalate their privileges.

### Rego

```rego
package container_capabilities

import data.lib.core
import data.lib.pods
import data.lib.security

policyID := "PORTEFAIX-0008"

violation[msg] {
	pods.containers[container]
	not container_dropped_all_capabilities(container)
	msg := core.format_with_id(sprintf("%s/%s/%s: Container must drop all capabilities", [core.kind, core.name, container.name]), policyID)
}

container_dropped_all_capabilities(container) {
	security.dropped_capability(container, "all")
}
```

_source: [policy/0008-container-capabilities](policy/0008-container-capabilities)_

## PORTEFAIX-0009: Container must not allow for privilege escalation

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Privileged containers can much more easily obtain root on the node.

### Rego

```rego
package container_escalation

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-0009"

violation[msg] {
	pods.containers[container]
	container_allows_escalation(container)

	msg := core.format_with_id(sprintf("%s/%s: Allows privilege escalation", [core.kind, core.name]), policyID)
}

container_allows_escalation(c) {
	c.securityContext.allowPrivilegeEscalation == true
}

container_allows_escalation(c) {
	core.missing_field(c.securityContext, "allowPrivilegeEscalation")
}
```

_source: [policy/0009-container-escaladation](policy/0009-container-escaladation)_

## PORTEFAIX-0010: Pod must run without access to the host aliases

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Pods that can change aliases in the host's /etc/hosts file can
redirect traffic to malicious servers.

### Rego

```rego
package pod_host_alias

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-0010"

violation[msg] {
	pods.pod[pod]
	pod_host_alias(pod)
	msg := core.format_with_id(sprintf("%s/%s: Pod must not have hostAliases", [core.kind, core.name]), policyID)
}

pod_host_alias(pod) {
	pod.spec.hostAliases
}
```

_source: [policy/0010-pod-host-alias](policy/0010-pod-host-alias)_

## PORTEFAIX-0011: Pod must run without access to the host IPC

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Pods that are allowed to access the host IPC can read memory of
the other containers, breaking that security boundary.

### Rego

```rego
package pod_host_ipc

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-0011"

violation[msg] {
	pods.pod[pod]
	pod_host_ipc(pod)
	msg := core.format_with_id(sprintf("%s/%s: Pod must run without access to the host IPC", [core.kind, core.name]), policyID)
}

pod_host_ipc(pod) {
	pod.spec.hostIPC
}
```

_source: [policy/0011-pod-host-ipc](policy/0011-pod-host-ipc)_

## PORTEFAIX-0012: Pod must run without access to the host networking

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Pods that can access the host's network interfaces can potentially
access and tamper with traffic the pod should not have access to.

### Rego

```rego
package pod_host_network

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-0012"

violation[msg] {
	pods.pod[pod]
	pod_host_network(pod)

	msg := core.format_with_id(sprintf("%s/%s: Pod must run without access to the host networking", [core.kind, core.name]), policyID)
}

pod_host_network(pod) {
	pod.spec.hostNetwork
}
```

_source: [policy/0012-pod-host-network](policy/0012-pod-host-network)_

## PORTEFAIX-0013: Pod must run without access to the host PID namespace

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Pods that can access the host's process tree can view and attempt to
modify processes outside of their namespace, breaking that security
boundary.

### Rego

```rego
package pod_host_pid

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-0013"

violation[msg] {
	pods.pod[pod]
	pod_host_pid(pod)
	msg := core.format_with_id(sprintf("%s/%s: Pods must run without access to the host PID namespace", [core.kind, core.name]), policyID)
}

pod_host_pid(pod) {
	pod.spec.hostPID
}
```

_source: [policy/0013-pod-host-pid](policy/0013-pod-host-pid)_

## PORTEFAIX-0014: Pod must run as non-root

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Pods running as root (uid of 0) can much more easily escalate privileges
to root on the node. As such, they are not allowed.

### Rego

```rego
package pod_run_as_nonroot

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-0014"

violation[msg] {
	pods.pod[pod]
	not pod_run_as_non_root(pod)

	msg := core.format_with_id(sprintf("%s/%s: Pod must run as non-root", [core.kind, core.name]), policyID)
}

pod_run_as_non_root(pod) {
	pod.spec.securityContext.runAsNonRoot
}
```

_source: [policy/0014-pod-without-runasnonroot](policy/0014-pod-without-runasnonroot)_
