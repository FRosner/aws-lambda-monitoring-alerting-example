locals {
  metrics-calculator-memory-name = "Memory"
  metrics-calculator-namespace = "${local.project-name}/calculator"
}

resource "aws_cloudwatch_log_metric_filter" "calculator-memory" {
  name           = "${local.project-name}-calculator-memory"
  log_group_name = "/aws/lambda/${aws_lambda_function.calculator.function_name}"

  // REPORT RequestId: f420d819-d07e-11e8-9ef2-4d8f649fd167	Duration: 158.15 ms	Billed Duration: 200 ms Memory Size: 1024 MB	Max Memory Used: 38 MB
  pattern = "[report_name=\"REPORT\", request_id_name=\"RequestId:\", request_id_value, duration_name=\"Duration:\", duration_value, duration_unit=\"ms\", billed_duration_name_1=\"Billed\", bill_duration_name_2=\"Duration:\", billed_duration_value, billed_duration_unit=\"ms\", memory_size_name_1=\"Memory\", memory_size_name_2=\"Size:\", memory_size_value, memory_size_unit=\"MB\", max_memory_used_name_1=\"Max\", max_memory_used_name_2=\"Memory\", max_memory_used_name_3=\"Used:\", max_memory_used_value, max_memory_used_unit=\"MB\"]"

  metric_transformation {
    name      = "${local.metrics-calculator-memory-name}"
    namespace = "${local.metrics-calculator-namespace}"
    value     = "$max_memory_used_value"
  }
}
