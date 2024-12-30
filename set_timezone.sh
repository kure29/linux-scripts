#!/bin/bash

# 设置时区为上海
echo "正在设置时区为上海..."
sudo timedatectl set-timezone Asia/Shanghai

# 显示当前时间和时区
echo "当前系统时间和时区："
timedatectl
