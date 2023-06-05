#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

function cattle_system_is_running(){
    kubectl get pods -A | grep cattle-cluster-agent| grep -q Running
}

echo -n "Waiting for workload cluster to be up..."
while ! cattle_system_is_running; do
    sleep 2
done
echo "done"
