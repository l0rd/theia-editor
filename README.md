# Theia editor for Eclipse Che

Files to build and run Eclipse Theia as the editor of an Eclipse Che Cloud Development Environment.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Building the Theia Container Image

```bash
IMAGE_NAME=quay.io/mloriedo/theia-editor:latest
docker build -t ${IMAGE_NAME} . && docker push ${IMAGE_NAME}
```

## Usage with DW and DWT definition

```
# Create the DevWorkspacesTemplate that contains Theia definition
kubectl apply -f ./dwt.yaml

# Create the CDE
kubectl apply -f ./dw-sample.yaml

# Wait for the workspace to be ready
kubectl wait --for=condition=Ready dw/dw --timeout=300s

# Retrieve the IDE URL
export IDE=`kubectl get dw dw -o jsonpath={.status.mainUrl}` && \
printf "\nOpen VS Code in your browser with the following link:\n\n\t${IDE}\n\n"
```

## Usage with URL params

Create a CDE using Theia as the editor with the `image` and `che-editor` URL parameters:

`https://<che-host>/#<git-repo>?image=<devtools-image>&che-editor=<editor-definition-raw-url>`

For example: 
https://workspaces.openshift.com/#https://github.com/l0rd/quarkus-api?image=quay.io/mloriedo/cloud-dev-images:ubi9&che-editor=https://raw.githubusercontent.com/l0rd/theia-editor/main/definition.yaml 

https://che-dogfooding.apps.che-dev.x6e0.p1.openshiftapps.com/f?url=https://github.com/l0rd/quarkus-api&image=quay.io/mloriedo/cloud-dev-images:ubi9&che-editor=https://raw.githubusercontent.com/l0rd/theia-editor/main/definition.yaml

:warning: the `image` parameter is required because the CDE dev tooling container image is required to have libc v3 and not v1 (the default UDI doesn't work).

## Debugging Theia

Look at the startup logs in `/editor/startup-logs.txt`:

```
total 8
drwxrwsrwx.  6 root       1001530000  103 Mar  4 22:40 .
dr-xr-xr-x.  1 root       root         87 Mar  4 22:40 ..
drwxr-sr-x.  2 1001530000 1001530000   57 Mar  4 22:40 node
drwxr-sr-x.  6 1001530000 1001530000   74 Mar  4 22:40 project
drwxr-sr-x.  2 1001530000 1001530000   18 Mar  4 22:40 runtime
-rw-r--r--.  1 1001530000 1001530000    0 Mar  4 22:40 startup-logs.txt
-rwxr-xr-x.  1 1001530000 1001530000 1001 Mar  4 22:40 startup.sh
drwxr-sr-x. 15 1001530000 1001530000 4096 Mar  4 22:40 theia
        not a dynamic executable
----------------------------------------
   Starting Theia
----------------------------------------
Configuring to accept webviews on '^.+\.webview\..+$' hostname.
2024-03-04T22:40:24.706Z root INFO Backend DefaultMessagingService.initialize: 25.8 ms [Finished 0.493 s after backend start]
2024-03-04T22:40:24.706Z root INFO Backend Object.initialize: 23.0 ms [Finished 0.493 s after backend start]
2024-03-04T22:40:24.706Z root INFO Backend MiniBrowserBackendSecurityWarnings.initialize: 1.3 ms [Finished 0.493 s after backend start]
2024-03-04T22:40:24.706Z root INFO Backend PluginDeployerContribution.initialize: 1.2 ms [Finished 0.493 s after backend start]
2024-03-04T22:40:24.706Z root INFO Backend WebviewBackendSecurityWarnings.initialize: 0.9 ms [Finished 0.493 s after backend start]
2024-03-04T22:40:24.706Z root INFO Backend HostedPluginLocalizationService.initialize: 1.1 ms [Finished 0.494 s after backend start]
2024-03-04T22:40:24.706Z root INFO Backend HostedPluginReader.initialize: 1.0 ms [Finished 0.494 s after backend start]
2024-03-04T22:40:24.711Z root INFO Backend PluginLocalizationServer.initialize: 24.1 ms [Finished 0.495 s after backend start]
2024-03-04T22:40:24.715Z root INFO configured all backend app contributions
2024-03-04T22:40:24.715Z root INFO Backend WebsocketEndpoint.onStart: 1.5 ms [Finished 0.504 s after backend start]
2024-03-04T22:40:24.717Z root INFO Theia app listening on http://0.0.0.0:3000.
2024-03-04T22:40:24.717Z root INFO Configuration directory URI: 'file:///home/user/.theia'
2024-03-04T22:40:24.719Z root INFO Backend DefaultWorkspaceServer.onStart: 3.2 ms [Finished 0.507 s after backend start]
2024-03-04T22:40:24.719Z root INFO Backend TaskBackendApplicationContribution.onStart: 0.5 ms [Finished 0.508 s after backend start]
2024-03-04T22:40:24.724Z root INFO Backend MiniBrowserEndpoint.onStart: 0.6 ms [Finished 0.508 s after backend start]
2024-03-04T22:40:24.724Z root INFO Backend MetricsBackendApplicationContribution.onStart: 4.9 ms [Finished 0.513 s after backend start]
2024-03-04T22:40:24.725Z root INFO Finished starting backend application: 0.0 ms [Finished 0.513 s after backend start]
2024-03-04T22:40:24.725Z root WARN The local plugin referenced by local-dir:/home/user/.theia-ide/plugins does not exist.
2024-03-04T22:40:24.725Z root WARN The local plugin referenced by local-dir:/home/user/.theia-ide/deployedPlugins does not exist.
2024-03-04T22:40:24.726Z root INFO Resolve plugins list: 8.0 ms [Finished 0.515 s after backend start]
2024-03-04T22:40:24.727Z root ERROR Uncaught Exception:  Error: EACCES: permission denied, mkdir '/home/user/.theia-ide'
2024-03-04T22:40:24.727Z root ERROR Error: EACCES: permission denied, mkdir '/home/user/.theia-ide'
```

## Things to fix

- Doesn't work with `che-editor` URL parameter 
- Only works with libc v3 images (doesn't work with current universal developer image that is based on UBI8)
- Errors in /editor/startup-logs.txt: "EACCES: permission denied, mkdir '/home/user/.theia-ide'"
- No idling for inactivity
- No multi-project support
- No out of the box syntax highlighting for Java
- Should we set the `--app-project-path` to something other than `/editor/`?

## License

MIT
