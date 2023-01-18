package k8srequiredprobes

test_disallow_is_missing_one_probe {
    count(violation) > 0 with input as {
        "review": {
            "kind": {
                "kind": "Pod",
                "version": "v1",
                "group": ""
            },
            "object": {
                "kind": "Pod",
                "metadata": {
                    "name": "pod_name",
                    "namespace": "some_ns"
                },
                "spec": {
                    "containers": [
                        {
                            "name": "container_name",
                            "livenessProbe": {
                                "TCP": "some_value"
                            }
                        }
                    ]
                }
            }
        },
        "parameters": {
            "probeTypes": ["TCP", "UDP"],
            "probes": ["livenessProbe", "readinessProbe"]
        }
    }
}

test_allow_has_all_probes {
    count(violation) == 0 with input as {
        "review": {
            "kind": {
                "kind": "Pod",
                "version": "v1",
                "group": ""
            },
            "object": {
                "kind": "Pod",
                "metadata": {
                    "name": "pod_name",
                    "namespace": "some_ns"
                },
                "spec": {
                    "containers": [
                        {
                            "name": "container_name",
                            "livenessProbe": {
                                "TCP": "some_value"
                            },
                            "readinessProbe": {
                                "TCP": "some_value"
                            }
                        }
                    ]
                }
            }
        },
        "parameters": {
            "probeTypes": ["TCP", "UDP"],
            "probes": ["livenessProbe", "readinessProbe"]
        }
    }
}