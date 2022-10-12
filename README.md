# aws-ssm-bastion-host

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| template | n/a |
| tls | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| instances\_number | number of instances to launch | `number` | `1` | no |
| name | name | `string` | `"bastion-host"` | no |
| policies | n/a | `list(any)` | <pre>[<br>  "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"<br>]</pre> | no |
| region | The AWS Region. | `string` | n/a | yes |
| ssm\_group\_name | description | `string` | `"SSMUserGroup"` | no |
| subnet\_name | List of one or more subnet names where the task will be performed. | `list(any)` | n/a | yes |
| tags | description | `map(any)` | `{}` | no |
| username | description | `string` | `"bastion-user"` | no |
| vpc\_name | The VPC name where the task will be performed. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ec2\_id | ID of EC2 instance |
| ssh\_private\_key | SSH Private key |