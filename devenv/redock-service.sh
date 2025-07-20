#!/bin/bash
while true; do
  echo "Starting redock service..."
  redock
  echo "Redock stopped, restarting in 5 seconds..."
  sleep 5
done