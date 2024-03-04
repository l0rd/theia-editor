#!/bin/sh
#
# Copyright (c) 2021 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#   Red Hat, Inc. - initial API and implementation
#

# Copy theia stuff to the shared volume
cp -r /home/node /editor/
cp -r /home/project /editor/
cp -r /home/theia /editor/
mkdir /editor/runtime
cp /usr/local/bin/node /editor/runtime/node

# Copy entrypoint
cp /editor-startup.sh /editor/startup.sh

echo "listing all files copied"
ls -la /editor
