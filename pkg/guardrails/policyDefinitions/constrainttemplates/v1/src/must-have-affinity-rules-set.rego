package k8saffinityrules

missing_affinity(obj) {
  not obj.affinity.podAntiAffinity
}

violation[{"msg": msg}] {
  input.review.object.spec.replicas > 1
  missing_affinity(input.review.object.spec.template.spec)
  msg := sprintf("%s with %d replicas should have pod anti-affinity rules set to avoid disruptions due to nodes crashing", [input.review.kind.kind, input.review.object.spec.replicas])
}