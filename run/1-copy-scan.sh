# $1 = gsutil_uri of the file
# $2 = filename (not filename_without_extension)

#=============================================
# Moving files from bucket to arkit-data
#=============================================

# cd ../arkit_data/scans
gsutil cp $1 .
unzip $2
rm $2


# cd ../../../simplerecon/simplerecon
