resource "aws_lambda_function" "calculator" {
  filename         = "${local.calculator-zip}"
  function_name    = "${local.project-name}-calculator"
  role             = "${aws_iam_role.calculator.arn}"
  handler          = "src/lambda.handler"
  source_code_hash = "${base64sha256(file(local.calculator-zip))}"
  runtime          = "nodejs8.10"
  timeout          = 3
}

resource "aws_iam_role" "calculator" {
  name = "${local.project-name}-calculator"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "lambda-logging" {
  name        = "${local.project-name}-lambda-logging"
  path        = "/"
  description = "IAM policy for logging from a Lambda function"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "calculator-logging" {
  role       = "${aws_iam_role.calculator.name}"
  policy_arn = "${aws_iam_policy.lambda-logging.arn}"
}
