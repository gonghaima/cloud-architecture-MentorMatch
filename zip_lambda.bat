@echo off

REM Navigate to the lambdaFunctions directory
cd lambdaFunctions

REM Use PowerShell to zip the getUser.js file
powershell.exe -Command "Compress-Archive -Path getUser.js -DestinationPath ../get_user_lambda_function_payload.zip"

REM Navigate back to the root directory
cd ..

echo Lambda function code zipped successfully.