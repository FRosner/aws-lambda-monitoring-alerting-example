resource "aws_sns_topic" "alarms" {
  name = "${local.project-name}-alarms"
}