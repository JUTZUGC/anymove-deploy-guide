# anymove 一键安装脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/patch-gg/anymove#quick-start
# 更新日期：2026-11-03
# 类型：script
$ErrorActionPreference = 'Stop'
Set-Location -Path $PSScriptRoot

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw '需要先安装 Git' }
if (-not (Get-Command python -ErrorAction SilentlyContinue)) { throw '需要先安装 Python 3' }

New-Item -ItemType Directory -Force -Path .download | Out-Null
Set-Location -Path .download

git clone https://github.com/patch-gg/anymove.git
Set-Location anymove; py -3.11 -m venv .venv
.venv\Scripts\pip install torch==2.11.0 --index-url https://download.pytorch.org/whl/cu128
.venv\Scripts\pip install -r requirements.txt
Write-Host "装好 Blender 5.2，并设置 BLENDER 环境变量指向可执行文件"

Write-Host ''

Write-Host '部署完成'
Write-Host '若结果异常或需要改配置，请参考官方文档：https://github.com/patch-gg/anymove#quick-start'
