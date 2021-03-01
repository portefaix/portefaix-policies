package pod_host_network

test_hostnetwork_false {
    pod := {
        "kind": "Pod",
        "metadata": {
            "name": "test-pod"
        },
        "spec": {
            "hostNetwork": false,
        }
    }

    not pod_host_network(pod)
}

test_hostnetwork_true {
    pod := {
        "kind": "Pod",
        "metadata": {
            "name": "test-pod"
        },
        "spec": {
            "hostNetwork": true,
        }
    }

    pod_host_network(pod)
}
