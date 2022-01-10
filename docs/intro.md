---
sidebar_position: 1
---

# Self Driving Cars

## About

This is a group project made for the Internet of Things (IoT) class for the University of West Attica(UniWA).

This project is about smart/self driving cars and their inner 'smart' communication.

The idea behind this project is to create 2 autonomous cars that can drive themselves and use sensors such as cameras and sonars to detect and avoid objects.

### Requirements

- Docker
- Docker-compose
- 1 Raspberry Pi per car
- 4 Sonar modules per car
- 1 camera module for each Raspberry Pi
- Motors, wheels and other components for the car movement

### Git Repositories

- Hardware Configuration: <code>https://github.com/BlackICE-Zed/iot_2021_hardware.git</code>
- Sonar: <code>https://git.sexycoders.org/SexyCoders/crash-bot.git</code>
- Camera: <code>https://github.com/Panagiotis-INS/self-driving-car-camera.git</code>
- Orchestration and Configuration: <code>https://github.com/IakMastro/self-driving-car-base.git</code>
- Interface: <code>https://github.com/IakMastro/self-driving-car-interface.git</code>
- Documentation: <code>https://github.com/IakMastro/self-driving-car-docs.git</code>

## Installation


```sh
# If it is installed on Debian-based Linux
./install_debian.sh

# If it is installed on Arch-based Linux
./install_arch.sh
```

## Usage


```sh
./launch.sh
```
