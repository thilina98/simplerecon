from flask import Flask, request, render_template, jsonify
import os
import subprocess

app = Flask(__name__)

@app.route("/", methods=["GET"])
def home():
    return render_template("index.html")

@app.route("/run", methods=["POST"])
def run_pipeline():

    # conda environments
    SIMPLE_RECON_CONDA_ENV = "simplerecon"
    FORKGAN_CONDA_ENV = "forkgan"

    json_request = request.json

    model = json_request.get("model")
    ios_logger_scan_zip_file_gsutil_uri = json_request.get("ios_logger_scan_zip_file_gsutil_uri")
    is_day = json_request.get("is_day")

    filename = os.path.basename(ios_logger_scan_zip_file_gsutil_uri)
    filename_without_extension = os.path.splitext(filename)[0]

    normalization = ""
    if model == "bdd100k-rotated":
        normalization = "none"
    elif model == "hostel-experiment" or model == "bdd100k-complete":
        normalization = "instance"

    SIMPLERECON_PATH = os.path.abspath(".")

# running the pipeline

    # cd command to change pwd to simplerecon/simplerecon (this directory)
    os.chdir(".")

    os.chdir("../arkit_data/scans")
    subprocess.run(["pwd"])
    bash_file_path = os.path.join(SIMPLERECON_PATH, "run/1-copy-scan.sh")
    subprocess.run(["bash", bash_file_path, ios_logger_scan_zip_file_gsutil_uri, filename])

    os.chdir("../../../simplerecon/simplerecon")
    bash_file_path = os.path.join(SIMPLERECON_PATH, "run/2-1-run-extraction.sh")
    subprocess.run(["conda", "run", "-n", SIMPLE_RECON_CONDA_ENV, "bash", bash_file_path, filename_without_extension])
        # surprisingly the cd command works while running the above script
        # the working directory changes to ../../forkgan/ForkGAN-pytorch/ while executing but the next subprocess command consider simplerecon/simplerecon as pwd 
        # it didn't work when i test again. i don't know why it worked before, and now above two lines are lies.

    if not is_day:
        os.chdir("../../forkgan/ForkGAN-pytorch/")
        bash_file_path = os.path.join(SIMPLERECON_PATH, "run/2-2-run-move-to-forkgan.sh")
        subprocess.run(["bash", bash_file_path, filename_without_extension])

        os.chdir("../../forkgan/ForkGAN-pytorch/")    
        bash_file_path = os.path.join(SIMPLERECON_PATH, "run/3-run-domain-adaptation.sh")
        subprocess.run(["conda", "run", "-n", FORKGAN_CONDA_ENV, "bash", bash_file_path, model, normalization])
        
        bash_file_path = os.path.join(SIMPLERECON_PATH, "run/4-1-run-processing-output.sh")
        subprocess.run(["bash", bash_file_path, model])

        os.chdir("../pre-recon")
        bash_file_path = os.path.join(SIMPLERECON_PATH, "run/4-2-run-processing-output.sh")
        subprocess.run(["bash", bash_file_path, filename_without_extension])

        os.chdir(f"../../simplerecon/arkit_data/scans/{filename_without_extension}")
        bash_file_path = os.path.join(SIMPLERECON_PATH, "run/4-3-run-processing-output.sh")
        subprocess.run(["bash", bash_file_path])

        os.chdir("../../../simplerecon")
        
    subprocess.run(["conda", "run", "-n", SIMPLE_RECON_CONDA_ENV, "bash", "run/5-run-recon.sh", filename_without_extension])

    bash_file_path = os.path.join(SIMPLERECON_PATH, "run/6-run-finish.sh")
    subprocess.run(["bash", bash_file_path, filename_without_extension])

    filename = filename_without_extension + ".ply"
    output_path = "OUTPUT_PATH/HERO_MODEL/arkit/default/meshes/0.04_3.0_open3d_color/"
    subprocess.run(["gsutil", "cp", output_path+filename, "gs://thilina-bucket/RECON-OUTPUT/"])

    output_gsutil_uri = "https://storage.cloud.google.com/thilina-bucket/RECON-OUTPUT/" + filename_without_extension + ".ply"

    return output_gsutil_uri


if __name__ == "__main__":
    app.run()
