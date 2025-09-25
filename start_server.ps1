# 启动简单的HTTP服务器
$port = 8080
$hostName = "localhost"

# 创建一个简单的HTTP监听器
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://$hostName`:$port/")

# 启动监听器
$listener.Start()
Write-Host "服务器已启动，访问地址: http://$hostName`:$port/"
Write-Host "按Ctrl+C停止服务器"

# 处理请求的函数
function Handle-Request($context) {
    $request = $context.Request
    $response = $context.Response
    
    # 获取请求的路径
    $path = $request.Url.LocalPath
    
    # 如果路径是根目录，返回index.html
    if ($path -eq "/") {
        $path = "/index.html"
    }
    
    # 构建文件路径
    $filePath = Join-Path -Path (Get-Location) -ChildPath $path.Substring(1)
    
    # 检查文件是否存在
    if (Test-Path -Path $filePath -PathType Leaf) {
        try {
            # 读取文件内容
            $content = [System.IO.File]::ReadAllBytes($filePath)
            $response.ContentLength64 = $content.Length
            
            # 设置内容类型
            $extension = [System.IO.Path]::GetExtension($filePath).ToLower()
            switch ($extension) {
                ".html" { $response.ContentType = "text/html" }
                ".css" { $response.ContentType = "text/css" }
                ".js" { $response.ContentType = "application/javascript" }
                ".json" { $response.ContentType = "application/json" }
                ".png" { $response.ContentType = "image/png" }
                ".jpg" { $response.ContentType = "image/jpeg" }
                ".gif" { $response.ContentType = "image/gif" }
                ".svg" { $response.ContentType = "image/svg+xml" }
                default { $response.ContentType = "application/octet-stream" }
            }
            
            # 发送响应
            $response.OutputStream.Write($content, 0, $content.Length)
        } catch {
            $response.StatusCode = 500
            Write-Host "错误处理文件 $filePath: $_"
        }
    } else {
        $response.StatusCode = 404
        $errorMsg = "文件未找到: $path"
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($errorMsg)
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
        Write-Host $errorMsg
    }
    
    $response.Close()
}

# 主循环，持续监听请求
try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        Handle-Request $context
    }
} finally {
    $listener.Stop()
    Write-Host "服务器已停止"
}