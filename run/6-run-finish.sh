# $1 = filename_without_extension

#====================
# finishing 
#====================

rm -R ../../forkgan/ForkGAN-pytorch/datasets/demo
# rm -R ../../forkgan/ForkGAN-pytorch/results
rm -R ../../forkgan/pre-recon/images
# rm -R ../arkit_data/scans/$1/
# Only deletes the directory if an argument is provided
if [ "$#" -ne 1 ]; then
    echo "ERROR: You need to pass the name of the directory you want to delete in simplerecon/arkit-data/scans/"
    exit 1
else:
    rm -R ../arkit_data/scans/$1/
fi
