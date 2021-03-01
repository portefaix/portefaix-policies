package pod_host_ipc

test_hostipc_false {
	pod := {
		"kind": "Pod",
		"metadata": {"name": "test-pod"},
		"spec": {"hostIPC": false},
	}

	not pod_host_ipc(pod)
}

test_hostipc_true {
	pod := {
		"kind": "Pod",
		"metadata": {"name": "test-pod"},
		"spec": {"hostIPC": true},
	}

	pod_host_ipc(pod)
}
