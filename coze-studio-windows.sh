#!/bin/bash

# Coze Studio Management Tool - Windows Git Bash Entry Script
# Coze Studio 管理工具 - Windows Git Bash 入口脚本

set -e

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load Windows compatibility layer
if [[ -f "$SCRIPT_DIR/scripts/windows-compat.sh" ]]; then
    source "$SCRIPT_DIR/scripts/windows-compat.sh"
    show_windows_warning
    check_docker_desktop
else
    echo "Warning: Windows compatibility script not found. Some features may not work correctly."
fi

# Override system-specific functions if running on Windows
if is_git_bash_windows 2>/dev/null; then
    # Override check_prerequisites to use Windows version
    check_prerequisites() {
        check_windows_prerequisites
    }
    
    # Override Docker operations
    export DOCKER_COMPOSE_CMD="docker compose"
    
    # Disable sudo for Windows
    alias sudo=''
    
    echo -e "${GREEN}Windows 兼容模式已启用${NC}"
    echo
fi

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

# Windows-specific main function
main() {
    # Check shell compatibility first
    check_shell
    
    # Load configuration
    load_config
    
    # Windows-specific initialization
    if is_git_bash_windows 2>/dev/null; then
        echo -e "${CYAN}初始化 Windows 环境...${NC}"
        
        # Check Windows prerequisites
        if ! check_windows_prerequisites; then
            echo -e "${RED}环境检查失败，请解决上述问题后重试。${NC}"
            exit 1
        fi
        echo
    fi
    
    # Detect language
    detect_language
    
    # Show welcome message
    msg "welcome"
    echo
    
    # Show Windows-specific message
    if is_git_bash_windows 2>/dev/null; then
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${PURPLE}=== Windows Git Bash 模式 ===${NC}"
            echo -e "${YELLOW}提示: 如需完整功能支持，建议使用 WSL2${NC}"
        else
            echo -e "${PURPLE}=== Windows Git Bash Mode ===${NC}"
            echo -e "${YELLOW}Tip: For full functionality, consider using WSL2${NC}"
        fi
        echo
    fi
    
    # Start main menu
    show_main_menu
}

# Error handling for Windows
handle_error() {
    echo
    if [[ "$SCRIPT_LANG" == "zh" ]]; then
        echo -e "${RED}❌ 安装过程中发生错误${NC}"
        if is_git_bash_windows 2>/dev/null; then
            echo -e "${YELLOW}Windows 环境提示:${NC}"
            echo -e "1. 确保 Docker Desktop 正在运行"
            echo -e "2. 检查是否以管理员身份运行"
            echo -e "3. 考虑使用 WSL2 获得更好的兼容性"
        fi
    else
        echo -e "${RED}❌ An error occurred during installation${NC}"
        if is_git_bash_windows 2>/dev/null; then
            echo -e "${YELLOW}Windows Environment Tips:${NC}"
            echo -e "1. Ensure Docker Desktop is running"
            echo -e "2. Check if running as administrator"
            echo -e "3. Consider using WSL2 for better compatibility"
        fi
    fi
    
    echo -e "${CYAN}正在清理...${NC}"
    
    # Windows-specific cleanup
    if is_git_bash_windows 2>/dev/null; then
        windows_cleanup
    fi
    
    # Stop any running containers
    if [[ -d "$COZE_INSTALL_DIR/docker" ]] || [[ -d "$install_dir/docker" ]]; then
        local docker_dir="${COZE_INSTALL_DIR:-$install_dir}/docker"
        cd "$docker_dir"
        docker compose down 2>/dev/null || true
    fi
    
    exit 1
}

# Set up error handling
trap handle_error ERR

# Run main function
main "$@"