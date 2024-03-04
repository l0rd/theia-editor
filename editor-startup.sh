#!/bin/sh
#
# Copyright (c) 2021-2024 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#   Red Hat, Inc. - initial API and implementation
#

# list checode
ls -la /editor/

# detect if we're using alpine/musl
libc=$(ldd /bin/ls | grep 'musl' | head -1 | cut -d ' ' -f1)
if [ -n "$libc" ]; then
  echo "ERROR: libc not found. We are probably try to run it on Alpine but that's not supported..."
  exit 1
else
  # Run launcher
  cd /editor/theia/applications/browser || (echo "ERROR: failed to open theia folder"; exit 1)
  echo "----------------------------------------"
  echo "   Starting Theia"
  echo "----------------------------------------"
  /editor/runtime/node /editor/theia/applications/browser/lib/backend/main.js "${PROJECT_SOURCE}" --app-project-path /editor/theia/ --hostname=0.0.0.0
fi
