@echo off

REM Navigate to the lambdaFunctions directory
cd lambdaFunctions

REM Remove existing zip files if they exist
if exist ../get_user_lambda_function_payload.zip del ../get_user_lambda_function_payload.zip
if exist ../create_user_lambda_function_payload.zip del ../create_user_lambda_function_payload.zip

REM Use PowerShell to zip the getUser.js file
powershell.exe -Command "Compress-Archive -Path getUser.js -DestinationPath ../get_user_lambda_function_payload.zip -Force"

REM Use PowerShell to zip the createUser.js file
powershell.exe -Command "Compress-Archive -Path createUser.js -DestinationPath ../create_user_lambda_function_payload.zip -Force"

REM Navigate back to the root directory
cd ..

echo Lambda function code zipped successfully.