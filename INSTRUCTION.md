## Setup

### aws setup
aws configure

### Create main.tf

### Run init
run "terraform init"

### Prepare zip task
touch zip_lambda.sh
chmod +x zip_lambda.bat

### Execute task
./zip_lambda.sh

### Run validate / plan / apply
terraform validate
terraform plan

export TF_PLUGIN_TIMEOUT=10m
export TF_LOG=trace
(export TF_LOG=off)
export TF_LOG_PATH=./terraform.log

terraform apply -auto-approve
TF_LOG=DEBUG terraform apply -auto-approve

    #### Helper

    - If errors as below
    Table already exists: Subject...
    declare the following
    ```shell
    terraform import aws_dynamodb_table.user_table User
    terraform import aws_dynamodb_table.subject_table Subject
    terraform import aws_iam_role.lambda_exec lambda_exec_role
    ```

### Deploy lambda
aws lambda update-function-code --function-name GetUser --zip-file fileb://Get_user_lambda_function_payload.zip

aws lambda update-function-code --function-name CreateUser --zip-file fileb://create_user_lambda_function_payload.zip


db schema planned

user 
	role
	username
	password
	address
	postcode
	offering
	studying

subject
	math
	english
	computing
	physics
