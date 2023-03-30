@echo off
' Use the following command to run the script in the background
' !start "MATLAB test" /Min /B test_bat.bat
matlab -automation -r "surf(peaks); pause(5); quit" > matlab_output.log
exit