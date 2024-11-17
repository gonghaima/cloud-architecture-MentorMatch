@echo off
setlocal

REM Variables
set "S3_BUCKET=your-unique-bucket-name-user-profile-images"
set "TEMP_FOLDER=%TEMP%\image_uploads"

REM Create a temporary folder to store images
if not exist "%TEMP_FOLDER%" mkdir "%TEMP_FOLDER%"

REM Loop through the range of women images
for /l %%i in (1,1,50) do (
    call :ProcessImage https://randomuser.me/api/portraits/women/%%i.jpg women%%i.jpg
)

REM Loop through the range of men images
for /l %%i in (1,1,50) do (
    call :ProcessImage https://randomuser.me/api/portraits/men/%%i.jpg men%%i.jpg
)

REM Clean up the temporary folder and files
echo Cleaning up temporary files...
rmdir /s /q "%TEMP_FOLDER%"

endlocal
echo All images uploaded successfully.
pause
exit /b

:ProcessImage
REM Arguments: %1 = Image URL, %2 = Local filename
set "IMAGE_URL=%1"
set "LOCAL_PATH=%TEMP_FOLDER%\%2"

echo Downloading %2 from %IMAGE_URL%
curl -o "%LOCAL_PATH%" "%IMAGE_URL%"
if exist "%LOCAL_PATH%" (
    echo Uploading %2 to S3
    aws s3 cp "%LOCAL_PATH%" "s3://%S3_BUCKET%/%2"
) else (
    echo Failed to download %2 from %IMAGE_URL%
)
exit /b
