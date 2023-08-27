#!/usr/bin/env zsh

echo "Installing ROS2 Humble..."
sudo apt install software-properties-common -y 
sudo add-apt-repository universe
sudo apt -qq update && sudo apt install curl -y
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
sudo apt -qq update && sudo apt -qq upgrade -y
sudo apt install ros-humble-ros-base ros-dev-tools -y
sudo rosdep init

echo "Installing Gazebo Garden..."
sudo apt-get -qq install lsb-release wget gnupg -y
sudo wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
sudo apt-get -qq update
sudo apt-get install gz-garden -y

echo "Setting up ROS2 workspace..."
mkdir -p ~/tb_ws/src && cd ~/tb_ws/src
git clone -b humble https://github.com/gazebosim/ros_gz.git
git clone https://github.com/StanfordASL/asl-tb3-utils.git

echo "Installing ROS2 dependencies..."
source /opt/ros/humble/setup.zsh
rosdep update && rosdep install --from-paths ~/tb_ws/src -r -i -y

echo "Building ROS2 workspace..."
cd ~/tb_ws
GZ_VERSION=garden colcon build --symlink-install

echo "Updating ~/.zshrc to include setup scripts"
echo "source /opt/ros/humble/setup.zsh" >> ~/.zshrc
echo "source \$HOME/tb_ws/install/local_setup.zsh" >> ~/.zshrc

echo "Done!"
