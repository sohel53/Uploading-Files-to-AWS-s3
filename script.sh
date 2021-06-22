#!/bin/bash

S3KEY="my aws key"
S3SECRET="my aws secret" # pass these in

function putS3
{
  path=$1
  file=$2
  aws_path=$3
  bucket='sohel-s3-bucket'
  date=$(date +"%a, %d %b %Y %T %z")
  acl="x-amz-acl:public-read"
  content_type='text/plain'
  string="PUT\n\n$content_type\n$date\n$acl\n/$bucket$aws_path$file"
  signature=$(echo -en "${string}" | openssl sha1 -hmac "${S3SECRET}" -binary | base64)
  curl -X PUT -T "$path/$file" \
    -H "Host: $bucket.s3.amazonaws.com" \
    -H "Date: $date" \
    -H "Content-Type: $content_type" \
    -H "$acl" \
    -H "Authorization: AWS ${S3KEY}:$signature" \
    "https://$bucket.s3.amazonaws.com$aws_path$file"
}

for file in "$path"/*; do
  putS3 "$path" "${file##*/}" "/path/on/s3/to/files/"
done

# Check the file is exists or not
if [ -f $file ]; then
   # Remove  the file with permission
   rm -i "$file"
   # Check the file is removed or not
   if [ -f $file ]; then
      echo "$file is not removed"
   else
      echo "$file is removed"
   fi
else
   echo "File does not exist"
fi
