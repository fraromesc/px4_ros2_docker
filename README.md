# Docker ROS2 PX4 Environment

This repository contains a Dockerfile and a `container.sh` script for generating a container image based on Ubuntu 22.04 with :
- [ROS 2 Humble](https://docs.ros.org/en/humble/index.html)
- [Gazebo Harmonic](https://gazebosim.org/docs/harmonic/getstarted/)
- [PX4 v1.16-alpha1](https://github.com/PX4/PX4-Autopilot/tree/v1.16.0-alpha1)
- [Micro-XRCE v3.0.1](https://github.com/eProsima/Micro-XRCE-DDS-Agent/tree/v3.0.1)
- [ROS 2 package `px4_msgs` release 1.15](https://github.com/PX4/px4_msgs/tree/release/1.15)
- [QGround Control Station](https://qgroundcontrol.com/)

## Requirements

Before getting started, ensure you have the following installed on your system:

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/) (optional, if you want to use `docker-compose`)

## Building the Image

To build the Docker image, run the following command:

```bash
docker build -t px4_ros2 .
```

This will generate a Docker image with the necessary dependencies for working with PX4 and ROS 2 Humble.

## Running the Container

To start an interactive container based on the generated image, run:

```bash
./container.sh run
```

This will open a session inside the container where you can work with PX4, ROS 2, and Gazebo.


## Customization

If you want to modify the PX4, Micro-XRCE, or `px4_msgs` version, edit the `Dockerfile` and adjust the corresponding variables.

## Contact

If you have any questions or suggestions, feel free to open an issue or a pull request.

