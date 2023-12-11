#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
LIGHT_GREEN='\033[1;32m'
LIGHT_BLUE='\033[1;34m'
LIGHT_RED='\033[1;31m'
NC='\033[0m'

printf "${LIGHT_GREEN}===================================================================================================\n${NC}"
printf "${YELLOW}Hi, ${MAGENTA}[$SE_USER_NAME]${NC}${YELLOW}! Welcome to ${LIGHT_BLUE}[BITSE GPU Server]${NC}!\n"
printf "${YELLOW}System information as of ${MAGENTA}[$(date +"%Y-%m-%d %H:%M:%S")]${NC}:\n"
printf "${GREEN} - Host IP: ${CYAN}$(hostname -I | cut -d " " -f1 )${NC}\n"
printf "${GREEN} - SSH Command: ${CYAN}ssh -p $SSH_PORT root@$(hostname -I | cut -d " " -f1 )${NC}\n"
printf "${GREEN} - Operating System: ${CYAN}$(lsb_release -ds)${NC}\n"
printf "${GREEN} - Kernel Version: ${CYAN}$(uname -r)${NC}\n"
printf "${GREEN} - CUDA Version: ${CYAN}$CUDA_VERSION${NC}\n"
printf "${GREEN} - CONDA Version: ${CYAN}$(/root/miniconda3/bin/conda --version)${NC}\n\n"
printf "${YELLOW}Use \`${LIGHT_RED}conda activate torch\`${YELLOW} to activate pre-installed pytorch environments.${NC}\n"
if [ -n "$VOLUME_MNT" ]; then
    printf "\n${LIGHT_RED}NOTE: The container you are in does not permanently store all data.${NC}\n"
    printf "${YELLOW}Please place your important code and data in ${LIGHT_BLUE}$HOME/$VOLUME_MNT${NC}, ${YELLOW}as this directory will be persisted.${NC}\n"
fi
printf "${LIGHT_GREEN}===================================================================================================\n${NC}"