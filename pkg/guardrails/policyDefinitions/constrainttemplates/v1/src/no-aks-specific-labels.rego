package k8srestrictedlabels

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
    keysStr := concat(",", keyVals)
    labels := split(keysStr,",")
}

violation[{"msg": msg}] {
  providedLabel := flatten_map(input.review.object.metadata.labels)[_]
  reservedLabel := input.parameters.labels[_]
  re_match(reservedLabel,providedLabel)
  not is_system_account(input.review.userInfo)
  not reservedLabel == ""
  msg := sprintf("Label <%s> is reserved for AKS use only",[reservedLabel])
}