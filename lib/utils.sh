#!/bin/bash

# Utility functions for Coze Studio management
# 工具函数集合

# Progress spinner
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Check prerequisites
check_prerequisites() {
    msg "checking_prereqs"
    
    # Check Git
    if ! command -v git &> /dev/null; then
        msg "git_missing"
        exit 1
    fi
    
    # Check Docker
    if ! command -v docker &> /dev/null; then
        msg "docker_missing"
        exit 1
    fi
    
    # Check Docker Compose
    if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
        msg "docker_compose_missing"
        exit 1
    fi
    
    # Check if Docker is running
    if ! docker info &> /dev/null; then
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${RED}错误: Docker 未运行。请启动 Docker 后重试。${NC}"
        else
            echo -e "${RED}Error: Docker is not running. Please start Docker and try again.${NC}"
        fi
        exit 1
    fi
    
    msg "prereqs_ok"
}

# Get installation directory
get_install_dir() {
    msg "install_dir"
    read -r install_dir
    if [[ -z "$install_dir" ]]; then
        install_dir="./coze-studio"
    fi
    
    # Convert to absolute path
    install_dir=$(realpath "$install_dir" 2>/dev/null || echo "$install_dir")
    
    if [[ -d "$install_dir" ]]; then
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${YELLOW}警告: 目录 '$install_dir' 已存在。继续将覆盖现有内容。${NC}"
            echo -e "${YELLOW}是否继续? (y/N):${NC}"
        else
            echo -e "${YELLOW}Warning: Directory '$install_dir' already exists. Continuing will overwrite existing content.${NC}"
            echo -e "${YELLOW}Do you want to continue? (y/N):${NC}"
        fi
        read -r confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            exit 0
        fi
    fi
}

# Backup Docker configuration
backup_docker_config() {
    if [[ -f /etc/docker/daemon.json ]]; then
        msg "backing_up_docker"
        if sudo cp /etc/docker/daemon.json /etc/docker/daemon.json.backup; then
            msg "docker_backup_success"
            return 0
        else
            msg "docker_config_failed"
            return 1
        fi
    fi
    return 0  # No backup needed if file doesn't exist
}

# Configure Docker registry mirrors for China
configure_docker_mirrors() {
    msg "sudo_required"
    msg "configuring_docker"
    
    # Create docker directory if it doesn't exist
    sudo mkdir -p /etc/docker
    
    # Create daemon.json with registry mirrors
    if sudo tee /etc/docker/daemon.json > /dev/null <<EOF
{
  "registry-mirrors": [
    "https://docker.1panel.live",
    "https://docker.1ms.run",
    "https://dytt.online",
    "https://docker-0.unsee.tech",
    "https://lispy.org",
    "https://docker.xiaogenban1993.com",
    "https://666860.xyz",
    "https://hub.rat.dev",
    "https://docker.m.daocloud.io",
    "https://demo.52013120.xyz",
    "https://proxy.vvvv.ee",
    "https://registry.cyou"
  ]
}
EOF
    then
        msg "docker_config_success"
        return 0
    else
        msg "docker_config_failed"
        return 1
    fi
}

# Restore Docker default configuration
restore_docker_config() {
    msg "restoring_docker"
    
    if [[ -f /etc/docker/daemon.json.backup ]]; then
        # Restore from backup
        if sudo cp /etc/docker/daemon.json.backup /etc/docker/daemon.json; then
            sudo rm -f /etc/docker/daemon.json.backup
            msg "docker_restore_success"
            return 0
        else
            msg "docker_config_failed"
            return 1
        fi
    else
        # No backup exists, remove daemon.json to use Docker defaults
        if sudo rm -f /etc/docker/daemon.json; then
            msg "docker_restore_success"
            return 0
        else
            msg "docker_config_failed"
            return 1
        fi
    fi
}

# Restart Docker service
restart_docker_service() {
    msg "restarting_docker"
    
    # Reload daemon and restart docker
    if sudo systemctl daemon-reload && sudo systemctl restart docker; then
        msg "docker_restart_success"
        return 0
    else
        msg "docker_config_failed"
        return 1
    fi
}

# Select network environment
select_network_environment() {
    msg "select_network_env"
    read -r network_choice
    
    case "$network_choice" in
        1)
            # Domestic environment - use mirror and configure Docker
            REPO_URL="${GITHUB_MIRROR_URL}/${COZE_REPO_URL}"
            msg "network_env_selected" "domestic"
            echo
            
            # Configure Docker mirrors for domestic use
            if backup_docker_config && configure_docker_mirrors && restart_docker_service; then
                if [[ "$SCRIPT_LANG" == "zh" ]]; then
                    echo -e "${GREEN}✓ 网络环境配置完成${NC}"
                else
                    echo -e "${GREEN}✓ Network environment configuration completed${NC}"
                fi
            else
                if [[ "$SCRIPT_LANG" == "zh" ]]; then
                    echo -e "${YELLOW}⚠️  Docker 镜像源配置失败，但不影响安装继续${NC}"
                else
                    echo -e "${YELLOW}⚠️  Docker mirror configuration failed, but installation can continue${NC}"
                fi
            fi
            ;;
        2)
            # International environment - use original URLs and restore Docker defaults
            REPO_URL="$COZE_REPO_URL"
            msg "network_env_selected" "international"
            echo
            
            # Restore Docker default configuration for international use
            if restore_docker_config && restart_docker_service; then
                if [[ "$SCRIPT_LANG" == "zh" ]]; then
                    echo -e "${GREEN}✓ 网络环境配置完成${NC}"
                else
                    echo -e "${GREEN}✓ Network environment configuration completed${NC}"
                fi
            else
                if [[ "$SCRIPT_LANG" == "zh" ]]; then
                    echo -e "${YELLOW}⚠️  Docker 配置恢复失败，但不影响安装继续${NC}"
                else
                    echo -e "${YELLOW}⚠️  Docker configuration restore failed, but installation can continue${NC}"
                fi
            fi
            ;;
        *)
            echo
            msg "invalid_network_option"
            echo
            wait_for_continue
            select_network_environment  # Recursively ask again
            return
            ;;
    esac
}

# Clone repository
clone_repository() {
    msg "cloning"
    
    # Remove existing directory if it exists
    if [[ -d "$install_dir" ]]; then
        rm -rf "$install_dir"
    fi
    
    # Clone with progress using the selected repository URL
    git clone "$REPO_URL" "$install_dir" &
    spinner $!
    wait $!
    local clone_status=$?
    
    if [[ $clone_status -eq 0 ]]; then
        msg "clone_success"
    else
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${RED}❌ 克隆失败${NC}"
        else
            echo -e "${RED}❌ Clone failed${NC}"
        fi
        handle_error
    fi
}

# Setup Docker environment
setup_docker() {
    msg "docker_setup"
    
    cd "$install_dir/docker"
    
    # Copy environment file
    cp .env.example .env
    
    if [[ "$SCRIPT_LANG" == "zh" ]]; then
        echo -e "${GREEN}✓ Docker 环境配置完成${NC}"
    else
        echo -e "${GREEN}✓ Docker environment configured${NC}"
    fi
}

# Start services
start_services() {
    msg "starting_services"
    
    cd "$install_dir/docker"
    
    # Start services with all profiles
    docker compose --profile "*" up -d &
    spinner $!
    wait $!
    local docker_status=$?
    
    if [[ $docker_status -eq 0 ]]; then
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${GREEN}✓ 服务启动成功${NC}"
        else
            echo -e "${GREEN}✓ Services started successfully${NC}"
        fi
    else
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${RED}❌ 服务启动失败${NC}"
        else
            echo -e "${RED}❌ Failed to start services${NC}"
        fi
        handle_error
    fi
}

# Verify installation
verify_installation() {
    if [[ "$SCRIPT_LANG" == "zh" ]]; then
        echo -e "${BLUE}验证安装...${NC}"
    else
        echo -e "${BLUE}Verifying installation...${NC}"
    fi
    
    sleep 10  # Wait for services to start
    
    # Check if services are running
    cd "$install_dir/docker"
    local running_services=$(docker compose ps --services --filter "status=running" | wc -l)
    local total_services=$(docker compose config --services | wc -l)
    
    if [[ "$running_services" -gt 0 ]]; then
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${GREEN}✓ 验证完成 ($running_services/$total_services 个服务运行中)${NC}"
        else
            echo -e "${GREEN}✓ Verification completed ($running_services/$total_services services running)${NC}"
        fi
    else
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${YELLOW}⚠️  某些服务可能需要更多时间启动${NC}"
        else
            echo -e "${YELLOW}⚠️  Some services may need more time to start${NC}"
        fi
    fi
}