FROM ros:humble-ros-base

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies in a single, cache-efficient layer
# CHANGES: 
# 1. Added 'git' so we can clone the missing package
# 2. Removed 'ros-humble-ros-tcp-endpoint' (it does not exist in apt for amd64)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ros-humble-navigation2 \
    ros-humble-nav2-bringup \
    ros-humble-rtabmap-ros \
    ros-humble-robot-localization \
    ros-humble-pcl-ros \
    python3-colcon-common-extensions \
    # Cleanup to reduce image size
    && rm -rf /var/lib/apt/lists/* /tmp/*

# Create a non-root user for security
RUN groupadd --gid 1000 ros && \
    useradd --uid 1000 --gid 1000 --create-home --shell /bin/bash ros

# Set working directory
WORKDIR /ros2_ws

# CHANGE: Manually clone the Unity TCP Endpoint source code
# We use the 'main-ros2' branch which is required for Humble
RUN mkdir -p src/ros_tcp_endpoint && \
    git clone https://github.com/Unity-Technologies/ROS-TCP-Endpoint.git src/ros_tcp_endpoint -b main-ros2

# Copy workspace source
# Copy ONLY the source code, not host build artifacts
COPY ros2_ws/src ./src

# Build the workspace as root (to ensure permissions are correct), then transfer ownership
# This will now build the TCP Endpoint from the source we cloned above
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && \
    colcon build --merge-install --symlink-install --executor sequential"

# Switch to root user
USER root

# Expose port for Unity ROS TCP Connector (ensure your ROS node binds to this port)
EXPOSE 10000

# Copy and setup entrypoint (as root, then fix perms)
COPY ros2/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
# Default command can be overridden
CMD ["bash"]