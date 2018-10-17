resource "aws_cloudwatch_metric_alarm" "calculator-time" {
  alarm_name          = "${local.project-name}-calculator-execution-time"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "${aws_lambda_function.calculator.timeout * 1000 * 0.75}"
  alarm_description   = "Calculator Execution Time"
  treat_missing_data  = "ignore"

  insufficient_data_actions = [
    "${aws_sns_topic.alarms.arn}",
  ]

  alarm_actions = [
    "${aws_sns_topic.alarms.arn}",
  ]

  ok_actions = [
    "${aws_sns_topic.alarms.arn}",
  ]

  dimensions {
    FunctionName = "${aws_lambda_function.calculator.function_name}"
    Resource     = "${aws_lambda_function.calculator.function_name}"
  }
}

resource "aws_cloudwatch_metric_alarm" "calculator-memory" {
  depends_on = [
    "aws_cloudwatch_log_metric_filter.calculator-memory",
  ]

  alarm_name          = "${local.project-name}-calculator-memory"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "${local.metrics-calculator-memory-name}"
  namespace           = "${local.metrics-calculator-namespace}"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "${aws_lambda_function.calculator.memory_size * 0.8}"
  alarm_description   = "Calculator Max Memory Consumption"
  treat_missing_data  = "notBreaching"

  insufficient_data_actions = [
    "${aws_sns_topic.alarms.arn}",
  ]

  alarm_actions = [
    "${aws_sns_topic.alarms.arn}",
  ]

  ok_actions = [
    "${aws_sns_topic.alarms.arn}",
  ]
}

resource "aws_cloudwatch_metric_alarm" "calculator-errors" {
  alarm_name          = "${local.project-name}-calculator-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = "60"
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "Calculator Execution Errors"
  treat_missing_data  = "ignore"

  insufficient_data_actions = [
    "${aws_sns_topic.alarms.arn}",
  ]

  alarm_actions = [
    "${aws_sns_topic.alarms.arn}",
  ]

  ok_actions = [
    "${aws_sns_topic.alarms.arn}",
  ]

  dimensions {
    FunctionName = "${aws_lambda_function.calculator.function_name}"
    Resource     = "${aws_lambda_function.calculator.function_name}"
  }
}
