#!/bin/bash
#########################################################################################################
#                                    MASTERNODE MANAGER                                                 #
#########################################################################################################
# Creator: Eddy Erkel                                                                                   #
# Discord: Eddy#6547                                                                                    #
# Date   : October, 2019                                                                                #
# Github : https://github.com/EddyErkel/Proxynode_Masternode_Manager                                    #
#                                                                                                       #
# Disclamer:                                                                                            #
# This script is provided 'as is', without warranty of any kind.                                        #
# Be aware that this script is run at your own risk and while this script                               #
# has been written with the intention of minimizing the potential for                                   #
# unintended consequences, the owners, providers and contributors                                       #
# can not be held responsible for any misuse or script problems.                                        #
# The owners, providers and contributors assume no liability for any                                    #
# financial loss, loss in revenue, loss of data, damages, direct or                                     #
# consequential that may result from the use of this script and                                         #
# the software that is downloaded and installed with it.                                                #
#                                                                                                       #
# By running this script you agree to understand and                                                    #
# accept the above terms and conditions.                                                                #
#                                                                                                       #
# Thanks:                                                                                               #
# Special thanks to the creator(s) of dupmn.                                                            #
# This piece of brilliant software makes it very easy to create                                         #
# and manage additional masternodes on the same system.                                                 #
# Please visit dupmn on github for more information about dupmn:                                        #
# https://github.com/neo3587/dupmn                                                                      #
#                                                                                                       #
# To do someday maybe:                                                                                  #
# - add alias to mn.conf file                                                                           #
# - remove option                                                                                       #
# - version check via diff                                                                              #
# - add multiple binaries versions for Ubuntu 16, 18 19                                                 #
#                                                                                                       #
#########################################################################################################
#                                    MASTERNODE MANAGER                                                 #
#########################################################################################################


# Script version
VERSION=0.5c


# Donation addresses
# Grateful for this work, reusing this work, or in a generous mood?
# Feel free to send a donation to one of the below addresses.
# It will be much appreciated.
DONADDR1="PRX: PJgbAJgKKq9HVX6dPAnvSeH4awJKUTAxYY"
DONADDR2="BTC: 18JNWyGhfAmhkWs7jzuuHn54jEZRPj81Jx"
DONADDR3="ETH: 0x067e8b995f7dbaf32081bc32927f6fac29b32055"
DONADDR4="LTC: LLqwyRiKiuvxkx76grFmbxEeoChLnxvaKH"


#########################################################################################################
#                                    MASTERNODE SPECIFIC VARIABLES                                      #
#########################################################################################################


# Masternode variables
NODE_NAME="Proxynode"
COIN_NAME="proxynode"
COIN_TICKER="PRX"
COIN_PATH="/usr/local/bin"
COIN_DAEMON="prxd"
COIN_CLI="prx-cli"
COIN_PID="prxd.pid"
COIN_FOLDER="$HOME/.prx"
COIN_CONFIG="prx.conf"
COIN_SERVICE="proxynode.service"
COIN_PORT="12195"
RPC_PORT="12196"
KEY_DUMMY="ReplaceThisDummyPrivateKeyByAManuallyGeneratedPrivateKey"                                # Dummy private key, will be assigned if a private key can not be generated.
OSVERSIONS=(16.04 18.04)                                                                            # Preferred Ubuntu OS version(s) (separate by spaces, e.g. 16.04 18.04)     


# Masternode binaries URL
COIN_URL="https://github.com/ProxyNode/proxynode/releases/download/v2.1.0/prx-Linux-v2.1.0.zip"     # Binaries compressed file. 
COIN_ZIPDIR="/Linux/"                                                                               # Path inside the zipfile that contains the binaries.


# Masternode Bootstrap URL
CHAIN_URL="http://sync.proxynode.network/prx.zip"                                                   # Bootstrap compressed file containing chain directory's.
CHAIN_DATA="blocks chainstate peers.dat"                                                            # Folders and files used for creating bootstrap.zip (separate by spaces, usually blocks chainstate peers.dat). 
                                                                                                    # These folders and files will also be deleted when installing bootstrap.  

# Masternode Addnodes URL
NODES_URL="https://raw.githubusercontent.com/ProxyNode/proxynode/master/addnodes.txt"               # Addnodes.txt file.


# Masternode related website URLs (shown at installation summary)
WWW_MAIN="http://proxynode.network/"                        # Main website URL
WWW_GHUB="https://github.com/ProxyNode/proxynode/releases"  # Github URL
WWW_EXPL="http://explorer.proxynode.network/"               # Explorer URL
WWW_MNO="https://masternodes.online/currencies/PRX/"        # Masternodes.Online URL
WWW_CMC="https://coinmarketcap.com/currencies/proxynode/"   # CoinMarketCap URL


# Dupmn variables
DUPMN_NAME="dupmn"
DUPMN_EXEC="/usr/bin/dupmn"
DUPMN_CONFIG="/root/.dupmn/dupmn.conf"
DUPMN_MNCONF="/root/.dupmn/${COIN_NAME}.dmn"
DUPMN_URL="https://raw.githubusercontent.com/neo3587/dupmn/master/dupmn_install.sh"


# Dupmn related website URLs (shown at installation summary)
WWW_DUPMN="https://github.com/neo3587/dupmn"
WWW_DUPMN1="https://github.com/neo3587/dupmn/wiki"
WWW_DUPMN2="https://github.com/neo3587/dupmn/wiki/FAQs"
WWW_DUPMN3="https://github.com/neo3587/dupmn/wiki/Commands"


# Get file names from URLs
COIN_ZIP=$(echo $COIN_URL | awk -F'/' '{print $NF}')
CHAIN_ZIP=$(echo $CHAIN_URL | awk -F'/' '{print $NF}')
NODES_TXT=$(echo $NODES_URL | awk -F'/' '{print $NF}')
DUPMN_SH=$(echo $DUPMN_URL | awk -F'/' '{print $NF}')


#########################################################################################################
#                                    MASTERNODE SPECIFIC FUNCTIONS                                      #
#########################################################################################################


# Display FIGlet logo
# http://patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=%0A
function display_logo() {
    if [ ! -z $1 ]; then DELAY=$1; else DELAY=0.04; fi
    echo -e "                                                                               ${N}"; sleep $DELAY
    echo -e " ██████╗ ██████╗  ██████╗ ██╗  ██╗██╗   ██╗${B}███╗   ██╗ ██████╗ ██████╗ ███████╗ ${N}"; sleep $DELAY
    echo -e " ██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝╚██╗ ██╔╝${B}████╗  ██║██╔═══██╗██╔══██╗██╔════╝ ${N}"; sleep $DELAY
    echo -e " ██████╔╝██████╔╝██║   ██║ ╚███╔╝  ╚████╔╝ ${B}██╔██╗ ██║██║   ██║██║  ██║█████╗   ${N}"; sleep $DELAY
    echo -e " ██╔═══╝ ██╔══██╗██║   ██║ ██╔██╗   ╚██╔╝  ${B}██║╚██╗██║██║   ██║██║  ██║██╔══╝   ${N}"; sleep $DELAY
    echo -e " ██║     ██║  ██║╚██████╔╝██╔╝ ██╗   ██║   ${B}██║ ╚████║╚██████╔╝██████╔╝███████╗ ${N}"; sleep $DELAY
    echo -e " ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ${B}╚═╝  ╚═══╝ ╚═════╝ ╚═════╝ ╚══════╝ ${N}"; sleep $DELAY
    echo -e "                                                                               ${N}"; sleep $DELAY
    echo -e "                        A Proof Of Stake cryptocurrency                        ${N}"; sleep $DELAY
    echo -e "                         focused on internet services                          ${N}"; sleep $DELAY
    echo -e "                            anonymity and security                             ${N}"; sleep $DELAY
    echo -e "                                                                               ${N}"; sleep $DELAY
    echo -e "───────────────────────────────────────────────────────────────────────────────${N}"; sleep $DELAY
}


# Display disclaimer
function display_disclaimer() {
    echo
    echo
    echo
    echo -e "${G}DISCLAIMER${N}"
    echo
    echo -e "${D}This script is provided 'as is', without warranty of any kind.${N}"
    echo -e "${D}Be aware that this script is run at your own risk and while this script${N}"
    echo -e "${D}has been written with the intention of minimizing the potential for${N}"
    echo -e "${D}unintended consequences, the owners, providers and contributors${N}"
    echo -e "${D}can not be held responsible for any misuse or script problems.${N}"
    echo -e "${D}The owners, providers and contributors assume no liability for any${N}"
    echo -e "${D}financial loss, loss in revenue, loss of data, damages, direct or${N}"
    echo -e "${D}consequential that may result from the use of this script and${N}"
    echo -e "${D}the software that is downloaded and installed with it.${N}"
    echo
    if [[ $1 != "noselection" ]]; then
        echo -e "${D}Do you understand and accept the above terms and conditions? [Y/n]${N}"
        echo
        read -s -n1 SELECTION   
        if [[ $SELECTION == @("Y"|"y"|"") ]]; then 
            echo -e "${Y}Thank you for accepting the above terms and conditions.${N}"
        else
            echo -e "${R}Sorry for not accepting the above terms and conditions.${N}"
            echo
            echo -e "${Y}As a result this script has been aborted.${N}"
            echo
            echo
            exit 1     
        fi
    fi
}


#########################################################################################################
#                                    GENERIC VARIABLES                                                  #
#########################################################################################################


# Script variables
VALIDCMD="false"                                    # Set value for valid command option check
DATE_TIME="`date +%Y-%m-%d\ %H:%M:%S`"              # Set date and time variable
FILE_DATE="`date +%Y%m%d_%H%M%S`"                   # Set date and time variable for use with filename (no spaces)
ARG1=$1                                             # First argument
ARG2=$2                                             # Second argument
ARG3=$3                                             # Third argument
ARG1=$(echo $ARG1 | sed -r 's/[-]//gi')             # Remove '-' characters from first argument
ARG1=${ARG1,,}                                      # Force lower case for first argument

if [ -f /bin/readlink ]; then
    SCRIPT_FULL=$(readlink -nf $0)                  # Script real file name (not symbolic link) including full path
else
    SCRIPT_NAME="$(basename "$0")"                  # Script file name
    SCRIPT_DIR="$(cd $(dirname "$0") && pwd)"       # Script location path
    SCRIPT_FULL="$SCRIPT_DIR/$SCRIPT_NAME"          # Script file name including full path (could be symbolic link)
    SCRIPT_FULL="$(stat $SCRIPT_FULL | grep File | sed 's/.*> //' | sed -e "s/'//g" | sed 's/ *File: *//')" # Get real filename
fi
SCRIPT_DIR=$(dirname $SCRIPT_FULL)                  # Script location path
SCRIPT_NAME=$(basename $SCRIPT_FULL)                # Script file name without path
SCRIPT_BASE="${SCRIPT_NAME%.*}"                     # Script file name without extension
SCRIPT_EXT="${SCRIPT_NAME##*.}"                     # Script file extension
CURRENT_DIR=$(pwd)                                  # Set current directory variable


# Script colors config
R='\033[0;31m'    # Red
G='\033[0;32m'    # Green
Y='\033[0;33m'    # Yellow
B='\033[0;34m'    # Blue
P='\033[0;35m'    # Purple
C='\033[0;36m'    # Cyan
W='\033[0;97m'    # White
D='\033[0;37m'    # Grey (Default)
N='\033[0m'       # No Color


#########################################################################################################
#                                    GENERIC FUNCTIONS                                                  #
#########################################################################################################


# Display script version
function script_version() {
    echo -e " v$VERSION ${N}"
}


# Clear screen
function clear_screen() {
    #clear
    tput reset # Clear screen while maintaining scrollback
}


# Display help
function display_help() {
    if [[ ! "$1" == "noheader" ]] ; then
        echo -e "${G}                         ${NODE_NAME^^} MASTERNODE MANAGER${N}"        
        echo -e "${D}───────────────────────────────────────────────────────────────────────────────${N}"
        echo
        echo -e "${G}This script will guide you through the installation, configuration${N}"
        echo -e "${G}and management of your $NODE_NAME masternode${N}."
        echo 
        echo -e "${Y}To install and manage additional $NODE_NAME masternodes this script${N}"     
        echo -e "${Y}will install and configure dupmn for $NODE_NAME when required.${N}" 
        echo
    fi
    echo
	echo -e "${D}Usage: $SCRIPT_NAME ${C}<option> [parameters]${N}"
	echo
    echo -e "${D}$SCRIPT_NAME ${C}install           ${D}: Install $NODE_NAME masternode(s)${N}"
    echo -e "${D}$SCRIPT_NAME ${C}summary           ${D}: Display $NODE_NAME main masternode installation summary${N}"
    echo -e "${D}$SCRIPT_NAME ${C}help              ${D}: Display this help text${N}"
    echo -e "${D}$SCRIPT_NAME ${C}update            ${D}: Update $NODE_NAME binaries${N}"
    echo -e "${D}$SCRIPT_NAME ${C}bootstrap         ${D}: Download and install $NODE_NAME bootstrap${N}"
    echo -e "${D}$SCRIPT_NAME ${C}createbootstrap   ${D}: Create $NODE_NAME bootstrap (from installed masternode)${N}"
    echo -e "${D}$SCRIPT_NAME ${C}stop              ${D}: Stop $NODE_NAME masternode${N}"
    echo -e "${D}$SCRIPT_NAME ${C}start             ${D}: Start $NODE_NAME masternode${N}"
    echo -e "${D}$SCRIPT_NAME ${C}status            ${D}: Show $NODE_NAME masternode status${N}"
    echo -e "${D}$SCRIPT_NAME ${C}monitor [seconds] ${D}: Monitor $NODE_NAME masternode and system continuously${N}"
    echo -e "${D}$SCRIPT_NAME ${C}showconf          ${D}: Display contents of $COIN_CONFIG${N}" 
    echo -e "${D}$SCRIPT_NAME ${C}replace strA strB ${D}: Replace 'string A' with 'string B' in $COIN_CONFIG${N}"
    echo -e "${D}$SCRIPT_NAME ${C}dupmn             ${D}: Install or update dupmn${N}"
    echo -e "${D}$SCRIPT_NAME ${C}disclaimer        ${D}: Display disclaimer${N}"
    echo -e "${D}$SCRIPT_NAME ${C}donation          ${D}: Show donation addresses${N}"
    echo
}


# Pre-installation checks
function checks() {
    echo
    echo
    echo
    echo -e "${G}PRE-INSTALLATION CHECKS${N}"
    echo
    FAILED="0"
    
    # Check if user is root
    if [[ $EUID -ne 0 ]]; then
        echo -e "${D}[${R}FAILED${D}] This script must be run as root.${N}"
        FAILED="1"
    else
        echo -e "${D}[${G}  OK  ${D}] This script is run as root.${N}"       
    fi

    # Check if a masternode has already been installed
    if [ -f $COIN_FOLDER/$COIN_CONFIG ]; then
        echo -e "${D}[${R}FAILED${D}] A $NODE_NAME masternode has already been installed.${N}"
        FAILED="1"
    else
        echo -e "${D}[${G}  OK  ${D}] No $NODE_NAME masternode installed.${N}"
    fi

    # Check Ubuntu version
    PREFOS="false"
    for OS in ${OSVERSIONS[@]}; do
        if [[ $(lsb_release -rs) == $OS ]]; then
            PREFOS="true"
        fi
    done
    
    if [[ $PREFOS == "false" ]]; then
        echo -e "[${R}FAILED${D}] You running Ubuntu $(lsb_release -rs) which is not a preferred OS version (${OSVERSIONS[*]}).${N}"
    else
        echo -e "${D}[${G}  OK  ${D}] You are running a preferred Ubuntu OS.${N}"
    fi
    
    echo
 
    if [[ $FAILED -eq "0" ]]; then
        echo -e "${Y}Passed all pre-installation checks.${N}"
    else
        echo -e "${R}One or more pre-installation checks failed.${N}"
        echo
        echo -e "${D}Do you want to continue the installation anyway (not recommended)? [y/N]${N}"
        read  -s -n1 SELECTION

        if [[ $SELECTION == @("N"|"n"|"") ]]; then
            exit 1
        fi
    fi
}


# Update system with latest updates
function update_system() {
    echo
    echo
    echo
    echo -e "${G}INSTALL SYSTEM UPDATES${N}"
    echo
    echo -e "${D}Do you want to update the system? [Y/n]${N}"
    read -s -n1 SELECTION

    if [[ $SELECTION == @("Y"|"y"|"") ]]; then
        echo
        echo -e "${D}Updating system...${N}"
        apt-get -y update          # Update the list of available packages and their versions 
        apt-get -y upgrade         # Install newer versions of packages currently installed
        #apt-get -y dist-upgrade   # Install newer versions of packages and remove obsolete packages (avoid on production systems)
        apt-get -y autoremove      # Remove orphaned packages which are not longer needed
        echo
        echo -e "${D}Install system tools...${N}"
        apt-get -y install zip unzip 
        apt-get -y install wget nano htop jq curl rsync
        apt-get -y install software-properties-common
        echo
        echo -e "${Y}Finished system update.${N}"
    else
        echo
        echo -e "${Y}System update skipped.${N}"
    fi
}


# Install masternode dependencies
function install_dependencies() {
    echo
    echo
    echo
    echo -e "${G}INSTALL DEPENDENCIES${N}"
    echo
    echo -e "${D}Do you want to install dependencies? [Y/n]${N}"
    read -s -n1 SELECTION

    if [[ $SELECTION == @("Y"|"y"|"") ]]; then
        echo
        echo -e "${D}Installing dependencies...${N}"
        apt-get -y install libzmq3-dev
        apt-get -y install libboost-system-dev libboost-filesystem-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
        apt-get -y install libevent-dev
 
        if [[ $(lsb_release -rs) < "19.04" ]]; then
            add-apt-repository -y ppa:bitcoin/bitcoin 
            apt-get -y update
            apt-get -y install libdb4.8-dev libdb4.8++-dev
        else
            apt-get install -y libdb5.3-dev 
            apt-get install -y libdb5.3++-dev 
            wget http://ftp.nl.debian.org/debian/pool/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u8_amd64.deb
            dpkg -i libssl1.0.0_1.0.1t-1+deb8u8_amd64.deb
        fi
        
        apt-get -y install libminiupnpc-dev
        
        echo
        echo -e "${Y}Masternode dependencies have been installed.${N}"
    else
        echo
        echo -e "${Y}Masternode dependencies installation skipped.${N}" 
    fi
}


# Install masternode binaries
function install_binaries() {
    echo 
    echo
    echo
    echo -e "${G}INSTALL ${NODE_NAME^^} MASTERNODE BINARIES${N}"
    echo
    echo -e "${D}Do you want to download and install $NODE_NAME masternode binaries? [Y/n]${N}"
    read -s -n1 SELECTION

    if [[ $SELECTION == @("Y"|"y"|"") ]]; then
        echo
        if [ -f $SCRIPT_DIR/$COIN_ZIP ]; then
            COIN_ZIP_DATE=$(date -r $COIN_ZIP '+%Y%m%d_%H%M%S')              # Get binaries file date
            mv $SCRIPT_DIR/$COIN_ZIP $SCRIPT_DIR/$COIN_ZIP.$COIN_ZIP_DATE
        fi
        echo -e "${D}Downloading $COIN_ZIP...${N}"
        wget -q $COIN_URL -P $SCRIPT_DIR
        if [ "$?" -gt "0" ]; then
            echo
            echo -e "${R}Failed to download $COIN_ZIP.${N}"
            exit 1
        else
            echo
            echo -e "${D}Extracting $COIN_ZIP to $COIN_PATH...${N}"
            extract $SCRIPT_DIR/$COIN_ZIP $COIN_PATH 
            if [ "$?" -gt "0" ]; then
                echo
                echo -e "${R}Failed to extract $COIN_ZIP.${N}"
                exit 1
            else 
                echo
                echo -e "${D}Setting execution permissions...${N}"
                chmod +x $COIN_PATH/$COIN_DAEMON
                chmod +x $COIN_PATH/$COIN_CLI
            fi
        fi
        echo
        echo -e "${Y}Masternode binaries have been installed.${N}"
    else
        echo
        if [ -f $COIN_PATH/$COIN_DAEMON ]; then
            echo -e "${Y}Masternode binaries installation skipped.${N}"
        else 
            echo -e "${R}Masternode installation aborted.${N}"
            exit 1
        fi
    fi
}


# Update masternode binaries
function update_binaries() {
    echo 
    echo
    echo
    echo -e "${G}UPDATE ${NODE_NAME^^} MASTERNODE BINARIES${N}"
    echo
    if [ -f $DUPMN_CONFIG  ]; then
        echo -e "${Y}Please make sure that all additional masternodes are stopped before and restarted after the update.${N}"        
        echo
    fi    
    echo -e "${D}Do you want to download and update $NODE_NAME masternode binaries? [Y/n]${N}"
    read -s -n1 SELECTION

    if [[ $SELECTION == @("Y"|"y"|"") ]]; then
        echo
        if [ -f $SCRIPT_DIR/$COIN_ZIP ]; then
            COIN_ZIP_DATE=$(date -r $COIN_ZIP '+%Y%m%d_%H%M%S')              # Get binaries file date
            mv $SCRIPT_DIR/$COIN_ZIP $SCRIPT_DIR/$COIN_ZIP.$COIN_ZIP_DATE
        fi
        echo -e "${D}Downloading $COIN_ZIP...${N}"
        wget -q $COIN_URL -P $SCRIPT_DIR
        if [ "$?" -gt "0" ]; then
            echo -e "${R}Failed to download $COIN_ZIP.${N}"
            exit 1
        else
            if [ -f "$COIN_FOLDER/$COIN_PID" ]; then
                ps -ef | grep $(/bin/cat $COIN_FOLDER/$COIN_PID) | grep $COIN_DAEMON | grep -v grep >/dev/null 2>&1
                EXITCODE="$?"
                if [[ "$EXITCODE" -eq "0" ]]; then
                    STARTED="yes"
                    node_stop
                else
                    STARTED="no"
                    echo
                    echo -e "${R}Masternode PID file exist, but no process found.${N}"
                fi
            else
                STARTED="no"
                echo
                echo -e "${D}Masternode is not running.${N}"

            fi
            echo
            echo
            echo
            echo -e "${G}UPDATE BINARIES${N}"
            echo
            echo -e "${D}Extracting $COIN_ZIP to $COIN_PATH...${N}"
            extract $SCRIPT_DIR/$COIN_ZIP $COIN_PATH
            if [ "$?" -gt "0" ]; then
                echo -e "${R}Failed to extract $COIN_ZIP.${N}"
                exit 1
            else 
                echo
                echo -e "${D}Setting execution permissions...${N}"
                chmod +x $COIN_PATH/$COIN_DAEMON
                chmod +x $COIN_PATH/$COIN_CLI
            fi
            if [[ "$STARTED" == "yes" ]]; then
                node_start
            else
                echo
                echo -e "${D}Would you like the masternode to be started? [Y/n]${N}"
                read -s -n1 SELECTION

                if [[ $SELECTION == @("Y"|"y"|"") ]]; then 
                    node_start
                fi
            fi
        fi
        echo
        echo -e "${Y}Masternode binaries have been updated.${N}"
        echo
    else
        echo
        echo -e "${R}Masternode update aborted.${N}"
        echo
        exit 1
    fi
}


# Install fail2ban
# https://www.fail2ban.org
function install_fail2ban() {
    echo
    echo
    echo  
    echo -e "${G}INSTALL FAIL2BAN${N}"
    echo
    echo -e "${D}Do you want to install Fail2Ban? (Recommended) [Y/n]${N}"
    read -s -n1 SELECTION

    if [[ $SELECTION == @("Y"|"y"|"") ]]; then  
        echo
        echo -e "${D}Installing fail2ban...${N}"
        echo
        apt-get -y install fail2ban
        service fail2ban restart 
        echo
        echo -e "${Y}Fail2Ban has been installed.${N}"
    else 
        echo
        echo -e "${Y}Fail2Ban installation skipped.${N}"
    fi

}


# Create swapfile
function create_swapfile() {
    echo
    echo
    echo  
    echo -e "${G}CREATE SWAP SPACE${N}"
    if [ ! -f /swapfile ]; then
        echo
        echo -e "${D}Do you want to create a swapfile? (Recommended) [Y/n]${N}"
        read -s -n1 SELECTION

        if [[ $SELECTION == @("Y"|"y"|"") ]]; then
            echo
            echo -e "${D}Please enter swap size or press enter for 2GB swapfile. [2GB]${N}"
            read SWAP_SIZE
  
            if [[ "$SWAP_SIZE" == "" ]]; then
                SWAP_SIZE="2G"
            fi
         
            echo
            echo -e "${D}Creating $SWAP_SIZE swapfile, this may take a few minutes...${N}"
            fallocate -l $SWAP_SIZE /swapfile
            chmod 600 /swapfile
            mkswap /swapfile
            swapon /swapfile
            if [ $? -eq 0 ]; then
                cp /etc/fstab /etc/fstab.bak
                echo '/swapfile none swap sw 0 0' | tee -a /etc/fstab
                sysctl vm.swappiness=10
                sysctl vm.vfs_cache_pressure=50
                cp /etc/sysctl.conf /etc/sysctl.conf.bak
                echo 'vm.swappiness=10' | tee -a /etc/sysctl.conf
                echo 'vm.vfs_cache_pressure=50' | tee -a /etc/sysctl.conf
                echo
                echo -e "${Y}Swapfile was created successfully.${N}"
            else
                echo
                echo -e "${R}Operation not permitted! Swap could not be created.${N}"
            fi
        else
            echo
            echo -e "${Y}Swapfile creation skipped.${N}"
        fi
    else
        echo
        echo -e "${Y}Swapfile already exists.${N}"
    fi
}


# Create massternode config file
function create_config() {
    echo
    echo
    echo   
    echo -e "${G}CREATE MASTERNODE CONFIGURATION FILE${N}"
    echo
    echo -e "${D}Creating masternode configuration file $COIN_CONFIG...${N}"
    # Create coin folder
    if [ ! -d $COIN_FOLDER ]; then
        mkdir -p $COIN_FOLDER 
    fi
    RPCUSER=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w10 | head -n1)
    RPCPASSWORD=$(tr -cd '[:alnum:]' < /dev/urandom | fold -w22 | head -n1)
    {
        echo 'rpcuser='$RPCUSER
        echo 'rpcpassword='$RPCPASSWORD
        echo 'rpcallowip=127.0.0.1'
        echo 'rpcport='$RPC_PORT
        echo ''
        echo 'port='$COIN_PORT
        echo 'server=1'
        echo 'listen=1'
        echo 'daemon=1'
    } > $COIN_FOLDER/$COIN_CONFIG  
    sleep 0.5
    echo
    echo -e "${Y}Masternode configuration file has been created.${N}"
}


# Install masternode bootstrap
function install_bootstrap() {
    echo
    echo
    echo  
    echo -e "${G}INSTALL ${NODE_NAME^^} MASTERNODE BOOTSTRAP${N}"
    echo
    echo -e "${D}Your masternode will be able to start without a bootstrap but it will take longer to sync.${N}"
    echo
    # Create coin folder
    if [ ! -d $COIN_FOLDER ]; then
        mkdir -p $COIN_FOLDER 
    fi
    # Change to coin folder
    cd $COIN_FOLDER  > /dev/null 2>&1 
    if [ -f $COIN_FOLDER/$CHAIN_ZIP ]; then
        CHAIN_DATE=$(date -r $COIN_FOLDER/$CHAIN_ZIP '+%Y-%m-%d %H:%M:%S')  # Get bootstrap file date
        echo 
        echo -e "${D}A previously downloaded bootstrap file ($CHAIN_ZIP) was found on disk, dated $CHAIN_DATE:${N}"
        ls -lh $COIN_FOLDER/$CHAIN_ZIP
        echo
        echo -e "${D}Would you like to ${C}D${D}elete or ${C}U${D}se the file on disk? [d/U]${N}"
        read -s -n1 SELECTION
        
        case $SELECTION in
            D|d)
                echo
                echo -e "${D}Deleting bootstrap file from disk...${N}"
                rm $COIN_FOLDER/$CHAIN_ZIP
                DOWNLOAD="yes"
                ;;
            U|u|*)
                echo
                echo -e "${D}Using bootstrap file from disk...${N}"
                DOWNLOAD="no" 
                ;;
        esac
    else
        DOWNLOAD="yes"
    fi
    
        
    if [[ "$DOWNLOAD" == "yes" ]]; then    
        wget --spider $CHAIN_URL 2>&1 | grep -q 'Remote file exists.'
        if [ "$?" -gt "0" ]; then
            echo
            echo -e "${R}Unable to download bootstrap file, the remote file does not exist.${N}"
            echo
            echo -e "${D}No worries, your masternode will be able to start without a bootstrap.${N}" 
        else
            CHAIN_SIZE=$(wget --spider $CHAIN_URL  2>&1 | grep Length | awk -F"[()]" '{print $2}')
            echo
            echo -e "${D}Do you want to download $CHAIN_SIZE bootstrap file? [Y/n]${N}"

            read -s -n1 SELECTION

            if [[ $SELECTION == @("Y"|"y"|"") ]]; then
                echo
                echo -e "${D}Downloading bootstrap file ($CHAIN_ZIP), this may take a few minutes...${N}"
                wget -q $CHAIN_URL -P $COIN_FOLDER --show-progress
                if [ "$?" -gt "0" ]; then
                    echo
                    echo -e "${R}Failed to download bootstrap file.${N}"
                    echo
                    echo -e "${D}No worries, your masternode will be able to start without a bootstrap.${N}" 
                else
                    echo
                    echo -e "${D}Bootstrap has been downloaded successfully.${N}"
                fi
                SKIPPED="no"
            else
                echo
                echo -e "${Y}Bootstrap download skipped.${N}"
                SKIPPED="yes"
            fi
        fi           
    fi 
    
    if [ -f $COIN_FOLDER/$CHAIN_ZIP ]; then
         if [ -z $CHAIN_SIZE ]; then
            CHAIN_SIZE=$(ls -lh $COIN_FOLDER/$CHAIN_ZIP | awk -F " " {'print $5'})
        fi    
        if [ -f "$COIN_FOLDER/$COIN_PID" ]; then
            ps -ef | grep $(/bin/cat $COIN_FOLDER/$COIN_PID) | grep $COIN_DAEMON | grep -v grep >/dev/null 2>&1
            EXITCODE="$?"
            if [[ "$EXITCODE" -eq "0" ]]; then
                STARTED="yes"
                echo
                node_stop
            else
                STARTED="no"
                echo
                echo -e "${R}Masternode PID file exist, but no process found.${N}"
            fi
        else
            STARTED="no"
            if [ -d $COIN_FOLDER/database ]; then 
                echo
                echo -e "${R}Masternode is not running.${N}" 
            fi
        fi
        
        # Delete blockchain files and folders
        for ITEM in ${CHAIN_DATA[@]}; do
            if [ -d $COIN_FOLDER/$ITEM ]; then
                echo
                echo -e "${D}Deleting $COIN_FOLDER/$ITEM...${N}"
                /bin/rm -rf $COIN_FOLDER/$ITEM
            fi
        done
        
        echo
        echo
        echo
        echo -e "${G}EXTRACTING ${NODE_NAME^^} MASTERNODE BOOTSTRAP${N}"
        echo
        echo -e "${D}Extracting bootstrap file, this may take a few minutes...${N}"
        extract $COIN_FOLDER/$CHAIN_ZIP $COIN_FOLDER | awk 'BEGIN {ORS=" "} {if(NR%4==0)print "."}'
        if [ "$?" -gt "0" ]; then
            echo
            echo -e "${R}Failed to extract $CHAIN_ZIP.${N}"
            echo -e "${D}No worries, your masternode will be able to start without a bootstrap.${N}" 
        else
            echo
            echo
            echo -e "${Y}Finished extracting bootstrap.${N}"
            echo
            echo
            echo -e "${D}Would you like to delete the $CHAIN_SIZE bootstrap file from disk? [y/N]${N}"
            read -s -n1 SELECTION
            if [[ ! $SELECTION == @("N"|"n"|"") ]]; then 
                echo
                echo -e "${D}Deleting bootstrap file...${N}"
                rm -f $COIN_FOLDER/$CHAIN_ZIP
            fi
            echo
            echo -e "${Y}Finished installing bootstrap.${N}"
        fi
        
        if [[ "$STARTED" == "yes" ]]; then
            node_start
        else
            echo
            echo
            echo -e "${D}Masternode will not be started as it was not running.${N}" 
        fi
    else
        if [[ $SKIPPED == "no" ]]; then
            echo -e "${R}Bootstrap file not found.${N}"  
        fi
    fi

}


# Create masternode bootstrap from installed masternode
function create_bootstrap() {
    echo
    echo
    echo  
    echo -e "${G}CREATE ${NODE_NAME^^} MASTERNODE BOOTSTRAP${N}"
    echo
    
    if [ ! -d $COIN_FOLDER ]; then
        echo -e "${R}Unable to create bootstrap.${N}"
        echo
        echo -e "${Y}Masternode folder $COIN_FOLDER does not exist.${N}" 
        echo
        exit 1
    fi
    
    # Change to coin folder
    cd $COIN_FOLDER  > /dev/null 2>&1 
    
    if [ -z $COIN_FOLDER/$CHAIN_ZIP ]; then
        CHAIN_ZIP="${COIN_NAME}_bootstrap.zip"
    fi
    
    if [ -f $COIN_FOLDER/$CHAIN_ZIP ]; then
        CHAIN_DATE=$(date -r $COIN_FOLDER/$CHAIN_ZIP '+%Y-%m-%d %H:%M:%S')  # Get bootstrap file date
        echo 
        echo -e "${D}A previously downloaded bootstrap file was found on disk, dated $CHAIN_DATE.${N}"
        ls -lh $COIN_FOLDER/$CHAIN_ZIP
        echo
        echo -e "${D}Would you like to ${C}D${D}elete the file or ${C}Q${D}uit? [d/Q]${N}"
        read -s -n1 SELECTION
        
        case $SELECTION in
            D|d)
                echo
                echo -e "${D}Deleting bootstrap file from disk...${N}"
                rm $COIN_FOLDER/$CHAIN_ZIP
                ;;
            Q|q|*)
                echo
                echo -e "${Y}Quit bootstrap creation.${N}"
                exit
                ;;
        esac
    fi
 
    if [ ! -f $COIN_FOLDER/$CHAIN_ZIP ]; then
        echo
        echo -e "${D}Do you want to create $NODE_NAME bootstrap file? [Y/n]${N}"
        read -s -n1 SELECTION

        if [[ $SELECTION == @("Y"|"y"|"") ]]; then 
            if [ -f "$COIN_FOLDER/$COIN_PID" ]; then
                ps -ef | grep $(/bin/cat $COIN_FOLDER/$COIN_PID) | grep $COIN_DAEMON | grep -v grep >/dev/null 2>&1
                EXITCODE="$?"
                if [[ "$EXITCODE" -eq "0" ]]; then
                    STARTED="yes"
                    node_stop
                else
                    STARTED="no"
                    echo
                    echo -e "${R}Masternode PID file exist, but no process found.${N}"
                fi
            else
                STARTED="no"
                echo
                echo -e "${R}Masternode is not running.${N}"                    
            fi
            echo
            echo
            echo
            echo -e "${G}CREATING ${NODE_NAME^^} MASTERNODE BOOTSTRAP${N}"
            echo
            echo -e "${D}Creating bootstrap file, this may take a few minutes...${N}"
            echo
            zip -r $COIN_FOLDER/$CHAIN_ZIP $CHAIN_DATA 
            if [ "$?" -gt "0" ]; then
                echo
                echo -e "${R}Failed to create bootstrap.${N}"
            else
                echo
                echo -e "${Y}Finished creating bootstrap file ${P}$CHAIN_ZIP${Y}.${N}"
            fi
            
            if [[ "$STARTED" == "yes" ]]; then
                node_start
            else
                echo
                echo -e "${D}Would you like the masternode to be started? [Y/n]${N}"
                read -s -n1 SELECTION

                if [[ $SELECTION == @("Y"|"y"|"") ]]; then 
                    node_start
                fi
            fi
        else
            echo
            echo -e "${Y}Quit bootstrap creation.${N}"            
        fi
    fi
    
    # Change to originating folder
    cd $CURRENT_DIR > /dev/null 2>&1 

}


# Get masternode local IP address
function get_localip() {
    echo
    echo
    echo  
    echo -e "${G}SELECT MASTERNODE LOCAL IP ADDRESS${N}"
    echo
    echo -e "${D}When a masternode is installed on a VPS its local IP address will be the same as its external/public IP address.${N}"
    echo -e "${D}When a masternode is behind a provider router its local IP address will differ from its external/public IP address.${N}"
    echo
    echo -e "${D}The masternode local IP address will be defined as the 'bind' IP address in the masternode config file.${N}"
    echo
    declare -a ARRAY
    ARRAY+=($(ip addr show scope global | awk '$1 ~ /^inet/ {print $2}' | awk -F "/" '{print $1}'))
    ARRAY+=($(echo "Manually"))
    ARRAY=($(echo ${ARRAY[@]} | tr [:space:] '\n' | sort -u ))          # Remove duplicates and sort array
    echo -e "${D}Please type a number to select the local masternode IP address:${N}"
    INDEX=0
    for RECORD in "${ARRAY[@]}"
    do
        echo -e "${D}${INDEX}) $RECORD${N}"
        let INDEX=${INDEX}+1
    done
    read -e SELECTION
    while [[ ! "$SELECTION" =~ ^[0-9]+$ ]] || [[ "$SELECTION" -lt 0 ]] || [[ "$SELECTION" -ge $INDEX ]]; do
        echo -en "\033[1A\033[2K"   # \033 is an Esc; the \033[1A moves the cursor to the previous line, \033[2K erases whatever was on it.
        echo -e "${R}Please try again.${N}"
        sleep 0.3
        echo -en "\033[1A\033[2K"   # \033 is an Esc; the \033[1A moves the cursor to the previous line, \033[2K erases whatever was on it.
        read -e SELECTION
    done
    RESULT=${ARRAY[$SELECTION]}
    if [ $RESULT == "Manually" ]; then
        echo
        echo -e "${D}Please type IP address manually:${N}"
        read -e RESULT
        while [[ -z $RESULT ]] || [[ $RESULT != *.*.*.* ]] && [[ $RESULT != *:*:* ]]; do
            echo -en "\033[1A\033[2K"   # \033 is an Esc; the \033[1A moves the cursor to the previous line, \033[2K erases whatever was on it.
            echo -e "${R}Please try again.${N}"
            sleep 0.3
            echo -en "\033[1A\033[2K"   # \033 is an Esc; the \033[1A moves the cursor to the previous line, \033[2K erases whatever was on it.
            read -e RESULT
        done
    fi
    NODE_IP=$RESULT
    echo
    echo -e "${Y}Selected masternode local IP address (bind): ${P}$NODE_IP${N}"
}


# Get masternode external IP address
function get_externalip() {
    echo
    echo
    echo  
    echo -e "${G}SELECT MASTERNODE EXTERNAL IP ADDRESS${N}"
    echo
    echo -e "${D}When a masternode is installed on a VPS its local IP address will be the same as its external/public IP address.${N}"
    echo -e "${D}When a masternode is behind a provider router its local IP address will differ from its external/public IP address.${N}"
    echo
    echo -e "${D}The masternode external IP address will be defined as 'externalip' and 'masternodeaddr' in the masternode config file.${N}"
    echo
    
    EXT_IP4=($(/usr/bin/curl -s4 ident.me))
    EXT_IP6=($(/usr/bin/curl -s6 ident.me))

    if ([ $EXT_IP4 != $NODE_IP ] && [ $EXT_IP6 != $NODE_IP ])
    then
        declare -a ARRAY
        ARRAY+=($(echo "$NODE_IP"))
        ARRAY+=($(echo "$EXT_IP4"))
        ARRAY+=($(echo "$EXT_IP6"))
        ARRAY+=($(echo "Manually"))
        ARRAY=($(echo ${ARRAY[@]} | tr [:space:] '\n' | sort -u ))              # Remove duplicates and sort array
        echo -e "${D}Please type a number to select the masternode external IP address:${N}"
        INDEX=0
        for RECORD in "${ARRAY[@]}"
        do
            echo -e "${D}${INDEX}) $RECORD${N}"
            let INDEX=${INDEX}+1
        done
        read -e SELECTION
        while [[ ! "$SELECTION" =~ ^[0-9]+$ ]] || [[ "$SELECTION" -lt 0 ]] || [[ "$SELECTION" -ge $INDEX ]]; do
            echo -en "\033[1A\033[2K"   # \033 is an Esc; the \033[1A moves the cursor to the previous line, \033[2K erases whatever was on it.
            echo -e "${R}Please try again.${N}"
            sleep 0.3
            echo -en "\033[1A\033[2K"   # \033 is an Esc; the \033[1A moves the cursor to the previous line, \033[2K erases whatever was on it.
            read -e SELECTION
        done
        RESULT=${ARRAY[$SELECTION]}
        if [ $RESULT == "Manually" ]; then
            echo
            echo -e "${D}Please type IP address manually:${N}"
            read -e RESULT
            while [[ -z $RESULT ]] || [[ $RESULT != *.*.*.* ]] && [[ $RESULT != *:*:* ]]; do
                echo -en "\033[1A\033[2K"   # \033 is an Esc; the \033[1A moves the cursor to the previous line, \033[2K erases whatever was on it.
                echo -e "${R}Please try again.${N}"
                sleep 0.3
                echo -en "\033[1A\033[2K"   # \033 is an Esc; the \033[1A moves the cursor to the previous line, \033[2K erases whatever was on it.
                read -e RESULT
            done
        fi
        EXT_IP=$RESULT
    else
        echo -e "${D}Use ${P}$NODE_IP${N} (same as local) as the masternode external IP address? [Y/n]${N}"
        read -s -n1 SELECTION

        if [[ $SELECTION == @("Y"|"y"|"") ]]; then          
            echo
            EXT_IP=$NODE_IP 
        else
            echo
            declare -a ARRAY
            ARRAY+=($(echo "$NODE_IP"))
            ARRAY+=($(echo "$EXT_IP4"))
            ARRAY+=($(echo "$EXT_IP6"))
            ARRAY+=($(ip addr show scope global | awk '$1 ~ /^inet/ {print $2}' | awk -F "/" '{print $1}'))
            ARRAY+=($(echo "Manually"))
            ARRAY=($(echo ${ARRAY[@]} | tr [:space:] '\n' | sort -u ))              # Remove duplicates and sort array
            echo -e "${D}Please type a number to select masternode external IP address:${N}"
            INDEX=0
            for RECORD in "${ARRAY[@]}"
            do
                echo -e "${D}${INDEX}) $RECORD${N}"
                let INDEX=${INDEX}+1
            done
            read -e SELECTION
            while [[ ! "$SELECTION" =~ ^[0-9]+$ ]] || [[ "$SELECTION" -lt 0 ]] || [[ "$SELECTION" -ge $INDEX ]]; do
                echo -en "\033[1A\033[2K"   # \033 is an Esc; the \033[1A moves the cursor to the previous line, \033[2K erases whatever was on it.
                echo -e "${R}Please try again.${N}"
                sleep 0.3
                echo -en "\033[1A\033[2K"   # \033 is an Esc; the \033[1A moves the cursor to the previous line, \033[2K erases whatever was on it.
                read -e SELECTION
            done
            RESULT=${ARRAY[$SELECTION]}
            if [ $RESULT == "Manually" ]; then
                echo
                echo -e "${D}Please type IP address manually:${N}"
                read -e RESULT
                while [[ -z $RESULT ]] || [[ $RESULT != *.*.*.* ]] && [[ $RESULT != *:*:* ]]; do
                    echo -en "\033[1A\033[2K"   # \033 is an Esc; the \033[1A moves the cursor to the previous line, \033[2K erases whatever was on it.
                    echo -e "${R}Please try again.${N}"
                    sleep 0.3
                    echo -en "\033[1A\033[2K"   # \033 is an Esc; the \033[1A moves the cursor to the previous line, \033[2K erases whatever was on it.
                    read -e RESULT
                done
                RESULT=${ARRAY[$SELECTION]}
            fi
            EXT_IP=$RESULT
        fi
    fi
    echo
    echo -e "${Y}Selected masternode external IP address (externalip/masternodeaddr): ${P}$EXT_IP${N}"
}


# Create or read masternode private key
function create_privkey() {
    echo
    echo
    echo  
    echo -e "${G}GENERATE MASTERNODE PRIVATE KEY${N}"
    echo
    echo -e "${D}To generate a private key go to your Windows Wallet > Tools > Debug Console and type 'masternode genkey'.${N}"
    echo -e "${D}If you do not paste a private key below this script will try to generate it for you.${N}"
    echo
    echo -e "${D}Please enter your private key below, or press enter to generate one:${N}"
    read -e COINKEY
    if [[ -z "$COINKEY" ]]; then
    
        if [ -f "$COIN_FOLDER/$COIN_PID" ]; then
            ps -ef | grep $(/bin/cat $COIN_FOLDER/$COIN_PID) | grep $COIN_DAEMON | grep -v grep >/dev/null 2>&1
            EXITCODE="$?"
            if [[ "$EXITCODE" -eq "0" ]]; then
                STARTED="yes"
                COINKEY=$($COIN_CLI masternode genkey 2>/dev/null)
                EXITCODE="$?"
            else
                STARTED="no"
                EXITCODE="1" 
            fi
        else
            STARTED="no"
            EXITCODE="1" 
        fi
        
        ERRCOUNT="0"
 
        if [ "$STARTED" == "no" ]; then
            echo -e "${Y}Starting masternode daemon...${N}"
            echo
            $COIN_DAEMON -daemon >/dev/null 2>&1
        fi
        echo
        echo -e "${D}Checking every 5 sec. for approximately 2 min. to see if a private key can be generated.${N}"
        echo

        /usr/bin/tput sc

        while [ "$EXITCODE" -ne "0" ]; do
            STATUS=$($COIN_CLI masternode status 2>&1 >/dev/null)
            echo -ne "$STATUS"
            COINKEY=$($COIN_CLI masternode genkey 2>/dev/null)
            EXITCODE="$?"
            ((ERRCOUNT++))
            if [ $ERRCOUNT -ge 24 ]; then
                EXITCODE="-1000"
                break
            fi
            echo -ne "."; sleep 1; echo -ne "."; sleep 1;echo -ne "."; sleep 1;echo -ne "."; sleep 1;echo -ne "."; sleep 1; /usr/bin/tput rc; /usr/bin/tput ed;
        done

        /usr/bin/tput rc; /usr/bin/tput ed;
        if  [ "$EXITCODE" -eq "-1000" ]; then
                echo -e "${R}Failed to generate a private key in time.${N}"
                echo -e "${D}For now a dummy key will be added to config file $COIN_CONFIG.${N}"
                echo -e "${D}Please replace the dummy key with a valid private key after installation.${N}"
                COINKEY=$KEY_DUMMY
         else
            echo -e "${D}Masternode private key generated:${N}"        
            #COINKEY=$($COIN_CLI masternode genkey)
            echo $COINKEY
        fi
        echo
        if [ "$STARTED" == "no" ]; then
            echo -e "${Y}Stopping masternode daemon...${N}"
            echo
            $COIN_CLI stop >/dev/null 2>&1
            sleep 3
        fi
    fi
    COINKEY=${COINKEY//[[:space:]]/}    # Removing white spaces
    echo
    echo -e "${Y}Using masternode private key (masternodeprivkey): ${P}$COINKEY${N}"
    echo
    echo -e "${D}Manually add the above private key to your Windows Wallet via${N}"
    echo -e "${D}Windows > Wallet Tools > Open Masternode Configuration File (masternode.conf).${N}"
    echo
} 


# Update masternode config file
function update_config() {
    echo
    echo
    echo  
    echo -e "${G}UPDATE MASTERNODE CONFIGURATION FILE${N}"
    echo
    echo -e "${D}Updating masternode configuration file $COIN_CONFIG...${N}"
    sed -i 's/daemon=1/daemon=0/' $COIN_FOLDER/$COIN_CONFIG  
    {
        echo 'masternode=1'
        echo 'logtimestamps=1'
        echo 'maxconnections=64'
        echo ''    
        echo 'bind=['$NODE_IP']:'$COIN_PORT
        echo 'externalip=['$EXT_IP']:'$COIN_PORT
        echo 'masternodeaddr=['$EXT_IP']:'$COIN_PORT
        echo ''        
        echo 'masternodeprivkey='$COINKEY
        echo '#masternodeblsprivkey='
        echo ''        
    } >> $COIN_FOLDER/$COIN_CONFIG
    sleep 0.5
    echo
    echo -e "${Y}Masternode configuration file has been updated.${N}"
}


# Add addnodes to masternode config file
function download_addnodes() {
    echo
    echo
    echo  
    echo -e "${G}ADD ADDNODE LIST${N}"
    echo
    echo -e "${D}Adding addnode list to masternode configuration file $COIN_CONFIG...${N}"
    # Verify addnodes list online availability
    wget --spider $NODES_URL >/dev/null 2>&1
    sleep 0.5
    if [ "$?" -gt "0" ]; then
        echo
        echo -e "${R}Failed to download addnode list $NODES_URL.${N}"
        echo -e "${D}No worries, your masternode will be able to start without the addnodes.${N}" 
    else
        # Downloading and adding addnode list to config file
        wget -O- -q $NODES_URL >> $COIN_FOLDER/$COIN_CONFIG
        if [ "$?" -gt "0" ]; then
            echo
            echo -e "${R}Failed to download addnode list $NODES_URL.${N}"
            echo -e "${D}Your masternode will be able to start without the addnodes.${N}" 
        else
            echo
            echo -e "${Y}Successfully added addnode list to masternode configuration file.${N}"
        fi        
    fi
}


# Enable firewall
function enable_firewall() {
    echo
    echo
    echo  
    echo -e "${G}INSTALL AND CONFIGURE FIREWALL${N}"
    echo
    echo -e "${D}Installing firewall...${N}"
    echo
    apt-get install -y ufw
    echo
    echo -e "${D}Adding SSH and $NODE_NAME MN port...${N}"
    ufw allow $COIN_PORT/tcp comment "$NODE_NAME MN port" >/dev/null
    ufw allow ssh comment "SSH" >/dev/null 2>&1
    ufw limit ssh/tcp >/dev/null 2>&1
    ufw default allow outgoing >/dev/null 2>&1
    echo
    echo -e "${D}Enable firewall...${N}"
    echo "y" | ufw enable >/dev/null 2>&1
    echo
    echo -e "${Y}Firewall installed, configured and enabled.${N}"
}


# Create systemd unit file
function configure_systemd() {
    echo
    echo
    echo  
    echo -e "${G}CREATE SYSTEMD UNIT FILE${N}"
    echo
    echo -e "${D}Creating masternode systemd unit file $COIN_SERVICE...${N}"
    {
    echo '[Unit]'
    echo 'Description='$COIN_NAME service
    echo 'After=network.target'
    echo ''
    echo '[Service]'
    echo 'User=root'
    echo 'Group=root'
    echo ''
    echo 'Type=forking'
    echo '#PIDFile='$COIN_FOLDER'/'$COIN_PID
    echo ''
    echo 'ExecStart='$COIN_PATH$'/'$COIN_DAEMON '-daemon -conf='$COIN_FOLDER/$COIN_CONFIG' -datadir='$COIN_FOLDER
    echo 'ExecStop=-'$COIN_PATH$'/'$COIN_CLI '-conf='$COIN_FOLDER/$COIN_CONFIG' -datadir='$COIN_FOLDER' stop'
    echo ''
    echo 'Restart=always'
    echo 'PrivateTmp=true'
    echo 'TimeoutStopSec=60s'
    echo 'TimeoutStartSec=10s'
    echo 'StartLimitInterval=120s'
    echo 'StartLimitBurst=5'
    echo ''
    echo '[Install]'
    echo 'WantedBy=multi-user.target'
    } > /etc/systemd/system/$COIN_SERVICE
    sleep 0.5
    echo
    echo -e "${D}Load masternode systemd unit file $COIN_SERVICE...${N}"
    sleep 0.5
    echo
    systemctl daemon-reload
    echo -e "${D}Enable masternode systemd unit $COIN_SERVICE...${N}"
    sleep 0.5
    systemctl enable $COIN_SERVICE # >/dev/null 2>&1
    echo
    echo -e "${Y}Masternode systemd unit file $COIN_SERVICE created and enabled.${N}"
}


# Start masternode
function node_start() {
    if [[ ! "$1" == "noheader" ]] ; then
        echo
        echo
        echo 
        echo -e "${G}START MASTERNODE${N}"
        echo
    fi
    if [ -f "$COIN_FOLDER/$COIN_PID" ]; then  
        ps -ef | grep $(/bin/cat $COIN_FOLDER/$COIN_PID) | grep $COIN_DAEMON | grep -v grep >/dev/null 2>&1
        EXITCODE="$?"
        if [[ "$EXITCODE" -eq "0" ]]; then
            echo
            echo -e "${Y}Masternode has already been started.${N}"
            node_status #noheader
        else
            echo
            echo -e "${R}Masternode PID file exist, but no process found.${N}"
        fi
    else
        echo -e "${D}Starting masternode...${N}"
        systemctl start $COIN_SERVICE
        EXITCODE="$?"
        sleep 3
        if [[ "$EXITCODE" -eq "0" ]]; then
            echo
            echo -e "${Y}Masternode started.${N}"
            monitor_small
        else
            echo -e "${R}Failed to start masternode.${N}"
            echo
            echo -e "${D}You should start by running the following commands as root:${N}"
            echo -e "${D}systemctl start $COIN_SERVICE${N}"
            echo -e "${D}systemctl status $COIN_SERVICE${N}"
            echo -e "${D}less /var/log/syslog${N}"
        fi
     fi
}


# Stop masternode
function node_stop() {
    if [[ ! "$1" == "noheader" ]] ; then
        echo
        echo
        echo 
        echo -e "${G}STOP MASTERNODE${N}"
        echo
    fi
    if [ -f "$COIN_FOLDER/$COIN_PID" ]; then  
        ps -ef | grep $(/bin/cat $COIN_FOLDER/$COIN_PID) | grep $COIN_DAEMON | grep -v grep >/dev/null 2>&1
        EXITCODE="$?"
        if [[ "$EXITCODE" -eq "0" ]]; then
            echo -ne "${D}Stopping masternode...${N}"; 
            echo
            $COIN_CLI stop >/dev/null 2>&1
            /bin/systemctl stop $COIN_SERVICE >/dev/null 2>&1
            monitor_small
        else
            echo -e "${R}Masternode PID file exist, but no process found.${N}"
        fi
    else
        echo -e "${Y}Masternode is not running.${N}"
    fi
}


# Display masternode status
function node_status() {
    if [[ ! "$1" == "noheader" ]] ; then
        echo
        echo
        echo 
        echo -e "${G}MASTERNODE STATUS ${N}"
        echo
    fi
    if [ -f "$COIN_FOLDER/$COIN_PID" ]; then
        ps -ef | grep $(/bin/cat $COIN_FOLDER/$COIN_PID) | grep $COIN_DAEMON | grep -v grep >/dev/null 2>&1
        if [[ "$?" -eq "0" ]]; then
            echo -e "${C}ps -ef | grep '$'(/bin/cat $COIN_FOLDER/$COIN_PID)${N}"
            ps -ef | grep $(/bin/cat $COIN_FOLDER/$COIN_PID) | grep -v grep
            STARTED="1"
        else
            echo -e "${R}Masternode PID file exist, but no $COIN_DAEMON process was found.${N}"  
        fi
    else
        STARTED="0"
    fi
    echo
    echo -e "${C}systemctl status $COIN_SERVICE ${N}"
    /bin/systemctl status $COIN_SERVICE 
    echo
    echo -e "${C}$COIN_CLI masternode status${N}"
    $COIN_CLI masternode status
    echo
    echo -e "${C}$COIN_CLI getblockcount${N}"
    $COIN_CLI getblockcount
    echo
    if [[ "$STARTED" == "1" ]]; then
        echo -e "${Y}Masternode is running.${N}"
        echo
    else
        echo -e "${R}Masternode is not running.${N}"
        echo
    fi
}


# Monitor masternode compact (displayed on single line)
function monitor_small() {
    if [[ ! "$1" == "noheader" ]] ; then
        echo
        echo
        echo 
        echo -e "${G}MASTERNODE MONITOR${N}"
        echo
    fi
    if [ -f "$COIN_FOLDER/$COIN_PID" ]; then
        echo -e "${Y}Press a key to stop monitoring.${N}"
        echo
        echo -e "${D}Displaying: exitcode | blockcount | status${N}"
        echo
        ps -ef | grep $(/bin/cat $COIN_FOLDER/$COIN_PID) 2> /dev/null | grep $COIN_DAEMON | grep -v grep >/dev/null 2>&1
        if [[ "$?" -eq "0" ]]; then
             /usr/bin/tput sc                                               # tput sc: Save the cursor position
             while  [ -z "$input" ];  do
                STATUS=$($COIN_CLI masternode status 2>&1)
                EXITCODE="$?"
                if [[ "$EXITCODE" -eq "0" ]]; then
                    STATUS=$($COIN_CLI masternode status | grep -i "successfully" 2>&1)
                fi
                BLOCK=$($COIN_CLI getblockcount 2> /dev/null)
                if [[ "$BLOCK" =~ ^[0-9]+$ ]]; then
                    BLOCKCOUNT=$BLOCK
                fi
                PRINTWIDTH=$(expr $(/usr/bin/tput cols) - ${#BLOCK} - 12)   # Calculate max number of characters on one line
                PRINTSTATUS=$(echo $STATUS | cut -c -$PRINTWIDTH)

                echo -ne "$EXITCODE | $BLOCKCOUNT | $PRINTSTATUS"

                i=0                
                while  [ -z "$input" ] && [ $i -lt 5 ] ;  do
                    read -t 1 -N 1 input
                    echo -ne "."
                    let "i++"
                done;
                if [[ "$STATUS" == *"couldn't connect"* ]]; then
                    MESSAGE="${R}Masternode stopped running.${N}" 
                    break
                else
                    MESSAGE="${Y}Masternode is running.${N}"
                fi
                /usr/bin/tput rc;                                           # tput rc: Restore the cursor position
                /usr/bin/tput ed;                                           # tput ed: Clear to end of screen
            done;
            echo -e "$EXITCODE | $BLOCKCOUNT | $PRINTSTATUS"
            echo
        else
            MESSAGE="${R}Masternode PID file exist, but no $COIN_DAEMON process was found.${N}"  
        fi
    else
        MESSAGE="${R}Masternode is not running.${N}"
    fi
    echo -e $MESSAGE
}
    
    
# Monitor masternode verbose (full page)
function monitor_large {
    #/usr/bin/tput sc #Save the cursor position, not used
    if [ ! -z $ARG2 ]; then SLEEP=$ARG2; else SLEEP=5; fi
    while  [ -z "$input" ]; do
        tput clear || exit 2; # Clear screen while maintaining scrollback
        CMD="
            echo -e '${D}───────────────────────────────────────────────────────────────────────────────${N}'
            echo -e '${G}${NODE_NAME^^} MASTERNODE MONITORING${N}'           
            echo -e '${D}───────────────────────────────────────────────────────────────────────────────${N}'
            echo -e '${G}SYSTEM STATUS${N}'
            echo
            echo -e '${D}Uptime${N}'
            uptime
            echo
            df -h 
            echo
            echo -e '${D}Memory${N}'
            free
            echo
            echo -e '${D}───────────────────────────────────────────────────────────────────────────────${N}'
            echo -e '${G}MASTERNODE STATUS${N}'
            echo
            $COIN_CLI -datadir=$COIN_FOLDER masternode status 2>&1 | grep -v '{$' | grep -v '^}'
            echo
            echo -e '${D}───────────────────────────────────────────────────────────────────────────────${N}'
            echo -e '${G}SYNC STATUS${N}'
            echo
            $COIN_CLI -datadir=$COIN_FOLDER mnsync status | grep Synced --color=never
            $COIN_CLI -datadir=$COIN_FOLDER getinfo | grep blocks --color=never
            $COIN_CLI -datadir=$COIN_FOLDER getinfo | grep connections --color=never
            echo
            echo -e '${D}───────────────────────────────────────────────────────────────────────────────${N}'
            echo -e '${G}VERSION INFO${N}'
            echo
            $COIN_CLI -datadir=$COIN_FOLDER getinfo | grep version --color=never
            echo
            echo -e '${D}───────────────────────────────────────────────────────────────────────────────${N}'
            echo
            echo -e '${D}This screen will refresh every $SLEEP seconds...${N}'
            echo
            echo -e '${Y}Press a key to stop monitoring.${D}'
            echo"
        bash -ic "$CMD";
        # Exit if a key or ^C is pressed or when an error occurs.
        exitcode=$?; [ $exitcode -ne 0 ] && exit $exitcode
        # Pause and read key press input
        read -s -t $SLEEP -N 1 input
        #/usr/bin/tput rc;   # Restore the cursor position, not used
    done;
} 
 
 
# Display masternode config file contents
function showconf() { 
    if [[ ! "$1" == "noheader" ]] ; then
        echo
        echo
        echo 
        echo -e "${G}SHOW CONFIG ${N}"
        echo
    fi
    if [ -f "$COIN_FOLDER/$COIN_CONFIG" ]; then 
        echo -e "${D}Display contents of $COIN_FOLDER/$COIN_CONFIG:${N}"
        echo
        cat $COIN_FOLDER/$COIN_CONFIG
    else
        echo -e "${R}File $COIN_FOLDER/$COIN_CONFIG does not exit.${N}"    
    fi 
} 


# Install dupmn
# https://github.com/neo3587/dupmn
function install_dupmn () {
    echo
    echo
    echo  
    echo -e "${G}INSTALL AND CONFIGURE DUPMN${N}"
    echo
    if [ -f $DUPMN_EXEC ]; then
        echo -e "${D}Dupmn is already installed, do you want to check for newer dupmn version? [Y/n]${N}"
        read  -s -n1 SELECTION

        if [[ $SELECTION == @("Y"|"y"|"") ]]; then
            echo
            echo -e "${D}Checking for newer dupmn version....${N}"
            echo
            $DUPMN_EXEC update
        else
            echo
            echo -e "${Y}Version check for dupmn skipped.${N}"
        fi
    else
        echo -e "${D}Do you want to install and configure dupmn? [Y/n]${N}"
        read  -s -n1 SELECTION

        if [[ $SELECTION == @("Y"|"y"|"") ]]; then
            wget --spider $DUPMN_URL  >/dev/null 2>&1
            if [ "$?" -ne 0 ]; then
                echo
                echo -e "${R}Installation file $DUPMN_SH not available for download.${N}"
            else
                 if [ -f $SCRIPT_DIR/$DUPMN_SH ]; then
                    # Rename file if it already exists
                    DUPMN_SH_DATE=$(date -r $SCRIPT_DIR/$DUPMN_SH '+%Y%m%d_%H%M%S')             # Get file date date
                    echo
                    echo -e "${D}Installation file $DUPMN_SH already exists, renaming to $DUPMN_SH_RENAME...${N}"
                    echo mv $SCRIPT_DIR/$DUPMN_SH $SCRIPT_DIR/$DUPMN_SH.$DUPMN_SH_DATE
                    mv $SCRIPT_DIR/$DUPMN_SH $SCRIPT_DIR/$DUPMN_SH.$DUPMN_SH_DATE
                    echo
                fi 
                echo
                echo -e "${Y}Downloading dupmn installation file ${P}$DUPMN_SH${Y}.${N}" 
                echo
                wget $DUPMN_URL -P $SCRIPT_DIR
                if [ "$?" -ne 0 ]; then
                    echo
                    echo -e "${R}Failed to download dupmn installation.${N}"
                else
                    chmod +x $SCRIPT_DIR/$DUPMN_SH
                    echo
                    echo -e "${D}Installing dupmn...${N}"
                    $SCRIPT_DIR/$DUPMN_SH
                    echo
                    echo
                    echo -e "${Y}Finished installing dupmn.${N}"
                fi
            fi
        else
            echo 
            echo -e "${Y}Installation of dupmn aborted.${N}"           
        fi
    fi
}


# Create dupmn config file
function create_dupmn_config() {
    echo
    echo
    echo  
    echo -e "${G}CREATE DUPMN CONFIGURATION FILE${N}"
    echo
    if [ -f $DUPMN_MNCONF  ]; then
        echo -e "${Y}$DUPMN_MNCONF already exists.${N}"
    else
        {
            echo 'COIN_NAME="'$COIN_NAME'"'
            echo 'COIN_PATH="'$COIN_PATH'"'
            echo 'COIN_DAEMON="'$COIN_DAEMON'"'
            echo 'COIN_CLI="'$COIN_CLI'"'
            echo 'COIN_FOLDER="'$COIN_FOLDER'"'
            echo 'COIN_CONFIG="'$COIN_CONFIG'"'
            echo 'COIN_SERVICE="'$COIN_SERVICE'"'
        } > $DUPMN_MNCONF  
        echo -e "${Y}Configuration file ${P}$DUPMN_MNCONF ${Y}has been created.${N}"
    fi
}  


# Load dumpn config file
function load_dupmn_profile() {
    echo
    echo
    echo  
    echo -e "${G}LOAD DUPMN PROFILE${N}"
    echo
    if [[ ! -f /root/.dupmn/${COIN_NAME} ]] || [[ ! -f $DUPMN_CONF ]]; then
        echo -e "${D}Loading $COIN_NAME dupmn profile...${N}"
        echo
        $DUPMN_EXEC profadd $DUPMN_MNCONF $COIN_NAME
        echo
        echo -e "${Y}Finished installing dupmn.${N}"
    else
        echo -e "${Y}Dupmn profile for $COIN_NAME has already been loaded.${N}"
    fi
    echo
    echo -e "${D}Type ${P}dupmn help${D} to show dupmn help contents.${N}"
}


# Install additional masternode using dupmn
function install_additional_node () {
    echo 
    echo
    echo
    echo -e "${G}INSTALL ADDITIONAL ${NODE_NAME^^} MASTERNODE USING DUPMN${N}"
    echo
    echo -e "${D}A $NODE_NAME masternode has already been installed on this system.${N}"
    echo
    echo -e "${Y}If you continue, an additional $NODE_NAME masternode will be installed using dupmn.${N}"
    echo -e "${Y}With dupmn you can manage all your additionally installed $NODE_NAME masternodes.${N}"
    echo -e "${Y}If not yet installed, dupmn will be installed and configured in advance.${N}"
    echo
    echo -e "${D}Do you want to install an additional $NODE_NAME masternode using dupmn? [Y/n]${N}"
    read -s -n1 SELECTION

    if [[ $SELECTION == @("Y"|"y"|"") ]]; then
        install_dupmn
        create_dupmn_config
        load_dupmn_profile
        if [ -f $COIN_FOLDER/$CHAIN_ZIP ]; then
            CHAIN_DATE=$(date -r $COIN_FOLDER/$CHAIN_ZIP '+%Y-%m-%d %H:%M:%S')      # Get bootstrap file date
            CHAIN_SIZE=$(ls -lh $COIN_FOLDER/$CHAIN_ZIP | awk -F " " {'print $5'})  # Get bootstrap file size
            echo
            echo
            echo
            echo -e "${G}BOOTSTRAP FILE FOUND${N}"
            echo
            echo -e "${D}A previously downloaded/created bootstrap file was found in directory $COIN_FOLDER:${N}"
            ls -lh $COIN_FOLDER/$CHAIN_ZIP
            echo
            echo -e "${Y}Please be aware that dupmn makes a complete copy of directory $COIN_FOLDER${N}"
            echo -e "${Y}including any previously downloaded files in that directory (e.g. bootstrap $CHAIN_ZIP).${N}"
            echo
            echo -e "${D}Would you like to temporarily ${C}M${D}ove the file, ${C}D${D}elete the file, ${C}C${D}ontinue or ${C}Q${D}uit? [M/d/c/q]${N}"
            read -s -n1 SELECTION
            
            case $SELECTION in
                M|m|*)
                    echo
                    echo -e "${D}Temporarily moving bootstrap file...${N}"
                    mv $COIN_FOLDER/$CHAIN_ZIP $COIN_FOLDER/../$CHAIN_ZIP 
                    MOVE=yes
                    ;;
                C|c)
                    echo
                    echo -e "${D}Continuing...${N}"
                    ;;                    
                Q|q|*)
                    echo
                    echo -e "${Y}Additional $NODE_NAME masternode installation aborted.${N}"
                    exit
                    ;;
            esac
        fi
        create_privkey
        echo
        echo
        echo
        echo -e "${G}INSTALL ADDITIONAL MASTERNODE USING DUPMN${N}"
        echo
        echo -e "${C}dupmn install $COIN_NAME --bootstrap --privkey=$COINKEY${N}"
        echo
        dupmn install $COIN_NAME --bootstrap --privkey=$COINKEY
        EXITCODE="$?"

        if [ $MOVE == yes ]; then
            echo
            echo -e "${D}Moving bootstrap to its original location...${N}"
            echo
            mv $COIN_FOLDER/../$CHAIN_ZIP $COIN_FOLDER/$CHAIN_ZIP
        fi

        if [[ "$EXITCODE" -eq "1" ]]; then
            echo
            echo -e "${Y}Finished installing additional $NODE_NAME masternode.${N}" 
            echo
            echo
            echo -e "${D}Please use ${C}dupmn${D} to manage your additional masternodes.${N}"
            echo
            dupmn_summary
        fi
    else
        echo
        echo -e "${Y}Additional $NODE_NAME masternode installation aborted.${N}"  
    fi
    echo
}
            

# Display installation summary for main (initial) masternode
function installation_summary() {
    echo
    echo -e "${G}MAIN MASTERNODE INSTALLATION SUMMARY${N}"
    echo
    if [ -z "$COINKEY" ]; then
        # If an IP address has not been selected read the config file
        if [ -f $COIN_FOLDER/$COIN_CONFIG ]; then
            CONFCONTENTS=$(cat $COIN_FOLDER/$COIN_CONFIG)
            NODE_IP=$(echo "$CONFCONTENTS" | grep ^bind | sed 's/.*\[\([^]]*\)\].*/\1/g')
            EXT_IP=$(echo "$CONFCONTENTS" | grep externalip | sed 's/.*\[\([^]]*\)\].*/\1/g')
            COIN_PORT=$(echo "$CONFCONTENTS" | grep ^port | sed -e 's#.*=\(\)#\1#')
            COINKEY=$(echo "$CONFCONTENTS" | grep masternodeprivkey | sed -e 's#.*=\(\)#\1#')
        else
            echo -e "${R}No $NODE_NAME masternode installation found in default directory $COIN_FOLDER.${N}"   
            echo
        fi
    fi
    if [ ! -z "$COINKEY" ]; then
        echo -e "${D}Configuration files:${N}"    
        echo -e "${D}- Systemd Unit file         : ${P}/etc/systemd/system/$COIN_SERVICE${N}"
        echo -e "${D}- Masternode Config file    : ${P}$COIN_FOLDER/$COIN_CONFIG${N}"
        echo
        echo -e "${D}Variables defined in $COIN_CONFIG:${N}"
        echo -e "${D}- bind                      : ${P}$NODE_IP:$COIN_PORT${N}"
        echo -e "${D}- externalip                : ${P}$EXT_IP:$COIN_PORT${N}"
        echo -e "${D}- masternodeaddr            : ${P}$EXT_IP:$COIN_PORT${N}"    
        echo -e "${D}- masternodeprivkey         : ${P}$COINKEY${N}"
        echo
    fi

    echo -e "${D}Commands to manage your main masternode via this script:${N}"     
    echo -e "${D}- Install (additional node) : ${C}$SCRIPT_NAME install${N}"
    echo -e "${D}- Show help                 : ${C}$SCRIPT_NAME help${N}"
    echo -e "${D}- Show masternode status    : ${C}$SCRIPT_NAME status${N}" 
    echo -e "${D}- Monitor masternode status : ${C}$SCRIPT_NAME monitor${N}"
    echo -e "${D}- Start masternode          : ${C}$SCRIPT_NAME start${N}"
    echo -e "${D}- Stop masternode           : ${C}$SCRIPT_NAME stop${N}"
    echo
    echo -e "${D}Commands to manage your main masternode using default commands:${N}"   
    echo -e "${D}- Show service status       : ${C}systemctl status $COIN_SERVICE${N}"
    echo -e "${D}- Start service             : ${C}systemctl start $COIN_SERVICE${N}"
    echo -e "${D}- Stop service              : ${C}systemctl stop $COIN_SERVICE${N}"
    echo -e "${D}- Show masternode status    : ${C}$COIN_CLI masternode status${N}"
    echo -e "${D}- Show masternode blockcount: ${C}$COIN_CLI getblockcount${N}"
    echo -e "${D}- Show masternode info      : ${C}$COIN_CLI getinfo${N}"
    echo
    echo -e "${D}${NODE_NAME^} related websites:${N}"
    if [ ! -z "$WWW_MAIN"  ]; then echo -e "${D}- Main website              : ${Y}$WWW_MAIN${N}" ; fi
    if [ ! -z "$WWW_EXPL"  ]; then echo -e "${D}- Explorer website          : ${Y}$WWW_EXPL${N}" ; fi
    if [ ! -z "$WWW_GHUB"  ]; then echo -e "${D}- Github website            : ${Y}$WWW_GHUB${N}" ; fi
    if [ ! -z "$WWW_MNO"   ]; then echo -e "${D}- Masternode Online website : ${Y}$WWW_MNO${N}"  ; fi
    if [ ! -z "$WWW_CMC"   ]; then echo -e "${D}- CoinMarkedCap website     : ${Y}$WWW_CMC${N}"  ; fi   
    if [ ! -f $DUPMN_CONFIG  ]; then
        if [ ! -z "$WWW_DUPMN"   ]; then echo -e "${D}- Dupmn website             : ${Y}$WWW_DUPMN${N}"  ; fi
    else        
        dupmn_summary
    fi
    echo
    echo -e "${D}Use ${C}$SCRIPT_NAME summary${D} to show this summary whenever needed.${N}"
    echo
}


# Display dupmn summary
function dupmn_summary() {
    echo
    echo -e "${G}INFORMATION FOR ADDITIONAL MASTERNODE INSTALLATIONS${N}"
    echo
    echo -e "${D}Commands to manage additional masternodes with dupmn:${N}"   
    echo -e "${D}- Show dupmn help           : ${C}$DUPMN_NAME help${N}" 
    echo -e "${D}- systemctl to all nodes    : ${C}$DUPMN_NAME systemctlall $COIN_NAME <command>${N}"
    echo -e "${D}- Start all masternodes     : ${C}$DUPMN_NAME systemctlall $COIN_NAME start${N}"
    echo -e "${D}- Stop all masternodes      : ${C}$DUPMN_NAME systemctlall $COIN_NAME stop${N}"
    echo -e "${D}- Status for all mn services: ${C}$DUPMN_NAME systemctlall $COIN_NAME status${N}"
    echo -e "${D}- Show all masternode status: ${C}prx-cli-all masternode status${N}"
    echo
    echo -e "${D}Dupmn related websites:${N}"
    if [ ! -z "$WWW_DUPMN"   ]; then echo -e "${D}- Dupmn website             : ${Y}$WWW_DUPMN${N}"  ; fi 
    if [ ! -z "$WWW_DUPMN1"  ]; then echo -e "${D}- Dupmn Main website        : ${Y}$WWW_DUPMN1${N}" ; fi 
    if [ ! -z "$WWW_DUPMN2"  ]; then echo -e "${D}- Dupmn wiki FAQ            : ${Y}$WWW_DUPMN2${N}" ; fi 
    if [ ! -z "$WWW_DUPMN3"  ]; then echo -e "${D}- Dupmn wiki commands       : ${Y}$WWW_DUPMN3${N}" ; fi 
}


# Replace a sting in the masternode config file
function replace() {
    echo
    echo
    echo  
    echo -e "${G}REPLACE STRING IN CONFIG${N}"
    echo
    if [[ -z "$ARG2" ]] || [[ -z "$ARG3" ]]
    then
        KEY="PrivateKey"
        KEYREV=$(echo $KEY | rev)
        echo -e "${D}Please provide both search and replace variables.${N}"
        echo
        echo -e "${D}Example:${N}" 
        echo -e "${C}$SCRIPT_NAME replace ${P}'12.34.56.78' '98.76.54.32'${N}"
        echo -e "${C}$SCRIPT_NAME replace ${P}'$KEY' '$KEYREV'${N}"
        echo
        echo
        exit 1
    else
        search=$ARG2
        replace=$ARG3

        echo -e "${D}Create backup copy of $COIN_CONFIG...${N}"
        COIN_CONFIG_DATE=$(date -r $COIN_FOLDER/$COIN_CONFIG '+%Y%m%d_%H%M%S')             # Get file date
        cp $COIN_FOLDER/$COIN_CONFIG $COIN_FOLDER/$COIN_CONFIG.$COIN_CONFIG_DATE
        echo
        echo -e "${D}Replace '${search}' by '${replace}' in $COIN_CONFIG...${N}"
        sed -i "s/${search}/${replace}/g" $COIN_FOLDER/$COIN_CONFIG
    fi
    
    showconf    
}


# Extract function
function extract() {
    FILE=$1                     # Compressed file name
    DIR=$2                      # Extraction directory
    FILE_EXT="${FILE##*.}"      # File extension
   
    case $FILE_EXT in
        zip)
            if [ "${FILE##*/}" == "$COIN_ZIP" ]; then
                DAEMON_PATH=$(unzip -l $COIN_ZIP | grep $COIN_DAEMON | awk '{ print $4 }') # Get file path for Daemon
                CLI_PATH=$(unzip -l $COIN_ZIP | grep $COIN_CLI | awk '{ print $4 }')       # Get file path for CLI
                unzip -o -j $FILE $DAEMON_PATH -d $DIR                                     # Extract Deamon file
                unzip -o -j $FILE $CLI_PATH -d $DIR                                        # Extract CLI file
                #unzip -o -j $FILE $COIN_DAEMON -d $DIR                                      # Extract Deamon file
                #unzip -o -j $FILE $COIN_CLI -d $DIR                                         # Extract CLI file
            else
                unzip $FILE -d $DIR
            fi
            ;;
        tgz)
            tar xvfz $FILE -C $DIR
            ;;
        tar.gz)
            tar xvfz $FILE -C $DIR
            ;;
        gz)
            #if [ $FILE == $COIN_ZIP ]; then        
            #    DAEMON_PATH=$(tar -tvf $COIN_ZIP | grep $COIN_DAEMON | awk '{ print $6 }')  # Get file path for Daemon
            #    CLI_PATH=$(tar -tvf $COIN_ZIP | grep $COIN_CLI | awk '{ print $6 }')        # Get file path for CLI        
            #    tar xvfz $FILE $DAEMON_PATH -O > $DIR/$COIN_DAEMON
            #    tar xvfz $FILE $DAEMON_PATH -O > $DIR/$COIN_CLI
            #else
                tar xvfz $FILE -C $DIR
            #fi
            ;;
    esac
}     


# Display donation information
function donation() {
    echo
    echo
    echo  
    echo -e "${G}DONATION${N}"
    echo
    echo -e "${D}Grateful for this work, reusing this work, or in a generous mood?${N}"     
    echo -e "${D}Feel free to send a donation to one of the below addresses.${N}"
    echo -e "${D}It will be much appreciated.${N}"
    echo
    echo -e "${Y}$DONADDR1${N}" 
    echo -e "${Y}$DONADDR2${N}" 
    echo -e "${Y}$DONADDR3${N}" 
    echo -e "${Y}$DONADDR4${N}" 
    echo
    echo -e "${G}Have a nice day!${N}"
    echo
}   


#########################################################################################################
#                                    CALL FUNCTIONS                                                     #
#########################################################################################################


# Change to script folder
cd $SCRIPT_DIR >/dev/null 2>&1 


if [[ $ARG1 == @("help"|) ]]; then
    VALIDCMD="true"
    clear_screen
    script_version
    display_logo
    display_help
fi


if [[ $ARG1 == "summary" ]]; then
    VALIDCMD="true"
    clear_screen
    display_logo 0
    installation_summary 
fi


if [[ $ARG1 == "install" ]]; then
    VALIDCMD="true"
    if [ ! -f $COIN_FOLDER/$COIN_CONFIG ]; then
        clear_screen
        display_logo
        display_disclaimer
        checks
        update_system
        install_dependencies
        install_binaries
        install_fail2ban
        create_swapfile
        create_config
        get_localip
        get_externalip
        create_privkey
        update_config
        download_addnodes
        enable_firewall
        configure_systemd
        install_bootstrap
        node_start
        node_status
        clear_screen
        display_logo
        installation_summary
    else
        clear_screen
        display_logo
        install_additional_node
    fi
fi


if [[ $ARG1 == "dupmn" ]]; then
    VALIDCMD="true"
    install_dupmn
    create_dupmn_config
    load_dupmn_profile

fi


if [[ $ARG1 == "disclaimer"       ]]; then
    VALIDCMD="true"
    clear_screen
    display_logo
    display_disclaimer noselection
fi


if [[ $ARG1 = "donation" ]] || [[ $ARG1 = "donate" ]]; then
    VALIDCMD="true"
    clear_screen
    display_logo
    donation                     
fi


if [[ $ARG1 == "start"            ]]; then VALIDCMD="true"; node_start          ; fi
if [[ $ARG1 == "stop"             ]]; then VALIDCMD="true"; node_stop           ; fi
if [[ $ARG1 == "status"           ]]; then VALIDCMD="true"; node_status         ; fi
if [[ $ARG1 == "showconf"         ]]; then VALIDCMD="true"; showconf            ; fi
if [[ $ARG1 == "bootstrap"        ]]; then VALIDCMD="true"; install_bootstrap   ; fi
if [[ $ARG1 == "createbootstrap"  ]]; then VALIDCMD="true"; create_bootstrap    ; fi
if [[ $ARG1 == "monitor"          ]]; then VALIDCMD="true"; monitor_large       ; fi
if [[ $ARG1 == "replace"          ]]; then VALIDCMD="true"; replace             ; fi
if [[ $ARG1 == "update"           ]]; then VALIDCMD="true"; update_binaries     ; fi


# Development options
if [[ $ARG1 == "check"            ]]; then VALIDCMD="true"; checks              ; fi
if [[ $ARG1 == "genkey"           ]]; then VALIDCMD="true"; create_privkey      ; fi
if [[ $ARG1 == "extract"          ]]; then VALIDCMD="true"; extract $ARG2 $ARG3 ; fi                                                                              
if [[ $ARG1 == "version"          ]]; then VALIDCMD="true"; script_version      ; fi  
if [[ $ARG1 == "clear"            ]]; then VALIDCMD="true"; clear_screen        ; fi 


# Change to originating folder
cd $CURRENT_DIR >/dev/null 2>&1


# Invalid option provided
if [[ $VALIDCMD == "false" ]]; then
    display_help noheader
    echo
    echo -e "${R}You entered an invalid option. Please try again.${N}" 
    echo
    exit 1
else
    exit 0
fi
