# Author: Fco Javier Roman
# email: fraromesc@gmail.com

FROM ubuntu:22.04

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y sudo
RUN sudo apt-get update
RUN sudo apt-get upgrade -y

# Install basic tools
RUN sudo apt-get install -y git
RUN sudo apt-get install -y tmux
RUN sudo apt-get install -y tmuxinator
RUN sudo apt-get install -y vim
RUN echo ":set number relativenumber" >> ~/.vimrc

# Install dependencies
RUN sudo apt-get install -y lsb-release
RUN sudo apt-get install -y gnupg
RUN sudo apt-get install -y wget


# Install PX4 v1.16-alpha1

WORKDIR /root
RUN git clone -b v1.16.0-alpha1 https://github.com/PX4/PX4-Autopilot.git --recursive
RUN bash /root/PX4-Autopilot/Tools/setup/ubuntu.sh 
WORKDIR /root/PX4-Autopilot
RUN make px4_sitl

# Install ROS2 HUMBLE

RUN sudo apt install -y locales
RUN sudo locale-gen en_US en_US.UTF-8
RUN sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN export LANG=en_US.UTF-8

# These lines are for ROS2 not ask region
ARG DEBIAN_FRONTEND=noninteractive
RUN dpkg-reconfigure locales
 
RUN sudo apt-get install -y software-properties-common
RUN sudo add-apt-repository universe

RUN sudo apt-get install -y curl
RUN sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN sudo apt-get update 
RUN sudo apt-get upgrade -y

 
RUN sudo apt install -y ros-humble-desktop

RUN sudo echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
RUN /bin/bash -c "source /opt/ros/humble/setup.bash"

RUN sudo apt install -y python3-colcon-common-extensions
RUN sudo apt install -y python3-rosdep

# Install Micro-XRCE-DDS-Agent v3.0.1
WORKDIR /root
RUN git clone -b v3.0.1 https://github.com/eProsima/Micro-XRCE-DDS-Agent.git
WORKDIR /root/Micro-XRCE-DDS-Agent
RUN mkdir build
WORKDIR /root/Micro-XRCE-DDS-Agent/build
RUN cmake .. #/root/Micro-XCRE-DDS-Agent
RUN make -j4
RUN sudo make install -j4
RUN sudo ldconfig /usr/local/lib/

# Build px4_msgs v.15

RUN sudo apt-get install -y cmake
RUN mkdir -p /root/px4msgs_ws/src
WORKDIR /root/px4msgs_ws/src
RUN git clone https://github.com/PX4/px4_msgs.git -b release/1.15
WORKDIR /root/px4msgs_ws
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && colcon build"

RUN sudo echo "source /root/px4msgs_ws/install/setup.bash" >> ~/.bashrc
