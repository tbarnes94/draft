package k8sreservedtaints


test_allowed_taint_on_system_pool {
    count(violation) == 0 with input as {
        "review": {
            "kind": {
                "kind": "Node"
            },
            "object": {
                "kind": "Node",
                "metadata": {
                    "labels": {
                        "kubernetes.azure.com/mode": "System"
                    }
                },
                "spec": {
                    "taints": [
                        {
                            "key": "reserved-taint",
                            "effect": "some-effect"
                        }
                    ]
                }
            },
            "parameters": {
                "reservedTaints": ["reserved-taint"]
            }
        }
    }
}

test_disallowed_taint_on_user_pool {
    count(violation) > 0 with input as {
        "review": {
            "kind": {
                "kind": "Node"
            },
            "object": {
                "kind": "Node",
                "metadata": {
                    "labels": {
                        "kubernetes.azure.com/mode": "User"
                    }
                },
                "spec": {
                    "taints": [
                        {
                            "key": "reserved-taint",
                            "effect": "some-effect"
                        }
                    ]
                }
            }
        },
         "parameters": {
             "reservedTaints": ["reserved-taint"]
         }
    }
}