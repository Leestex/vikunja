#!/bin/sh
# qlane test target: create the two QA accounts once. Run by the ai.qlane.postdeploy hook in
# docker-compose.qlane.yml, inside the vikunja container, so the passwords come from the container's
# environment and never appear in the compose configuration or the hook's command line.
# Both are ordinary users: an instance admin needs a Pro license, which needs the license server.
set -eu
seed() {
  username=$1 email=$2 password=$3
  if vikunja user list -e "$email" >/dev/null 2>&1; then
    echo "qlane: $username exists"
  else
    vikunja user create -u "$username" -e "$email" -p "$password" >/dev/null
    echo "qlane: created $username"
  fi
}
seed qa-admin qa-admin@example.com "${QA_ADMIN_PASSWORD:?}"
seed qa-user qa-user@example.com "${QA_USER_PASSWORD:?}"
