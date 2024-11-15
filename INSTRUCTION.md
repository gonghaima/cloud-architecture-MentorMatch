## Setup

### aws setup
aws configure

### Create main.tf

### Run init
run "terraform init"

### Prepare zip task
touch zip_lambda.sh
chmod +x zip_lambda.sh

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
        
