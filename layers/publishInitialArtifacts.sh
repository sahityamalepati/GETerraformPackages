#!/bin/bash

#Get input from user
echo "Enter project name: "
read project

echo "Enter repo name: "
read repo_name

#Login to az devops
az extension add --name azure-devops
az devops login

#Loop through layers directory. Create and run pipeline to publish initial artifact
for FILE in */;
do
pipeline_name="layer-${FILE%?}"
az pipelines create --name $pipeline_name --description 'Pipeline for Stratum' --repository $repo_name --yml-path "/layers/${FILE}Pipelines/Pipeline.yaml" --branch master --repository-type tfsgit
done