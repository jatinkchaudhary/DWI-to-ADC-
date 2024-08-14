#!/bin/sh
# (c) 2024 MRC Turku, University of Turku
# All rights reserved, Proprietary and confidential
# version 1.0.0 by: Harri Merisaari [03/2024]

 # Set batch definition file and make sure that it exists
selectionfile=$1
modality=$2
basedir=$(realpath $3)
bvalfile=$(realpath bval)
if [[ ! -f "$selectionfile" ]]
then
    echo "Namelist file does not exist, creating it"
    ls $experiment_dir >> $selectionfile
fi
# Set log file for batch execution
logfile="failures.txt"
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
    if test -f $basedir/$subjectname/DWI4b500_ADCm.nii.gz; then
        :
        continue
    else
        echo "File "$basedir/$subjectname/DWI4b500_ADCm.nii.gz" missing"        
    fi
    xtermcmd=$(echo ./run.sh $basedir/$subjectname/DWI.nii $basedir/$subjectname/PM.nii 100 $bvalfile $basedir/$subjectname)
    echo $(date +"%d/%m/%Y %H:%M:%S")':'$(whoami)':'$0':'$xtermcmd >> $basedir'/'$subjectname'_fit.log'
    echo $xtermcmd
    ret=$(eval $xtermcmd)
    if [ "$?" -eq "0" ]
    then
        echo "SUCCESS"
        echo $(date +"%d/%m/%Y %H:%M:%S")':'$(whoami)':'$0':SUCCESS' >> $basedir'/'$subjectname'_fit.log'
    else
        echo "FAILURE"
        echo "Failure in " + $xtermcmd >> $logfile
        echo $(date +"%d/%m/%Y %H:%M:%S")':'$(whoami)':'$0':FAILURE' >> $basedir'/'$subjectname'_fit.log'
    fi
done
