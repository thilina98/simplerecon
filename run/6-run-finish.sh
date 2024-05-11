# $1 = filename_without_extension

#====================
# finishing 
#====================

rm -R ../../forkgan/ForkGAN-pytorch/datasets/demo
# rm -R ../../forkgan/ForkGAN-pytorch/results
rm -R ../../forkgan/pre-recon/images

# if no arguments are provided, exits the script
if [ "$#" -ne 1 ]; then
    echo "ERROR: You need to pass the name of the directory, if you want to delete a directory in simplerecon/arkit-data/scans/"
    exit 1
fi
rm -R ../arkit_data/scans/$1/
