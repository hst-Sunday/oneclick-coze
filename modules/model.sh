#!/bin/bash

# Model management module for Coze Studio
# 模型管理模块

# Add model function
add_model() {
    msg "select_template"
    echo
    
    # Check if Coze Studio is installed
    if ! check_coze_installation; then
        msg "coze_not_installed"
        echo
        wait_for_user
        return
    fi
    
    # Find template files
    local template_dir="$COZE_INSTALL_DIR/backend/conf/model/template"
    local templates=()
    local template_names=()
    
    if [[ ! -d "$template_dir" ]]; then
        msg "no_templates_found"
        echo
        wait_for_user
        return
    fi
    
    # Collect template files
    local index=1
    for template_file in "$template_dir"/model_template_*.yaml; do
        if [[ -f "$template_file" ]]; then
            templates+=("$template_file")
            # Extract model name by removing path and prefix
            local basename=$(basename "$template_file")
            local model_name=${basename#model_template_}
            model_name=${model_name%.yaml}
            template_names+=("$model_name")
            echo "$index) $model_name"
            ((index++))
        fi
    done
    
    if [[ ${#templates[@]} -eq 0 ]]; then
        msg "no_templates_found"
        echo
        wait_for_user
        return
    fi
    
    echo "0) $(if [[ "$SCRIPT_LANG" == "zh" ]]; then echo "返回主菜单"; else echo "Return to main menu"; fi)"
    echo
    msg "enter_template_choice"
    read -r choice
    
    # Validate choice
    if [[ "$choice" == "0" ]]; then
        return
    fi
    
    if [[ ! "$choice" =~ ^[0-9]+$ ]] || [[ "$choice" -lt 1 ]] || [[ "$choice" -gt ${#templates[@]} ]]; then
        echo
        msg "invalid_option"
        echo
        wait_for_continue
        return
    fi
    
    # Get selected template
    local selected_index=$((choice - 1))
    local selected_template="${templates[$selected_index]}"
    local selected_name="${template_names[$selected_index]}"
    
    # Generate target file path
    local target_file="$COZE_INSTALL_DIR/backend/conf/model/${selected_name}.yaml"
    
    # Check if target file already exists
    if [[ -f "$target_file" ]]; then
        echo
        msg "file_exists_warning"
        read -r overwrite
        if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
            return
        fi
    fi
    
    # Copy template file
    if cp "$selected_template" "$target_file"; then
        echo
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${GREEN}✓ 模板文件复制成功${NC}"
        else
            echo -e "${GREEN}✓ Template file copied successfully${NC}"
        fi
    else
        echo
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${RED}❌ 模板文件复制失败${NC}"
        else
            echo -e "${RED}❌ Failed to copy template file${NC}"
        fi
        echo
        wait_for_user
        return
    fi
    
    # Get API Key
    echo
    msg "enter_api_key_for_model"
    read -s api_key
    echo
    
    if [[ -z "$api_key" ]]; then
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${RED}错误: API Key 不能为空${NC}"
        else
            echo -e "${RED}Error: API Key cannot be empty${NC}"
        fi
        echo
        wait_for_user
        return
    fi
    
    # Get Model ID
    msg "enter_model_id_for_model"
    read -r model_id
    
    if [[ -z "$model_id" ]]; then
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${RED}错误: 模型 ID 不能为空${NC}"
        else
            echo -e "${RED}Error: Model ID cannot be empty${NC}"
        fi
        echo
        wait_for_user
        return
    fi
    
    # Update configuration file
    sed -i.bak "s|api_key: \".*\"|api_key: \"$api_key\"|g" "$target_file"
    sed -i.bak "s|model: \".*\"|model: \"$model_id\"|g" "$target_file"
    
    # Remove backup file
    rm -f "$target_file.bak"
    
    echo
    msg "model_added_success"
    if [[ "$SCRIPT_LANG" == "zh" ]]; then
        echo -e "${CYAN}模型名称: $selected_name${NC}"
        echo -e "${CYAN}配置文件: $target_file${NC}"
    else
        echo -e "${CYAN}Model name: $selected_name${NC}"
        echo -e "${CYAN}Config file: $target_file${NC}"
    fi
    
    # Restart coze-server to make the new model effective
    echo
    if [[ "$SCRIPT_LANG" == "zh" ]]; then
        echo -e "${BLUE}正在重启 coze-server 以使新模型生效...${NC}"
    else
        echo -e "${BLUE}Restarting coze-server to make new model effective...${NC}"
    fi
    
    cd "$COZE_INSTALL_DIR/docker"
    docker compose --profile "*" restart coze-server &
    spinner $!
    wait $!
    
    if [[ $? -eq 0 ]]; then
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${GREEN}✓ coze-server 重启成功，新模型已生效${NC}"
        else
            echo -e "${GREEN}✓ coze-server restarted successfully, new model is now active${NC}"
        fi
    else
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${YELLOW}⚠️  coze-server 重启失败，可能需要手动重启${NC}"
            echo -e "${CYAN}手动重启命令: docker compose --profile \"*\" restart coze-server${NC}"
        else
            echo -e "${YELLOW}⚠️  Failed to restart coze-server, manual restart may be needed${NC}"
            echo -e "${CYAN}Manual restart command: docker compose --profile \"*\" restart coze-server${NC}"
        fi
    fi
    
    echo
    wait_for_user
}