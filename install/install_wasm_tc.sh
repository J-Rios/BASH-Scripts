#!/usr/bin/env bash

##############################################################################

### Script Configurations ###

# EMSDK Tool Version to install
# Check for versions here:
# https://github.com/emscripten-core/emsdk/tags
# EMSDK_VERSION = "3.1.4"
EMSDK_VERSION="latest"

# Path where to install EMSDK Tool
SDK_INSTALL_PATH=/opt/emsdk

##############################################################################

### Auxiliar Functions ###

# APT update function
apt_update()
{
    echo "-------------------------------------------------"
    echo " Updating Repositories"
    echo "-------------------------------------------------"
    apt-get update
    echo ""
}

# APT install package function
apt_install()
{
    if [ $# -gt 0 ]; then
        echo "-------------------------------------------------"
        echo " Installing ${1} package"
        echo "-------------------------------------------------"
        apt-get -y install $1
        if [[ $? != 0 ]]; then
            echo "Error: Can't install ${1} package"
            echo ""
            exit 1
        fi
        echo ""
    fi
}

# Get and install EMSDK Tool
emsdk_install()
{
    # Get the emsdk repository
    rm -rf $SDK_INSTALL_PATH
    echo "-------------------------------------------------"
    echo " Installing EMSDK Tool"
    echo "-------------------------------------------------"
    git clone https://github.com/emscripten-core/emsdk.git $SDK_INSTALL_PATH
    if [[ $? != 0 ]]; then
        echo "Error: Can't download emsdk GIT repository"
        echo ""
        exit 1
    fi
    cd $SDK_INSTALL_PATH

    # Download and install the latest SDK tools.
    echo "./emsdk install ${EMSDK_VERSION}"
    ./emsdk install $EMSDK_VERSION

    # Make the SDK version "active" for the current user
    # (writes .emscripten file)
    echo "./emsdk activate ${EMSDK_VERSION}"
    ./emsdk activate $EMSDK_VERSION
}

# EMSDK static source toolchain to user environment
emsdk_set_environment()
{
    # Get Home directory of user that calls the script as root
    USERHOME=$(getent passwd $SUDO_USER | cut -d: -f6)

    # Setup EMSDK environment on current shell
    echo "source ${SDK_INSTALL_PATH}/emsdk_env.sh"
    source ${SDK_INSTALL_PATH}/emsdk_env.sh

    # Setup EMSDK environment on shell start
    SETUP_CMD="source ${SDK_INSTALL_PATH}/emsdk_env.sh > /dev/null 2>&1"
    if [[ -f "${USERHOME}/.bashrc" ]]; then
        grep -qxF "${SETUP_CMD}" $USERHOME/.bashrc
        if [[ $? != 0 ]]; then
            echo "" >> $USERHOME/.bashrc
            echo "# EMSDK Environment setup" >> $USERHOME/.bashrc
            echo ${SETUP_CMD} >> $USERHOME/.bashrc
            echo "" >> $USERHOME/.bashrc
        fi
    fi
    if [[ -f "${USERHOME}/.zshrc" ]]; then
        grep -qxF "${SETUP_CMD}" $USERHOME/.zshrc
        if [[ $? != 0 ]]; then
            echo "" >> $USERHOME/.bashrc
            echo "# EMSDK Environment setup" >> $USERHOME/.bashrc
            echo ${SETUP_CMD} >> $USERHOME/.zshrc
            echo "" >> $USERHOME/.bashrc
        fi
    fi
}

##############################################################################

### Main Functionality ###

# Check for root privileges
if [ "$(id -u)" != "0" ]; then
    echo "This script must be executed with administration privileges."
    echo ""
    exit 1
fi

# Show Script Header
echo ""
echo "Installing Web Assembly Toolchain..."
echo ""
#apt_update
#apt_install python3
#apt_install cmake
#apt_install git
#emsdk_install
emsdk_set_environment
echo ""
echo "Installation completed successfully."
echo ""
exit 0
