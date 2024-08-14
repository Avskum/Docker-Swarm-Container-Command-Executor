# Docker Swarm Container Command Executor

This project provides a Bash script designed to execute commands inside an active Docker container that is part of a Docker Swarm service. The script retrieves details of the currently running container for a specific service, identifies the container's actual name on a Docker node, and then executes a user-defined command within that container.

## Features

- Retrieve details of an active container running in a Docker Swarm service.
- Identify the exact container name on a specific Docker node using SSH.
- Execute custom commands inside the identified container via SSH.

## Requirements

- Docker Swarm cluster set up and running.
- SSH access to the Docker nodes (passwordless SSH recommended).
- Bash shell (tested on Bash 4.x and above).
