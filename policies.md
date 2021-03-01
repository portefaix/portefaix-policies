# Policies

## Violations

* [PORTEFAIX-0001: Common Kubernetes labels are set](#portefaix-0001-common-kubernetes-labels-are-set)
* [PORTEFAIX-0002: Container must not use latest image tag](#portefaix-0002-container-must-not-use-latest-image-tag)
* [PORTEFAIX-0003: Workload must define resource contraintes](#portefaix-0003-workload-must-define-resource-contraintes)

## PORTEFAIX-0001: Common Kubernetes labels are set

**Severity:** Violation

**Resources:** Any Resource

See: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels

### Rego

```rego
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

## PORTEFAIX-0003: Workload must define resource contraintes

**Severity:** Violation

**Resources:** apps/DaemonSet apps/Deployment apps/StatefulSet core/Pod

Resource constraints on containers ensure that a given workload does not take up more resources than it requires
and potentially starve other applications that need to run.

### Rego

```rego
package workload_resource_constraints

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

_source: [policy/0003-workload-resources](policy/0003-workload-resources)_
