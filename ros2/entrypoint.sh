#!/bin/bash
set -e  # Exit on error

# Source ROS 2 and workspace setups
source /opt/ros/humble/setup.bash
source /ros2_ws/install/setup.bash

# Launch rosbridge for Unity TCP connection in background
# NOTE: rosbridge_websocket_launch defaults to port 9090.
# If you need TCP on port 10000, you may need a different launch file or config.
ros2 launch rosbridge_server rosbridge_websocket_launch.xml &
ROSBRIDGE_PID=$!

# Function to gracefully shut down processes
shutdown() {
    echo "Shutting down..."
    kill $ROSBRIDGE_PID 2>/dev/null
    wait $ROSBRIDGE_PID 2>/dev/null
    exit 0
}

# Trap SIGTERM and SIGINT (docker stop, Ctrl+C)
trap shutdown SIGTERM SIGINT

# Wait for background processes (keeps container running)
wait $ROSBRIDGE_PID