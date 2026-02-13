#!/bin/bash

echo "======================================"
echo "  RUthirsty - Test Server"
echo "======================================"
echo ""
echo "Starting test server at http://localhost:8000"
echo "Open this URL in your browser to test the app"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

# Check if Python 3 is available
if command -v python3 &> /dev/null; then
    cd src && python3 -m http.server 8000
# Check if Python is available
elif command -v python &> /dev/null; then
    cd src && python -m http.server 8000
else
    echo "Error: Python is not installed"
    echo "Please install Python or use npx http-server"
    exit 1
fi
