resource "aws_lambda_permission" "allow_bucket" {
  count         = var.enable ? 1 : 0
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_arn
  principal     = "s3.amazonaws.com"
  statement_id  = "AllowExecutionFromS3Bucket"
  source_arn    = var.s3_bucket_arn
}
