FROM ros:humble-ros-base

# Install dependencies
RUN apt-get update && apt-get install -y \
    ros-humble-navigation2 \
    ros-humble-nav2-bringup \
    ros-humble-rtabmap-ros \
    ros-humble-robot-localization \
    ros-humble-pcl-ros \
    python3-colcon-common-extensions

# Copy your ROS workspace
WORKDIR /ros2_ws
COPY . /ros2_ws

RUN . /opt/ros/humble/setup.sh && colcon build

CMD ["bash"]

