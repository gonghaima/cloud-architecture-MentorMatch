@echo off
setlocal

REM Variables
set "IMAGE_URL=https://randomuser.me/api/portraits/women/1.jpg"
set "S3_BUCKET=your-unique-bucket-name-user-profile-images"
set "LOCAL_PATH=%TEMP%\1.jpg"

REM Download the image
curl -o "%LOCAL_PATH%" "%IMAGE_URL%"

REM Upload the image to S3
aws s3 cp "%LOCAL_PATH%" "s3://%S3_BUCKET%/1.jpg"

REM Clean up the local file
del "%LOCAL_PATH%"

endlocal
echo Image uploaded successfully.
pause