#!/usr/bin/env bash
set -e
#!/bin/bash

# 设置环境变量-2月28日解决方案部使用，勿动
export ANTHROPIC_AUTH_TOKEN=sk-YSZzO6liWWYYKu2irfMm3CYqkvmG5OQ4mSCoMcsQKQ4QO69O
export ANTHROPIC_BASE_URL=https://apiHK.Ai
#export CLAUDE_CODE_DISABLE_EXPERIMENTAL_BETAS=1
# 备选API线路（去掉下面两行注释生效）
# export ANTHROPIC_AUTH_TOKEN=sk-BnACKGNS5fruSd9Mmm2cH4MuLXGR27sB0md9KsYN6fvR4CYi
# export ANTHROPIC_BASE_URL=https://xinghuapi.com

first_run=false
# 检查claude是否已安装
if ! command -v claude &> /dev/null; then
    echo "Claude未安装，正在安装..."
    npm install -g @anthropic-ai/claude-code
    if [ $? -ne 0 ]; then
        echo "Claude安装失败，请检查网络连接和npm配置"
        exit 1
    fi
    echo "Claude安装成功！"
    first_run=true
else
    echo "Claude已安装"
fi

# 启动claude
echo "启动Claude..."
if $first_run; then
    # 10秒倒计时
    for i in 10 9 8 7 6 5 4 3 2 1; do
        echo -ne "初次启动Claude需要简单配置，所有配置按【回车键】选默认设置即可。请阅读以上指导: $i秒\r"
        sleep 1
    done
    echo -ne "                                          \r"
fi

claude
