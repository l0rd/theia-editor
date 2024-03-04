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

## Usage

https://workspaces.openshift.com/#?image=quay.io/mloriedo/cloud-dev-images:ubi9&che-editor=definition.yaml 

## Things to fix

- Only works with libc v3 images (doesn't work with current universal developer image that is based on UBI8)
- Errors in /editor/startup-logs.txt: "EACCES: permission denied, mkdir '/home/user/.theia-ide'"
- No idling for inactivity
- No multi-project support

## License

Information about the project's license and any additional terms or conditions.
