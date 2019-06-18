# Contribution Guidelines

Contributions to this module are very welcome! We follow a fairly standard [pull request
process](https://help.github.com/articles/about-pull-requests/) for contributions, subject to the following guidelines:

1. [File a GitHub issue](#file-a-github-issue)
1. [Update the examples](#update-the-examples)
1. [Update the code](#update-the-code)
1. [Update the documentation](#update-the-documentation)
1. [Create a pull request](#create-a-pull-request)
1. [Merge and release](#merge-and-release)

## File a GitHub issue

Before starting any work, we recommend filing a GitHub issue in this repo. This is your chance to ask questions and
get feedback from the maintainers and the community. If there is anything you're unsure about, just ask!

## Update the examples

We also recommend updating the examples/creating new examples _before_ updating any code. This
ensures the examples stay up to date and verify all the functionality in this module, including whatever new
functionality you're adding in your contribution. Check out the [Makefile](https://github.com/spring-media/terraform-aws-lambda/blob/master/Makefile)
for instructions for testing all examples.

Furthermore we recommend to `terraform apply` all new or updated examples in your AWS account since some errors
won't occur in the planning phase.

## Update the code

At this point, make your code changes and use your updated or new example to verify that everything is working. As you work,
keep in mind two things:

1. Backwards compatibility
1. Downtime

Please adhere to the Terraform [module guidelines](https://www.terraform.io/docs/modules/index.html).

### Backwards compatibility

Please make every effort to avoid unnecessary backwards incompatible changes. With Terraform code, this means:

1. Do not delete, rename, or change the type of input variables.
1. If you add an input variable, it should have a `default`.
1. Do not delete, rename, or change the type of output variables.
1. Do not delete or rename a module in the `modules` folder.

If a backwards incompatible change cannot be avoided, please make sure to call that out when you submit a pull request,
explaining why the change is absolutely necessary.

### Downtime

Bear in mind that the Terraform code in this module is used by real companies to run real infrastructure in
production, and certain types of changes could cause downtime. For example, consider the following:

1. If you rename a resource (e.g. `aws_instance "foo"` -> `aws_instance "bar"`), Terraform will see that as deleting
   the old resource and creating a new one.
1. If you change certain attributes of a resource (e.g. the `name` of an `aws_elb`), the cloud provider (e.g. AWS) may
   treat that as an instruction to delete the old resource and a create a new one.

Deleting certain types of resources (e.g. virtual servers, load balancers) can cause downtime, so when making code
changes, think carefully about how to avoid that. For example, can you avoid downtime by using
[create_before_destroy](https://www.terraform.io/docs/configuration/resources.html#create_before_destroy)? Or via
the `terraform state` command? If so, make sure to note this in our pull request. If downtime cannot be avoided,
please make sure to call that out when you submit a pull request.

## Update the documentation

Please update the documentation of the root and all affected nested modules. Version information will be updated
by tooling.

## Create a pull request

[Create a pull request](https://help.github.com/articles/creating-a-pull-request/) with your changes. Please make sure
to include the following:

1. A description of the change, including a link to your GitHub issue.
1. Any notes on backwards incompatibility or downtime.

## Merge and release

The maintainers for this repo will review your code and provide feedback. If everything looks good, they will merge the
code and release a new version, which you'll be able to find in the [releases page](../../releases).
