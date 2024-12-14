#!/bin/bash

# Function to generate SSH key
generate_ssh_key() {
    if [ ! -f ~/.ssh/id_rsa ]; then
        echo "No SSH key found. Generating a new SSH key..."
        ssh-keygen -t rsa -b 4096 -C "youremail@example.com" -f ~/.ssh/id_rsa -N ""
        echo "SSH key generated successfully!"
    else
        echo "SSH key already exists. Skipping key generation."
    fi
}

# Display SSH key
display_ssh_key() {
    echo "Please copy the SSH key below and add it to GitHub under Settings > SSH and GPG Keys:"
    echo "==================================================================="
    cat ~/.ssh/id_rsa.pub
    echo "==================================================================="
    echo "After adding the SSH key to GitHub, come back here and type 'yes'."
}

# Wait for user confirmation
wait_for_confirmation() {
    while true; do
        read -p "Have you added the SSH key to GitHub? (yes/no): " response
        if [ "$response" == "yes" ]; then
            break
        else
            echo "Please add the SSH key to GitHub before proceeding."
        fi
    done
}

# Test SSH connection
test_ssh_connection() {
    echo "Testing SSH connection to GitHub..."
    ssh -T git@github.com
    if [ $? -eq 1 ]; then
        echo "SSH connection successful! Proceeding with Git setup..."
    else
        echo "SSH connection failed. Please check your setup and try again."
        exit 1
    fi
}

# Git setup and push
setup_and_push() {
    echo "Enter the GitHub repository SSH URL (e.g., git@github.com:username/repo.git):"
    read repo_url
    echo "Initializing Git repository..."
    git init
    echo "Adding all files to the repository..."
    git add .
    echo "Committing changes..."
    git commit -m "Initial commit"
    echo "Adding remote repository..."
    git remote add origin $repo_url
    echo "Pushing to GitHub..."
    git push -u origin main
    echo "Code successfully pushed to GitHub!"
}

# Main script flow
echo "GitHub Automation Tool"
generate_ssh_key
display_ssh_key
wait_for_confirmation
test_ssh_connection
setup_and_push
