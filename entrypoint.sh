#!/bin/bash
while getopts ":a:s:b:e:h:u:z:" opt; do
    case "$opt" in
        a)  access_key=$OPTARG ;;
        s)  secret_key=$OPTARG ;;
        b)  bucket_location=$OPTARG ;;
        e)  host_base=$OPTARG ;;
        h)  host_bucket=$OPTARG ;;
        u)  use_https=$OPTARG ;;
        z)  s3cmd_operation=$OPTARG ;;
        \?) echo "Invalid option: -$OPTARG" >&2 exit 1 ;;
        :) echo "Option -$OPTARG requires an argument." >&2 exit 1 ;;
    esac
done

sed -i "s/%access_key%/$access_key/g" /home/$USER/.s3cfg
sed -i "s/%secret_key%/$secret_key/g" /home/$USER/.s3cfg
sed -i "s/%bucket_location%/$bucket_location/g" /home/$USER/.s3cfg
sed -i "s/%host_base%/$host_base/g" /home/$USER/.s3cfg
sed -i "s/%host_bucket%/$host_bucket/g" /home/$USER/.s3cfg
sed -i "s/%use_https%/$use_https/g" /home/$USER/.s3cfg

cd /data
now=$(date +"%T")
echo "Start Time : $now"
s3cmd $s3cmd_operation /tmp/download.7z
now=$(date +"%T")
echo "End download Time : $now"
7z x /tmp/download.7z
now=$(date +"%T")
echo "End Extract Time : $now"