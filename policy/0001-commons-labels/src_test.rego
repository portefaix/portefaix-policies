package k8s_labels

test_metadata_without_labels {
	metadata := {}
	not recommended_labels_provided(metadata)
}

test_metadata_with_labels_false {
	metadata := {
		"name": "test-pod",
		"labels": {"app": "my-app"},
	}

	not recommended_labels_provided(metadata)
}

test_metadata_with_labels_true {
	metadata := {
		"name": "test-pod",
		"labels": {
			"app": "my-app",
			"app.kubernetes.io/name": "portefaix",
			"app.kubernetes.io/instance": "portefaix-app",
			"app.kubernetes.io/version": "v1.0.0",
			"app.kubernetes.io/component": "portefaix-frontend",
			"app.kubernetes.io/part-of": "portefaix",
			"app.kubernetes.io/managed-by": "portefaix",
		},
	}

	recommended_labels_provided(metadata)
}
