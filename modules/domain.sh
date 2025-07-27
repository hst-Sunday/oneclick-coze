#!/bin/bash

# Domain configuration module for Coze Studio
# 域名配置模块

# Check if system is supported (Ubuntu or Debian)
check_system_support() {
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        case "$ID" in
            ubuntu)
                SYSTEM_TYPE="ubuntu"
                return 0
                ;;
            debian)
                SYSTEM_TYPE="debian"
                return 0
                ;;
            *)
                msg "system_not_supported" "$PRETTY_NAME"
                return 1
                ;;
        esac
    else
        msg "system_not_supported" "Unknown"
        return 1
    fi
}

# Install Nginx on Ubuntu
install_nginx_ubuntu() {
    msg "installing_nginx"
    
    # Install dependencies
    sudo apt install -y curl gnupg2 ca-certificates lsb-release ubuntu-keyring
    
    # Add Nginx signing key
    curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
        | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
    
    # Verify key
    gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
    
    # Add Nginx repository
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/mainline/ubuntu $(lsb_release -cs) nginx" \
        | sudo tee /etc/apt/sources.list.d/nginx.list
    
    # Update and install
    sudo apt update
    sudo apt install -y nginx
    
    # Start and enable nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    
    if systemctl is-active --quiet nginx; then
        msg "nginx_install_success"
        return 0
    else
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${RED}❌ Nginx 安装失败${NC}"
        else
            echo -e "${RED}❌ Nginx installation failed${NC}"
        fi
        return 1
    fi
}

# Install Nginx on Debian
install_nginx_debian() {
    msg "installing_nginx"
    
    # Install dependencies
    sudo apt install -y curl gnupg2 ca-certificates lsb-release debian-archive-keyring
    
    # Add Nginx signing key
    curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
        | sudo tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
    
    # Verify key
    gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
    
    # Add Nginx repository
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/mainline/debian $(lsb_release -cs) nginx" \
        | sudo tee /etc/apt/sources.list.d/nginx.list
    
    # Update and install
    sudo apt update
    sudo apt install -y nginx
    
    # Start and enable nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    
    if systemctl is-active --quiet nginx; then
        msg "nginx_install_success"
        return 0
    else
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${RED}❌ Nginx 安装失败${NC}"
        else
            echo -e "${RED}❌ Nginx installation failed${NC}"
        fi
        return 1
    fi
}

# Install acme.sh
install_acme_sh() {
    msg "installing_acme"
    
    # Get user email
    msg "enter_email"
    read -r user_email
    
    if [[ -z "$user_email" ]]; then
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${RED}错误: 邮箱地址不能为空${NC}"
        else
            echo -e "${RED}Error: Email address cannot be empty${NC}"
        fi
        return 1
    fi
    
    # Install acme.sh
    curl https://get.acme.sh | sh -s email="$user_email"
    
    # Source acme.sh
    source ~/.bashrc
    
    if [[ -f ~/.acme.sh/acme.sh ]]; then
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${GREEN}✓ acme.sh 安装成功${NC}"
        else
            echo -e "${GREEN}✓ acme.sh installed successfully${NC}"
        fi
        return 0
    else
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${RED}❌ acme.sh 安装失败${NC}"
        else
            echo -e "${RED}❌ acme.sh installation failed${NC}"
        fi
        return 1
    fi
}

# Setup SSL certificate
setup_ssl_certificate() {
    local domain="$1"
    
    msg "generating_ssl"
    
    # Stop nginx temporarily for standalone mode
    sudo systemctl stop nginx
    
    # Generate certificate
    ~/.acme.sh/acme.sh --issue --standalone -d "$domain"
    
    if [[ $? -eq 0 ]]; then
        # Install certificate
        ~/.acme.sh/acme.sh --install-cert -d "$domain" \
            --key-file /etc/nginx/ssl/"$domain".key \
            --fullchain-file /etc/nginx/ssl/"$domain".pem \
            --reloadcmd "systemctl reload nginx"
        
        msg "ssl_success"
        return 0
    else
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${RED}❌ SSL 证书申请失败${NC}"
            echo -e "${YELLOW}请确保域名已正确解析到此服务器${NC}"
        else
            echo -e "${RED}❌ SSL certificate generation failed${NC}"
            echo -e "${YELLOW}Please ensure the domain is correctly pointed to this server${NC}"
        fi
        sudo systemctl start nginx
        return 1
    fi
}

# Configure Nginx reverse proxy
configure_nginx_proxy() {
    local domain="$1"
    
    msg "configuring_nginx"
    
    # Create SSL directory
    sudo mkdir -p /etc/nginx/ssl
    
    # Create Nginx configuration for Coze Studio
    sudo tee /etc/nginx/conf.d/"$domain".conf > /dev/null <<EOF
# HTTP to HTTPS redirect
server {
    listen 80;
    server_name $domain;
    return 301 https://\$server_name\$request_uri;
}

# HTTPS server
server {
    listen 443 ssl http2;
    server_name $domain;
    
    # SSL configuration
    ssl_certificate /etc/nginx/ssl/$domain.pem;
    ssl_certificate_key /etc/nginx/ssl/$domain.key;
    
    # SSL security settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-RSA-AES128-SHA256:ECDHE-RSA-AES256-SHA384:ECDHE-RSA-AES128-SHA:ECDHE-RSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-RSA-AES128-SHA:DHE-RSA-AES256-SHA;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    
    # Security headers
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    add_header X-Frame-Options DENY always;
    add_header X-Content-Type-Options nosniff always;
    add_header X-XSS-Protection "1; mode=block" always;
    
    # Proxy to Coze Studio
    location / {
        proxy_pass http://localhost:8888;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        
        # WebSocket support
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
        
        # Increase proxy timeout for long requests
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
EOF
    
    # Test nginx configuration
    if sudo nginx -t; then
        # Reload nginx
        sudo systemctl reload nginx
        
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${GREEN}✓ Nginx 配置成功${NC}"
        else
            echo -e "${GREEN}✓ Nginx configured successfully${NC}"
        fi
        return 0
    else
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${RED}❌ Nginx 配置失败${NC}"
        else
            echo -e "${RED}❌ Nginx configuration failed${NC}"
        fi
        return 1
    fi
}

# Main domain setup function
setup_domain() {
    msg "configure_domain"
    echo
    
    # Check system support
    if ! check_system_support; then
        echo
        wait_for_user
        return
    fi
    
    echo
    if [[ "$SCRIPT_LANG" == "zh" ]]; then
        echo -e "${BLUE}检测到支持的系统: $SYSTEM_TYPE${NC}"
    else
        echo -e "${BLUE}Detected supported system: $SYSTEM_TYPE${NC}"
    fi
    
    # Check if Coze Studio is installed and running
    if ! check_coze_installation; then
        msg "coze_not_installed"
        echo
        wait_for_user
        return
    fi
    
    # Install Nginx based on system type
    echo
    if ! command -v nginx &> /dev/null; then
        case "$SYSTEM_TYPE" in
            ubuntu)
                if ! install_nginx_ubuntu; then
                    echo
                    wait_for_user
                    return
                fi
                ;;
            debian)
                if ! install_nginx_debian; then
                    echo
                    wait_for_user
                    return
                fi
                ;;
        esac
    else
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${YELLOW}Nginx 已安装，跳过安装步骤${NC}"
        else
            echo -e "${YELLOW}Nginx already installed, skipping installation${NC}"
        fi
    fi
    
    # Install acme.sh
    echo
    if [[ ! -f ~/.acme.sh/acme.sh ]]; then
        if ! install_acme_sh; then
            echo
            wait_for_user
            return
        fi
    else
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${YELLOW}acme.sh 已安装，跳过安装步骤${NC}"
        else
            echo -e "${YELLOW}acme.sh already installed, skipping installation${NC}"
        fi
    fi
    
    # Get domain name
    echo
    msg "enter_domain"
    read -r domain_name
    
    if [[ -z "$domain_name" ]]; then
        if [[ "$SCRIPT_LANG" == "zh" ]]; then
            echo -e "${RED}错误: 域名不能为空${NC}"
        else
            echo -e "${RED}Error: Domain name cannot be empty${NC}"
        fi
        echo
        wait_for_user
        return
    fi
    
    # Setup SSL certificate
    echo
    if ! setup_ssl_certificate "$domain_name"; then
        echo
        wait_for_user
        return
    fi
    
    # Configure Nginx
    echo
    if ! configure_nginx_proxy "$domain_name"; then
        echo
        wait_for_user
        return
    fi
    
    # Success message
    echo
    msg "domain_setup_complete"
    echo -e "  ${GREEN}https://$domain_name${NC}"
    echo
    
    if [[ "$SCRIPT_LANG" == "zh" ]]; then
        echo -e "${YELLOW}注意事项:${NC}"
        echo "- 确保域名 DNS 已正确解析到此服务器"
        echo "- 防火墙需要开放 80 和 443 端口"
        echo "- SSL 证书会自动续期"
    else
        echo -e "${YELLOW}Important notes:${NC}"
        echo "- Ensure domain DNS is correctly pointed to this server"
        echo "- Firewall needs to allow ports 80 and 443"
        echo "- SSL certificate will auto-renew"
    fi
    
    echo
    wait_for_user
}