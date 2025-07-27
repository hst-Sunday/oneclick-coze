# Coze Studio 一键管理工具

[![Version](https://img.shields.io/badge/version-1.0-blue.svg)](https://github.com/oneclick-coze)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-bash-orange.svg)](https://www.gnu.org/software/bash/)
[![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)](https://www.linux.org/)

> 🚀 一个功能强大的 Coze Studio 一键安装和管理工具，支持中英文双语，提供完整的模型管理、服务控制和域名配置功能。

[English](#english) | [中文](#中文)

---

## 中文

### 📖 项目介绍

Coze Studio 一键管理工具是一个基于 Bash 的交互式命令行工具，专为简化 Coze Studio 的部署、配置和管理而设计。通过直观的菜单界面，用户可以轻松完成从安装到高级配置的所有操作。

### ✨ 功能特性

- 🌍 **双语支持** - 完整的中英文界面，自动语言检测
- 🔧 **一键安装** - 自动化安装 Coze Studio，包含所有依赖检查
- 🤖 **模型管理** - 动态添加和配置 AI 模型，支持多种模型模板
- 🔄 **服务控制** - 启动、停止、重启 Coze Studio 服务
- 🌐 **网络优化** - 智能网络环境选择，国内外加速支持
- 🔒 **域名配置** - 自动 HTTPS 配置，SSL 证书管理
- 🗑️ **完整清理** - 安全卸载，包含数据和配置清理
- 📦 **模块化架构** - 易于维护和扩展的代码结构

### 🖥️ 系统要求

| 组件 | 要求 |
|------|------|
| **操作系统** | Linux (Ubuntu 18.04+, Debian 9+, CentOS 7+) |
| **Shell** | Bash 4.0+ |
| **内存** | 4GB+ RAM |
| **存储** | 10GB+ 可用空间 |
| **网络** | 互联网连接 |

#### 必需依赖
- Git
- Docker & Docker Compose
- curl
- sudo 权限

#### 域名配置额外要求
- Ubuntu 18.04+ 或 Debian 9+
- 有效的域名和 DNS 配置
- 开放 80/443 端口

### 🚀 快速开始

#### 1. 下载工具

```bash
# 克隆仓库
git clone https://github.com/your-username/oneclick-coze.git
cd oneclick-coze

# 赋予执行权限
chmod +x coze-studio.sh
```

#### 2. 运行工具

```bash
./coze-studio.sh
```

#### 3. 选择语言

首次运行时选择界面语言：
- `1` - 中文
- `2` - English

### 📋 主要功能

#### 1️⃣ 安装 Coze Studio

完整的自动化安装流程：

1. **系统检查** - 验证 Git、Docker 等依赖
2. **目录配置** - 选择安装目录
3. **网络环境** - 选择国内/国外网络环境
4. **代码下载** - 克隆 Coze Studio 仓库
5. **模型配置** - 设置 API Key 和默认模型
6. **服务启动** - 启动所有必需服务
7. **验证安装** - 确认服务正常运行

**网络环境选择：**
- **国内环境**：使用 GitHub 加速镜像 + Docker 镜像源
- **国外环境**：直接访问原始仓库和镜像

#### 2️⃣ 添加模型

动态模型管理功能：

- 📁 **模板发现** - 自动扫描可用模型模板
- 🎯 **智能选择** - 交互式模板选择界面
- 🔧 **配置向导** - 引导式 API Key 和模型 ID 配置
- 🔄 **自动重启** - 配置完成后自动重启相关服务

#### 3️⃣ 服务管理

全面的服务控制：

- **重启服务** - 重新启动所有 Coze Studio 服务
- **停止服务** - 安全停止所有运行中的服务
- **状态监控** - 实时服务状态检查

#### 4️⃣ 域名配置 (Ubuntu/Debian)

专业的 HTTPS 配置：

- 🔒 **SSL 证书** - 自动申请 Let's Encrypt 证书
- 🌐 **Nginx 代理** - 自动配置反向代理
- 🔄 **自动续期** - SSL 证书自动续期
- 🛡️ **安全配置** - 完整的安全头和 HTTPS 重定向

#### 5️⃣ 完整卸载

安全的系统清理：

- 🛑 **服务停止** - 停止所有相关服务
- 🗑️ **文件清理** - 删除安装目录和配置
- 📦 **镜像清理** - 清理 Docker 镜像和容器
- ⚠️ **安全确认** - 防止意外删除的确认机制

### 🌐 网络环境配置

#### 国内用户优化

选择"国内"网络环境时，工具会自动配置：

**GitHub 加速：**
```
原始地址: https://github.com/coze-dev/coze-studio.git
加速地址: https://ghfast.top/https://github.com/coze-dev/coze-studio.git
```

**Docker 镜像加速：**
```json
{
  "registry-mirrors": [
    "https://docker.1panel.live",
    "https://docker.1ms.run",
    "https://dytt.online",
    // ... 更多镜像源
  ]
}
```

#### 国外用户配置

选择"国外"网络环境时：
- 使用原始 GitHub 地址
- 恢复 Docker 默认配置
- 获得最佳的原生性能

### 🔧 配置说明

#### 默认配置文件

```bash
config/settings.conf
```

主要配置项：
- `DEFAULT_INSTALL_DIR`: 默认安装目录
- `DEFAULT_MODEL_ID`: 默认模型 ID
- `COZE_REPO_URL`: 仓库地址
- `AUTO_DETECT_LANGUAGE`: 自动语言检测

#### 自定义配置

可以修改配置文件来改变默认行为：

```bash
# 编辑配置文件
nano config/settings.conf

# 重新运行工具
./coze-studio.sh
```

### 📁 项目结构

```
oneclick-coze/
├── coze-studio.sh          # 主入口脚本
├── README.md              # 项目文档
├── CLAUDE.md              # 开发者文档
├── lib/                   # 核心库
│   ├── common.sh          # 通用函数和变量
│   ├── messages.sh        # 多语言消息系统
│   ├── ui.sh              # 用户界面
│   └── utils.sh           # 工具函数
├── modules/               # 功能模块
│   ├── install.sh         # 安装模块
│   ├── model.sh           # 模型管理
│   ├── service.sh         # 服务控制
│   ├── domain.sh          # 域名配置
│   └── cleanup.sh         # 清理模块
└── config/               # 配置文件
    └── settings.conf     # 默认配置
```

### ❓ 常见问题

#### Q: 脚本提示 "trap: ERR: bad trap" 错误？
A: 请确保使用 Bash 运行脚本：
```bash
bash coze-studio.sh
```

#### Q: Docker 权限错误？
A: 确保当前用户有 sudo 权限：
```bash
sudo usermod -aG docker $USER
newgrp docker
```

#### Q: 网络连接失败？
A: 尝试选择不同的网络环境：
- 国内用户选择"国内"环境
- 海外用户选择"国外"环境

#### Q: SSL 证书申请失败？
A: 检查以下条件：
- 域名正确解析到服务器 IP
- 防火墙开放 80/443 端口
- 确保域名未被其他服务占用

#### Q: 模型配置后不生效？
A: 工具会自动重启 coze-server，如果仍然不生效，请手动重启：
```bash
cd coze-studio/docker
docker compose --profile "*" restart coze-server
```

### 🔧 故障排除

#### 查看日志
```bash
# 查看 Docker 服务日志
cd coze-studio/docker
docker compose logs -f

# 查看特定服务日志
docker compose logs coze-server
```

#### 重置配置
```bash
# 停止所有服务
docker compose --profile "*" down

# 重置 Docker 配置
sudo rm -f /etc/docker/daemon.json
sudo systemctl restart docker

# 重新运行安装
./coze-studio.sh
```

### 🤝 贡献指南

欢迎贡献代码！请遵循以下步骤：

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

#### 开发规范
- 遵循现有代码风格
- 添加适当的注释
- 确保双语支持
- 测试所有功能

### 📄 许可证

本项目采用 MIT 许可证 - 详见 [LICENSE](LICENSE) 文件。

### 📞 支持

如果遇到问题，请：
1. 查看 [常见问题](#常见问题)
2. 搜索 [Issues](https://github.com/your-username/oneclick-coze/issues)
3. 创建新的 Issue

---

## English

### 📖 Introduction

Coze Studio One-Click Management Tool is an interactive command-line utility built with Bash, designed to simplify the deployment, configuration, and management of Coze Studio. Through an intuitive menu interface, users can easily complete all operations from installation to advanced configuration.

### ✨ Features

- 🌍 **Bilingual Support** - Complete Chinese/English interface with automatic language detection
- 🔧 **One-Click Installation** - Automated Coze Studio installation with dependency checks
- 🤖 **Model Management** - Dynamic AI model addition and configuration with multiple templates
- 🔄 **Service Control** - Start, stop, restart Coze Studio services
- 🌐 **Network Optimization** - Smart network environment selection with acceleration support
- 🔒 **Domain Configuration** - Automatic HTTPS setup with SSL certificate management
- 🗑️ **Complete Cleanup** - Safe uninstallation with data and configuration cleanup
- 📦 **Modular Architecture** - Easy to maintain and extend codebase

### 🖥️ System Requirements

| Component | Requirement |
|-----------|-------------|
| **OS** | Linux (Ubuntu 18.04+, Debian 9+, CentOS 7+) |
| **Shell** | Bash 4.0+ |
| **RAM** | 4GB+ |
| **Storage** | 10GB+ available space |
| **Network** | Internet connection |

#### Required Dependencies
- Git
- Docker & Docker Compose
- curl
- sudo privileges

#### Additional Requirements for Domain Configuration
- Ubuntu 18.04+ or Debian 9+
- Valid domain name with DNS configuration
- Open ports 80/443

### 🚀 Quick Start

#### 1. Download Tool

```bash
# Clone repository
git clone https://github.com/your-username/oneclick-coze.git
cd oneclick-coze

# Make executable
chmod +x coze-studio.sh
```

#### 2. Run Tool

```bash
./coze-studio.sh
```

#### 3. Select Language

Choose interface language on first run:
- `1` - 中文 (Chinese)
- `2` - English

### 📋 Main Features

#### 1️⃣ Install Coze Studio

Complete automated installation process:

1. **System Check** - Verify Git, Docker dependencies
2. **Directory Setup** - Choose installation directory
3. **Network Environment** - Select China/International network
4. **Code Download** - Clone Coze Studio repository
5. **Model Configuration** - Set API Key and default model
6. **Service Startup** - Start all required services
7. **Installation Verification** - Confirm services are running

**Network Environment Options:**
- **China**: GitHub acceleration mirror + Docker registry mirrors
- **International**: Direct access to original repositories

#### 2️⃣ Add Model

Dynamic model management:

- 📁 **Template Discovery** - Automatically scan available model templates
- 🎯 **Smart Selection** - Interactive template selection interface
- 🔧 **Configuration Wizard** - Guided API Key and model ID setup
- 🔄 **Auto Restart** - Automatic service restart after configuration

#### 3️⃣ Service Management

Comprehensive service control:

- **Restart Service** - Restart all Coze Studio services
- **Stop Service** - Safely stop all running services
- **Status Monitoring** - Real-time service status checking

#### 4️⃣ Domain Configuration (Ubuntu/Debian)

Professional HTTPS setup:

- 🔒 **SSL Certificates** - Automatic Let's Encrypt certificate acquisition
- 🌐 **Nginx Proxy** - Automatic reverse proxy configuration
- 🔄 **Auto Renewal** - SSL certificate automatic renewal
- 🛡️ **Security Config** - Complete security headers and HTTPS redirect

#### 5️⃣ Complete Removal

Safe system cleanup:

- 🛑 **Service Stop** - Stop all related services
- 🗑️ **File Cleanup** - Remove installation directories and configs
- 📦 **Image Cleanup** - Clean Docker images and containers
- ⚠️ **Safety Confirmation** - Confirmation mechanism to prevent accidental deletion

### ❓ FAQ

#### Q: Script shows "trap: ERR: bad trap" error?
A: Make sure to run with Bash:
```bash
bash coze-studio.sh
```

#### Q: Docker permission errors?
A: Ensure current user has sudo privileges:
```bash
sudo usermod -aG docker $USER
newgrp docker
```

#### Q: Network connection failures?
A: Try different network environments:
- China users: select "China" environment
- International users: select "International" environment

#### Q: SSL certificate acquisition fails?
A: Check these conditions:
- Domain correctly resolves to server IP
- Firewall allows ports 80/443
- Domain not occupied by other services

### 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### 📞 Support

If you encounter issues:
1. Check [FAQ](#faq)
2. Search [Issues](https://github.com/your-username/oneclick-coze/issues)
3. Create a new Issue

---

<div align="center">

**⭐ 如果这个项目对您有帮助，请给我们一个 Star！**

**⭐ If this project helps you, please give us a Star!**

</div>