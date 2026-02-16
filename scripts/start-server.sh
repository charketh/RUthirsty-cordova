#!/bin/bash

echo "======================================"
echo "  启动 RUthirsty Live Server"
echo "======================================"
echo ""

PID_FILE="/workspaces/RUthirsty-cordova/live-server.pid"

# 检查是否已经在运行
if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    if ps -p $PID > /dev/null 2>&1; then
        echo "⚠️  Live-server 已经在运行 (PID: $PID)"
        echo "   访问: http://localhost:8080"
        echo "   停止: ./stop-server.sh"
        exit 1
    else
        rm "$PID_FILE"
    fi
fi

# 启动 live-server
echo "🚀 正在启动 live-server..."
nohup npx live-server src --port=8080 --open=/index.html > /workspaces/RUthirsty-cordova/live-server.log 2>&1 &
echo $! > "$PID_FILE"

# 等待启动
sleep 2

# 验证启动状态
if ps -p $(cat "$PID_FILE") > /dev/null 2>&1; then
    echo ""
    echo "✅ Live-server 启动成功！"
    echo ""
    echo "📱 访问地址:"
    echo "   http://127.0.0.1:8080"
    echo "   http://localhost:8080"
    echo ""
    echo "📝 日志文件: ./live-server.log"
    echo "🔧 停止服务: ./stop-server.sh"
    echo ""
    echo "✨ 热重载已启用 - 修改文件将自动刷新页面"
    echo "======================================"
else
    echo "❌ 启动失败，请检查日志: cat live-server.log"
    rm "$PID_FILE"
    exit 1
fi
