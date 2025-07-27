#!/bin/bash

# Service management module for Coze Studio
# 服务管理模块

# Restart Coze Studio function
restart_coze_studio() {
    if [[ "$SCRIPT_LANG" == "zh" ]]; then
        echo -e "${CYAN}=== 重启 Coze Studio ===${NC}"
    else
        echo -e "${CYAN}=== Restart Coze Studio ===${NC}"
    fi
    
    # Check if Coze Studio is installed
    if ! check_coze_installation; then
        msg "coze_not_installed"
        echo
        wait_for_user
        return
    fi
    
    cd "$COZE_INSTALL_DIR/docker"
    
    if [[ "$SCRIPT_LANG" == "zh" ]]; then
        echo -e "${BLUE}正在停止服务...${NC}"
    else
        echo -e "${BLUE}Stopping services...${NC}"
    fi
    
    docker compose --profile "*" down
    
    if [[ "$SCRIPT_LANG" == "zh" ]]; then
        echo -e "${BLUE}正在启动服务...${NC}"
    else
        echo -e "${BLUE}Starting services...${NC}"
    fi
    
    docker compose --profile "*" up -d &
    spinner $!
    wait $!
    
    if [[ $? -eq 0 ]]; then
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${GREEN}✓ 服务重启成功${NC}"
        else
            echo -e "${GREEN}✓ Services restarted successfully${NC}"
        fi
    else
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${RED}❌ 服务重启失败${NC}"
        else
            echo -e "${RED}❌ Failed to restart services${NC}"
        fi
    fi
    
    echo
    wait_for_user
}

# Stop Coze Studio function
stop_coze_studio() {
    if [[ "$SCRIPT_LANG" == "zh" ]]; then
        echo -e "${CYAN}=== 停止 Coze Studio ===${NC}"
    else
        echo -e "${CYAN}=== Stop Coze Studio ===${NC}"
    fi
    
    # Check if Coze Studio is installed
    if ! check_coze_installation; then
        msg "coze_not_installed"
        echo
        wait_for_user
        return
    fi
    
    cd "$COZE_INSTALL_DIR/docker"
    
    if [[ "$SCRIPT_LANG" == "zh" ]]; then
        echo -e "${BLUE}正在停止服务...${NC}"
    else
        echo -e "${BLUE}Stopping services...${NC}"
    fi
    
    docker compose --profile "*" down
    
    if [[ $? -eq 0 ]]; then
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${GREEN}✓ 服务停止成功${NC}"
        else
            echo -e "${GREEN}✓ Services stopped successfully${NC}"
        fi
    else
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${RED}❌ 服务停止失败${NC}"
        else
            echo -e "${RED}❌ Failed to stop services${NC}"
        fi
    fi
    
    echo
    wait_for_user
}