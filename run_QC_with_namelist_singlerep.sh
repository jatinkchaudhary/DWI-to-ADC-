#!/bin/sh
# (c) 2024 MRC Turku, University of Turku
# All rights reserved, Proprietary and confidential
# version 1.0.0 by: Harri Merisaari [03/2024]

 # Set batch definition file and make sure that it exists
mkdir ../../QC_PRODIF_singlerep
selectionfile=$1
basedir=$(realpath ../../PRODIF_singlebpMRI_Data_organized_8_3_2024_4b500/DWI4b500)
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
    echo $subjectname
    adcfile=$basedir/${subjectname}/DWI4b500_ADCm.nii.gz
    pmfile=$basedir/${subjectname}/PM.nii
    lsfile=$basedir/${subjectname}/LS.nii
    if [ ! -f $adcfile ];
    then
        echo $adcfile" does not exist"
        continue
    fi
    if [ ! -f $pmfile ];
    then
        echo $pmfile" does not exist"
        continue
    fi
    python QC.py --bgfile $adcfile --maskname $pmfile --oname ../../QC_PRODIF_singlerep/${subjectname}_PM.png --offset 30 --scale 4 --flip lr
    python QC.py --bgfile $adcfile --maskname $lsfile --oname ../../QC_PRODIF_singlerep/${subjectname}_LS.png --offset 30 --scale 4 --flip lr
done
