### Create main.tf for elastic beanstalk 


Here's how Elastic Beanstalk works:

You define the application and its configuration (including environment variables, build process, and platform version) in Terraform using the aws_elasticbeanstalk_application resource.
You specify the desired environment tier and platform (e.g., SingleInstance and Node.js 16) in the option_settings section.
When you deploy the Elastic Beanstalk environment, it creates EC2 instances based on the configuration provided, including the instance type specified in the option_settings.
Benefits of using Elastic Beanstalk for EC2 management:

Simplified Management: Terraform manages the Elastic Beanstalk application and environment configuration, and Elastic Beanstalk in turn manages the underlying EC2 instances, offering a more abstracted approach.
Scalability: Elastic Beanstalk automatically scales the EC2 instances based on traffic patterns.

   

### List a list of available stack

aws elasticbeanstalk list-available-solution-stacks

after that, choose the following stack
64bit Amazon Linux 2023 v6.3.0 running Node.js 20

### Creating template
https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/environments-cfg-autoscaling-launch-templates.html#environments-cfg-autoscaling-launch-templates-options

### Setup Frontend
<!-- npx degit gravity-ui/gravity-ui-vite-example#main MentorMatchApp -->
npm create vite@latest
MentorMatchApp


