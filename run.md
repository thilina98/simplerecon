# Directory Structure

First, Your directory structure should look like following.
```
- fyp_shared
    - forkgan
        - ForkGAN-pytorch
        - pre-recon
    - simplerecon
        - simplerecon
        - arkit_data
            - scans
```
Note the followings about the directory structure.
* The name of the top directory does not matter. i.e. you can have a different name instead of "fyp_shared".
* "ForkGAN-pytorch" directory and the inner-most "simplerecon" directory are the git repos.
* `arkit_data/scans` is the directory you keep your arkit scans in.
* You need to have `divide_original_and_converted.py` and `rename_files.py` inside pre-recon directory.
    * The content of the files should be as following.
        * `divide_original_and_converted.py`

            ```python
            import os
            import shutil

            def divide_images(source_dir, real_dir, fake_dir):
                # Create destination directories if they don't exist
                os.makedirs(real_dir, exist_ok=True)
                os.makedirs(fake_dir, exist_ok=True)

                # Iterate through files in the source directory
                for filename in os.listdir(source_dir):
                    if filename.lower().find("real") != -1:
                        # Move files containing "real" to the real directory
                        shutil.move(os.path.join(source_dir, filename), os.path.join(real_dir, filename))
                        print(f"Moved {filename} to {real_dir}")
                    elif filename.lower().find("fake") != -1:
                        # Move files containing "fake" to the fake directory
                        shutil.move(os.path.join(source_dir, filename), os.path.join(fake_dir, filename))
                        print(f"Moved {filename} to {fake_dir}")
                    else:
                        # Ignore files that don't contain "real" or "fake"
                        print(f"Ignored {filename}")

            
            source_directory = "./images"
            real_images_directory = "./images/original_images"
            fake_images_directory = "./images/converted_images"

            divide_images(source_directory, real_images_directory, fake_images_directory)

            ```
        * `rename_files.py`

            ```python
            import os
            import re

            def rename_files(directory):
                # Iterate through files in the directory
                for filename in os.listdir(directory):
                    # Match the pattern of the filename
                    match = re.match(r'(\d+)_fake_.+\.png', filename)
                    if match:
                        # Extract the numeric part and pad it with zeros
                        frame_number = match.group(1)
                        new_filename = f"{frame_number.zfill(5)}.png"
                        
                        # Rename the file
                        old_path = os.path.join(directory, filename)
                        new_path = os.path.join(directory, new_filename)
                        os.rename(old_path, new_path)
                        print(f"Renamed {filename} to {new_filename}")
                    else:
                        print(f"Ignored {filename}")


            directory = "./images/converted_images"
            rename_files(directory)

            ```



# How to input custom data

Move your ios_logger scan (the whole directory) into `fyp_shared/simplerecon/arkit_data/scans/`. \
Let's say the directory name was `scan-1`. `scan-1` should contain your scan video (.m4v file) and all other generated data files in it. You need to move this directory into the above mentioned location.\
After you move your scan directory, its path should be `fyp_shared/simplerecon/arkit_data/scans/scan-1`.

now you need to rename your scan data directory as **`demo-scan`**.\
once you renamed, it would look like, `fyp_shared/simplerecon/arkit_data/scans/demo-scan`



# Changing working directory

You need to change your working directory to `fyp_shared/simplerecon/simplerecon`. This is the directory where `run.sh` is stored.
```
cd /home/fyp_shared/simplerecon/simplerecon
```
Please make sure to change the path according to the path on your machine.



# Running the pipeline

Run the following command.
```
. run.sh
```

# Results

> You can find the final reconstruction in `fyp_shared/simplerecon/simplerecon/OUTPUT_PATH/HERO_MODEL/arkit/default/meshes/0.04_3.0_open3d_color` directory

> You can find night-to-day converted images in `fyp_shared/simplerecon/arkit_data/scans/demo-scan/images`

> The original exported frames from the scan are deleted now. If you want to Preserve original data, comment out the last line in `run.sh`. Then you can find the original images in `fyp_shared/forkgan/pre-recon/images/original_images` 