#/bin/bash
matlabroot="/Applications/MATLAB_R20*.app/bin/"
cd $matlabroot
./matlab -r "open('SettlingTubeInterface.mlx')" -sd '~/Documents/GitHub/SedSettle'