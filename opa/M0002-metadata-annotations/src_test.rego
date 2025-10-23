package k8s_annotations

test_metadata_without_annotations {
	metadata := {}
	not recommended_annotations_provided(metadata)
}

test_metadata_with_annotations_false {
	metadata := {
		"name": "test-pod",
		"annotations": {"app": "my-app"},
	}

	not recommended_annotations_provided(metadata)
}

test_metadata_with_annotations_true {
	metadata := {
		"name": "test-pod",
		"annotations": {
			"app": "my-app",
			"a8r.io/description": "The foo project",
			"a8r.io/owner": "portefaix",
			"a8r.io/bugs": "https://github.com/portefaix/portefaix-policies/issues",
			"a8r.io/documentation": "https://github.com/portefaix/portefaix-policies",
			"a8r.io/repository": "https://github.com/portefaix/portefaix-policies",
			"a8r.io/support": "https://github.com/portefaix/portefaix-policies/issues",
		},
	}

	recommended_annotations_provided(metadata)
}
