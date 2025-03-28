#!/bin/bash

# Create agent directory
mkdir -p ~/myagent
cd ~/myagent

# Download the agent
curl -O https://vstsagentpackage.azureedge.net/agent/3.234.0/vsts-agent-linux-x64-3.234.0.tar.gz

# Extract the agent
tar zxvf vsts-agent-linux-x64-3.234.0.tar.gz

# Configure the agent
./config.sh --unattended \
    --url "https://dev.azure.com/YOUR_ORG" \
    --auth PAT \
    --token "YOUR_PAT_TOKEN" \
    --pool "damiPool" \
    --agent "damiAgent" \
    --replace

# Install and start the agent service
sudo ./svc.sh install azureuser
sudo ./svc.sh start 