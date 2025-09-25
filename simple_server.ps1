$httpListener = New-Object System.Net.HttpListener
$httpListener.Prefixes.Add('http://localhost:8082/')
$httpListener.Start()
Write-Host '简易服务器已启动在 http://localhost:8082'

while ($httpListener.IsListening) {
    $context = $httpListener.GetContext()
    $requestUrl = $context.Request.Url
    $localPath = $requestUrl.LocalPath
    
    if ($localPath -eq '/') {
        $localPath = '/index.html'
    }
    
    $filePath = Join-Path (Get-Location) $localPath.TrimStart('/')
    
    if (Test-Path $filePath -PathType Leaf) {
        $response = $context.Response
        $content = Get-Content -Path $filePath -Raw -Encoding UTF8
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
    } else {
        $context.Response.StatusCode = 404
    }
    
    $context.Response.Close()
}