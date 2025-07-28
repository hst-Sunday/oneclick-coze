# Windows 11 安装指南

本指南提供在 Windows 11 系统上运行 Coze Studio 管理工具的详细步骤。

## 🎯 推荐方案：WSL2 + Ubuntu

### 前提条件
- Windows 11 (版本 21H2 或更高)
- 管理员权限
- 至少 8GB 内存
- 20GB 可用磁盘空间
- 确保Windows 11 安装了Docker Desktop 且在设置里开启了 WSL Intergration  
  1.打开 Docker Desktop  
  2.点击右上角的 Settings（设置）⚙️  
  3.选择左侧菜单的：Resources → WSL Integration

### 步骤 1: 启用 WSL2

1. **以管理员身份打开 PowerShell**
   ```powershell
   # 启用 WSL 功能
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
   
   # 启用虚拟机平台
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   
   # 重启计算机
   Restart-Computer
   ```

2. **设置 WSL2 为默认版本**
   ```powershell
   wsl --set-default-version 2
   ```

3. **安装 Ubuntu 24.04 LTS**
   ```powershell
   # 方法1: 通过命令行安装
   wsl --install -d Ubuntu-24.04
   
   # 方法2: 从 Microsoft Store 安装 Ubuntu 24.04 LTS
   ```

### 步骤 2: 配置 Ubuntu 环境

1. **启动 Ubuntu 并设置用户**
   - 首次启动会要求创建用户名和密码
   - 建议用户名使用小写字母和数字
   ```powershell
   # 进入 ubuntu-24.04
   wsl ~ -d Ubuntu-24.04
   
   # 方法2: 从 Microsoft Store 安装 Ubuntu 24.04 LTS
   ```

2. **更新系统**
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

3. **安装必要依赖**
   ```bash
   # 安装 Git
   sudo apt install git -y
   
   # 安装 curl
   sudo apt install curl -y
   
   # 验证安装
   git --version
   curl --version
   ```

### 步骤 3: 安装 Docker Desktop

1. **下载 Docker Desktop for Windows**
   - 访问 [Docker 官网](https://docs.docker.com/desktop/windows/install/)
   - 下载 Docker Desktop Installer.exe

2. **安装 Docker Desktop**
   - 运行安装程序
   - 确保选择 "Enable WSL 2 Features" 选项
   - 完成安装后重启系统

3. **配置 Docker Desktop WSL2 集成**
   - 打开 Docker Desktop
   - 进入 Settings → General
   - 确保启用 "Use the WSL 2 based engine"
   - 进入 Settings → Resources → WSL Integration
   - 启用与 Ubuntu-24.04 的集成

### 步骤 4: 运行 Coze Studio 管理工具

1. **在 WSL Ubuntu 中获取脚本**
   ```bash
   # 克隆仓库
   git clone <repository-url> oneclick-coze
   cd oneclick-coze
   
   # 添加执行权限
   chmod +x coze-studio.sh
   ```

2. **运行脚本**
   ```bash
   ./coze-studio.sh
   ```

## 🔧 替代方案：Git Bash

### 适用场景
- 不想使用 WSL2
- 轻量级运行环境
- 仅需要基础功能

### 限制说明
- Docker 功能可能受限
- 部分 Linux 特定命令不可用
- 需要手动处理权限相关操作

### 安装步骤

1. **安装 Git for Windows**
   - 下载 [Git for Windows](https://git-scm.com/download/win)
   - 安装时选择 "Git Bash Here" 选项

2. **安装 Docker Desktop**
   - 按照上述 Docker Desktop 安装步骤

3. **运行修改版脚本**
   ```bash
   # 在 Git Bash 中运行
   bash coze-studio.sh
   ```

## ⚠️ 常见问题解决

### WSL2 相关问题

**问题**: WSL2 启动失败
**解决方案**:
```powershell
# 检查 WSL 状态
wsl --list --verbose

# 更新 WSL 内核
wsl --update

# 重置 WSL
wsl --shutdown
```

**问题**: Docker 在 WSL2 中无法启动
**解决方案**:
1. 确保 Docker Desktop 正在运行
2. 检查 WSL Integration 设置
3. 重启 Docker Desktop

### Docker 相关问题

**问题**: Docker 命令权限被拒绝
**解决方案**:
```bash
# 将用户添加到 docker 组
sudo usermod -aG docker $USER

# 重新登录或重启 WSL
exit
# 重新打开 WSL 终端
```

**问题**: Docker Compose 命令不可用
**解决方案**:
```bash
# 检查 Docker Compose 版本
docker compose version

# 如果不可用，手动安装
sudo apt install docker-compose-plugin -y
```

## 🚀 性能优化建议

### WSL2 优化
1. **分配足够的内存**
   ```
   # 创建 %USERPROFILE%\.wslconfig 文件
   [wsl2]
   memory=8GB
   processors=4
   ```

2. **使用 WSL2 文件系统**
   ```bash
   # 在 WSL 内部的文件系统中工作，而不是 Windows 挂载点
   cd ~/
   # 而不是 cd /mnt/c/
   ```

### Docker 优化
1. **配置资源限制**
   - Docker Desktop → Settings → Resources
   - 分配适当的 CPU 和内存

2. **启用 BuildKit**
   ```bash
   export DOCKER_BUILDKIT=1
   ```

## 📝 附加说明

### 文件系统访问
- WSL2 Ubuntu 文件系统: `\\wsl$\Ubuntu-24.04\home\<username>`
- Windows 文件从 WSL 访问: `/mnt/c/`

### 网络配置
- WSL2 使用虚拟化网络
- Docker 容器可以正常访问外部网络
- 本地服务可通过 `localhost` 访问

### 备份和迁移
```bash
# 导出 WSL 分发版
wsl --export Ubuntu-24.04 ubuntu-backup.tar

# 导入 WSL 分发版
wsl --import Ubuntu-24.04 C:\wsl\Ubuntu-24.04 ubuntu-backup.tar
```

---

如果遇到任何问题，请参考 [故障排除文档](./TROUBLESHOOTING.md) 或提交 Issue。