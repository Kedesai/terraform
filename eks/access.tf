resource "aws_eks_access_entry" "admin" {
  cluster_name      = aws_eks_cluster.this.name
  principal_arn     = aws_iam_role.eks_cluster.arn
  kubernetes_groups = ["system:masters"]
  type              = "STANDARD"
}