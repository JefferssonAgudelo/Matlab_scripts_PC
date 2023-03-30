@echo off
' Use the following command to run the script in the background
' !start "MATLAB test" /Min /B test_bat.bat
' matlab -automation -r "surf(peaks); pause(5); quit" > matlab_output.log

nohup matlab -nodisplay -r < ~/Users/jeffersson_agudelo/Documents/CB104_local_data/Matlab_Scripts_here/Turb_Langevin/Computing_reconnection_rate.m > mft_1.log &
exit