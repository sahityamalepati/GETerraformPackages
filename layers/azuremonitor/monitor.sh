## add subscription filter

echo 'variable "resource_ids" {' > resource_ids.tf
echo 'type = map(string)' >> resource_ids.tf
echo 'description = "Map of monitor_enable resource ids"' >> resource_ids.tf
echo 'default = {' >> resource_ids.tf
az resource list --tag monitor_enable=true --query []."[name, id]" --output json | sed 's/\[//g; s/\],/\n/g; s/",/" =/g; s/\]//g'| awk NF=NF RS= >> resource_ids.tf
echo '}' >> resource_ids.tf
echo '}' >> resource_ids.tf


