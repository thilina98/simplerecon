# set -e        # the terminal needs to terminate if any of the commands were to fail (but this also closes the terminal, so we connot see the outputs). 
                # the above step would also stop the cleaning steps at the end.


# $1 = gsutil_uri of the file
# $2 = filename (not filename_without_extension)
# $3 = filename_without_extension
# $4 = model
# $5 = normalization

#=============================================
# Moving files from bucket to arkit-data
#=============================================

cd ../arkit_data/scans
gsutil cp $1 .
unzip $2
rm $2

cd ../../../simplerecon/simplerecon

# $3 = filename_without_extension

#=============================
# ARKit data extraction 
#=============================

echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo                                         Extracting images, intrinsics, and poses
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


# adding the name of the scan folder to "simplerecon/data_splits/arkit/scans.txt"
echo $3 > data_splits/arkit/scans.txt

conda activate simplerecon            # not activated in the script, script is running after the activation. see the python code.
python ./data_scripts/ios_logger_preprocessing.py --data_config configs/data/neucon_arkit_default.yaml 



# $3 = filename_without_extension

#==================================
# moving images to forkgan
#==================================

cd ../../forkgan/ForkGAN-pytorch/

# now we need to move the extracted images to /home/fyp_shared/forkgan/ForkGAN-pytorch/datasets/demo/images and then convert them
mkdir datasets/demo
mv ../../simplerecon/arkit_data/scans/$3/images datasets/demo/
mv datasets/demo/images datasets/demo/testA
mkdir datasets/demo/testB
cp datasets/demo/testA/* datasets/demo/testB




# $4 = model
# $5 = normalization

echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo                          running domain-adaptation
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

conda activate forkgan
python eval.py --dataroot ./datasets/demo --name $4 --model fork_gan --input_nc 3 --output_nc 3 --load_size 512 --crop_size 512 --preprocess scale_height_and_crop --lambda_identity 0.0 --netD ms3 --norm $5 --lambda_conf 1 --batch_size 8





# $4 = model

#=============================
# processing GAN output
#=============================

mv results/$4/test_latest/images ../pre-recon
cd ../pre-recon



# $3 = file_name_without_extension

#=============================
# processing GAN output
#=============================

python divide_original_and_converted.py
python rename_files.py

mv images/converted_images ../../simplerecon/arkit_data/scans/$3
cd ../../simplerecon/arkit_data/scans/$1


#=============================
# processing GAN output
#=============================

mv converted_images images

cd ../../../simplerecon




#=======================
# Simplerecon
#=======================

echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo                       Generating tuple files
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

conda activate simplerecon
python ./data_scripts/generate_test_tuples.py  --num_workers 16 --data_config configs/data/neucon_arkit_default.yaml

echo +++++++++++++++++++++++++++++++++++++++++++++++++++
echo                  3D reconstruction
echo +++++++++++++++++++++++++++++++++++++++++++++++++++

CUDA_VISIBLE_DEVICES=0 python test.py --name HERO_MODEL \
            --output_base_path OUTPUT_PATH \
            --config_file configs/models/hero_model.yaml \
            --load_weights_from_checkpoint weights/hero_model.ckpt \
            --data_config configs/data/neucon_arkit_default.yaml \
            --num_workers 8 \
            --batch_size 2 \
            --fast_cost_volume \
            --run_fusion \
            --depth_fuser open3d \
            --fuse_color \
            --skip_to_frame 83;




# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
# %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# # $3 = filename_without_extension

# #====================
# # finishing 
# #====================

# rm -R ../../forkgan/ForkGAN-pytorch/datasets/demo
# # rm -R ../../forkgan/ForkGAN-pytorch/results
# rm -R ../../forkgan/pre-recon/images

# # if no arguments are provided, exits the script
# if [ "$#" -ne 1 ]; then
#     echo "ERROR: You need to pass the name of the directory, if you want to delete a directory in simplerecon/arkit-data/scans/"
#     exit 1
# fi
# rm -R ../arkit_data/scans/$3/
