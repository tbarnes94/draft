package k8srestrictedlabels

test_disallowed_provided_restricted_label_not_system_user {
    count(violation) > 0 with input as {
        "review": {
            "userInfo": {
                "username": "non-aks-user",
                "groups": ["non-aks-group"]
            },
            "object": {
                "metadata": {
                    "labels": {
                        "aks-reserved-label": "some-value"
                    }
                }
            }
        },
        "parameters": {
            "labels": ["aks-reserved-label"],
            "allowedUsers": ["some-aks-user"],
            "allowedGroups": ["some-system-group"]
        }
    }
}

test_allowed_restricted_label_system_username {
    count(violation) == 0 with input as {
        "review": {
            "userInfo": {
                "username": "some-aks-user",
                "groups": ["non-aks-group"]
            },
            "object": {
                "metadata": {
                    "labels": {
                        "aks-reserved-label": "some-value"
                    }
                }
            }
        },
        "parameters": {
            "labels": ["aks-reserved-label"],
            "allowedUsers": ["some-aks-user"],
            "allowedGroups": ["some-system-group"]
        }
    }
}

test_allowed_restricted_label_system_group {
    count(violation) == 0 with input as {
        "review": {
            "userInfo": {
                "username": "not-aks-user",
                "groups": ["some-system-group"]
            },
            "object": {
                "metadata": {
                    "labels": {
                        "aks-reserved-label": "some-value"
                    }
                }
            }
        },
        "parameters": {
            "labels": ["aks-reserved-label"],
            "allowedUsers": ["some-aks-user"],
            "allowedGroups": ["some-system-group"]
        }
    }
}

test_allowed_no_restricted_label {
    count(violation) == 0 with input as {
        "review": {
            "userInfo": {
                "username": "not-aks-user",
                "groups": ["some-system-group"]
            },
            "object": {
                "metadata": {
                    "labels": {
                        "non-reserved-label": "some-value"
                    }
                }
            }
        },
        "parameters": {
            "labels": ["aks-reserved-label"],
            "allowedUsers": ["some-aks-user"],
            "allowedGroups": ["some-system-group"]
        }
    }
}