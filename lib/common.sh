#!/bin/bash

# Common functions and variables for Coze Studio management
# 通用函数和变量定义

# Version information
readonly SCRIPT_VERSION="1.0"
readonly SCRIPT_NAME="Coze Studio Management Tool"

# Color definitions for better UX
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Global variables
SCRIPT_LANG=""
COZE_INSTALL_DIR=""
REPO_URL="https://github.com/coze-dev/coze-studio.git"  # Default repository URL

# Check if we're running in bash
check_shell() {
    if [[ -z "$BASH_VERSION" ]]; then
        echo "Error: This script requires bash. Please run with: bash coze-studio.sh"
        exit 1
    fi
}

# Language detection
detect_language() {
    local lang="${LANG:-en_US}"
    if [[ "$lang" =~ ^zh ]]; then
        SCRIPT_LANG="zh"
    else
        SCRIPT_LANG="en"
    fi
}

# Language selection
select_language() {
    msg "lang_select"
    read -r lang_choice
    
    case "$lang_choice" in
        1)
            SCRIPT_LANG="zh"
            ;;
        2)
            SCRIPT_LANG="en"
            ;;
        *)
            # Keep detected language
            ;;
    esac
}

# Error handling
handle_error() {
    msg "error_occurred"
    msg "cleanup"
    
    # Stop any running containers
    if [[ -d "$COZE_INSTALL_DIR/docker" ]]; then
        cd "$COZE_INSTALL_DIR/docker"
        docker compose down 2>/dev/null || true
    fi
    
    exit 1
}

# Check if Coze Studio is installed
check_coze_installation() {
    # Look for common installation directories
    local possible_dirs=("./coze-studio" "../coze-studio" "$HOME/coze-studio" "/opt/coze-studio")
    
    for dir in "${possible_dirs[@]}"; do
        if [[ -d "$dir/backend/conf/model/template" ]]; then
            COZE_INSTALL_DIR="$dir"
            return 0
        fi
    done
    
    # If not found in common locations, ask user
    if [[ "$SCRIPT_LANG" == "zh" ]]; then
        echo -e "${YELLOW}请输入 Coze Studio 安装目录路径:${NC}"
    else
        echo -e "${YELLOW}Please enter Coze Studio installation directory path:${NC}"
    fi
    read -r user_dir
    
    if [[ -d "$user_dir/backend/conf/model/template" ]]; then
        COZE_INSTALL_DIR="$user_dir"
        return 0
    fi
    
    return 1
}

# Wait for user input to continue
wait_for_user() {
    if [[ "$SCRIPT_LANG" == "zh" ]]; then
        echo -e "${CYAN}按任意键返回主菜单${NC}"
    else
        echo -e "${CYAN}Press any key to return to main menu${NC}"
    fi
    read -n 1
}

# Wait for user input to continue (general)
wait_for_continue() {
    if [[ "$SCRIPT_LANG" == "zh" ]]; then
        echo -e "${CYAN}按任意键继续${NC}"
    else
        echo -e "${CYAN}Press any key to continue${NC}"
    fi
    read -n 1
}