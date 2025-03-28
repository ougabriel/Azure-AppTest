# Create agent directory
$agentDir = "C:\azagent"
New-Item -ItemType Directory -Force -Path $agentDir
Set-Location $agentDir

# Download the agent
$url = "https://vstsagentpackage.azureedge.net/agent/3.234.0/vsts-agent-win-x64-3.234.0.zip"
$output = "$agentDir\agent.zip"
Invoke-WebRequest -Uri $url -OutFile $output

# Extract the agent
Expand-Archive -Path $output -DestinationPath $agentDir -Force

# Configure the agent
.\config.cmd --unattended `
    --url "https://dev.azure.com/YOUR_ORG" `
    --auth PAT `
    --token "YOUR_PAT_TOKEN" `
    --pool "damiPool" `
    --agent "damiAgent" `
    --replace

# Install and start the agent service
.\install.cmd 