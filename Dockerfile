# Author: Fco Javier Roman
# email: fraromesc@gmail.com

FROM ubuntu:22.04

# User name
ARG USER_NAME=grvc
ENV USER_NAME=${USER_NAME}

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y sudo
RUN sudo apt-get update
RUN sudo apt-get upgrade -y

# Install basic tools

RUN sudo apt-get install -y git

# Install dependencies

RUN sudo apt-get install -y lsb-release
RUN sudo apt-get install -y gnupg
RUN sudo apt-get install -y wget

# Create User "$USER_NAME"

RUN useradd -ms /bin/bash $USER_NAME
RUN echo "$USER_NAME ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER_NAME
USER $USER_NAME
RUN sudo usermod -a -G dialout $USER_NAME

# Install PX4 v1.16-alpha1

WORKDIR /home/$USER_NAME/
RUN ls
RUN git clone -b v1.16.0-alpha1 https://github.com/PX4/PX4-Autopilot.git --recursive
RUN sudo apt-get update --fix-missing && sudo apt-get install -y bc
RUN bash /home/$USER_NAME/PX4-Autopilot/Tools/setup/ubuntu.sh 
WORKDIR /home/$USER_NAME/PX4-Autopilot
RUN make px4_sitl

# Install ROS2 HUMBLE

RUN sudo apt install -y locales
RUN sudo locale-gen en_US en_US.UTF-8
RUN sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
RUN export LANG=en_US.UTF-8

# These lines are for ROS2 not ask region
ARG DEBIAN_FRONTEND=noninteractive
#RUN sudo dpkg-reconfigure locales
 
RUN sudo apt-get install -y software-properties-common
RUN sudo add-apt-repository universe

RUN sudo apt-get install -y curl
RUN sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN sudo apt-get update 
RUN sudo apt-get upgrade -y

 
RUN sudo apt install -y ros-humble-desktop

RUN sudo echo "source /opt/ros/humble/setup.bash" >> /home/$USER_NAME/.bashrc
RUN sudo /bin/bash -c "source /opt/ros/humble/setup.bash"

RUN sudo apt install -y python3-colcon-common-extensions
RUN sudo apt install -y python3-rosdep

# Install Micro-XRCE-DDS-Agent v3.0.1

WORKDIR /home/$USER_NAME/
RUN git clone -b v3.0.1 https://github.com/eProsima/Micro-XRCE-DDS-Agent.git
WORKDIR /home/$USER_NAME/Micro-XRCE-DDS-Agent
RUN sudo mkdir build
WORKDIR /home/$USER_NAME/Micro-XRCE-DDS-Agent/build
RUN sudo cmake .. 
RUN sudo make -j4
RUN sudo make install -j4
RUN sudo ldconfig /usr/local/lib/

# Build px4_msgs v.15

RUN sudo apt-get install -y cmake
RUN mkdir -p /home/$USER_NAME/ros2_ws/src
WORKDIR /home/$USER_NAME/ros2_ws/src
RUN git clone https://github.com/PX4/px4_msgs.git -b release/1.15
WORKDIR /home/$USER_NAME/ros2_ws
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && colcon build"

RUN sudo echo "source /home/$USER_NAME/ros2_ws/install/setup.bash" >> /home/$USER_NAME/.bashrc

# Install Bridge Ros - Gz

RUN sudo sudo apt install -y ros-humble-ros-gzharmonic-bridge ros-humble-ros-gzharmonic-sim ros-humble-ros-gzharmonic-sim-demos
RUN sudo apt-get update

# RUN sudo apt install ros-humble-ros-gz


RUN sudo apt-get remove modemmanager -y
RUN sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl -y
RUN sudo apt install libfuse2 -y


RUN sudo apt install libxcb-xinerama0 libxkbcommon-x11-0 libxcb-cursor-dev -y 

# Download QGround
WORKDIR /home/$USER_NAME
RUN sudo wget https://d176tv9ibo4jno.cloudfront.net/latest/QGroundControl-x86_64.AppImage

# Install QGround

RUN sudo apt install fuse
RUN sudo chmod +x QGroundControl-x86_64.AppImage

# Set up

RUN sudo apt-get install -y tmux
RUN sudo apt-get install -y tmuxinator
RUN sudo apt-get install -y vim

RUN echo 'export PS1="🤖\[\e[38;5;141m\]\u@\h\[\e[0m\] \[\e[38;5;39m\]\w\[\e[0m\] \[\e[38;5;197m\]\$ \[\e[0m\]"' >> /home/$USER_NAME/.bashrc

RUN echo ":set number relativenumber" >> /home/$USER_NAME/.vimrc
