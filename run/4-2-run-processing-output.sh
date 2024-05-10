# $1 = file_name_without_extension

#=============================
# processing GAN output
#=============================

python divide_original_and_converted.py
python rename_files.py

mv images/converted_images ../../simplerecon/arkit_data/scans/$1
# cd ../../simplerecon/arkit_data/scans/$1
