# $1 = filename_without_extension

#=======================
# Simplerecon
#=======================

echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo                       Generating tuple files
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

# conda activate simplerecon
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

