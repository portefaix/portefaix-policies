# Policies

## medium
* [portefaix-C0001 - Container must not use latest image tag](#portefaix-c0001)
* [portefaix-C0002 - Container must set liveness probe](#portefaix-c0002)
* [portefaix-C0003 - Container must set readiness probe](#portefaix-c0003)
* [portefaix-C0004 - Container must mount secrets as volumes, not enviroment variables](#portefaix-c0004)
* [portefaix-C0005 - Container must drop all capabilities](#portefaix-c0005)
* [portefaix-C0006 - Container must not allow for privilege escalation](#portefaix-c0006)
* [portefaix-C0007 - portefaix-C0007](#portefaix-c0007)

## low
* [portefaix-M0001 - Metadata must set recommanded Kubernetes labels](#portefaix-m0001)
* [portefaix-M0002 - Metadata should have a8r.io annotations](#portefaix-m0002)
* [portefaix-M0003 - Metadata should have portefaix.xyz annotations](#portefaix-m0003)

## portefaix-C0001 - Container must not use latest image tag

**Category:** Best Practices

**Severity:** medium

**Description:** The ':latest' tag is mutable and can lead to unexpected errors if the image changes. A best practice is to use an immutable tag that maps to a specific version of an application pod.

## portefaix-C0002 - Container must set liveness probe

**Category:** Best Practices

**Severity:** medium

**Description:** Liveness probe need to be configured to correctly manage a pods lifecycle during deployments, restarts, and upgrades. For each pod, a periodic `livenessProbe` is performed by the kubelet to determine if the pod's containers are running or need to be restarted

## portefaix-C0003 - Container must set readiness probe

**Category:** Best Practices

**Severity:** medium

**Description:** Readiness probe need to be configured to correctly manage a pods lifecycle during deployments, restarts, and upgrades. For each pod, a `readinessProbe` is used by services and deployments to determine if the pod is ready to receive network traffic.

## portefaix-C0004 - Container must mount secrets as volumes, not enviroment variables

**Category:** BestPractices

**Severity:** medium

**Description:** Disallow using secrets from environment variables which are visible in resource definitions.

## portefaix-C0005 - Container must drop all capabilities

**Category:** BestPractices

**Severity:** medium

**Description:** Capabilities permit privileged actions without giving full root access. All capabilities should be dropped from a pod, with only those required added back.

## portefaix-C0006 - Container must not allow for privilege escalation

**Category:** BestPractices

**Severity:** medium

**Description:** Privilege escalation, such as via set-user-ID or set-group-ID file mode, should not be allowed.

## portefaix-C0007 - portefaix-C0007

**Category:** BestPractices

**Severity:** medium

**Description:** Check that liveness and readiness probes are not set to the same values.

## portefaix-M0001 - Metadata must set recommanded Kubernetes labels

**Category:** Best Practices

**Severity:** low

**Description:** Metadata must set recommanded Kubernetes labels See: https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels

## portefaix-M0002 - Metadata should have a8r.io annotations

**Category:** Best Practices

**Severity:** low

**Description:** Metadata should have all the expected a8r.io annotations See: https://ambassadorlabs.github.io/k8s-for-humans/

## portefaix-M0003 - Metadata should have portefaix.xyz annotations

**Category:** Best Practices

**Severity:** low

**Description:** Metadata should have Portefaix annotations
