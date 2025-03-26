# Alarm Clock Application

A simple GUI-based alarm clock application built with Python and Tkinter.

## Prerequisites

- Docker installed on your machine
- X11 server (for GUI display)
  - On Windows: VcXsrv or Xming
  - On Linux: Built-in X server
  - On macOS: XQuartz

## Local Development

### Running without Docker

1. Install Python 3.9 or later
2. Install requirements:
   ```bash
   pip install -r requirements.txt
   ```
3. Run the application:
   ```bash
   python alarm_clock.py
   ```

### Running with Docker

1. Build the Docker image:
   ```bash
   docker build -t alarm-clock .
   ```

2. Run the container:

   **On Linux:**
   ```bash
   xhost +local:docker
   docker run -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix alarm-clock
   ```

   **On Windows (with VcXsrv):**
   1. Start VcXsrv (XLaunch)
   2. Configure with "Disable access control" checked
   3. Run the container:
   ```bash
   docker run -e DISPLAY=host.docker.internal:0 alarm-clock
   ```

   **On macOS (with XQuartz):**
   ```bash
   xhost +localhost
   docker run -e DISPLAY=host.docker.internal:0 alarm-clock
   ```

## Azure Pipeline Deployment

### Azure Pipeline Configuration (azure-pipelines.yml)

```yaml
trigger:
  - main

pool:
  vmImage: 'ubuntu-latest'

steps:
- task: Docker@2
  inputs:
    containerRegistry: 'your-container-registry'
    repository: 'alarm-clock'
    command: 'buildAndPush'
    Dockerfile: '**/Dockerfile'
    tags: |
      $(Build.BuildId)
      latest

- task: AzureWebAppContainer@1
  inputs:
    azureSubscription: 'Your-Azure-Subscription'
    appName: 'your-webapp-name'
    containers: 'your-container-registry/alarm-clock:$(Build.BuildId)'
```

### Deployment Steps

1. Create an Azure Container Registry (ACR)
2. Create an Azure Web App for Containers
3. Configure the Azure Pipeline:
   - Create a new pipeline in Azure DevOps
   - Connect to your repository
   - Use the provided azure-pipelines.yml configuration
   - Update the following values:
     - `your-container-registry`
     - `Your-Azure-Subscription`
     - `your-webapp-name`
4. Run the pipeline

## Notes

- The application uses system bell for alarms in Linux environment
- For production deployment, consider implementing proper logging and monitoring
- The container requires X11 forwarding for GUI display
- Make sure to handle security configurations appropriately in production

## Troubleshooting

1. If the GUI doesn't appear:
   - Check if X11 server is running
   - Verify DISPLAY environment variable
   - Ensure X11 forwarding is properly configured

2. If the alarm sound doesn't work:
   - Check system sound settings
   - Verify audio device permissions

## Security Considerations

- The application runs with X11 forwarding, which may have security implications
- Consider implementing appropriate access controls
- Review and update dependencies regularly
- Follow container security best practices 