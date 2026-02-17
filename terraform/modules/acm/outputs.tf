output "acm_arn" {
  value = aws_acm_certificate.this.arn
}

output "acm_domain_name" {
  value = aws_acm_certificate.this.domain_name
}
