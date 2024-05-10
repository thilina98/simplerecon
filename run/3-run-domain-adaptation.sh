# $1 = model
# $2 = normalization

echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo                          running domain-adaptation
echo +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# conda activate forkgan
# python eval.py --dataroot ./datasets/demo --name bdd100k-rotated --model fork_gan --input_nc 3 --output_nc 3 --load_size 512 --crop_size 512 --preprocess scale_height_and_crop --lambda_identity 0.0 --netD ms3 --norm none --lambda_conf 1 --batch_size 8
# python eval.py --dataroot ./datasets/demo --name hostel-experiment --model fork_gan --input_nc 3 --output_nc 3 --load_size 512 --crop_size 512 --preprocess scale_height_and_crop --lambda_identity 0.0 --netD ms3 --norm instance --lambda_conf 1 --batch_size 8
python eval.py --dataroot ./datasets/demo --name $1 --model fork_gan --input_nc 3 --output_nc 3 --load_size 512 --crop_size 512 --preprocess scale_height_and_crop --lambda_identity 0.0 --netD ms3 --norm $2 --lambda_conf 1 --batch_size 8
