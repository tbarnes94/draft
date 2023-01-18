package k8srestrictedimagepulls

data_namespace := {
    "test-namespace": {
        "v1": {
            "Secret": {
                "secret1": {},
                "secret2": {}
            }
        }
    }
}

test_disallowed_edit_no_image_pulls_object {
    count(violation) > 0 with input as {
       	"review": {
            "object": {
                "spec": {},
                "metadata": {
                    "name": "test-pod"
                }
            },
            "namespace": "test-namespace"
        }
    }

}

test_disallowed_edit_pod_secret_is_not_registered {
    count(violation) > 0 with input as {
       	"review": {
            "object": {
                "spec": {
                    "imagePullSecrets": [
                        {"name": "test-secret"}
                    ]
                },
                "metadata": {
                    "name": "test-pod"
                }
            },
            "namespace": "test-namespace"
        }        
    } with data.inventory.namespace as data_namespace

}

test_allowed_edit_pod_secret_is_registered{
    count(violation) == 0 with input as {
       	"review": {
            "object": {
                "spec": {
                    "imagePullSecrets": [
                        {"name": "secret1"}
                    ]
                },
                "metadata": {
                    "name": "test-pod"
                }
            },
            "namespace": "test-namespace"
        }
    } with data.inventory.namespace as data_namespace
}