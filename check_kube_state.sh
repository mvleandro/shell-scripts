#!/bin/bash

# Check if at least one context has been provided
if [ $# -eq 0 ]; then
  echo -e "Show unhealthy pods and resources in multiple Kubernetes clusters.\n"
  echo "Usage: $0 <k8s_context_1> <k8s_context_2> ..."
  exit 1
fi

function check_unhealthy_pods {
  local namespace=$1
  local context=$2
  # Getting pods that are not in Ready condition
  local pods=$(kubectl --context $context get pods --namespace $namespace -o json | jq -r '.items[] | select(.status.conditions[] | select(.type=="Ready" and .status!="True")) | "\(.metadata.namespace) \(.metadata.name) \(.spec.nodeName)"')

  if [[ ! -z "$pods" ]]; then
    echo "$pods"
  else
    echo "No unhealthy pods found."
  fi
}

function check_resources {
  local resource_type=$1
  local context=$2
  local resources
  if [ "$resource_type" == "daemonsets" ]; then
    resources=$(kubectl --context $context get $resource_type --all-namespaces -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,DESIRED:.status.desiredNumberScheduled,CURRENT:.status.currentNumberScheduled,READY:.status.numberReady)
  else
    resources=$(kubectl --context $context get $resource_type --all-namespaces -o custom-columns=NAMESPACE:.metadata.namespace,NAME:.metadata.name,DESIRED:.spec.replicas,AVAILABLE:.status.availableReplicas)
  fi

  # Reading each line of the result
  while IFS= read -r line; do
    # Skipping the first line (header)
    if [[ "$line" == "NAMESPACE"* ]]; then
      continue
    fi

    if [ "$resource_type" == "daemonsets" ]; then
      read -r namespace name desired current ready <<<$(echo $line | awk '{print $1,$2,$3,$4,$5}')
      if [ "$desired" != "$current" ] || [ "$desired" != "$ready" ]; then
        if [ $desired -eq 0 ]; then
          continue
        fi
        echo -e "\nUnhealthy $resource_type: $namespace/$name, Desired: $desired, Current: $current, Ready: $ready"
        check_unhealthy_pods $namespace $context
      fi
    else
      read -r namespace name desired available <<<$(echo $line | awk '{print $1,$2,$3,$4}')
      if [[ "$desired" != "$available" && "$desired" != "<none>" && "$available" != "<none>" ]]; then
        if [ $desired -eq 0 ]; then
          continue
        fi      
        echo -e "\nUnhealthy $resource_type: $namespace/$name, Desired: $desired, Available: $available"
        check_unhealthy_pods $namespace $context
      fi
    fi
  done <<< "$resources"
}

# Iterate over each context provided
for context in "$@"; do
  echo -e "\n\n*******************************************"
  echo "Checking resources in context $context..."

  # Checking StatefulSets
  echo "Checking StatefulSets in context $context..."
  check_resources statefulsets $context

  # Checking ReplicaSets
  echo -e "\n\n*******************************************"
  echo "Checking ReplicaSets in context $context..."
  check_resources replicasets $context

  # Checking DaemonSets
  echo -e "\n\n*******************************************"
  echo "Checking DaemonSets in context $context..."
  check_resources daemonsets $context
done
