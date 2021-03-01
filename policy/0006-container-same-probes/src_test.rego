package container_same_probes

test_input_as_container_has_differents_probe {
	container := {
		"livenessProbe": {
			"httpGet": {
				"path": "/health",
				"scheme": "HTTP",
				"port": 8181,
			},
			"initialDelaySeconds": 5,
			"periodSeconds": 5,
		},
		"readinessProbe": {
			"httpGet": {
				"path": "/ready",
				"scheme": "HTTP",
				"port": 8181,
			},
			"initialDelaySeconds": 5,
			"periodSeconds": 5,
		},
	}

	not container_same_probe_provided(container)
}

test_input_as_container_has_same_probe {
	container := {
		"livenessProbe": {
			"httpGet": {
				"path": "/health",
				"scheme": "HTTP",
				"port": 8181,
			},
			"initialDelaySeconds": 5,
			"periodSeconds": 5,
		},
		"readinessProbe": {
			"httpGet": {
				"path": "/health",
				"scheme": "HTTP",
				"port": 8181,
			},
			"initialDelaySeconds": 5,
			"periodSeconds": 5,
		},
	}

	container_same_probe_provided(container)
}
