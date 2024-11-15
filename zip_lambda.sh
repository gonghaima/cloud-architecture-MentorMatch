#!/bin/bash

# Navigate to the lambdaFunctions directory
cd lambdaFunctions

# Zip the getUser.js file
zip -r ../get_user_lambda_function_payload.zip getUser.js

# Navigate back to the root directory
cd ..

echo "Lambda function code zipped successfully."