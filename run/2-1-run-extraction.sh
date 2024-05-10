# $1 = filename_without_extension

#=============================
# ARKit data extraction 
#=============================

echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo                                         Extracting images, intrinsics, and poses
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# adding the name of the scan folder to "simplerecon/data_splits/arkit/scans.txt"
echo $1 > data_splits/arkit/scans.txt

# conda activate simplerecon            # not activated in the script, script is running after the activation. see the python code.
python ./data_scripts/ios_logger_preprocessing.py --data_config configs/data/neucon_arkit_default.yaml 



