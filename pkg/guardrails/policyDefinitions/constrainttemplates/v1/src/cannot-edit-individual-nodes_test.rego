package k8srestrictednodeedits

test_disallowed_change_label_is_not_system_account {
    count(violation) > 0 with input as {
        "review":{
            "userInfo": {
                "username":"unknown",
                "groups":["system:node3"]
            },
            "object":{
                "metadata":{
                    "labels":{
                        "label1":"value2"
                    }
                },
                "spec":{
                    "taints":[{
                        "key":"key1"
                    }]
                }
            },
            "oldObject":{
                "metadata":{
                    "labels":{
                        "label1":"value1"
                    }
                },
                "spec":{
                    "taints":[{
                        "key":"key1"
                    }]
                }
            }
        },
        "parameters":{
            "allowedUsers": ["nodeclient","system:serviceaccount:kube-system:aci-connector-linux","system:serviceaccount:kube-system:node-controller","acsService","aksService","system:serviceaccount:kube-system:cloud-node-manager"],
            "allowedGroups": ["system:node"]
        }
    }
}

test_allowed_change_label_is_system_account {
    count(violation) == 0 with input as {
        "review":{
            "userInfo": {
                "username":"unknown",
                "groups":["system:node"]
            },
            "object":{
                "metadata":{
                    "labels":{
                        "label1":"value2"
                    }
                },
                "spec":{
                    "taints":[{
                        "key":"key1"
                    }]
                }
            },
            "oldObject":{
                "metadata":{
                    "labels":{
                        "label1":"value1"
                    }
                },
                "spec":{
                    "taints":[{
                        "key":"key1"
                    }]
                }
            }
        },
        "parameters":{
            "allowedUsers": ["nodeclient","system:serviceaccount:kube-system:aci-connector-linux","system:serviceaccount:kube-system:node-controller","acsService","aksService","system:serviceaccount:kube-system:cloud-node-manager"],
            "allowedGroups": ["system:node"]
        }
    }
}

test_disallowed_change_taint_is_not_system_account {
    count(violation) > 0 with input as {
       "review":{
           "userInfo": {
               "username":"unknown",
               "groups":["someaccount"]
           },
           "object":{
               "metadata":{
                   "labels":{
                       "label1":"value1"
                   }
               },
               "spec":{
                   "taints":[{
                       "key":"key2"
                   }]
               }
           },
           "oldObject":{
               "metadata":{
                   "labels":{
                       "label1":"value1"
                   }
               },
               "spec":{
                   "taints":[{
                       "key":"key1"
                   }]
               }
           }
       },
       "parameters":{
           "allowedUsers": ["nodeclient","system:serviceaccount:kube-system:aci-connector-linux","system:serviceaccount:kube-system:node-controller","acsService","aksService","system:serviceaccount:kube-system:cloud-node-manager"],
        "allowedGroups": ["system:node"]
       }
   }
}

test_allowed_change_taint_is_system_account {
    count(violation) == 0 with input as {
       "review":{
           "userInfo": {
               "username":"unknown",
               "groups":["system:node"]
           },
           "object":{
               "metadata":{
                   "labels":{
                       "label1":"value1"
                   }
               },
               "spec":{
                   "taints":[{
                       "key":"key2"
                   }]
               }
           },
           "oldObject":{
               "metadata":{
                   "labels":{
                       "label1":"value1"
                   }
               },
               "spec":{
                   "taints":[{
                       "key":"key1"
                   }]
               }
           }
       },
       "parameters":{
           "allowedUsers": ["nodeclient","system:serviceaccount:kube-system:aci-connector-linux","system:serviceaccount:kube-system:node-controller","acsService","aksService","system:serviceaccount:kube-system:cloud-node-manager"],
        "allowedGroups": ["system:node"]
       }
   }
}