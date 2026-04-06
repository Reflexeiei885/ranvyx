# ===== ASCII LOGO =====
$logo = @"
RRRRR    AAA   N   N V   V Y   Y X   X
R    R  A   A  NN  N V   V  Y Y   X X 
RRRRR   AAAAA  N N N V   V   Y     X  
R   R   A   A  N  NN  V V    Y    X X 
R    R  A   A  N   N   V     Y   X   X

      R A N V Y X S T O R E
"@

# ===== GRADIENT COLORS =====
$colors = @(
    "Green",
    "Green",
    "Green"
)

# ===== SHOW LOGO (LEFT + GRADIENT + TYPE EFFECT) =====
function Show-Logo {
    Clear-Host

    $lines = $logo -split "`n"
    $colorIndex = 0

    foreach ($line in $lines) {
        $color = $colors[$colorIndex % $colors.Count]

        foreach ($char in $line.ToCharArray()) {
            Write-Host -NoNewline $char -ForegroundColor $color
            Start-Sleep -Milliseconds 1   # ปรับความเร็วได้
        }

        Write-Host ""
        $colorIndex++
    }
}

# ===== TYPE TEXT =====
function Type-Text($text, $color="White", $speed=3) {
    foreach ($char in $text.ToCharArray()) {
        Write-Host -NoNewline $char -ForegroundColor $color
        Start-Sleep -Milliseconds $speed
    }
    Write-Host ""
}

# ===== FAKE LOADING (CUSTOM BAR) =====
function Fake-Loading($text) {
    Write-Host ""
    Type-Text $text "Yellow" 2

    $barLength = 30
    for ($i = 0; $i -le $barLength; $i++) {
        $percent = [int](($i / $barLength) * 100)
        $bar = ("#" * $i).PadRight($barLength, "-")

        Write-Host -NoNewline "`r[$bar] $percent%" -ForegroundColor Green
        Start-Sleep -Milliseconds (Get-Random -Min 20 -Max 60)
    }

    Write-Host ""
}

# ===== CLEAN PRINT =====
function Print-Success($text) {
    Write-Host "[+] $text" -ForegroundColor Green
}

function Print-Error($text) {
    Write-Host "[-] $text" -ForegroundColor Red
}

# ===== START =====
Show-Logo

Write-Host ""
Write-Host "Enter License Key : " -NoNewline -ForegroundColor White
$key = Read-Host

# ===== KeyAuth =====
$appName  = "PWShell"
$ownerId  = "igr22xSE8H"
$version  = "1.0"
$apiUrl   = "https://keyauth.win/api/1.2/"

Fake-Loading "Connecting to server..."

$initBody = "type=init&ver=$version&name=$appName&ownerid=$ownerId"
$initResp = Invoke-RestMethod -Uri $apiUrl -Method Post -Body $initBody -ContentType "application/x-www-form-urlencoded"

if (-not $initResp.success) {
    Print-Error "Init failed"
    exit
}

$sessionId = $initResp.sessionid
$hwid = (Get-WmiObject Win32_ComputerSystemProduct).UUID

Fake-Loading "Verifying license..."

$licBody = "type=license&key=$([Uri]::EscapeDataString($key))&hwid=$([Uri]::EscapeDataString($hwid))&sessionid=$sessionId&name=$appName&ownerid=$ownerId"
$licResp = Invoke-RestMethod -Uri $apiUrl -Method Post -Body $licBody -ContentType "application/x-www-form-urlencoded"

if (-not $licResp.success) {
    Print-Error "Invalid key"
    exit
}

Print-Success "Login success"

# ===== INSTALL =====
Write-Host "[*] Fetching DLL into memory..." -ForegroundColor Yellow

try {
    $response = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Reflexeiei885/ranvyx/refs/heads/main/dxgi.dll" -UseBasicParsing
    $bytes = $response.Content
    Write-Host "[+] DLL loaded in memory ($($bytes.Length) bytes)" -ForegroundColor Green
} catch {
    Write-Host "[-] Download failed" -ForegroundColor Red
    exit
}

Write-Host "Enter PID : " -NoNewline
$targetPid = Read-Host

try {
    $proc = Get-Process -Id $targetPid -ErrorAction Stop
    Write-Host "[+] Target: $($proc.ProcessName)" -ForegroundColor Green
} catch {
    Write-Host "[-] Invalid PID" -ForegroundColor Red
}

Write-Host ""
Write-Host "[*] Preparing injection (simulation)..." -ForegroundColor Yellow
Start-Sleep 1

Write-Host "[*] Mapping DLL into memory (simulation)..." -ForegroundColor Cyan
Start-Sleep 1

Write-Host "[*] Executing entry point (simulation)..." -ForegroundColor Cyan
Start-Sleep 1

Write-Host ""
Write-Host "[+] Done (simulation only)" -ForegroundColor Green
