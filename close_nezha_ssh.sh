#!/bin/bash

# 服务文件路径
SERVICE_FILE="/etc/systemd/system/nezha-agent.service"

# 检查服务文件是否存在
if [[ ! -f "$SERVICE_FILE" ]]; then
    echo "服务文件 $SERVICE_FILE 不存在，无法修改！"
    exit 1
fi

# 备份服务文件
cp "$SERVICE_FILE" "${SERVICE_FILE}.bak"
echo "已备份原始文件到 ${SERVICE_FILE}.bak"

# 使用 sed 修改 ExecStart 行
sed -i '/^ExecStart=\/opt\/nezha\/agent\/nezha-agent/ s/$/ --disable-command-execute/' "$SERVICE_FILE"

echo "已在 ExecStart 行末尾添加 --disable-command-execute"

# 重新加载 systemd 配置
systemctl daemon-reload
echo "已重新加载 systemd 配置"

# 重启服务
systemctl restart nezha-agent
echo "已重启 nezha-agent 服务"

# 检查服务状态
systemctl status nezha-agent

# 添加执行权限并运行 close_nezha_ssh.sh 脚本
chmod +x close_nezha_ssh.sh && ./close_nezha_ssh.sh
echo "已赋予 close_nezha_ssh.sh 可执行权限并运行脚本"

# 添加执行权限并运行 nezha_v0.sh 脚本，选择选项 12
chmod +x nezha_v0.sh
echo "正在运行 nezha_v0.sh 并选择选项 12..."
echo "12" | ./nezha_v0.sh
echo "nezha_v0.sh 脚本执行完毕"
