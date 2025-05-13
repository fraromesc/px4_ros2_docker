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

# Install dependencies
RUN sudo apt-get install -y lsb-release
RUN sudo apt-get install -y gnupg
RUN sudo apt-get install -y wget

RUN useradd -ms /bin/bash grvc
RUN echo "grvc ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/grvc
USER grvc
# Install PX4 v1.16-alpha1

WORKDIR /home/grvc/
RUN ls
RUN git clone -b v1.16.0-alpha1 https://github.com/PX4/PX4-Autopilot.git --recursive
RUN sudo bash /home/grvc/PX4-Autopilot/Tools/setup/ubuntu.sh 
WORKDIR /home/grvc/PX4-Autopilot
RUN sudo make px4_sitl

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

RUN sudo echo "source /opt/ros/humble/setup.bash" >> /home/grvc/.bashrc
RUN sudo /bin/bash -c "source /opt/ros/humble/setup.bash"

RUN sudo apt install -y python3-colcon-common-extensions
RUN sudo apt install -y python3-rosdep


# Install Micro-XRCE-DDS-Agent v3.0.1
WORKDIR /home/grvc/
RUN git clone -b v3.0.1 https://github.com/eProsima/Micro-XRCE-DDS-Agent.git
WORKDIR /home/grvc/Micro-XRCE-DDS-Agent
RUN sudo mkdir build
WORKDIR /home/grvc/Micro-XRCE-DDS-Agent/build
RUN sudo cmake .. 
RUN sudo make -j4
RUN sudo make install -j4
RUN sudo ldconfig /usr/local/lib/

# Build px4_msgs v.15

RUN sudo apt-get install -y cmake
RUN mkdir -p /home/grvc/px4msgs_ws/src
WORKDIR /home/grvc/px4msgs_ws/src
RUN git clone https://github.com/PX4/px4_msgs.git -b release/1.15
WORKDIR /home/grvc/px4msgs_ws
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && colcon build"

RUN sudo echo "source /home/grvc/px4msgs_ws/install/setup.bash" >> /home/grvc/.bashrc

# Install Bridge Ros - Gz

# RUN sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'
# RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
# RUN sudo apt-get update

# RUN sudo apt install ros-humble-ros-gz

# Set up 

#RUN echo 'export PS1="🤖\[\e[38;5;141m\]\u@\h\[\e[0m\] \[\e[38;5;39m\]\w\[\e[0m\] \[\e[38;5;197m\]\$ \[\e[0m\]"' >> /home/grvc/.bashrc

RUN echo ":set number relativenumber" >> /home/grvc/.vimrc

RUN sudo usermod -a -G dialout grvc
RUN sudo apt-get remove modemmanager -y
RUN sudo apt install gstreamer1.0-plugins-bad gstreamer1.0-libav gstreamer1.0-gl -y
RUN sudo apt install libfuse2 -y


RUN sudo apt install libxcb-xinerama0 libxkbcommon-x11-0 libxcb-cursor-dev -y 

RUN sudo wget https://d176tv9ibo4jno.cloudfront.net/latest/QGroundControl.AppImage

RUN sudo apt install fuse

RUN sudo apt install libfuse2

RUN sudo apt-get install -y tmux
RUN sudo apt-get install -y tmuxinator
RUN sudo apt-get install -y vim


