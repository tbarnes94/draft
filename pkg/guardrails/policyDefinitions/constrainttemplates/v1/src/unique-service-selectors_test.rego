package k8suniqueserviceselector


test_disallowed_other_services_with_same_selector {
    count(violation) > 0 with input as {
       "review": {
           "kind": {
               "kind": "Service",
               "version": "v1",
               "group": ""
           },
           "object": {
               "kind": "Service",
               "metadata": {
                   "name": "service_name",
                   "namespace": "some_ns",
                   "labels": {
                       "kubernetes.azure.com/mode": "System"
                   }
               },
               "spec": {
                   "selector": {
                           "some-key": "some-value"
                       }
                   }
           }
       },
       "parameters": {
           "reservedTaints": ["reserved-taint"]
       }
   } with data.inventory as {
        "namespace": {
            "some_ns": {
                "some_group_for_service": {
                    "Service": [
                        {
                            "kind": "Service",
                            "apiVersion": "v1",
                            "metadata": {
                                "name": "some_other_name",
                                "namespace": "some_ns"
                            },
                            "spec": {
                                "selector": {
                                    "some-key": "some-value"
                                }
                            }
                        }
                    ]
                }
            }
        }
    }
}

test_allowed_other_no_services_with_same_selector {
    count(violation) == 0 with input as {
       "review": {
           "kind": {
               "kind": "Service",
               "version": "v1",
               "group": ""
           },
           "object": {
               "kind": "Service",
               "metadata": {
                   "name": "service_name",
                   "namespace": "some_ns",
                   "labels": {
                       "kubernetes.azure.com/mode": "System"
                   }
               },
               "spec": {
                   "selector": {
                           "some-key": "some-value"
                       }
                   }
           }
       },
       "parameters": {
           "reservedTaints": ["reserved-taint"]
       }
   } with data.inventory as {
        "namespace": {
            "some_ns": {
                "some_group_for_service": {
                    "Service": [
                        {
                            "kind": "Service",
                            "apiVersion": "v1",
                            "metadata": {
                                "name": "some_other_name",
                                "namespace": "some_ns"
                            },
                            "spec": {
                                "selector": {
                                    "some-other-key": "some-value"
                                }
                            }
                        }
                    ]
                }
            }
        }
    }
}