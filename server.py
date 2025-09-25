import http.server
import socketserver
import os

PORT = 8082

# 设置当前目录为工作目录
handler = http.server.SimpleHTTPRequestHandler

# 启动服务器
with socketserver.TCPServer(("localhost", PORT), handler) as httpd:
    print(f"服务器已启动在 http://localhost:{PORT}")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("服务器已停止")
        httpd.server_close()