#!/bin/bash

set -e  # Exit on error
# set -x  # Uncomment this line to enable debugging if needed

# Name of your API service
SERVICE_NAME="put_service_name_here"

# Command to execute in the container
CONTAINER_COMMAND="curl -s google.com"

# Function to get the details of an active container for a service
get_active_container_details() {
    local SERVICE_NAME=$1
    docker service ps $SERVICE_NAME \
        --filter "desired-state=running" \
        --format "{{.ID}} {{.Node}} {{.Name}}" | 
        head -n1
}

# Function to get the actual container name
get_container_name() {
    local NODE=$1
    local SERVICE_NAME=$2
    local TASK_ID=$3
    
    ssh $NODE "docker ps --format '{{.Names}}' | grep $SERVICE_NAME | grep $TASK_ID"
}

# Function to execute command in container
execute_in_container() {
    local NODE=$1
    local CONTAINER_NAME=$2
    local COMMAND=$3

    ssh $NODE "docker exec $CONTAINER_NAME $COMMAND"
}

# Get the details of the active container
CONTAINER_DETAILS=$(get_active_container_details $SERVICE_NAME)

if [ -n "$CONTAINER_DETAILS" ]; then
    TASK_ID=$(echo $CONTAINER_DETAILS | awk '{print $1}')
    NODE=$(echo $CONTAINER_DETAILS | awk '{print $2}')
    TASK_NAME=$(echo $CONTAINER_DETAILS | awk '{print $3}')

    echo "Active task for $SERVICE_NAME:"
    echo "Task ID: $TASK_ID"
    echo "Running on node: $NODE"
    echo "Task name: $TASK_NAME"
    
    # Get the actual container name
    CONTAINER_NAME=$(get_container_name $NODE $SERVICE_NAME $TASK_ID)
    
    if [ -n "$CONTAINER_NAME" ]; then
        echo "Container Name: $CONTAINER_NAME"
        echo ""
        echo "Executing command in container: $CONTAINER_COMMAND"
        COMMAND_OUTPUT=$(execute_in_container $NODE $CONTAINER_NAME "$CONTAINER_COMMAND")
        echo "Command output:"
        echo "$COMMAND_OUTPUT"
    else
        echo "Failed to get container name for task $TASK_ID on node $NODE"
    fi
else
    echo "No active container found for service $SERVICE_NAME"
fi
