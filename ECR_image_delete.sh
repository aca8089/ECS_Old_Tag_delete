#!/bin/bash
#================================================================
# DESCRIPTION
#
# Script inputs
# -a --> aws region. eg:- us-east-1
# -d --> date before which ECR images should be deleted. eg:- "12/31/2017 00:00:00" (MM/DD/YYYY HH:MM:SS Format). Be sure to put between double quotes.
# -r --> Repository name
#
# Script execution syntax:-  ./script -a <source region> -d <"MM/DD/YYYY HH:MM:SS"> -r <Repository name>
# eg:- ./script -a us-west-2 -d "12/31/2017 00:00:00" -r test

## Options for passing as arguments "a=Region, d=Date like 12/31/2017 00:00:00 (MM/DD/YYYY HH:MM:SS Format), r= Repository name ##

while getopts a:d:r: option
do
case "${option}"
in
a) REGION=${OPTARG};;
d) DATE=${OPTARG};;
r) REPO=${OPTARG};;
esac
done

## Syntax check

if [ -z "$REGION" ] || [ -z "$DATE" ] || [ -z "$REPO" ];then
    echo -e "\n Pass arguments as a=Region, d=Date like 12/31/2017 00:00:00 (MM/DD/YYYY HH:MM:SS Format), r= Repository name. Please check and try again. \n"
    exit 2
fi

## Choice to confirm the date

read -p "Delete images older than the date $DATE (MM/DD/YYYY) from $REPO (y/n)? " CHOICE

case "$CHOICE" in
  y|Y)
    DATEAGO=$(date "+%s" -d "$DATE")
    IMAGES=$(aws --region $REGION ecr describe-images --repository-name $REPO --output json | jq '.[]' | jq '.[]' | jq "select (.imagePushedAt < $DATEAGO)" | jq -r '.imageDigest')
    echo -e "Found the following images \n $IMAGES"
    for IMAGE in ${IMAGES[*]}; do
      echo "Deleting $IMAGE"
      aws --region $REGION ecr batch-delete-image --repository-name $REPO --image-ids imageDigest=$IMAGE
    done
  ;;

  *) echo "Exited due to choice NO " ;exit 0  ;;
esac

