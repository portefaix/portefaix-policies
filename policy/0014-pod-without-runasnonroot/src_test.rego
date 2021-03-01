package pod_run_as_nonroot

test_runasnonroot_true {
    pod := {
        "kind": "Pod",
        "metadata": {
            "name": "test-pod"
        },
        "spec": {
            "securityContext": {
                "runAsNonRoot": true
            }
        }
    }

    pod_run_as_non_root(pod)
}

test_runasnonroot_null {
    pod := {
        "kind": "Pod",
        "metadata": {
            "name": "test-pod"
        }
    }

    not pod_run_as_non_root(pod)
}

test_runasnonroot_false {
    pod := {
        "kind": "Pod",
        "metadata": {
            "name": "test-pod"
        },
        "spec": {
            "securityContext": {
                "runAsNonRoot": false
            }
        }
    }

    not pod_run_as_non_root(pod)
}
