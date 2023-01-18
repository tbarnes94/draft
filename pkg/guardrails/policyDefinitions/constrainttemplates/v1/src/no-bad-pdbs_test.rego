package k8spoddisruptionbudget

# ===========================================================
# Testing Max_unavailable
# ===========================================================
test_allowed_valid_max_unavailable {
    count(violation) == 0 with input as {
        "review": {
            "kind": {
                "kind": "PodDisruptionBudget"
            },
            "object": {
                "metadata": {
                    "name": "PDB_NAME"
                },
                "spec": {
                    "maxUnavailable": 1
                }
            }
        }
    }
}

test_allowed_valid_max_unavailable_field_missing {
    count(violation) == 0 with input as {
        "review": {
            "kind": {
                "kind": "PodDisruptionBudget"
            },
            "object": {
                "metadata": {
                    "name": "PDB_NAME"
                },
                "spec": {
                    "somefield": 1
                }
            }
        }
    }
}

test_disallowed_invalid_max_unavailable {
    count(violation) > 0 with input as {
        "review": {
            "kind": {
                "kind": "PodDisruptionBudget"
            },
            "object": {
                "metadata": {
                    "name": "PDB_NAME"
                },
                "spec": {
                    "maxUnavailable": 0
                }
            }
        }
    }
}

# ===========================================================
# Testing Max_unavailable with PDB in inventory
# ===========================================================

test_allowed_valid_max_unavailable_pdb_in_inventory {
    count(violation) == 0 with input as {
        "review": {
            "kind": {
                "kind": "Deployment"
            },
            "object": {
                "kind": "Deployment",
                "metadata": {
                    "name": "DEPLOY_NAME",
                    "namespace": "some_ns"
                },
                "spec": {
                    "selector": {
                        "matchLabels": {
                            "some-key": "some-value"
                        }
                    }
                }
            }
        }
    } with data.inventory as {
       "namespace":{
           "some_ns": {
               "policy/v1": {
                   "PodDisruptionBudget": [
                       {
                           "metadata": {
                               "name": "PDB_NAME"
                           },
                           "spec": {
                               "maxUnavailable": 1,
                               "selector": {
                                   "matchLabels": {
                                       "some-key": "some-value"
                                   }
                               }
                           }
                       }
                   ]
               }
           }
       }
   }
}


test_disallowed_valid_max_unavailable_pdb_in_inventory {
    count(violation) > 0 with input as {
        "review": {
            "kind": {
                "kind": "Deployment"
            },
            "object": {
                "kind": "Deployment",
                "metadata": {
                    "name": "DEPLOY_NAME",
                    "namespace": "some_ns"
                },
                "spec": {
                    "selector": {
                        "matchLabels": {
                            "some-key": "some-value"
                        }
                    }
                }
            }
        }
    } with data.inventory as {
       "namespace":{
           "some_ns": {
               "policy/v1": {
                   "PodDisruptionBudget": [
                       {
                           "metadata": {
                               "name": "PDB_NAME"
                           },
                           "spec": {
                               "maxUnavailable": 0,
                               "selector": {
                                   "matchLabels": {
                                       "some-key": "some-value"
                                   }
                               }
                           }
                       }
                   ]
               }
           }
       }
   }
}

test_allowed_valid_min_available_pdb_in_inventory {
    count(violation) == 0 with input as {
        "review": {
            "kind": {
                "kind": "Deployment"
            },
            "object": {
                "kind": "Deployment",
                "metadata": {
                    "name": "DEPLOY_NAME",
                    "namespace": "some_ns"
                },
                "spec": {
                    "replicas": 3,
                    "selector": {
                        "matchLabels": {
                            "some-key": "some-value"
                        }
                    }
                }
            }
        }
    } with data.inventory as {
       "namespace":{
           "some_ns": {
               "policy/v1": {
                   "PodDisruptionBudget": [
                       {
                           "metadata": {
                               "name": "PDB_NAME"
                           },
                           "spec": {
                               "minAvailable": 1,
                               "selector": {
                                   "matchLabels": {
                                       "some-key": "some-value"
                                   }
                               }
                           }
                       }
                   ]
               }
           }
       }
   }
}

test_disallowed_valid_min_available_pdb_in_inventory {
    count(violation) > 0 with input as {
        "review": {
            "kind": {
                "kind": "Deployment"
            },
            "object": {
                "kind": "Deployment",
                "metadata": {
                    "name": "DEPLOY_NAME",
                    "namespace": "some_ns"
                },
                "spec": {
                    "replicas": 3,
                    "selector": {
                        "matchLabels": {
                            "some-key": "some-value"
                        }
                    }
                }
            }
        }
    } with data.inventory as {
       "namespace":{
           "some_ns": {
               "policy/v1": {
                   "PodDisruptionBudget": [
                       {
                           "metadata": {
                               "name": "PDB_NAME"
                           },
                           "spec": {
                               "minAvailable": 3,
                               "selector": {
                                   "matchLabels": {
                                       "some-key": "some-value"
                                   }
                               }
                           }
                       }
                   ]
               }
           }
       }
   }
}

# =====================================================
# Testing Deployments
# =====================================================
test_allowed_pdb_valid_min_available_deploy_in_inventory {
    count(violation) == 0 with input as {
        "review": {
            "kind": {
                "kind": "PodDisruptionBudget"
            },
            "object": {
                 "metadata": {
                     "name": "PDB_NAME",
                     "namespace": "some_ns"
                 },
                 "spec": {
                     "minAvailable": 1,
                     "selector": {
                         "matchLabels": {
                             "some-key": "some-value"
                         }
                     }
                 }
             }
        }
    } with data.inventory as {
       "namespace":{
           "some_ns": {
               "apps/v1": {
                   "Deployment": [
                       {
                           "kind": "Deployment",
                           "metadata": {
                               "name": "DEPLOY_NAME",
                               "namespace": "some_ns"
                           },
                           "spec": {
                               "replicas": 3,
                               "selector": {
                                   "matchLabels": {
                                       "some-key": "some-value"
                                   }
                               }
                           }
                       }
                   ]
               }
           }
       }
   }
}

test_disallowed_pdb_valid_min_available_deploy_in_inventory {
    count(violation) > 0 with input as {
        "review": {
            "kind": {
                "kind": "PodDisruptionBudget"
            },
            "object": {
                 "metadata": {
                     "name": "PDB_NAME",
                     "namespace": "some_ns"
                 },
                 "spec": {
                     "minAvailable": 3,
                     "selector": {
                         "matchLabels": {
                             "some-key": "some-value"
                         }
                     }
                 }
             }
        }
    } with data.inventory as {
       "namespace":{
           "some_ns": {
               "apps/v1": {
                   "Deployment": [
                       {
                           "kind": "Deployment",
                           "metadata": {
                               "name": "DEPLOY_NAME",
                               "namespace": "some_ns"
                           },
                           "spec": {
                               "replicas": 3,
                               "selector": {
                                   "matchLabels": {
                                       "some-key": "some-value"
                                   }
                               }
                           }
                       }
                   ]
               }
           }
       }
   }
}

# =====================================================
# Testing StatefulSets
# =====================================================
test_allowed_pdb_valid_min_available_statefulset_in_inventory {
    count(violation) == 0 with input as {
        "review": {
            "kind": {
                "kind": "PodDisruptionBudget"
            },
            "object": {
                 "metadata": {
                     "name": "PDB_NAME",
                     "namespace": "some_ns"
                 },
                 "spec": {
                     "minAvailable": 1,
                     "selector": {
                         "matchLabels": {
                             "some-key": "some-value"
                         }
                     }
                 }
             }
        }
    } with data.inventory as {
       "namespace":{
           "some_ns": {
               "apps/v1": {
                   "StatefulSet": [
                       {
                           "kind": "StatefulSet",
                           "metadata": {
                               "name": "SS_NAME",
                               "namespace": "some_ns"
                           },
                           "spec": {
                               "replicas": 3,
                               "selector": {
                                   "matchLabels": {
                                       "some-key": "some-value"
                                   }
                               }
                           }
                       }
                   ]
               }
           }
       }
   }
}

test_disallowed_pdb_valid_min_available_statefulset_in_inventory {
    count(violation) > 0 with input as {
        "review": {
            "kind": {
                "kind": "PodDisruptionBudget"
            },
            "object": {
                 "metadata": {
                     "name": "PDB_NAME",
                     "namespace": "some_ns"
                 },
                 "spec": {
                     "minAvailable": 3,
                     "selector": {
                         "matchLabels": {
                             "some-key": "some-value"
                         }
                     }
                 }
             }
        }
    } with data.inventory as {
       "namespace":{
           "some_ns": {
               "apps/v1": {
                   "StatefulSet": [
                       {
                           "kind": "StatefulSet",
                           "metadata": {
                               "name": "SS_NAME",
                               "namespace": "some_ns"
                           },
                           "spec": {
                               "replicas": 3,
                               "selector": {
                                   "matchLabels": {
                                       "some-key": "some-value"
                                   }
                               }
                           }
                       }
                   ]
               }
           }
       }
   }
}

# =====================================================
# Testing StatefulSets
# =====================================================
test_allowed_pdb_valid_min_available_Replicaset_in_inventory {
    count(violation) == 0 with input as {
        "review": {
            "kind": {
                "kind": "PodDisruptionBudget"
            },
            "object": {
                 "metadata": {
                     "name": "PDB_NAME",
                     "namespace": "some_ns"
                 },
                 "spec": {
                     "minAvailable": 1,
                     "selector": {
                         "matchLabels": {
                             "some-key": "some-value"
                         }
                     }
                 }
             }
        }
    } with data.inventory as {
       "namespace":{
           "some_ns": {
               "apps/v1": {
                   "ReplicaSet": [
                       {
                           "kind": "ReplicaSet",
                           "metadata": {
                               "name": "SS_NAME",
                               "namespace": "some_ns"
                           },
                           "spec": {
                               "replicas": 3,
                               "selector": {
                                   "matchLabels": {
                                       "some-key": "some-value"
                                   }
                               }
                           }
                       }
                   ]
               }
           }
       }
   }
}

test_disallowed_pdb_valid_min_available_replicaset_in_inventory {
    count(violation) > 0 with input as {
        "review": {
            "kind": {
                "kind": "PodDisruptionBudget"
            },
            "object": {
                 "metadata": {
                     "name": "PDB_NAME",
                     "namespace": "some_ns"
                 },
                 "spec": {
                     "minAvailable": 3,
                     "selector": {
                         "matchLabels": {
                             "some-key": "some-value"
                         }
                     }
                 }
             }
        }
    } with data.inventory as {
       "namespace":{
           "some_ns": {
               "apps/v1": {
                   "ReplicaSet": [
                       {
                           "kind": "ReplicaSet",
                           "metadata": {
                               "name": "SS_NAME",
                               "namespace": "some_ns"
                           },
                           "spec": {
                               "replicas": 3,
                               "selector": {
                                   "matchLabels": {
                                       "some-key": "some-value"
                                   }
                               }
                           }
                       }
                   ]
               }
           }
       }
   }
}

