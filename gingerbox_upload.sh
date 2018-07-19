#!/bin/bash

# Upload an eligibility file to gingerbox.io
#
# Note : Your .gingerbox.conf file should be copied to your home directory,
#        or specified via the '--config' command option.
#
# Usage: gingerio_upload.sh <file>

#!/bin/bashset -e

function usage(){
    echo -e "\nThe script can be used to upload file to your gingerbox account."
    echo -e "\nUsage:\n $0 [options..] <filename> \n"
    echo -e "Options:"
    echo -e "-h | --help - Display usage instructions."
    echo -e "-z | --config - Specify the location of the config file. (Default: ${HOME}/.gingerbox.conf).\n"
    exit 0;
}

# Default location of upload credentials.
CONFIG="${HOME}/.gingerbox.conf"

ACCESS_TOKEN=""
FILE=""
curl_args=" --progress"

set -o errexit -o noclobber -o pipefail

# Unpack args.
while true; do
  case "$1" in
    -h | --help ) usage; shift ;;
    -z | --config ) CONFIG="$2"; shift 2 ;;
    * ) echo "case *"; break ;;
  esac
done

if [ ! -z "$CONFIG" ]
    then
    if [ -e "$CONFIG" ]
    then
    . ${CONFIG}
    fi
fi

if [ ! -z "$1" ]
then
    FILE=$1
else
    echo "FILE is not optional"
    usage;
    exit -1;
fi

# Method to extract data from json response.
function jsonValue() {
KEY=$1
num=$2
awk -F"[,:}][^://]" '{for(i=1;i<=NF;i++){if($i~/\042'${KEY}'\042/){print $(i+1)}}}' | tr -d '"' | sed -n ${num}p | sed -e 's/[}]*$//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' -e 's/[,]*$//'
}

function log() {
    echo -e "${1}"
}

# Method to upload files to google drive.
# Requires 3 arguments file path, google folder id and access token.
function uploadFile(){

    FILE="$1"
    FOLDER_ID="$2"
    ACCESS_TOKEN="$3"
    SLUG=`basename "$FILE"`
    FILESIZE=$(wc -c "$FILE" | awk '{print $1}')

    # JSON post data to specify the file name and containing folder.
    postData="{\"name\": \"$SLUG\",\"parents\": [\"$FOLDER_ID\"]}"
    postDataSize=$(echo ${postData} | wc -c)

    # Curl command to initiate resume-able upload session and grab the returned location URL.
    log "Generating upload link for file $FILE ..."
    uploadLink=`/usr/bin/curl \
                --silent \
                -X POST \
                -H "Host: www.googleapis.com" \
                -H "Authorization: Bearer ${ACCESS_TOKEN}" \
                -H "Content-Type: application/json; charset=UTF-8" \
                -H "X-Upload-Content-Length: $FILESIZE" \
                -d "$postData" \
                "https://www.googleapis.com/upload/drive/v3/files?uploadType=resumable" \
                --http1.1 \
                --dump-header - | sed -ne s/"Location: "//p | tr -d '\r\n'`

    # Curl command to push the file to ginger box.
    # If the file size is large then the content can be split to chunks and uploaded.
    # In that case content range needs to be specified.
    log "Uploading file $FILE to google drive..."
    curl \
    -X PUT \
    -H "Authorization: Bearer ${ACCESS_TOKEN}" \
    -H "Content-Length: ${FILESIZE}" \
    -H "Slug: ${SLUG}" \
    --upload-file "$FILE" \
    --output /dev/null \
    "$uploadLink" \
    ${curl_args}
}

# Get an access token from the refresh token found in config.
if [ -z "$ACCESS_TOKEN" ]
then
    RESPONSE=`curl --silent "https://www.googleapis.com/oauth2/v4/token" --data "client_id=$CLIENT_ID&client_secret=$CLIENT_SECRET&refresh_token=$REFRESH_TOKEN&grant_type=refresh_token&refresh_token=$REFRESH_TOKEN"`
    ACCESS_TOKEN=`echo "$RESPONSE" | jsonValue access_token`
fi

# Upload the file.
if [ ! -z "$FILE" ]; then
    if [ -f "$FILE" ];then
        uploadFile "$FILE" "$FOLDER_ID" "$ACCESS_TOKEN"
        exit 0
    fi
fi

# Invalid file, exit with error and usage.
log "A valid file must be specified."
usage
exit -1
