FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04

# RUN sed -i.bak -e "s%http://[^ ]\+%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list
RUN perl -p -i.bak -e 's%(deb(?:-src|)\s+)https?://(?!archive\.canonical\.com|security\.ubuntu\.com)[^\s]+%$1http://linux.yz.yamagata-u.ac.jp/pub/linux/ubuntu/archives/%' /etc/apt/sources.list

ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics
ENV DEBIAN_FRONTEND noninteractive

ARG UID="1000"
ARG USER_NAME="ros1"
ARG ROS_DISTRO="noetic"

SHELL ["/bin/bash", "-c"]

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        sudo \
        bash-completion \
        tzdata \
        wget \
        gnupg \
        zip \
        unzip \
        locales \
        ca-certificates \
        lsb-release
RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list && \
    wget https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc && \
    apt-key add ros.asc && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        libpng16-16 \
        python3-catkin-tools \
        python3-rosinstall-generator \
        ros-${ROS_DISTRO}-desktop-full \
        ros-${ROS_DISTRO}-tf \
        ros-${ROS_DISTRO}-cv-bridge \
        ros-${ROS_DISTRO}-pcl-conversions \
        ros-${ROS_DISTRO}-pcl-ros \
        ros-${ROS_DISTRO}-image-* \
        ros-noetic-mesh-msgs \
        ros-noetic-rviz-animated-view-controller \
        ros-noetic-hdf5-map-io \
        python3-pip \
        python3-rosinstall \
        python3-wstool \
        gedit \
        git \
        libdw-dev \
        opencl-headers \
        ocl-icd-opencl-dev \
        byobu \
        build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Followings are required by GS-SDF
RUN wget https://download.pytorch.org/libtorch/cu118/libtorch-cxx11-abi-shared-with-deps-2.4.1%2Bcu118.zip
RUN unzip libtorch-cxx11-abi-shared-with-deps-*.zip
RUN rm *.zip
RUN 
RUN wget https://github.com/Kitware/CMake/releases/download/v3.23.0/cmake-3.23.0-linux-x86_64.sh
RUN printf "y\nn\n" | bash ./cmake-3.23.0-linux-x86_64.sh --skip-licence --prefix=/usr 

RUN pip3 install rosdep
RUN pip3 install tqdm
RUN pip3 install "typing-extensions<4.7"
RUN pip3 install torch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 --index-url https://download.pytorch.org/whl/cu117

# Follwings are general settings
RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL=ja_JP.UTF-8
RUN localedef -f UTF-8 -i ja_JP ja_JP.utf8

ENV DEBIAN_FRONTEND newt

RUN source /opt/ros/${ROS_DISTRO}/setup.bash

RUN adduser --uid ${UID} --disabled-password --gecos '' --shell /bin/bash ${USER_NAME} && \
    mkdir -p /etc/sudoers.d/ && chmod 777 /home/${USER_NAME}
RUN echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/90-${USER_NAME}

USER $USER_NAME
WORKDIR /home/$USER_NAME
ENV ROSDISTRO ${ROS_DISTRO}

RUN source /opt/ros/${ROSDISTRO}/setup.bash && \
    echo "source /opt/ros/${ROSDISTRO}/setup.bash" >> ~/.bashrc && \
    echo "export Torch_DIR=/libtorch/share/cmake/Torch" >> ~/.bashrc && \
    echo "if [[ -f ~/catkin_ws/devel/setup.bash ]]; then" >> ~/.bashrc && \
    echo "    source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc && \
    echo "fi" >> ~/.bashrc
