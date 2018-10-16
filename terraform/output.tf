output "invoke" {
  value = "for i in `seq 1 10`; do; aws lambda invoke --invocation-type RequestResponse --function-name ${aws_lambda_function.calculator.function_name} --region ${data.aws_region.current.name} --log-type Tail --payload \"{\\\"a\\\":1,\\\"b\\\":2,\\\"timeout\\\":$(( ( RANDOM % 1500 )  + 1 ))}\" calculator.log; done"
}