package k8sreservedtaints

is_system_pool(node) {
  node.metadata.labels["kubernetes.azure.com/mode"] == "system"
}

is_system_pool(node) {
  node.metadata.labels["kubernetes.azure.com/mode"] == "System"
}

violation[{"msg": msg}] {
  node := input.review.object
  # did the customer try to add a taint with key "CriticalAddonsOnly" to a non-system pool?
  taints := {x | x = node.spec.taints[_].key}
  not is_system_pool(node)
  taint := taints[_]
  restrictedTaint := input.parameters.reservedTaints[_]
  re_match(restrictedTaint,taint)

  msg := sprintf("Taint with key <%s> is reserved for the system pool only",[taint])
}