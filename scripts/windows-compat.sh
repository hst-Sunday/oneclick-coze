#!/bin/bash

# Windows Compatibility Script for Git Bash
# Windows Git Bash 兼容性脚本

# Color definitions for Git Bash
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Check if running in Git Bash on Windows
is_git_bash_windows() {
    [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]
}

# Windows-specific path conversion
convert_path() {
    local path="$1"
    if is_git_bash_windows; then
        # Convert Windows paths to Git Bash format
        echo "$path" | sed 's|\\|/|g' | sed 's|^\([A-Za-z]\):|/\L\1|'
    else
        echo "$path"
    fi
}

# Check Windows prerequisites
check_windows_prerequisites() {
    echo -e "${CYAN}检查 Windows 环境依赖...${NC}"
    
    # Check Git
    if ! command -v git &> /dev/null; then
        echo -e "${RED}错误: 未找到 Git。请从 https://git-scm.com/download/win 下载安装。${NC}"
        return 1
    fi
    echo -e "${GREEN}✓ Git 已安装${NC}"
    
    # Check Docker Desktop
    if ! command -v docker &> /dev/null; then
        echo -e "${RED}错误: 未找到 Docker。请安装 Docker Desktop for Windows。${NC}"
        echo -e "${YELLOW}下载地址: https://docs.docker.com/desktop/windows/install/${NC}"
        return 1
    fi
    echo -e "${GREEN}✓ Docker 已安装${NC}"
    
    # Check if Docker is running
    if ! docker info &> /dev/null 2>&1; then
        echo -e "${RED}错误: Docker 未运行。请启动 Docker Desktop。${NC}"
        return 1
    fi
    echo -e "${GREEN}✓ Docker 正在运行${NC}"
    
    # Check Docker Compose
    if ! docker compose version &> /dev/null 2>&1; then
        echo -e "${RED}错误: Docker Compose 不可用。请确保 Docker Desktop 已正确安装。${NC}"
        return 1
    fi
    echo -e "${GREEN}✓ Docker Compose 可用${NC}"
    
    return 0
}

# Windows-compatible sudo simulation
windows_sudo() {
    if is_git_bash_windows; then
        echo -e "${YELLOW}注意: Windows 环境下需要管理员权限，请确保以管理员身份运行 Git Bash。${NC}"
        # Execute command without sudo
        "$@"
    else
        sudo "$@"
    fi
}

# Windows-compatible Docker operations
docker_compose_up() {
    local profile="$1"
    if is_git_bash_windows; then
        # Use Docker Compose V2 syntax for Windows
        docker compose --profile "$profile" up -d
    else
        docker-compose --profile "$profile" up -d
    fi
}

docker_compose_down() {
    if is_git_bash_windows; then
        docker compose down
    else
        docker-compose down
    fi
}

docker_compose_restart() {
    local service="$1"
    if is_git_bash_windows; then
        docker compose restart "$service"
    else
        docker-compose restart "$service"
    fi
}

# Windows-compatible file operations
safe_cp() {
    local src="$1"
    local dest="$2"
    
    if is_git_bash_windows; then
        # Use cp with explicit path conversion
        src=$(convert_path "$src")
        dest=$(convert_path "$dest")
    fi
    
    cp "$src" "$dest"
}

safe_rm() {
    local file="$1"
    
    if is_git_bash_windows; then
        file=$(convert_path "$file")
    fi
    
    rm -f "$file"
}

# Windows-compatible directory operations
safe_mkdir() {
    local dir="$1"
    
    if is_git_bash_windows; then
        dir=$(convert_path "$dir")
    fi
    
    mkdir -p "$dir"
}

# Windows-compatible permission fix
fix_permissions() {
    local path="$1"
    
    if is_git_bash_windows; then
        # Windows doesn't need chmod, but we can try
        echo -e "${YELLOW}注意: Windows 环境下跳过权限设置${NC}"
    else
        chmod +x "$path"
    fi
}

# Windows environment detection and warning
show_windows_warning() {
    if is_git_bash_windows; then
        echo -e "${YELLOW}================================${NC}"
        echo -e "${YELLOW}检测到 Windows Git Bash 环境${NC}"
        echo -e "${YELLOW}================================${NC}"
        echo -e "${CYAN}注意事项:${NC}"
        echo -e "1. 确保 Docker Desktop 正在运行"
        echo -e "2. 建议以管理员身份运行 Git Bash"
        echo -e "3. 部分 Linux 特定功能可能不可用"
        echo -e "4. 推荐使用 WSL2 获得更好的兼容性"
        echo
        echo -e "${CYAN}按任意键继续，或 Ctrl+C 取消...${NC}"
        read -n 1
        echo
    fi
}

# Docker Desktop integration check
check_docker_desktop() {
    if is_git_bash_windows; then
        echo -e "${CYAN}检查 Docker Desktop 集成...${NC}"
        
        # Check if Docker Desktop is accessible
        if docker version | grep -q "Docker Desktop"; then
            echo -e "${GREEN}✓ Docker Desktop 集成正常${NC}"
        else
            echo -e "${YELLOW}⚠️  检测到 Docker，但可能不是 Docker Desktop${NC}"
            echo -e "${CYAN}建议使用 Docker Desktop for Windows 获得最佳体验${NC}"
        fi
    fi
}

# Windows-specific cleanup
windows_cleanup() {
    if is_git_bash_windows; then
        echo -e "${CYAN}执行 Windows 特定清理...${NC}"
        # Add any Windows-specific cleanup tasks here
    fi
}

# Export functions for use in main script
export -f is_git_bash_windows
export -f convert_path
export -f check_windows_prerequisites
export -f windows_sudo
export -f docker_compose_up
export -f docker_compose_down
export -f docker_compose_restart
export -f safe_cp
export -f safe_rm
export -f safe_mkdir
export -f fix_permissions
export -f show_windows_warning
export -f check_docker_desktop
export -f windows_cleanup