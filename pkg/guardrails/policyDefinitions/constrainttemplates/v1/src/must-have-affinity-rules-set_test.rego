package k8saffinityrules


test_disallowed_missing_affinity_field {
    count(violation) > 0 with input as {
        "review": {
        "kind":{
                    "kind": "Deployment"
                },
            "object": {
                "spec": {
                    "replicas": 4,
                    "template": {
                        "spec": {
                            "metadata":{
                                "name": "test"
                            }
                        }
                    }
                }
            }
        }
    }
}

test_disallowed_missing_pod_affinity_field {
    count(violation) > 0 with input as {
        "review": {
        "kind":{
                    "kind": "Deployment"
                },
            "object": {
                "spec": {
                    "replicas": 4,
                    "template": {
                        "spec": {
                            "affinity":{
                                "someotherfield": "someothervalue"
                            }
                        }
                    }
                }
            }
        }
    }
}

test_allowed_multiple_replicas {
    count(violation) == 0 with input as {
        "review": {
        "kind":{
                    "kind": "Deployment"
                },
            "object": {
                "spec": {
                    "replicas": 4,
                    "template": {
                        "spec": {
                            "affinity":{
                                "podAntiAffinity": {
                                    "weight": 100
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

test_allowed_single_replicas {
    count(violation) == 0 with input as {
        "review": {
        "kind":{
                    "kind": "Deployment"
                },
            "object": {
                "spec": {
                    "replicas": 1,
                    "template": {
                        "spec": {
                            "metadata": {
                                "name":"somename"
                            }
                        }
                    }
                }
            }
        }
    }
}