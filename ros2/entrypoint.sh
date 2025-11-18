#!/bin/bash
set -e

source /opt/ros/humble/setup.bash
source /ros2_ws/install/setup.bash

# Launch ROS-TCP endpoint (not rosbridge)
ros2 run ros_tcp_endpoint default_server --ros-args -p port:=10000 &
ROS_TCP_PID=$!

shutdown() {
    echo "Shutting down..."
    kill $ROS_TCP_PID 2>/dev/null
    wait $ROS_TCP_PID 2>/dev/null
    exit 0
}

trap shutdown SIGTERM SIGINT
wait $ROS_TCP_PID