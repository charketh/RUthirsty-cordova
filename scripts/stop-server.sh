#!/bin/bash

PID_FILE="/workspaces/RUthirsty-cordova/live-server.pid"

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p $PID > /dev/null 2>&1; then
        echo "正在停止 live-server (PID: $PID)..."
        kill $PID
        rm "$PID_FILE"
        echo "✅ Live-server 已停止"
    else
        echo "⚠️  进程 $PID 不存在"
        rm "$PID_FILE"
    fi
else
    echo "⚠️  未找到 PID 文件，服务器可能未运行"
fi
