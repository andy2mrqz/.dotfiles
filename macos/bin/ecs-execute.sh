#!/bin/bash

CLUSTER="${1:-$(
	read -r -p 'Cluster: ' c
	echo "$c"
)}"
SERVICE=$(aws ecs list-services --cluster "$CLUSTER" --query 'serviceArns[0]' --output text | awk -F/ '{print $NF}')
TASK=$(aws ecs list-tasks --cluster "$CLUSTER" --service-name "$SERVICE" --desired-status RUNNING --query 'taskArns[0]' --output text)
CONTAINERS_STR=$(aws ecs describe-tasks --cluster "$CLUSTER" --tasks "$TASK" --query 'tasks[0].containers[].name' --output text)
read -r -a CONTAINERS <<<"$CONTAINERS_STR"
if [ "${#CONTAINERS[@]}" -eq 1 ]; then
	CONTAINER="${CONTAINERS[0]}"
else
	for c in "${CONTAINERS[@]}"; do [[ $c == "$CLUSTER" || $c == "$SERVICE" ]] && CONTAINER="$c"; done
	[ -z "$CONTAINER" ] && { select c in "${CONTAINERS[@]}"; do
		CONTAINER="$c"
		break
	done; }
fi

echo
echo "Cluster: $CLUSTER, Service: $SERVICE, Task: $TASK, Container: $CONTAINER"
echo

echo
echo "aws ecs execute-command --cluster $CLUSTER --task $TASK --container $CONTAINER --command \"/bin/sh\" --interactive"
echo

aws ecs execute-command --cluster "$CLUSTER" --task "$TASK" --container "$CONTAINER" --command "/bin/sh" --interactive
