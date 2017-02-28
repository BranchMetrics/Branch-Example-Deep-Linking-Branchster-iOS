#!/bin/bash
# Script line:
# ../Shared/ZLibrary/ZLibrary/ZBuildInfo.sh
# Dependency line:
# $(TARGET_BUILD_DIR)/$(INFOPLIST_PATH)
set -euo pipefail
target="${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
echo "Updating date '`date`' in '$target'."
(/usr/libexec/PlistBuddy -c "delete :ZBuildInfoDate" "${target}" || true)
 /usr/libexec/PlistBuddy -c "add :ZBuildInfoDate date `date`" "${target}"
