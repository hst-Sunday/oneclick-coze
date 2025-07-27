#!/bin/bash

# Cleanup module for Coze Studio
# 清理模块

# Remove Coze Studio function
remove_coze_studio() {
    if [[ "$SCRIPT_LANG" == "zh" ]]; then
        echo -e "${CYAN}=== 删除 Coze Studio ===${NC}"
        echo -e "${YELLOW}警告: 此操作将完全删除 Coze Studio 及其所有数据！${NC}"
        echo -e "${YELLOW}确定要继续吗? (y/N):${NC}"
    else
        echo -e "${CYAN}=== Remove Coze Studio ===${NC}"
        echo -e "${YELLOW}Warning: This will completely remove Coze Studio and all its data!${NC}"
        echo -e "${YELLOW}Are you sure you want to continue? (y/N):${NC}"
    fi
    
    read -r confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${CYAN}操作已取消${NC}"
        else
            echo -e "${CYAN}Operation cancelled${NC}"
        fi
        echo
        wait_for_user
        return
    fi
    
    # Check if Coze Studio is installed
    if ! check_coze_installation; then
        msg "coze_not_installed"
        echo
        wait_for_user
        return
    fi
    
    # Stop services first
    if [[ "$SCRIPT_LANG" == "zh" ]]; then
        echo -e "${BLUE}正在停止服务...${NC}"
    else
        echo -e "${BLUE}Stopping services...${NC}"
    fi
    
    cd "$COZE_INSTALL_DIR/docker"
    docker compose --profile "*" down
    
    # Remove Docker images
    if [[ "$SCRIPT_LANG" == "zh" ]]; then
        echo -e "${BLUE}正在清理 Docker 镜像...${NC}"
    else
        echo -e "${BLUE}Cleaning up Docker images...${NC}"
    fi
    
    docker compose --profile "*" down --rmi all --volumes --remove-orphans 2>/dev/null || true
    
    # Remove installation directory
    if [[ "$SCRIPT_LANG" == "zh" ]]; then
        echo -e "${BLUE}正在删除安装目录...${NC}"
    else
        echo -e "${BLUE}Removing installation directory...${NC}"
    fi
    
    cd ..
    rm -rf "$COZE_INSTALL_DIR"
    
    if [[ $? -eq 0 ]]; then
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${GREEN}✓ Coze Studio 删除成功${NC}"
        else
            echo -e "${GREEN}✓ Coze Studio removed successfully${NC}"
        fi
    else
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${RED}❌ 删除过程中发生错误${NC}"
        else
            echo -e "${RED}❌ Error occurred during removal${NC}"
        fi
    fi
    
    echo
    wait_for_user
}