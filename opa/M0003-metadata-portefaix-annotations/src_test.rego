package k8s_annotations_portefaix

test_metadata_without_annotations {
	metadata := {}
	not recommended_portefaix_annotations_provided(metadata)
}

test_metadata_with_annotations_false {
	metadata := {
		"name": "test-pod",
		"annotations": {"app": "my-app"},
	}

	not recommended_portefaix_annotations_provided(metadata)
}

test_metadata_with_annotations_true {
	metadata := {
		"name": "test-pod",
		"annotations": {
			"app": "my-app",
			"portefaix.xyz/version": "v0.0.0",
		},
	}

	recommended_portefaix_annotations_provided(metadata)
}
