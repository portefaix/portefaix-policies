package container_mount_secrets

test_input_as_container_mount_secret_in_env {
    container := {
        "env": [
            {
                "name": "TOKEN",
                "valueFrom": {
                    "secretKeyRef": {
                        "name": "my-secret",
                        "key": "token",
                    }
                }
            }
        ]
    }
    container_mount_secrets(container)
}