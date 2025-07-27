#!/bin/bash

# Installation module for Coze Studio
# Coze Studio 安装模块

# Configure model during installation
configure_model() {
    msg "select_template"
    echo
    
    # Determine which directory variable to use (install_dir during installation, COZE_INSTALL_DIR after)
    local working_dir
    if [[ -n "$install_dir" ]]; then
        working_dir="$install_dir"
    else
        working_dir="$COZE_INSTALL_DIR"
    fi
    
    # Check if Coze Studio installation directory exists
    if [[ ! -d "$working_dir" ]]; then
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${RED}错误: Coze Studio 安装目录不存在${NC}"
        else
            echo -e "${RED}Error: Coze Studio installation directory not found${NC}"
        fi
        return 1
    fi
    
    cd "$working_dir"
    
    # Find template files
    local template_dir="$working_dir/backend/conf/model/template"
    local templates=()
    local template_names=()
    
    if [[ ! -d "$template_dir" ]]; then
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${RED}错误: 找不到模型模板目录${NC}"
        else
            echo -e "${RED}Error: Model template directory not found${NC}"
        fi
        return 1
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
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${RED}错误: 找不到可用的模型模板${NC}"
        else
            echo -e "${RED}Error: No available model templates found${NC}"
        fi
        return 1
    fi
    
    echo
    msg "enter_template_choice"
    read -r choice
    
    # Validate choice
    if [[ ! "$choice" =~ ^[0-9]+$ ]] || [[ "$choice" -lt 1 ]] || [[ "$choice" -gt ${#templates[@]} ]]; then
        echo
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${RED}错误: 无效的选择${NC}"
        else
            echo -e "${RED}Error: Invalid choice${NC}"
        fi
        return 1
    fi
    
    # Get selected template
    local selected_index=$((choice - 1))
    local selected_template="${templates[$selected_index]}"
    local selected_name="${template_names[$selected_index]}"
    
    # Generate target file path
    local target_file="$working_dir/backend/conf/model/${selected_name}.yaml"
    
    # Check if target file already exists
    if [[ -f "$target_file" ]]; then
        echo
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${YELLOW}警告: 配置文件已存在，是否覆盖? (y/N):${NC}"
        else
            echo -e "${YELLOW}Warning: Config file already exists, overwrite? (y/N):${NC}"
        fi
        read -r overwrite
        if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
            return 1
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
        return 1
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
        return 1
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
        return 1
    fi
    
    # Update configuration file
    sed -i.bak "s|api_key: \".*\"|api_key: \"$api_key\"|g" "$target_file"
    sed -i.bak "s|model: \".*\"|model: \"$model_id\"|g" "$target_file"
    
    # Remove backup file
    rm -f "$target_file.bak"
    
    echo
    msg "config_success"
    if [[ "$SCRIPT_LANG" == "zh" ]]; then
        echo -e "${CYAN}模型名称: $selected_name${NC}"
        echo -e "${CYAN}配置文件: $target_file${NC}"
    else
        echo -e "${CYAN}Model name: $selected_name${NC}"
        echo -e "${CYAN}Config file: $target_file${NC}"
    fi
}

# Install Coze Studio function (main installation logic)
install_coze_studio() {
    # Installation steps with manual error handling
    check_prerequisites || handle_error
    echo
    
    get_install_dir || handle_error
    echo
    
    select_network_environment || handle_error
    echo
    
    clone_repository || handle_error
    echo
    
    configure_model || handle_error
    echo
    
    setup_docker || handle_error
    echo
    
    start_services || handle_error
    echo
    
    verify_installation || handle_error
    echo
    
    msg "installation_complete"
    echo
    
    wait_for_user
}