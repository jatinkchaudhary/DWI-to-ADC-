#!/bin/sh
# (c) 2022 MRC Turku, University of Turku
# All rights reserved, Proprietary and confidential
# version 1.0.0 by: Harri Merisaari [03/2022]

 # Set batch definition file and make sure that it exists
selectionfile=$1
modality=$2
# Folder where results are saved
experiment_dir='../../'$3
dataset=PRODIF
method=$4
ROI=$5
suffix=$6
echo $dataset
if [[ ! -f "$selectionfile" ]]
then
    echo "Namelist file does not exist, creating it"
    ls $experiment_dir >> $selectionfile
fi
# Create Quality Control (QC) folder
mkdir -p $(echo $experiment_dir)'/QC'
# Set log file for batch execution
logfile="failures_step8.0.txt"
# Resolve number of lines in the file i. e. number of cases to process
no_folders=(`wc -l $selectionfile`)
no_folder=${no_folders[0]}
echo $no_folders " folders to be processed"
echo "Failed executions" > $logfile
# Go trough lines in the
for (( round=1; round<=$no_folders; round++ ))
do
    subjectname=$(sed -n "$round"p $selectionfile | awk '{print $1}')
    #process patient with python script
    xtermcmd=$(echo python step8_features_with_CWRU.py --modality $modality --BGname PM --method $method --input $experiment_dir --output '../../'$dataset'_features_'$modality'_'$ROI$suffix --case $subjectname --voxelsize [1.116,1.116,5.0])
    echo $(date +"%d/%m/%Y %H:%M:%S")':'$(whoami)':'$0':'$xtermcmd >> $experiment_dir'/QC/'$subjectname'.log'
    echo $xtermcmd
    ret=$(eval $xtermcmd)
    if [ "$?" -eq "0" ]
    then
        echo "SUCCESS"
        echo $(date +"%d/%m/%Y %H:%M:%S")':'$(whoami)':'$0':SUCCESS' >> $experiment_dir'/QC/'$subjectname'.log'
    else
        echo "FAILURE"
        echo "Failure in " + $xtermcmd >> $logfile
        echo $(date +"%d/%m/%Y %H:%M:%S")':'$(whoami)':'$0':FAILURE' >> $experiment_dir'/QC/'$subjectname'.log'
    fi
done
