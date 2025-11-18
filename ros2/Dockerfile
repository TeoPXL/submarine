FROM ros:humble-ros-base

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies in a single, cache-efficient layer
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-humble-navigation2 \
    ros-humble-nav2-bringup \
    ros-humble-rtabmap-ros \
    ros-humble-robot-localization \
    ros-humble-pcl-ros \
    ros-humble-ros-tcp-endpoint \
    python3-colcon-common-extensions \
    # Cleanup to reduce image size
    && rm -rf /var/lib/apt/lists/* /tmp/*

# Create a non-root user for security
RUN groupadd --gid 1000 ros && \
    useradd --uid 1000 --gid 1000 --create-home --shell /bin/bash ros

# Set working directory and copy workspace source
WORKDIR /ros2_ws
# Copy ONLY the source code, not host build artifacts
COPY ros2_ws/src ./src

# Build the workspace as root (to ensure permissions are correct), then transfer ownership
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