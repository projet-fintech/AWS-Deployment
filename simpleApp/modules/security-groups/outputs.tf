output "worker_node_sg_id" {
  value = aws_security_group.eks_worker_nodes.id
}
output "control_plane_sg_id" {
  value = aws_security_group.eks_control_plane.id
}
output "alb_security_group_id" {
  value = aws_security_group.alb.id
}
