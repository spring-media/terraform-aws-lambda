<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.12.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda"></a> [lambda](#module\_lambda) | app.terraform.io/bankrate/lambda-function/aws | ~> 4.0.0 |
| <a name="module_lambda_cloudwatch_trigger"></a> [lambda\_cloudwatch\_trigger](#module\_lambda\_cloudwatch\_trigger) | app.terraform.io/bankrate/lambda-cloudwatch-trigger/aws | ~> 4.0.0 |
| <a name="module_lambda_ddb_trigger"></a> [lambda\_ddb\_trigger](#module\_lambda\_ddb\_trigger) | app.terraform.io/bankrate/lambda-event-source/aws | 2.3.0 |
| <a name="module_lambda_s3_trigger"></a> [lambda\_s3\_trigger](#module\_lambda\_s3\_trigger) | app.terraform.io/bankrate/lambda-s3-trigger/aws | ~> 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_subscription_filter.cloudwatch_logs_to_es](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_subscription_filter) | resource |
| [aws_iam_policy.kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.ssm_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.kms_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_permission.cloudwatch_logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ssm_policy_document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_architecture"></a> [architecture](#input\_architecture) | Triggers are not required. Chose one trigger, if any, to use with lambda.  If one is true, all others must be false. | <pre>object({<br>    cloudwatch_trigger             = bool<br>    s3_trigger                     = bool<br>    ddb_trigger                    = bool<br>  })</pre> | <pre>{<br>  "cloudwatch_trigger": false,<br>  "ddb_trigger": false,<br>  "s3_trigger": false<br>}</pre> | no |
| <a name="input_bucket_arn"></a> [bucket\_arn](#input\_bucket\_arn) | value | `string` | `""` | no |
| <a name="input_bucket_id"></a> [bucket\_id](#input\_bucket\_id) | value | `string` | `""` | no |
| <a name="input_create_default_sg"></a> [create\_default\_sg](#input\_create\_default\_sg) | By default creates a security group that's unique to your lambda, meaning that every lambda you create with this module will use its own set of ENIs | `bool` | `false` | no |
| <a name="input_create_in_vpc"></a> [create\_in\_vpc](#input\_create\_in\_vpc) | By default this is set to true. If you don't want to create the lambda in a VPC then this should be set to false | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of what your Lambda Function does. | `string` | `""` | no |
| <a name="input_enable"></a> [enable](#input\_enable) | is a trigger enables true or false | `bool` | `true` | no |
| <a name="input_enable_newrelic"></a> [enable\_newrelic](#input\_enable\_newrelic) | (optional) describe your variable | `bool` | `false` | no |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | Environment variables in map(map(string)) | `map(map(string))` | `{}` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment for the resouces | `string` | n/a | yes |
| <a name="input_event_source_arn"></a> [event\_source\_arn](#input\_event\_source\_arn) | value | `string` | `""` | no |
| <a name="input_filename"></a> [filename](#input\_filename) | The path to the function's deployment package within the local filesystem. Default is an empty string to satisfy the underlying interface. | `any` | `""` | no |
| <a name="input_handler"></a> [handler](#input\_handler) | The function entrypoint in your code. | `any` | n/a | yes |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The Amazon Resource Name (ARN) of the KMS key to decrypt AWS Systems Manager parameters. | `string` | `""` | no |
| <a name="input_layers"></a> [layers](#input\_layers) | List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function. See [Lambda Layers](https://docs.aws.amazon.com/lambda/latest/dg/configuration-layers.html) | `list(string)` | `[]` | no |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. Defaults to 14. | `number` | `14` | no |
| <a name="input_logfilter_destination_arn"></a> [logfilter\_destination\_arn](#input\_logfilter\_destination\_arn) | The ARN of the destination to deliver matching log events to. Kinesis stream or Lambda function ARN. | `string` | `""` | no |
| <a name="input_memory_size"></a> [memory\_size](#input\_memory\_size) | Amount of memory in MB your Lambda Function can use at runtime. Defaults to 128. | `number` | `128` | no |
| <a name="input_name"></a> [name](#input\_name) | A unique name for your Lambda Function. | `any` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Name of the owner or vertical this belongs to. | `any` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Name of the project this falls under. | `any` | n/a | yes |
| <a name="input_publish"></a> [publish](#input\_publish) | Whether to publish creation/change as new Lambda Function Version. Defaults to true. | `bool` | `true` | no |
| <a name="input_reserved_concurrent_executions"></a> [reserved\_concurrent\_executions](#input\_reserved\_concurrent\_executions) | The amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations. Defaults to Unreserved Concurrency Limits -1. | `string` | `"-1"` | no |
| <a name="input_resource_allocation"></a> [resource\_allocation](#input\_resource\_allocation) | Name of the project this falls under. | `string` | `"low"` | no |
| <a name="input_runtime"></a> [runtime](#input\_runtime) | The runtime environment for the Lambda function you are uploading. Defaults to go1.x | `string` | `"go1.x"` | no |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | value | `string` | `"rate(1 minute)"` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | security groups | `list(string)` | `[]` | no |
| <a name="input_service"></a> [service](#input\_service) | Name of the service this is used in. | `any` | n/a | yes |
| <a name="input_ssm_parameter_names"></a> [ssm\_parameter\_names](#input\_ssm\_parameter\_names) | List of AWS Systems Manager Parameter Store parameters this Lambda will have access to. In order to decrypt secure parameters, a kms\_key\_arn needs to be provided as well. | `list` | `[]` | no |
| <a name="input_table_name"></a> [table\_name](#input\_table\_name) | value | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the Lambda function. | `map(string)` | `{}` | no |
| <a name="input_team_name"></a> [team\_name](#input\_team\_name) | Name of the team this belongs to. | `any` | n/a | yes |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | The amount of time your Lambda Function has to run in seconds. Defaults to 3. | `number` | `3` | no |
| <a name="input_vpc_tag_key_override"></a> [vpc\_tag\_key\_override](#input\_vpc\_tag\_key\_override) | override of vpc tag | `string` | `"PrimaryVPC"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) identifying your Lambda Function. |
<!-- END_TF_DOCS -->