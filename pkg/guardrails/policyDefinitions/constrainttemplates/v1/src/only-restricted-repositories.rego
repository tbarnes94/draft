package k8srestrictedrepos

violation[{"msg": msg}] {
  container := input.review.object.spec.containers[_]
  not re_match(input.parameters.allowedRegex, container.image)
  msg := sprintf("Container image <%s> doesn't satisfy allowed regex <%s>", [container.image, input.parameters.allowedRegex])
}