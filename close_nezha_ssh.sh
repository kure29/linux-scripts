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

# 添加执行权限并运行 nezha_v0.sh 脚本，自动选择选项 1 和 12
chmod +x nezha_v0.sh
echo "正在运行 nezha_v0.sh 并自动选择选项 1 和 12..."

# 使用 expect 自动选择选项 1 和 12
expect << EOF
spawn ./nezha_v0.sh
expect "请输入选择 [1-2]：" { send "1\r" }
expect "请输入选择 [0-13]:" { send "12\r" }
expect eof
EOF

echo "nezha_v0.sh 脚本执行完毕"
