provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_iam_role" "elastic_beanstalk_role" {
  name = "aws-elasticbeanstalk-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_web_tier" {
  role       = aws_iam_role.elastic_beanstalk_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_worker_tier" {
  role       = aws_iam_role.elastic_beanstalk_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWorkerTier"
}

resource "aws_iam_role_policy_attachment" "elastic_beanstalk_multicontainer_docker" {
  role       = aws_iam_role.elastic_beanstalk_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkMulticontainerDocker"
}

resource "aws_iam_instance_profile" "elastic_beanstalk_instance_profile" {
  name = "aws-elasticbeanstalk-ec2-role"
  role = aws_iam_role.elastic_beanstalk_role.name
}

resource "aws_launch_template" "example" {
  name_prefix   = "my-launch-template"
  image_id      = "ami-0c55b159cbfafe1f0" # Replace with a valid AMI ID for your region
  instance_type = "t2.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.elastic_beanstalk_instance_profile.name
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elastic_beanstalk_application" "example" {
  name        = "MentorMatch"
  description = "MentorMatch Application"
}

resource "aws_elastic_beanstalk_environment" "example" {
  name                = "MentorMatch-env-1"
  application         = aws_elastic_beanstalk_application.example.name
  solution_stack_name = "64bit Amazon Linux 2023 v6.3.0 running Node.js 20"

  setting {
    namespace = "aws:autoscaling:launchtemplate"
    name      = "LaunchTemplateId"
    value     = aws_launch_template.example.id
  }

  setting {
    namespace = "aws:autoscaling:launchtemplate"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.elastic_beanstalk_instance_profile.name
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = aws_iam_role.elastic_beanstalk_role.arn
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "HealthCheckPath"
    value     = "/"
  }
}