data "aws_lb" "app_lb" {
  name = aws_lb.app_lb.name
}
#Output of the load balancer dns
output "load_balancer_dns" {
  value = data.aws_lb.app_lb.dns_name
}