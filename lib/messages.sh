#!/bin/bash

# Multilingual message system for Coze Studio management
# 多语言消息系统

# Multilingual message function
msg() {
    local key="$1"
    case "$key" in
        "welcome")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${PURPLE}=== Coze Studio 一键安装脚本 ===${NC}"
                echo -e "${CYAN}欢迎使用 Coze Studio 自动安装程序！${NC}"
            else
                echo -e "${PURPLE}=== Coze Studio One-Click Installation ===${NC}"
                echo -e "${CYAN}Welcome to Coze Studio automatic installer!${NC}"
            fi
            ;;
        "lang_select")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${YELLOW}请选择语言 / Please select language:${NC}"
                echo "1) 中文"
                echo "2) English"
            else
                echo -e "${YELLOW}Please select language / 请选择语言:${NC}"
                echo "1) 中文"
                echo "2) English"
            fi
            ;;
        "main_menu")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${CYAN}=== Coze Studio 管理工具 ===${NC}"
                echo -e "${YELLOW}请选择操作:${NC}"
                echo "1) 安装 Coze Studio"
                echo "2) 添加模型"
                echo "3) 重启 Coze Studio"
                echo "4) 停止 Coze Studio"
                echo "5) 删除 Coze Studio"
                echo "6) 配置域名 (仅Ubuntu/Debian)"
                echo "0) 退出"
                echo
                echo -e "${YELLOW}请输入选项 [0-6]:${NC}"
            else
                echo -e "${CYAN}=== Coze Studio Management Tool ===${NC}"
                echo -e "${YELLOW}Please select an operation:${NC}"
                echo "1) Install Coze Studio"
                echo "2) Add Model"
                echo "3) Restart Coze Studio"
                echo "4) Stop Coze Studio"
                echo "5) Remove Coze Studio"
                echo "6) Configure Domain (Ubuntu/Debian only)"
                echo "0) Exit"
                echo
                echo -e "${YELLOW}Enter option [0-6]:${NC}"
            fi
            ;;
        "checking_prereqs")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${BLUE}正在检查系统依赖...${NC}"
            else
                echo -e "${BLUE}Checking system prerequisites...${NC}"
            fi
            ;;
        "git_missing")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${RED}错误: 未找到 Git。请先安装 Git:${NC}"
                echo "macOS: brew install git"
                echo "Ubuntu/Debian: sudo apt-get install git"
                echo "CentOS/RHEL: sudo yum install git"
            else
                echo -e "${RED}Error: Git not found. Please install Git first:${NC}"
                echo "macOS: brew install git"
                echo "Ubuntu/Debian: sudo apt-get install git"
                echo "CentOS/RHEL: sudo yum install git"
            fi
            ;;
        "docker_missing")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${RED}错误: 未找到 Docker。请先安装 Docker:${NC}"
                echo "请访问 https://docs.docker.com/get-docker/ 获取安装说明"
            else
                echo -e "${RED}Error: Docker not found. Please install Docker first:${NC}"
                echo "Visit https://docs.docker.com/get-docker/ for installation instructions"
            fi
            ;;
        "docker_compose_missing")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${RED}错误: 未找到 Docker Compose。请先安装 Docker Compose:${NC}"
                echo "请访问 https://docs.docker.com/compose/install/ 获取安装说明"
            else
                echo -e "${RED}Error: Docker Compose not found. Please install Docker Compose first:${NC}"
                echo "Visit https://docs.docker.com/compose/install/ for installation instructions"
            fi
            ;;
        "prereqs_ok")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${GREEN}✓ 系统依赖检查通过${NC}"
            else
                echo -e "${GREEN}✓ Prerequisites check passed${NC}"
            fi
            ;;
        "install_dir")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${YELLOW}请输入安装目录 (默认: ./coze-studio):${NC}"
            else
                echo -e "${YELLOW}Enter installation directory (default: ./coze-studio):${NC}"
            fi
            ;;
        "cloning")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${BLUE}正在克隆 Coze Studio 仓库...${NC}"
            else
                echo -e "${BLUE}Cloning Coze Studio repository...${NC}"
            fi
            ;;
        "clone_success")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${GREEN}✓ 代码克隆完成${NC}"
            else
                echo -e "${GREEN}✓ Repository cloned successfully${NC}"
            fi
            ;;
        "model_config")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${BLUE}配置模型设置...${NC}"
            else
                echo -e "${BLUE}Configuring model settings...${NC}"
            fi
            ;;
        "api_key")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${YELLOW}请输入您的 API Key:${NC}"
            else
                echo -e "${YELLOW}Please enter your API Key:${NC}"
            fi
            ;;
        "model_id")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${YELLOW}请输入模型 ID (默认: doubao-seed-1.6):${NC}"
            else
                echo -e "${YELLOW}Please enter Model ID (default: doubao-seed-1.6):${NC}"
            fi
            ;;
        "config_success")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${GREEN}✓ 模型配置完成${NC}"
            else
                echo -e "${GREEN}✓ Model configuration completed${NC}"
            fi
            ;;
        "docker_setup")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${BLUE}设置 Docker 环境...${NC}"
            else
                echo -e "${BLUE}Setting up Docker environment...${NC}"
            fi
            ;;
        "starting_services")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${BLUE}启动服务 (这可能需要几分钟)...${NC}"
            else
                echo -e "${BLUE}Starting services (this may take a few minutes)...${NC}"
            fi
            ;;
        "installation_complete")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${GREEN}🎉 安装完成！${NC}"
                echo -e "${CYAN}Coze Studio 已成功安装并启动！${NC}"
                echo ""
                echo -e "${YELLOW}访问信息:${NC}"
                echo "- Web UI: http://localhost:8888"
                echo ""
                echo -e "${YELLOW}管理命令:${NC}"
                echo "- 停止服务: docker compose --profile \"*\" down"
                echo "- 重启服务: docker compose --profile \"*\" up -d"
                echo "- 查看日志: docker compose --profile \"*\" logs -f"
            else
                echo -e "${GREEN}🎉 Installation completed!${NC}"
                echo -e "${CYAN}Coze Studio has been successfully installed and started!${NC}"
                echo ""
                echo -e "${YELLOW}Access Information:${NC}"
                echo "- Web UI: http://localhost:8888"
                echo ""
                echo -e "${YELLOW}Management Commands:${NC}"
                echo "- Stop services: docker compose --profile \"*\" down"
                echo "- Restart services: docker compose --profile \"*\" up -d"
                echo "- View logs: docker compose --profile \"*\" logs -f"
            fi
            ;;
        "error_occurred")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${RED}❌ 安装过程中发生错误${NC}"
            else
                echo -e "${RED}❌ An error occurred during installation${NC}"
            fi
            ;;
        "cleanup")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${YELLOW}正在清理...${NC}"
            else
                echo -e "${YELLOW}Cleaning up...${NC}"
            fi
            ;;
        "invalid_option")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${RED}无效选项，请输入 0-6${NC}"
            else
                echo -e "${RED}Invalid option, please enter 0-6${NC}"
            fi
            ;;
        "feature_not_implemented")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${YELLOW}该功能正在开发中...${NC}"
                echo -e "${CYAN}按任意键返回主菜单${NC}"
            else
                echo -e "${YELLOW}This feature is under development...${NC}"
                echo -e "${CYAN}Press any key to return to main menu${NC}"
            fi
            ;;
        "goodbye")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${GREEN}感谢使用 Coze Studio 管理工具！${NC}"
            else
                echo -e "${GREEN}Thank you for using Coze Studio Management Tool!${NC}"
            fi
            ;;
        "coze_not_installed")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${RED}错误: 未找到 Coze Studio 安装${NC}"
                echo -e "${YELLOW}请先使用选项 1 安装 Coze Studio${NC}"
            else
                echo -e "${RED}Error: Coze Studio installation not found${NC}"
                echo -e "${YELLOW}Please install Coze Studio first using option 1${NC}"
            fi
            ;;
        "no_templates_found")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${YELLOW}未找到模型模板文件${NC}"
                echo -e "${YELLOW}请检查 template 目录是否存在${NC}"
            else
                echo -e "${YELLOW}No model templates found${NC}"
                echo -e "${YELLOW}Please check if template directory exists${NC}"
            fi
            ;;
        "select_template")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${CYAN}=== 添加模型 ===${NC}"
                echo -e "${YELLOW}可用的模型模板:${NC}"
            else
                echo -e "${CYAN}=== Add Model ===${NC}"
                echo -e "${YELLOW}Available model templates:${NC}"
            fi
            ;;
        "enter_template_choice")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${YELLOW}请选择模板编号 (0 返回主菜单):${NC}"
            else
                echo -e "${YELLOW}Select template number (0 to return to main menu):${NC}"
            fi
            ;;
        "file_exists_warning")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${YELLOW}警告: 配置文件已存在，是否覆盖? (y/N):${NC}"
            else
                echo -e "${YELLOW}Warning: Configuration file already exists, overwrite? (y/N):${NC}"
            fi
            ;;
        "model_added_success")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${GREEN}✓ 模型添加成功！${NC}"
            else
                echo -e "${GREEN}✓ Model added successfully!${NC}"
            fi
            ;;
        "enter_api_key_for_model")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${YELLOW}请输入该模型的 API Key:${NC}"
            else
                echo -e "${YELLOW}Please enter API Key for this model:${NC}"
            fi
            ;;
        "enter_model_id_for_model")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${YELLOW}请输入模型 ID:${NC}"
            else
                echo -e "${YELLOW}Please enter Model ID:${NC}"
            fi
            ;;
        "system_not_supported")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${RED}错误: 此功能仅支持 Ubuntu 和 Debian 系统${NC}"
                echo -e "${YELLOW}当前系统: $1${NC}"
            else
                echo -e "${RED}Error: This feature only supports Ubuntu and Debian systems${NC}"
                echo -e "${YELLOW}Current system: $1${NC}"
            fi
            ;;
        "configure_domain")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${CYAN}=== 配置域名 ===${NC}"
            else
                echo -e "${CYAN}=== Configure Domain ===${NC}"
            fi
            ;;
        "installing_nginx")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${BLUE}正在安装 Nginx...${NC}"
            else
                echo -e "${BLUE}Installing Nginx...${NC}"
            fi
            ;;
        "nginx_install_success")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${GREEN}✓ Nginx 安装成功${NC}"
            else
                echo -e "${GREEN}✓ Nginx installed successfully${NC}"
            fi
            ;;
        "installing_acme")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${BLUE}正在安装 acme.sh...${NC}"
            else
                echo -e "${BLUE}Installing acme.sh...${NC}"
            fi
            ;;
        "enter_email")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${YELLOW}请输入您的邮箱地址 (用于 SSL 证书注册):${NC}"
            else
                echo -e "${YELLOW}Please enter your email address (for SSL certificate registration):${NC}"
            fi
            ;;
        "enter_domain")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${YELLOW}请输入您的域名 (例如: example.com):${NC}"
            else
                echo -e "${YELLOW}Please enter your domain name (e.g.: example.com):${NC}"
            fi
            ;;
        "generating_ssl")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${BLUE}正在申请 SSL 证书...${NC}"
            else
                echo -e "${BLUE}Generating SSL certificate...${NC}"
            fi
            ;;
        "ssl_success")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${GREEN}✓ SSL 证书申请成功${NC}"
            else
                echo -e "${GREEN}✓ SSL certificate generated successfully${NC}"
            fi
            ;;
        "configuring_nginx")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${BLUE}正在配置 Nginx...${NC}"
            else
                echo -e "${BLUE}Configuring Nginx...${NC}"
            fi
            ;;
        "domain_setup_complete")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${GREEN}🎉 域名配置完成！${NC}"
                echo -e "${CYAN}您现在可以通过 HTTPS 访问 Coze Studio:${NC}"
            else
                echo -e "${GREEN}🎉 Domain configuration completed!${NC}"
                echo -e "${CYAN}You can now access Coze Studio via HTTPS:${NC}"
            fi
            ;;
        "select_network_env")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${CYAN}=== 选择网络环境 ===${NC}"
                echo -e "${YELLOW}请选择您的网络环境:${NC}"
                echo "1) 国内 (使用 GitHub 加速镜像)"
                echo "2) 国外 (直接访问 GitHub)"
                echo
                echo -e "${YELLOW}请输入选项 [1-2]:${NC}"
            else
                echo -e "${CYAN}=== Select Network Environment ===${NC}"
                echo -e "${YELLOW}Please select your network environment:${NC}"
                echo "1) China (Use GitHub acceleration mirror)"
                echo "2) International (Direct GitHub access)"
                echo
                echo -e "${YELLOW}Enter option [1-2]:${NC}"
            fi
            ;;
        "network_env_selected")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                case "$1" in
                    "domestic")
                        echo -e "${GREEN}✓ 已选择国内网络环境，将使用 GitHub 加速镜像${NC}"
                        ;;
                    "international")
                        echo -e "${GREEN}✓ 已选择国外网络环境，将直接访问 GitHub${NC}"
                        ;;
                esac
            else
                case "$1" in
                    "domestic")
                        echo -e "${GREEN}✓ Selected China network environment, using GitHub acceleration mirror${NC}"
                        ;;
                    "international")
                        echo -e "${GREEN}✓ Selected International network environment, direct GitHub access${NC}"
                        ;;
                esac
            fi
            ;;
        "invalid_network_option")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${RED}无效选项，请输入 1 或 2${NC}"
            else
                echo -e "${RED}Invalid option, please enter 1 or 2${NC}"
            fi
            ;;
        "configuring_docker")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${BLUE}正在配置 Docker 镜像源...${NC}"
            else
                echo -e "${BLUE}Configuring Docker registry mirrors...${NC}"
            fi
            ;;
        "docker_config_success")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${GREEN}✓ Docker 镜像源配置成功${NC}"
            else
                echo -e "${GREEN}✓ Docker registry mirrors configured successfully${NC}"
            fi
            ;;
        "restoring_docker")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${BLUE}正在恢复 Docker 默认配置...${NC}"
            else
                echo -e "${BLUE}Restoring Docker default configuration...${NC}"
            fi
            ;;
        "docker_restore_success")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${GREEN}✓ Docker 默认配置恢复成功${NC}"
            else
                echo -e "${GREEN}✓ Docker default configuration restored successfully${NC}"
            fi
            ;;
        "backing_up_docker")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${BLUE}正在备份 Docker 配置...${NC}"
            else
                echo -e "${BLUE}Backing up Docker configuration...${NC}"
            fi
            ;;
        "docker_backup_success")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${GREEN}✓ Docker 配置备份成功${NC}"
            else
                echo -e "${GREEN}✓ Docker configuration backed up successfully${NC}"
            fi
            ;;
        "restarting_docker")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${BLUE}正在重启 Docker 服务...${NC}"
            else
                echo -e "${BLUE}Restarting Docker service...${NC}"
            fi
            ;;
        "docker_restart_success")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${GREEN}✓ Docker 服务重启成功${NC}"
            else
                echo -e "${GREEN}✓ Docker service restarted successfully${NC}"
            fi
            ;;
        "docker_config_failed")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${RED}❌ Docker 配置失败${NC}"
            else
                echo -e "${RED}❌ Docker configuration failed${NC}"
            fi
            ;;
        "sudo_required")
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${YELLOW}此操作需要管理员权限，将提示输入密码${NC}"
            else
                echo -e "${YELLOW}This operation requires administrator privileges, you will be prompted for password${NC}"
            fi
            ;;
        *)
            if [[ "$SCRIPT_LANG" == "zh" ]]; then
                echo -e "${RED}未知消息: $key${NC}"
            else
                echo -e "${RED}Unknown message: $key${NC}"
            fi
            ;;
    esac
}