# anymove 一键安装指南

> 第三方部署指南 · 非 anymove 官方仓库。官方项目：[patch-gg/anymove](https://github.com/patch-gg/anymove)
> 内容来自官方文档（2026-11-03）。项目迭代快，请以[官方文档](https://github.com/patch-gg/anymove#quick-start)为准。

[![⚡ 一键安装](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E5%AE%89%E8%A3%85-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键安装推荐用百度搭子)

## 一键安装（推荐：用百度搭子）

> [!TIP]
> 不用自己敲命令，让百度搭子帮你把环境跑起来。

⚠️ 需要 NVIDIA 显卡与 CUDA：训练关节读取器建议 12 GB 显存，24 GB 更稳；读取与拟合阶段要求低得多。还要 Blender 5.2 用于骨骼拟合与导出。Windows 下所有命令把 `.venv/bin/` 换成 `.venv\Scripts\`。首次训练可能占用一张卡约 20 分钟。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/anymove-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会建好 Python 3.11 环境，装 CUDA 版 PyTorch 与依赖，再提示配置 Blender，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Git；构建依赖以官方文档为准。）



## anymove 是什么？

anymove 是开源的两路相机拍同一只生物，读出关节，把骨骼贴上去，直接导出可用的 GLB（协议：Apache-2.0，<img src="https://img.shields.io/github/stars/patch-gg/anymove?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

从一段双视角视频给任意生物做动作捕捉：用 DINOv2 读关节，在两个视角里拟合骨骼，逐帧贴合后导出 GLB 动画。

- 不限人形，四足与幻想生物都能试
- 双视角联合拟合，减少遮挡误差
- DINOv2 关节读取，可用少量姿态微调
- 导出 GLB，24 fps，可直接进引擎
- 附带 Claude Code 技能
- Apache-2.0，可商用可二开

（来源：[官方仓库](https://github.com/patch-gg/anymove)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 490 stars | 名称搜索 11 条（每页 20 条时一页） |
| 不限人形 | 适用范围广 |
| 双视角联合拟合 | — |
| 导出 GLB | 引擎直接可用 |
| 带 Claude Code 技能 | — |
| Apache-2.0 | 可商用 |

| 需要注意 | 说明 |
|---|---|
| 需要 NVIDIA CUDA 环境 | — |
| 训练阶段显存要求高 | — |
| 依赖 Blender 5.2 | — |
| 双视角素材准备麻烦 | — |
| 拟合结果需人工检查 | — |

> 以上基于官方文档与社区反馈整理（2026-11-03），以官方最新文档为准。

## 快速部署（官方方式）

```bash
git clone https://github.com/patch-gg/anymove.git
cd anymove && python3.11 -m venv .venv
.venv/bin/pip install torch==2.11.0 --index-url https://download.pytorch.org/whl/cu128
.venv/bin/pip install -r requirements.txt
echo "装好 Blender 5.2，并设置 BLENDER 环境变量指向可执行文件"
```

部署步骤来源：[https://github.com/patch-gg/anymove#quick-start](https://github.com/patch-gg/anymove#quick-start)

## 验证状态

| 场景 | 状态 |
|---|---|
| README 确认 Python 3.11、CUDA 依赖与 Blender 5.2 | 已核对 2026-11-03 |
| 未实测环境安装与动捕 | 说明 2026-11-03 |
| MCP 冒烟：initialize / tools/list 返回 get_guide、search_guide、get_project_info | 已验证 2026-11-03 |
| 非目标宿主调用 get_guide 被拦截（HOST_NOT_ALLOWED） | 已验证 2026-11-03 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

以 Agent Skill 形式提供（`/plugin install anymove@anymove`），本身不含 MCP；本仓库的 MCP 只提供安装步骤与常见问题。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-11-03）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\anymove-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 流程

1. 准备一段同框双视角视频
2. 读出每帧关节，得到 `det.npz`
3. 用参考姿态拟合骨骼
4. 逐帧贴合，导出 GLB

## 常用命令

```powershell
.venv\Scripts\python -m mocap.solve examples/dragon_roar/det.npz
.venv\Scripts\python tools\make_prompt.py assets/dragon "动作描述" prompts/dragon/tailwhip.txt
.venv\Scripts\python tools\score_takes.py dragon
```

## Blender

设置环境变量指向 5.2 的可执行文件：

```powershell
$env:BLENDER="C:\Program Files\Blender Foundation\Blender 5.2\blender.exe"
```

## 注意

- 训练读取器吃显存，先从小样本开始
- 双视角必须同框且同步，否则关节会飘
- 骨骼拟合需要目标生物的 rig
- 输出是动画，不含模型贴图
- 结果要人工过一遍，别直接上线

## 常见坑

- 装依赖失败：确认 Python 3.11 与 CUDA 12.8 版本匹配
- torch 装成 CPU 版：检查 `--index-url` 是否生效
- Blender 找不到：设置 `BLENDER` 环境变量到绝对路径
- 关节乱跳：确认两路画面同框且时间对齐
- 显存不足：减少训练姿态数或换更小批量
- 导出的 GLB 没动画：检查骨骼绑定与帧率
- Windows 路径错误：统一用 `.venv\Scripts\`

## 免责声明

本仓库为第三方指南，与 anymove 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-11-03），项目迭代快，请以[官方文档](https://github.com/patch-gg/anymove#quick-start)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
