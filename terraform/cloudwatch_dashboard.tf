locals {
  dashboard-calculator-max-time-color   = "#1f77b4"
  dashboard-calculator-avg-time-color   = "#9467bd"
  dashboard-calculator-memory-color     = "#ff7f0e"
  dashboard-calculator-error-color      = "#d62728"
  dashboard-calculator-invocation-color = "#2ca02c"
}

resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${local.project-name}"

  dashboard_body = <<EOF
{
  "widgets": [
    {
      "type": "text",
      "x": 0,
      "y": 0,
      "width": 24,
      "height": 1,
      "properties": {
        "markdown": "# ${aws_lambda_function.calculator.function_name}"
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 1,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/Lambda", "Duration",
            "FunctionName", "${aws_lambda_function.calculator.function_name}",
            "Resource", "${aws_lambda_function.calculator.function_name}",
            {
              "stat": "Maximum",
              "yAxis": "left",
              "label": "Maximum Execution Time",
              "color": "${local.dashboard-calculator-max-time-color}",
              "period": 10
            }
          ],
          [
            "AWS/Lambda", "Duration",
            "FunctionName", "${aws_lambda_function.calculator.function_name}",
            "Resource", "${aws_lambda_function.calculator.function_name}",
            {
              "stat": "Average",
              "yAxis": "left",
              "label": "Average Execution Time",
              "color": "${local.dashboard-calculator-avg-time-color}",
              "period": 10
            }
          ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "${data.aws_region.current.name}",
        "yAxis": {
          "left": {
            "min": 0,
            "max": ${aws_lambda_function.calculator.timeout}000,
            "label": "ms",
            "showUnits": false
          }
        },
        "title": "Execution Time",
        "period": 300,
        "annotations": {
          "horizontal": [{
              "color": "${local.dashboard-calculator-max-time-color}",
              "label": "Alarm Threshold",
              "value": ${aws_cloudwatch_metric_alarm.calculator-time.threshold}
            }
          ]
        }
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 1,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "${local.metrics-calculator-namespace}", "${local.metrics-calculator-memory-name}",
            {
              "stat": "Maximum",
              "label": "Max Memory Used",
              "color": "${local.dashboard-calculator-memory-color}",
              "period": 10
            }
          ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "${data.aws_region.current.name}",
        "yAxis": {
          "left": {
            "min": 0,
            "max": ${aws_lambda_function.calculator.memory_size},
            "showUnits": false,
            "label": "MB"
          }
        },
        "title": "Memory Consumption",
        "period": 300,
        "annotations": {
          "horizontal": [{
              "color": "${local.dashboard-calculator-memory-color}",
              "label": "Alarm Threshold",
              "value": ${aws_cloudwatch_metric_alarm.calculator-memory.threshold}
            }
          ]
        }
      }
    },
    {
      "type": "metric",
      "x": 0,
      "y": 7,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/Lambda", "Errors",
            "FunctionName", "${aws_lambda_function.calculator.function_name}",
            "Resource", "${aws_lambda_function.calculator.function_name}",
            {
              "color": "${local.dashboard-calculator-error-color}",
              "stat": "Sum",
              "period": 10
            }
          ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "${data.aws_region.current.name}",
        "title": "Execution Errors",
        "annotations": {
          "horizontal": [{
              "color": "${local.dashboard-calculator-error-color}",
              "label": "Alarm Threshold",
              "value": ${aws_cloudwatch_metric_alarm.calculator-errors.threshold}
            }
          ]
        }
      }
    },
    {
      "type": "metric",
      "x": 12,
      "y": 7,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/Lambda", "Invocations",
            "FunctionName", "${aws_lambda_function.calculator.function_name}",
            "Resource", "${aws_lambda_function.calculator.function_name}",
            {
              "color": "${local.dashboard-calculator-invocation-color}",
              "stat": "Sum",
              "period": 10
            }
          ]
        ],
        "view": "timeSeries",
        "stacked": false,
        "region": "${data.aws_region.current.name}",
        "title": "Invocations"
      }
    }
  ]
}
EOF
}
