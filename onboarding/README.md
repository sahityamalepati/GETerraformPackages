[[_TOC_]]

# Azure DevOps Onboarding Overview

This document will describe how to deploy the base infrastructure that is needed in order to successfully start deploying resources to Azure.

## Prerequisites

In order to follow this guide, the following prerequisites must be met:

- The Azure DevOps project must already exist
- The user must have sufficient permissions in Azure DevOps to create a an agent pool

## Azure DevOps Onboarding Steps

### Run Terraform Script to Provision the Base Infrastructure

To run the script, please do the following:

1. Go to the repo above, click "Clone" and copy the URL and generate Git credentials.
1. Login to [Azure Cloud Shell](https://www.shell.azure.com)
1. Navigate to your desired directory and type "git clone <URL from above>." The directory name does not matter; the repo just needs to be cloned 
1. Navigate to the Terraform directory.
1. Open the editor for easier navigation between files.
1. Open "terraform.tfvars" and edit the variables accordingly. Note that the agent_pool variable must match the name of the agent pool you create. The PAT is also case sensitive. You must also enter the **entire** PLS resource ID for which your subscription has been onboarded to.
1. If you need an ACR, set the deploy_acr variable to true in terraform.tfvars. **Save the file**.
1. Before applying script you need to validate the subscription where resources will be provisioning to (in case if you have multiple subscription access)

```bash
az account show
```

In case you need to change subscription run the command bellow

```bash
az account set --subscription "ExampleSubscriptionName_WhereYouWillDeployResorces"
```

10. Once Subscription is confirmed, in the command prompt, type the following:

```bash
./runme.sh
```

> Please note that the script creates a Managed Service Identity. Particularly, a [System-Assigned Identity](https://docs.microsoft.com/en-us/azure/active-directory/managed-identities-azure-resources/overview#managed-identity-types) which exists for the life of the virtual machine scale set.

### Add Role Assignment to the NPRD VMSS MSI

In order for the MSI to access resources in the NPRD subscription and PRD subscription, be sure to add the necessary role for that resource. You will need to add "Reader" access to the Shared Image Gallery, for example. You will also need to grant your MSIs "User Access Administrator" to the subscriptions and "Storage Blob Data Contributor" to the storage account.

### Create Agent Pool

In order to run pipelines to deploy resources into Azure, an agent pool comprised of self-hosted, private agents will need to be configured. A Virtual Machine Scale Set was already deployed, but this will connect it to this agent pool. You can then reference the name of the agent pool within your pipelines. To create an agent pool, do the following:

1. Login to Azure DevOps and navigate to the appropriate organization.
1. Click on **Organization Settings** and **Agent Pools**.
1. Click on **Add Pool** at the top right corner.
1. Select the Pool Type to be **Azure virtual machine scale set**.
1. Select your subscription and the VMSS created above in the Terraform
1. Set your desired maximum number of agents and number of agents to keep on standby
1. Select "Grant access permissions to all pipelines"
1. Un-select "Auto-provision this agent pool in all projects"

[Creating Agent Pools - Azure DevOps](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/pools-queues?view=azure-devops&tabs=yaml%2Cbrowser#creating-agent-pools)


### Setup Maintenance Jobs

To ensure the agents do not run out of space with data from previous runs, you will need to manually setup maintenance jobs as well. These jobs will run at a specified date and time that you select. To setup maintenance jobs, do the following:

1. Login to Azure DevOps and navigate to the appropriate organization.
1. Click on **Organization Settings** and **Agent Pools**.
1. Click on the agent pool you created above and click on **Settings**.
1. Toggle on the **Enable agent maintenance job**.
1. (The settings are up to the application team) We recommend changing the **Days to keep unused working directories** to 14 to ensure the agents do not run out of space. Everything else can remain the default value.
1. Under **Scheduling**, pick a day and time that will not interview with the application team's work. 


## Known Issues
### Linux Agent runs as root and not the correct user due to systemd setup
As per [Run Linux Agent as systemd service](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops#run-as-a-systemd-service) `If you run your agent as a service, you cannot run the agent service as root user.`

There's a bug where by default agent service gets configured under `root` account insted of specific user.

As workaround:<br/>
1. Switch to `root` profile using command `sudo -i`
2. Navigate to `/etc/systemd/system/` folder.
3. Open file in vi editor with name like `vsts.agent.<OrgName>.<AgentPoolName>.<Agent>\x2d<Region>\x2d<vmname>.service`
4. Edit the line `User=` and add specific user name that you used to setup VMSS Pool. For example: `User=<UserName>`. Save the file after modification
5. Run command `chmod ugo+rwx -R /azagent` to ensure permissions are populated. Specifically for folder `/azagent/_diag/`, it should be `drwxrwxrwx` for `/azagent/_diag/pages` folder.
6. Reload daemonset by running command `systemctl daemon-reload`
7. Restart DevOps Agent service by running command `/azagent/svc.sh stop` and `/azagent/svc.sh start`