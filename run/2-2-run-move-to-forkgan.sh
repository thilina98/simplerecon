# $1 = filename_without_extension

#==================================
# moving images to forkgan
#==================================

# cd ../../forkgan/ForkGAN-pytorch/

# now we need to move the extracted images to /home/fyp_shared/forkgan/ForkGAN-pytorch/datasets/demo/images and then convert them
mkdir datasets/demo
mv ../../simplerecon/arkit_data/scans/$1/images datasets/demo/
mv datasets/demo/images datasets/demo/testA
mkdir datasets/demo/testB
cp datasets/demo/testA/* datasets/demo/testB