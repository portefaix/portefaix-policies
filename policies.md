# Policies

## Violations

* [PORTEFAIX-C0001: Container must not use latest image tag](#portefaix-c0001-container-must-not-use-latest-image-tag)
* [PORTEFAIX-C0002: Container must set liveness probe](#portefaix-c0002-container-must-set-liveness-probe)
* [PORTEFAIX-C0003: Container must set readiness probe](#portefaix-c0003-container-must-set-readiness-probe)
* [PORTEFAIX-C0004: Container must mount secrets as volumes, not enviroment variables](#portefaix-c0004-container-must-mount-secrets-as-volumes,-not-enviroment-variables)
* [PORTEFAIX-C0005: Container must drop all capabilities](#portefaix-c0005-container-must-drop-all-capabilities)
* [PORTEFAIX-C0006: Container must not allow for privilege escalation](#portefaix-c0006-container-must-not-allow-for-privilege-escalation)
* [PORTEFAIX-C0007: Container must set readiness probe](#portefaix-c0007-container-must-set-readiness-probe)
* [PORTEFAIX-C0008: Container must define resource contraintes](#portefaix-c0008-container-must-define-resource-contraintes)
* [PORTEFAIX-M0001: Common Kubernetes labels are set](#portefaix-m0001-common-kubernetes-labels-are-set)
* [PORTEFAIX-P0001: Pod must run without access to the host aliases](#portefaix-p0001-pod-must-run-without-access-to-the-host-aliases)
* [PORTEFAIX-P0002: Pod must run without access to the host IPC](#portefaix-p0002-pod-must-run-without-access-to-the-host-ipc)
* [PORTEFAIX-P0003: Pod must run without access to the host networking](#portefaix-p0003-pod-must-run-without-access-to-the-host-networking)
* [PORTEFAIX-P0004: Pod must run as non-root](#portefaix-p0004-pod-must-run-as-non-root)
* [PORTEFAIX-P0005: Pod must run without access to the host PID namespace](#portefaix-p0005-pod-must-run-without-access-to-the-host-pid-namespace)

## Warnings

* [PORTEFAIX-M0002: Annotating Kubernetes Services for Humans](#portefaix-m0002-annotating-kubernetes-services-for-humans)

## PORTEFAIX-C0001: Container must not use latest image tag

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Copyright (C) 2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

See: https://kubernetes.io/docs/concepts/configuration/overview/#container-images

### Rego

```rego
package container_image_tag

import data.lib.core # as konstraint_core
import data.lib.pods # as konstraint_pods

policyID := "PORTEFAIX-C0001"

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

_source: [policy/C0001-container-image-tag](policy/C0001-container-image-tag)_

## PORTEFAIX-C0002: Container must set liveness probe

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Copyright (C) 2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Indicates whether the container is running

See: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes

### Rego

```rego
package container_liveness_probe

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-C0002"

violation[msg] {
	pods.containers[container]
	not container_liveness_probe_provided(container)
	msg := core.format_with_id(sprintf("%s/%s/%s: Container liveness probe be specified", [core.kind, core.name, container.name]), policyID)
}

container_liveness_probe_provided(container) {
	core.has_field(container, "livenessProbe")
}
```

_source: [policy/C0002-container-liveness-probe](policy/C0002-container-liveness-probe)_

## PORTEFAIX-C0003: Container must set readiness probe

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Copyright (C) 2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Indicates whether the container is ready to respond to requests. If you don't set the readiness probe,
the kubelet assumes that the app is ready to receive traffic as soon as the container starts.

See: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes

### Rego

```rego
package container_readiness_probe

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-C0003"

violation[msg] {
	pods.containers[container]
	not container_liveness_probe_provided(container)
	msg := core.format_with_id(sprintf("%s/%s/%s: Container readiness probe be specified", [core.kind, core.name, container.name]), policyID)
}

container_liveness_probe_provided(container) {
	core.has_field(container, "readinessProbe")
}
```

_source: [policy/C0003-container-readiness-probe](policy/C0003-container-readiness-probe)_

## PORTEFAIX-C0004: Container must mount secrets as volumes, not enviroment variables

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Copyright (C) 2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

This is to prevent that the secret values appear in the command that was
used to start the container, which may be inspected by individuals that
shouldn't have access to the secret values.

See: https://learnk8s.io/production-best-practices#application-development

### Rego

```rego
package container_mount_secrets

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-C0004"

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

_source: [policy/C0004-container-secret-not-env](policy/C0004-container-secret-not-env)_

## PORTEFAIX-C0005: Container must drop all capabilities

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Copyright (C) 2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Granting containers privileged capabilities on the node makes it easier
for containers to escalate their privileges.

### Rego

```rego
package container_capabilities

import data.lib.core
import data.lib.pods
import data.lib.security

policyID := "PORTEFAIX-C0005"

violation[msg] {
	pods.containers[container]
	not container_dropped_all_capabilities(container)
	msg := core.format_with_id(sprintf("%s/%s/%s: Container must drop all capabilities", [core.kind, core.name, container.name]), policyID)
}

container_dropped_all_capabilities(container) {
	security.dropped_capability(container, "all")
}
```

_source: [policy/C0005-container-capabilities](policy/C0005-container-capabilities)_

## PORTEFAIX-C0006: Container must not allow for privilege escalation

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Copyright (C) 2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Privileged containers can much more easily obtain root on the node.

### Rego

```rego
package container_escalation

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-C0006"

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

_source: [policy/C0006-container-escaladation](policy/C0006-container-escaladation)_

## PORTEFAIX-C0007: Container must set readiness probe

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Copyright (C) 2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

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
```

_source: [policy/C0007-container-same-probes](policy/C0007-container-same-probes)_

## PORTEFAIX-C0008: Container must define resource contraintes

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Copyright (C) 2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Resource constraints on containers ensure that a given workload does not take up more resources than it requires
and potentially starve other applications that need to run.

See: https://kubesec.io/basics/containers-resources-limits-cpu/

### Rego

```rego
package container_resource_constraints

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-C0008"

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

_source: [policy/C0008-container-resources](policy/C0008-container-resources)_

## PORTEFAIX-M0001: Common Kubernetes labels are set

**Severity:** Violation

**Resources:** Any Resource

Copyright (C) 2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

See: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels

### Rego

```rego
package k8s_labels

import data.lib.core # as konstraint_core

policyID := "PORTEFAIX-M0001"

violation[msg] {
	not recommended_labels_provided(core.resource.metadata)
	msg = core.format_with_id(sprintf("%s/%s: does not contain all the expected k8s labels", [core.kind, core.name]), policyID)
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

_source: [policy/M0001-metadata-labels](policy/M0001-metadata-labels)_

## PORTEFAIX-P0001: Pod must run without access to the host aliases

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Copyright (C) 2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Pods that can change aliases in the host's /etc/hosts file can
redirect traffic to malicious servers.

### Rego

```rego
package pod_host_alias

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-P0001"

violation[msg] {
	pods.pod[pod]
	pod_host_alias(pod)
	msg := core.format_with_id(sprintf("%s/%s: Pod must not have hostAliases", [core.kind, core.name]), policyID)
}

pod_host_alias(pod) {
	pod.spec.hostAliases
}
```

_source: [policy/P0001-pod-host-alias](policy/P0001-pod-host-alias)_

## PORTEFAIX-P0002: Pod must run without access to the host IPC

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Copyright (C) 2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Pods that are allowed to access the host IPC can read memory of
the other containers, breaking that security boundary.

### Rego

```rego
package pod_host_ipc

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-P0002"

violation[msg] {
	pods.pod[pod]
	pod_host_ipc(pod)
	msg := core.format_with_id(sprintf("%s/%s: Pod must run without access to the host IPC", [core.kind, core.name]), policyID)
}

pod_host_ipc(pod) {
	pod.spec.hostIPC
}
```

_source: [policy/P0002-pod-host-ipc](policy/P0002-pod-host-ipc)_

## PORTEFAIX-P0003: Pod must run without access to the host networking

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Copyright (C) 2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Pods that can access the host's network interfaces can potentially
access and tamper with traffic the pod should not have access to.

### Rego

```rego
package pod_host_network

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-P0003"

violation[msg] {
	pods.pod[pod]
	pod_host_network(pod)

	msg := core.format_with_id(sprintf("%s/%s: Pod must run without access to the host networking", [core.kind, core.name]), policyID)
}

pod_host_network(pod) {
	pod.spec.hostNetwork
}
```

_source: [policy/P0003-pod-host-network](policy/P0003-pod-host-network)_

## PORTEFAIX-P0004: Pod must run as non-root

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Copyright (C) 2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Pods running as root (uid of 0) can much more easily escalate privileges
to root on the node. As such, they are not allowed.

### Rego

```rego
package pod_run_as_nonroot

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-P0004"

violation[msg] {
	pods.pod[pod]
	not pod_run_as_non_root(pod)

	msg := core.format_with_id(sprintf("%s/%s: Pod must run as non-root", [core.kind, core.name]), policyID)
}

pod_run_as_non_root(pod) {
	pod.spec.securityContext.runAsNonRoot
}
```

_source: [policy/P0004-pod-without-runasnonroot](policy/P0004-pod-without-runasnonroot)_

## PORTEFAIX-P0005: Pod must run without access to the host PID namespace

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Copyright (C) 2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Pods that can access the host's process tree can view and attempt to
modify processes outside of their namespace, breaking that security
boundary.

### Rego

```rego
package pod_host_pid

import data.lib.core
import data.lib.pods

policyID := "PORTEFAIX-P0005"

violation[msg] {
	pods.pod[pod]
	pod_host_pid(pod)
	msg := core.format_with_id(sprintf("%s/%s: Pods must run without access to the host PID namespace", [core.kind, core.name]), policyID)
}

pod_host_pid(pod) {
	pod.spec.hostPID
}
```

_source: [policy/P0005-pod-host-pid](policy/P0005-pod-host-pid)_

## PORTEFAIX-M0002: Annotating Kubernetes Services for Humans

**Severity:** Warning

**Resources:** Any Resource

Copyright (C) 2021 Nicolas Lamirault <nicolas.lamirault@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

See: https://ambassadorlabs.github.io/k8s-for-humans/

### Rego

```rego
package k8s_annotations

import data.lib.core # as konstraint_core

policyID := "PORTEFAIX-M0002"

warn[msg] {
	not recommended_annotations_provided(core.resource.metadata)
	msg = core.format_with_id(sprintf("%s/%s: does not contain all the expected a8r annotations", [core.kind, core.name]), policyID)
}

recommended_annotations_provided(metadata) {
	metadata.annotations["a8r.io/description"]
	metadata.annotations["a8r.io/owner"]
	metadata.annotations["a8r.io/bugs"]
	metadata.annotations["a8r.io/documentation"]
	metadata.annotations["a8r.io/repository"]
	metadata.annotations["a8r.io/description"]
	metadata.annotations["a8r.io/support"]
}
```

_source: [policy/M0002-metadata-annotations](policy/M0002-metadata-annotations)_
