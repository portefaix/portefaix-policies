package pod_host_pid

test_hostpid_false {
    pod := {
        "kind": "Pod",
        "metadata": {
            "name": "test-pod"
        },
        "spec": {
            "hostPID": false,
        }
    }

    not pod_host_pid(pod)
}

test_hostpid_true {
    pod := {
        "kind": "Pod",
        "metadata": {
            "name": "test-pod"
        },
        "spec": {
            "hostPID": true,
        }
    }

    pod_host_pid(pod)
}
