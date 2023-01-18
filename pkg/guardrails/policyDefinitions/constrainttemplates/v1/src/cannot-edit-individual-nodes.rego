package k8srestrictednodeedits

is_system_account(userinfo) {
  user := input.parameters.allowedUsers[_]
  userinfo.username == user
}

is_system_account(userinfo) {
  userGroups := {x | x = userinfo.groups[_]}
  allowedGroups := {x | x = input.parameters.allowedGroups[_]}
  diffList := userGroups - allowedGroups
  count(diffList) < count(userGroups)
}

flatten_map(obj) = labels {
	keyVals := [s | s = concat(":",[key,val]); val = obj[key]]
    str := concat(",", keyVals)
    labels := split(str,",")
}

unchanged_taints_or_labels(node, oldNode) {
    taints := {x | x = flatten_map(taint); taint = node.spec.taints[_]}
    oldTaints := {x | x = flatten_map(taint); taint = oldNode.spec.taints[_]}
    addedTaints := taints - oldTaints
    deletedTaints := oldTaints - taints
    count(addedTaints) == count(deletedTaints)
    count(addedTaints) == 0
    labels := {x | x = flatten_map(node.metadata.labels)[_]}
    oldLabels := {x | x = flatten_map(oldNode.metadata.labels)[_]}
    addedLabels := labels - oldLabels
    deletedLabels := oldLabels - labels
    count(addedLabels) == count(deletedLabels)
    count(addedLabels) == 0
}


violation[{"msg":msg}]{
  	not unchanged_taints_or_labels(input.review.object, input.review.oldObject)
	not is_system_account(input.review.userInfo)
  	msg := "Tainting or labelling individual nodes is not recommended. Please use AZ cli to taint/label nodepools instead"
}