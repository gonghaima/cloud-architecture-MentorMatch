@echo off

REM Navigate to the lambdaFunctions directory
cd lambdaFunctions

REM Remove existing zip files if they exist
if exist ../get_user_lambda_function_payload.zip del ../get_user_lambda_function_payload.zip
@REM if exist ../create_user_lambda_function_payload.zip del ../create_user_lambda_function_payload.zip
@REM if exist ../update_user_lambda_function_payload.zip del ../update_user_lambda_function_payload.zip
@REM if exist ../list_users_lambda_function_payload.zip del ../list_users_lambda_function_payload.zip
@REM if exist ../delete_user_lambda_function_payload.zip del ../delete_user_lambda_function_payload.zip

powershell.exe -Command "Compress-Archive -Path getUser.js,node_modules -DestinationPath ../get_user_lambda_function_payload.zip -Force"
@REM powershell.exe -Command "Compress-Archive -Path createUser.js,node_modules -DestinationPath ../create_user_lambda_function_payload.zip -Force"
@REM powershell.exe -Command "Compress-Archive -Path updateUser.js,node_modules -DestinationPath ../update_user_lambda_function_payload.zip -Force"
@REM powershell.exe -Command "Compress-Archive -Path listUsers.js,node_modules -DestinationPath ../list_users_lambda_function_payload.zip -Force"
@REM powershell.exe -Command "Compress-Archive -Path deleteUser.js,node_modules -DestinationPath ../delete_user_lambda_function_payload.zip -Force"

REM Navigate back to the root directory
cd ..

echo Lambda function code zipped successfully.