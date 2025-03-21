#!/bin/bash

TARGET="$1"

TASK_ARN=$(aws ecs list-tasks --cluster "$TARGET" --service-name "$TARGET" --desired-status RUNNING --query 'taskArns[0]' --output text)

echo "Running the following command:"
echo "aws ecs execute-command --cluster $TARGET --task $TASK_ARN --container $TARGET --command \"/bin/sh\" --interactive"

aws ecs execute-command --cluster "$TARGET" --task "$TASK_ARN" --container "$TARGET" --command "/bin/sh" --interactive

