provider "aws" {
  region = "eu-west-1"
}

module "lambda" {
  source        = "../../"
  handler       = "some-handler"
  function_name = "handler"
  s3_bucket     = "some-bucket"
  s3_key        = "v1.0.0/handler.zip"

  event {
    type             = "alb"
    target_group_arn = "${aws_lb_target_group.lambda.arn}"
  }

  # optionally configure Parameter Store access with decryption
  ssm_parameter_names = ["some/config/root/*"]
  kms_key_arn         = "arn:aws:kms:eu-west-1:647379381847:key/f79f2b-04684-4ad9-f9de8a-79d72f"

  # optionally create a log subscription for streaming log events
  logfilter_destination_arn = "arn:aws:lambda:eu-west-1:647379381847:function:cloudwatch_logs_to_es_production"

  tags {
    key = "value"
  }
}

resource "aws_lb" "lb" {
  name = "some-lb"
  subnets = ["some-subnet"]
}

resource "aws_lb_target_group" "lambda" {
  name        = "tf-handler-tg"
  target_type = "lambda"
}

resource "aws_lb_target_group_attachment" "tg-attachment" {
  target_group_arn = "${aws_lb_target_group.lambda.arn}"
  target_id        = "${module.lambda.arn}"
  depends_on       = ["aws_lambda_permission.with_lb"]
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = "443"
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.lambda.arn}"
  }
}

resource "aws_lb_listener_rule" "lambda" {
  listener_arn = "${aws_lb_listener.listener.arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.lambda.arn}"
  }

  condition {
    field  = "host-header"
    values = ["some-host.io"]
  }
}
