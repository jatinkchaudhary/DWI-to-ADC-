#!/bin/sh
# (c) 2023 MRC Turku, University of Turku
# All rights reserved, Proprietary and confidential
# version 1.0.0 by: Harri Merisaari [07/2023]

prefix=$1
./step8_run_with_namelist.sh namelist_TRAIN1.txt $prefix PRODIF78_TRTR_training_and_validation_DWI_ADC/scan_1 HU LS _TRAIN1
./step8_run_with_namelist.sh namelist_TRAIN2.txt $prefix PRODIF78_TRTR_training_and_validation_DWI_ADC/scan_2 HU LS _TRAIN2
./step8_run_with_namelist.sh namelist_TEST1.txt $prefix PRODIF34_TRTR_hold_out_DWI_ADC/scan_1 Gabor LS _TEST1
./step8_run_with_namelist.sh namelist_TEST2.txt $prefix PRODIF34_TRTR_hold_out_DWI_ADC/scan_2 Gabor LS _TEST2
./step8_run_with_namelist.sh namelist_TRAIN1.txt $prefix PRODIF78_TRTR_training_and_validation_DWI_ADC/scan_1 Zernike LS _TRAIN1
./step8_run_with_namelist.sh namelist_TRAIN2.txt $prefix PRODIF78_TRTR_training_and_validation_DWI_ADC/scan_2 Zernike LS _TRAIN2
./step8_run_with_namelist.sh namelist_TRAIN1.txt $prefix PRODIF78_TRTR_training_and_validation_DWI_ADC/scan_1 Wavelet LS _TRAIN1
./step8_run_with_namelist.sh namelist_TRAIN2.txt $prefix PRODIF78_TRTR_training_and_validation_DWI_ADC/scan_2 Wavelet LS _TRAIN2
./step8_run_with_namelist.sh namelist_TRAIN1.txt $prefix PRODIF78_TRTR_training_and_validation_DWI_ADC/scan_1 LBP LS _TRAIN1
./step8_run_with_namelist.sh namelist_TRAIN2.txt $prefix PRODIF78_TRTR_training_and_validation_DWI_ADC/scan_2 LBP LS _TRAIN2
./step8_run_with_namelist.sh namelist_TEST1.txt $prefix PRODIF34_TRTR_hold_out_DWI_ADC/scan_1 Laws LS _TEST1
./step8_run_with_namelist.sh namelist_TEST2.txt $prefix PRODIF34_TRTR_hold_out_DWI_ADC/scan_2 Laws LS _TEST2
./step8_run_with_namelist.sh namelist_TRAIN1.txt $prefix PRODIF78_TRTR_training_and_validation_DWI_ADC/scan_1 Laws3D LS _TRAIN1
./step8_run_with_namelist.sh namelist_TRAIN2.txt $prefix PRODIF78_TRTR_training_and_validation_DWI_ADC/scan_2 Laws3D LS _TRAIN2
