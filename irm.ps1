$ProgressPreference = "SilentlyContinue"

$apiUrl = "https://api.github.com/repos/FELIPER231/FENTINEX-Toolbox/releases/latest"
$tempFile = [System.IO.Path]::Combine(
    [System.IO.Path]::GetTempPath(),
    "FENTINEX-Toolbox-Setup.exe"
)

$Logo = @"
 ______ ______ _   _ _______ _____ _   _ ________   __
|  ____|  ____| \ | |__   __|_   _| \ | |  ____\ \ / /
| |__  | |__  |  \| |  | |    | | |  \| | |__   \ V /
|  __| |  __| | . ` |  | |    | | | . ` |  __|   > <
| |    | |____| |\  |  | |   _| |_| |\  | |____ / . \
|_|    |______|_| \_|  |_|  |_____|_| \_|______/_/ \_\

                FENTINEX Toolbox
"@

try {
    Clear-Host
    Write-Host $Logo -ForegroundColor Cyan

    $currentIdentity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentIdentity)
    $isAdmin = $principal.IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )

    if (-not $isAdmin) {
        Write-Host ""
        Write-Host "FENTINEX Toolbox requiere privilegios de administrador." -ForegroundColor Yellow
        Write-Host "Ejecuta PowerShell como Administrador e intentalo nuevamente." -ForegroundColor Yellow
        exit 1
    }

    if (Test-Path $tempFile) {
        Remove-Item -Path $tempFile -Force -ErrorAction SilentlyContinue
    }

    Write-Host ""
    Write-Host "Buscando la ultima version de FENTINEX Toolbox..." -ForegroundColor Cyan

    $releaseInfo = Invoke-RestMethod -Uri $apiUrl -Headers @{
        "Accept"     = "application/vnd.github.v3+json"
        "User-Agent" = "FENTINEX-Toolbox"
    }

    $asset = $releaseInfo.assets |
        Where-Object { $_.name -match "^FENTINEX\.Toolbox_.*_x64-setup\.exe$" } |
        Select-Object -First 1

    if (-not $asset) {
        throw "No se encontro el instalador de FENTINEX Toolbox en la ultima release."
    }

    $downloadUrl = $asset.browser_download_url

    Write-Host ""
    Write-Host "Version encontrada: $($releaseInfo.tag_name)" -ForegroundColor Green
    Write-Host "Descargando FENTINEX Toolbox..." -ForegroundColor Green

    Invoke-WebRequest -Uri $downloadUrl -OutFile $tempFile

    if (-not (Test-Path $tempFile)) {
        throw "La descarga del instalador no se completo correctamente."
    }

    Write-Host ""
    Write-Host "Iniciando FENTINEX Toolbox..." -ForegroundColor Green

    Start-Process -FilePath $tempFile -Wait

    if (Test-Path $tempFile) {
        Remove-Item -Path $tempFile -Force -ErrorAction SilentlyContinue
    }

    Write-Host ""
    Write-Host "Gracias por usar FENTINEX Toolbox." -ForegroundColor Cyan
}
catch {
    Write-Host ""
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "No fue posible descargar o ejecutar FENTINEX Toolbox." -ForegroundColor Red
}