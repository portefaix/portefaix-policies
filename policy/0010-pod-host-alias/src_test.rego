package pod_host_alias

test_input_with_alias_missing {
    pod := {
        "kind": "Pod",
        "spec": {}
    }

    not pod_host_alias(pod)
}

test_input_with_alias {
    pod := {
        "kind": "Pod",
        "spec": {
            "hostAliases": [
                {
                    "ip": "127.0.0.1",
                    "hostnames": ["foo.local"]
                }
            ]
        }
    }

    pod_host_alias(pod)
}