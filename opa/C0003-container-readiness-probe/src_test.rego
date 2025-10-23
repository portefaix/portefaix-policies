package container_readiness_probe

test_input_as_container_missing_liveness_probe {
	container := {}
	not container_liveness_probe_provided(container)
}

test_input_as_container_has_liveness_probe {
	container := {"readinessProbe": {
		"httpGet": {
			"path": "/health",
			"scheme": "HTTP",
			"port": 8181,
		},
		"initialDelaySeconds": 5,
		"periodSeconds": 5,
	}}

	container_liveness_probe_provided(container)
}
