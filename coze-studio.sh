#!/bin/bash

# Coze Studio Management Tool - Main Entry Script
# Coze Studio 管理工具 - 主入口脚本
# Author: Claude
# Version: 1.0

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load all required modules
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/messages.sh"
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/lib/ui.sh"
source "$SCRIPT_DIR/modules/install.sh"
source "$SCRIPT_DIR/modules/model.sh"
source "$SCRIPT_DIR/modules/service.sh"
source "$SCRIPT_DIR/modules/cleanup.sh"
source "$SCRIPT_DIR/modules/domain.sh"

# Main function
main() {
    # Check shell compatibility first
    check_shell
    
    # Detect language
    detect_language
    
    # Show welcome message
    msg "welcome"
    echo
    
    # Language selection
    select_language
    echo
    
    # Show main menu
    show_main_menu
}

# Run main function
main "$@"