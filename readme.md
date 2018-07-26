#================================================================
# DESCRIPTION

This script can be used to delete ECR images prior to a particular date in ECS Repository


Script inputs
 -a --> aws region. eg:- us-east-1
 -d --> date before which ECR images should be deleted. eg:- "12/31/2017 00:00:00" (MM/DD/YYYY HH:MM:SS Format). Be sure to put between double quotes.
 -r --> Repository name

 Script execution syntax:-  ./script -a <source region> -d <"MM/DD/YYYY HH:MM:SS"> -r <Repository name>

 eg:- ./script -a us-west-2 -d "12/31/2017 00:00:00" -r test

