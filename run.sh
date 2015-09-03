#!/bin/bash

cd /usr/local/MATLAB/R2015a/bin
./matlab -nodesktop -r "cd ~/Dropbox/work/active/defects/numerics/;LoopSolve;quit"
cd ~/Dropbox/work/active/defects/numerics/plots/data_files
FOLDERNAME=$(date +"%Y-%m-%d_%H:%M")
mkdir "$FOLDERNAME"
cd ..
mv *.txt plots/data_files/$FOLDERNAME

