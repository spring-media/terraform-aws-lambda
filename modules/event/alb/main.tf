resource "aws_lambda_permission" "with_lb" {
  count         = "${var.enable}"
  statement_id  = "AllowExecutionFromlb"
  action        = "lambda:InvokeFunction"
  function_name = "${var.lambda_function_arn}"
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = "${var.target_group_arn}"
}
