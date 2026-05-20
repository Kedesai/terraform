locals {
  cluster_tags = merge(
    var.tags,
    {
      "Name" = var.cluster_name
    }
  )
}