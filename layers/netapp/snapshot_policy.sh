#!/bin/bash

echo "starting snapshot policy script"

sudo apt-get install jq

snapshotPolicy=$(az netappfiles snapshot policy show -g $resourceGroup --account-name $netappAccountName --snapshot-policy-name $snapshotPolicyName --query 'name' -o json)

if [[ ! -n "$snapshotPolicy" && "$delpolicy" -eq 0 ]]
then
    echo "$snapshotPolicyName will be created!"
    az netappfiles snapshot policy create \
        -g $resourceGroup \
        --account-name $netappAccountName \
        --snapshot-policy-name $snapshotPolicyName \
        -l $location \
        --hourly-snapshots $hourlySnapshots \
        --monthly-snapshots $monthlySnapshots \
        --monthly-days $monthlydays \
        --monthly-hour $monthlyhour \
        --monthly-minute $monthlyminute \
        --weekly-snapshots $weeklySnapshots \
        --daily-snapshots $dailySnapshots \
        --enabled $enabled
elif [[ -n "$snapshotPolicy" && "$delpolicy" -eq 0 ]]
then
    echo "$snapshotPolicyName will be updated!"
    az netappfiles snapshot policy update \
        -g $resourceGroup \
        --account-name $netappAccountName \
        --snapshot-policy-name $snapshotPolicyName \
        -l $location \
        --hourly-snapshots $hourlySnapshots \
        --monthly-snapshots $monthlySnapshots \
        --monthly-days $monthlydays \
        --monthly-hour $monthlyhour \
        --monthly-minute $monthlyminute \
        --weekly-snapshots $weeklySnapshots \
        --daily-snapshots $dailySnapshots \
        --enabled $enabled
else
     echo "$snapshotPolicyName will be deleted!"
     az netappfiles snapshot policy delete \
     -g $resourceGroup \
     --account-name $netappAccountName \
     --snapshot-policy-name $snapshotPolicyName
fi