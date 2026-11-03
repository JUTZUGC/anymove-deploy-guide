#!/usr/bin/env bash
set -euo pipefail
# anymove 一键安装脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/patch-gg/anymove#quick-start
# 更新日期：2026-11-03
# 类型：script
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }
command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1 || { echo "需要先安装 Python 3"; exit 1; }

mkdir -p .download
cd .download

git clone https://github.com/patch-gg/anymove.git
cd anymove && python3.11 -m venv .venv
.venv/bin/pip install torch==2.11.0 --index-url https://download.pytorch.org/whl/cu128
.venv/bin/pip install -r requirements.txt
echo "装好 Blender 5.2，并设置 BLENDER 环境变量指向可执行文件"

echo ""

echo "部署完成"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/patch-gg/anymove#quick-start"
