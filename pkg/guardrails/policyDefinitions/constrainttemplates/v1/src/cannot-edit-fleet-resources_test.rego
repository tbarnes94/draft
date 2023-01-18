package k8srestrictedgatekeeperedits

test_disallowed_edit_is_not_system_account {
    count(violation) > 0 with input as {
       	"review": {
                "userInfo": {
                    "username":"unknown",
                    "groups":["system:node3"]
                },
                "object":{
                    "metadata":{
                        "labels":{
                            "label1": "label1",
                            "label2": "label2",
                            "label3": "label3",                        
                            "addonmanager.kubernetes.io/mode": "test",
                            "kubernetes.azure.com/managed-by": "fleet"
                        },
                        "name": "fleet-test"
                    },
                    "spec":{
                        "taints":[{
                            "key":"key1"
                        }]
                    }
                },
                "operation": "DELETE"
        },
        "parameters": {
                "allowedUsers": ["nodeclient","system:serviceaccount:kube-system:aci-connector-linux","system:serviceaccount:kube-system:node-controller","acsService","aksService","system:serviceaccount:kube-system:cloud-node-manager"],
                "allowedGroups": ["system:node"]
        }      
    }
}

test_allowed_edit_is_system_account {
    count(violation) == 0 with input as {
        "review": {
                "userInfo": {
                    "username":"unknown",
                    "groups":["system:node"]
                },
                "object":{
                    "metadata":{
                        "labels":{
                            "label1": "label1",
                            "label2": "label2",
                            "label3": "label3",                        
                            "addonmanager.kubernetes.io/mode": "test",
                            "kubernetes.azure.com/managed-by": "fleet"
                        },
                        "name": "fleet-test"
                    }
                    "spec":{
                        "taints":[{
                            "key":"key1"
                        }]
                    },
                },
                "operation": "UPDATE"
        },
        "parameters": {
                "allowedUsers": ["nodeclient","system:serviceaccount:kube-system:aci-connector-linux","system:serviceaccount:kube-system:node-controller","acsService","aksService","system:serviceaccount:kube-system:cloud-node-manager"],
                "allowedGroups": ["system:node"]
        }        
    }
}

test_allowed_edit_labels_mismatch {
    count(violation) == 0 with input as {
        "review": {
                "userInfo": {
                    "username":"unknown",
                    "groups":["system:node3"]
                },
                "object":{
                    "metadata":{
                        "labels":{
                            "label1": "label1",
                            "label2": "label2",
                            "label3": "label3",                        
                            "addonmanager.kubernetes.io/mode": "test",
                            "kubernetes.azure.com/managed-by": "NOT_Fleet"
                        },
                        "name": "gatekeeper-test"
                    },
                    "spec":{
                        "taints":[{
                            "key":"key1"
                        }]
                    }
                },
                "operation": "DELETE"
        },
        "parameters": {
                "allowedUsers": ["nodeclient","system:serviceaccount:kube-system:aci-connector-linux","system:serviceaccount:kube-system:node-controller","acsService","aksService","system:serviceaccount:kube-system:cloud-node-manager"],
                "allowedGroups": ["system:node"]
        }      
   }
}

test_disallowed_edit_label_match {
    count(violation) > 0 with input as {
        "review": {
                "userInfo": {
                    "username":"unknown",
                    "groups":["system:node3"]
                },
                "object":{
                    "metadata":{
                        "labels":{
                            "label1": "label1",
                            "label2": "label2",
                            "label3": "label3",                        
                            "addonmanager.kubernetes.io/mode": "test",
                            "kubernetes.azure.com/managed-by": "fleet"
                        },
                        "name": "fleet-test"
                    },
                    "spec":{
                        "taints":[{
                            "key":"key1"
                        }]
                    }
                },
                "operation": "DELETE"
        },
        "parameters": {
                "allowedUsers": ["nodeclient","system:serviceaccount:kube-system:aci-connector-linux","system:serviceaccount:kube-system:node-controller","acsService","aksService","system:serviceaccount:kube-system:cloud-node-manager"],
                "allowedGroups": ["system:node"]
        }      
   }
}