#!/bin/bash

# Install Apache2
sudo apt-get update
sudo apt-get install -y apache2

mkdir mon-site

# Enable and start Apache2
if sudo systemctl enable apache2; then
    if sudo systemctl start apache2; then
        echo "Apache2 installed and started successfully."
    else
        echo "Failed to start Apache2 service." >&2
        exit 1
    fi
else
    echo "Failed to enable Apache2 service." >&2
    exit 1
fi

# Verify Apache2 is running
curl http://localhost