package container_escalation

test_no_securityContext {
    container := {}
    not container_allows_escalation(container)
}

test_allowescalation_false {
    container := {
        "securityContext": {
            "allowPrivilegeEscalation": false
        }
    }
    not container_allows_escalation(container)
}

test_allowescalation_true {
    container := {
        "securityContext": {
            "allowPrivilegeEscalation": true
        }
    }
    container_allows_escalation(container)
}