#!/bin/sh
# (c) 2024 MRC Turku, University of Turku
# All rights reserved, Proprietary and confidential
# version 1.0.0 by: Harri Merisaari [03/2024]

echo docker run -it --rm -v $(realpath settings.ini):/root/settings.ini -v $1:/data.nii -v $2:/mask.nii -v $4:/bval -v $5:/output haanme/fitdwi:v1.0.1 /usr/bin/bash -c "/usr/local/bin/dwiNifti2ASCII.sh /data.nii /mask.nii $3 /bval [0,1,2,3]; /usr/local/bin/dwifit /data_ASCII.txt Mono BFGS settings.ini; /usr/local/bin/dwiASCII2Nifti.sh /data.nii /mask.nii /data_ASCII_Mono_results.txt; cp /data_ASCII_Mono_results_ADCm.nii.gz /output/DWI4b500_ADCm.nii.gz"
docker run -it --rm -v $(realpath settings.ini):/root/settings.ini -v $1:/data.nii -v $2:/mask.nii -v $4:/bval -v $5:/output haanme/fitdwi:v1.0.1 /usr/bin/bash -c "/usr/local/bin/dwiNifti2ASCII.sh /data.nii /mask.nii $3 /bval [0,1,2,3]; /usr/local/bin/dwifit /data_ASCII.txt Mono BFGS settings.ini; /usr/local/bin/dwiASCII2Nifti.sh /data.nii /data_mask.nii.gz /data_ASCII_Mono_results.txt; cp /data_ASCII_Mono_results_ADCm.nii.gz /output/DWI4b500_ADCm.nii.gz"
