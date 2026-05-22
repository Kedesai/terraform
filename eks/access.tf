
resource "aws_eks_access_entry" "admin" {
  cluster_name  = aws_eks_cluster.this.name
  principal_arn = var.cluster_role_arn != null ? var.cluster_role_arn : aws_iam_role.eks_cluster[0].arn
}