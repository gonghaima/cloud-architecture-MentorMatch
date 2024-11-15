@echo off

REM Navigate to the lambdaFunctions directory
cd lambdaFunctions

REM Remove existing zip files if they exist
@REM if exist ../get_user_lambda_function_payload.zip del ../get_user_lambda_function_payload.zip
@REM if exist ../create_user_lambda_function_payload.zip del ../create_user_lambda_function_payload.zip
if exist ../update_user_lambda_function_payload.zip del ../update_user_lambda_function_payload.zip

@REM REM Use PowerShell to zip the getUser.js file along with node_modules
@REM powershell.exe -Command "Compress-Archive -Path getUser.js,node_modules -DestinationPath ../get_user_lambda_function_payload.zip -Force"

@REM REM Use PowerShell to zip the createUser.js file along with node_modules
@REM powershell.exe -Command "Compress-Archive -Path createUser.js,node_modules -DestinationPath ../create_user_lambda_function_payload.zip -Force"

REM Use PowerShell to zip the updateUser.js file along with node_modules
powershell.exe -Command "Compress-Archive -Path updateUser.js,node_modules -DestinationPath ../update_user_lambda_function_payload.zip -Force"

REM Navigate back to the root directory
cd ..

echo Lambda function code zipped successfully.