To create multiple EC2 instances with slight variations in parameters using Terraform, you can use a combination of `for_each` or `count` along with variable maps to iterate over the instance configurations. Here is an example demonstrating how to achieve this:

1. **Define variables for the instance configurations:**

```hcl
variable "instances" {
  description = "Map of instance configurations"
  type = map(object({
    ami           = string
    instance_type = string
    key_name      = string
    subnet_id     = string
    tags          = map(string)
  }))
  default = {
    instance1 = {
      ami           = "ami-0abcdef1234567890"
      instance_type = "t2.micro"
      key_name      = "my-key"
      subnet_id     = "subnet-0bb1c79de3EXAMPLE"
      tags          = {
        Name = "Instance1"
        Env  = "Production"
      }
    },
    instance2 = {
      ami           = "ami-0abcdef1234567890"
      instance_type = "t2.small"
      key_name      = "my-key"
      subnet_id     = "subnet-0bb1c79de3EXAMPLE"
      tags          = {
        Name = "Instance2"
        Env  = "Staging"
      }
    }
  }
}
```

2. **Create the EC2 instances using `for_each`:**

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  for_each = var.instances

  ami           = each.value.ami
  instance_type = each.value.instance_type
  key_name      = each.value.key_name
  subnet_id     = each.value.subnet_id

  tags = each.value.tags

  lifecycle {
    create_before_destroy = true
  }
}
```

3. **Output the instance details (optional):**

```hcl
output "instance_ids" {
  value = { for k, v in aws_instance.example : k => v.id }
}

output "public_ips" {
  value = { for k, v in aws_instance.example : k => v.public_ip }
}
```

4. **Full Terraform script:**

Here is the full Terraform script for reference:

```hcl
# main.tf

provider "aws" {
  region = "us-west-2"
}

variable "instances" {
  description = "Map of instance configurations"
  type = map(object({
    ami           = string
    instance_type = string
    key_name      = string
    subnet_id     = string
    tags          = map(string)
  }))
  default = {
    instance1 = {
      ami           = "ami-0abcdef1234567890"
      instance_type = "t2.micro"
      key_name      = "my-key"
      subnet_id     = "subnet-0bb1c79de3EXAMPLE"
      tags          = {
        Name = "Instance1"
        Env  = "Production"
      }
    },
    instance2 = {
      ami           = "ami-0abcdef1234567890"
      instance_type = "t2.small"
      key_name      = "my-key"
      subnet_id     = "subnet-0bb1c79de3EXAMPLE"
      tags          = {
        Name = "Instance2"
        Env  = "Staging"
      }
    }
  }
}

resource "aws_instance" "example" {
  for_each = var.instances

  ami           = each.value.ami
  instance_type = each.value.instance_type
  key_name      = each.value.key_name
  subnet_id     = each.value.subnet_id

  tags = each.value.tags

  lifecycle {
    create_before_destroy = true
  }
}

output "instance_ids" {
  value = { for k, v in aws_instance.example : k => v.id }
}

output "public_ips" {
  value = { for k, v in aws_instance.example : k => v.public_ip }
}
```

This script sets up a map variable `instances` that defines the different configurations for each EC2 instance. The `for_each` argument in the `aws_instance` resource iterates over this map, creating an EC2 instance for each configuration.

You can customize the variable definitions with different AMIs, instance types, key names, subnet IDs, and tags as needed.
