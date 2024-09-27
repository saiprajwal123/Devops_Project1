#!/bin/bash

######################################################################
# About: Listing users with read access to a GitHub repository
# Input: GitHub username and token of the person executing the script
# Owner: Sai Prajwal Kacham
# Date of Creation: 20 - 01 -2024
# Last Date of Edit: 21 - 01 -2024
# Modification: Helper function and metadata added
# Contact for Issues: Sai Prajwal Kacham
######################################################################

# Helper Function
function helper {
    expected_no_of_args=2

    if [ "$#" -ne "$expected_no_of_args" ]; then
        echo "Please execute the script with the expected command-line arguments."
        echo "Example: ./script.sh arg1 arg2"
        exit 1
    fi
}

helper "$@"

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token
USERNAME=$1
TOKEN=$2

# User and Repository information
REPO_OWNER=$3
REPO_NAME=$4

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Main script
echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
