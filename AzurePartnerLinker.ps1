# ----------------------------
# Intro ASCII-Titel
# ----------------------------
$asciiTitle = @"
                                                                                    
 _____       _____                                                                 
|  _  |_____|     |___ ___                                                         
|   __|     |  |  |   | -_|                                                        
|__|  |_|_|_|_____|_|_|___|                                                        
                                                                                   
                                                                                   
 _____                    _____         _                  __    _     _           
|  _  |___ _ _ ___ ___   |  _  |___ ___| |_ ___ ___ ___   |  |  |_|___| |_ ___ ___ 
|     |- _| | |  _| -_|  |   __| .'|  _|  _|   | -_|  _|  |  |__| |   | '_| -_|  _|
|__|__|___|___|_| |___|  |__|  |__,|_| |_| |_|_|___|_|    |_____|_|_|_|_,_|___|_|  
                                                                                   
"@



# ----------------------------
# Hilfsfunktion für Logging
# ----------------------------
function Write-Log {
    param (
        [string]$Message,
        [string]$Level = "Info"
    )

    # Datum/Uhrzeit für Log-Datei
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Level] $Message"

    # Konsolen-Output für User
    switch ($Level) {
        "Info"    { Write-Host "`nℹ️  $Message`n" -ForegroundColor Cyan }
        "Success" { Write-Host "`n✅  $Message`n" -ForegroundColor Green }
        "Warning" { Write-Host "`n⚠️  $Message`n" -ForegroundColor Yellow }
        "Error"   { Write-Host "`n❌  $Message`n" -ForegroundColor Red }
        default   { Write-Host "`n$Message`n" }
    }

    # Log-Datei
    $logFile = "$env:USERPROFILE\azure_script_log.txt"
    Add-Content -Path $logFile -Value $logEntry
}

# ----------------------------
# Modul-Installation / Import
# ----------------------------
function Install-RequiredModule {
    param (
        [string]$ModuleName,
        [string]$LocalPath = "./Modules/$ModuleName"
    )

    Write-Log "Prüfe Modul $ModuleName..." -Level Info

    if (Test-Path "$LocalPath\$ModuleName.psd1") {
        Write-Log "Lokales Bundle für $ModuleName gefunden. Importiere ohne Installation..." -Level Info
        try {
            Import-Module "$LocalPath\$ModuleName.psd1" -ErrorAction Stop
            Write-Log "Modul $ModuleName geladen." -Level Success
        } catch {
            $errorMessage = $_.Exception.Message
            Write-Log "Fehler beim Import von lokalem Modul ${ModuleName}: $errorMessage" -Level Error
            exit 1
        }
    } else {
        if (-not (Get-Module -ListAvailable -Name $ModuleName)) {
            Write-Log "$ModuleName nicht installiert. Installiere selektiv..." -Level Warning
            try {
                Install-Module -Name $ModuleName -AllowClobber -Force -Scope CurrentUser -ErrorAction Stop
                Write-Log "Installation von $ModuleName erfolgreich." -Level Success
            } catch {
                $errorMessage = $_.Exception.Message
                Write-Log "Fehler bei Installation von ${ModuleName}: $errorMessage" -Level Error
                exit 1
            }
        }
        try {
            Import-Module $ModuleName -ErrorAction Stop
            Write-Log "Modul $ModuleName geladen." -Level Success
        } catch {
            $errorMessage = $_.Exception.Message
            Write-Log "Fehler beim Laden von ${ModuleName}: $errorMessage" -Level Error
            exit 1
        }
    }
}

# ----------------------------
# Service Principal Authentifizierung
# ----------------------------
function Connect-ServicePrincipal {
    param (
        [string]$tenantId,
        [string]$appId,
        [string]$clientSecret
    )

    Write-Log "Starte Authentifizierung..." -Level Info

    try {
        $securePassword = ConvertTo-SecureString $clientSecret -AsPlainText -Force
        $cred = New-Object System.Management.Automation.PSCredential ($appId, $securePassword)

        # Unterdrücke Warnungen, Fehler als terminating erzwingen
        $oldPref = $WarningPreference
        $WarningPreference = "SilentlyContinue"

        Connect-AzAccount -ServicePrincipal -Credential $cred -Tenant $tenantId -ErrorAction Stop

        $context = Get-AzContext -ErrorAction Stop

        $WarningPreference = $oldPref

        Write-Log "Anmeldung erfolgreich!" -Level Success
        return $true
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Log "Authentifizierungsfehler: $errorMessage" -Level Error
        return $false
    }
}

# ----------------------------
# Login-Menü (Schleife, keine Rekursion)
# ----------------------------
function Get-LoginMenu {
    Write-Log "Login-Menü gestartet für Partner-ID-Verknüpfung" -Level Info

    do {
        $tenantId = Read-Host "Geben Sie die Tenant-ID des Kunden ein"
        $appId = Read-Host "Geben Sie die App-ID des SP ein"
        $clientSecret = Read-Host "Geben Sie das Client-Secret ein" -AsSecureString
        $clientSecretPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($clientSecret))

        $success = Connect-ServicePrincipal -tenantId $tenantId -appId $appId -clientSecret $clientSecretPlain
        if (-not $success) {
            Write-Host "`nBitte prüfen Sie Ihre Eingaben und versuchen Sie es erneut.`n" -ForegroundColor Yellow
        }
    } until ($success)
}

# ----------------------------
# Hauptmenü
# ----------------------------
function Get-MainMenu {
    Write-Log "Hauptmenü gestartet." -Level Info
    Write-Host "`nWählen Sie eine Aktion:`n"
    Write-Host "1. Partner ID setzen/verknüpfen (tenant-weit)"
    Write-Host "2. Verknüpfte Partner ID abrufen und prüfen"
    Write-Host "3. Partner ID aktualisieren"
    Write-Host "4. Partner ID entfernen"
    Write-Host "5. Beenden`n"

    $choice = Read-Host "Ihre Auswahl (1-5)"
    switch ($choice) {
        1 { Set-PartnerId }
        2 { Get-PartnerId }
        3 { Update-PartnerId }
        4 { Remove-PartnerId }
        5 { 
            Write-Log "Skript beendet." -Level Info
            exit 
        }
        default {
            Write-Log "Ungültige Auswahl." -Level Warning
            Get-MainMenu
        }
    }
}

# ----------------------------
# Partner-ID Funktionen
# ----------------------------
function Set-PartnerId {
    $partnerId = Read-Host "Geben Sie die Partner ID ein (z. B. eure Microsoft-Partner-ID für Rewards)"
    Write-Log "Verknüpfe Partner-ID $partnerId tenant-weit..." -Level Info
    try {
        New-AzManagementPartner -PartnerId $partnerId -ErrorAction Stop
        Write-Log "Partner-ID $partnerId erfolgreich tenant-weit verknüpft." -Level Success
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Log "Fehler beim Setzen: $errorMessage" -Level Error
    }
    Get-MainMenu
}

function Get-PartnerId {
    Write-Log "Prüfe aktuelle Partner-ID-Verknüpfung..." -Level Info
    try {
        $partner = Get-AzManagementPartner -ErrorAction Stop
        if ($partner -ne $null) {
            Write-Host "`nVerknüpfte Partner-ID: $($partner.PartnerId)`n" -ForegroundColor Green
            Write-Log "Partner-ID abgefragt: $($partner.PartnerId)" -Level Info
        } else {
            Write-Host "`nKeine Verknüpfung gefunden – bitte Partner-ID setzen.`n" -ForegroundColor Yellow
        }
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Log "Fehler beim Abrufen: $errorMessage" -Level Error
    }
    Get-MainMenu
}

function Update-PartnerId {
    $partnerId = Read-Host "Geben Sie die neue Partner ID ein"
    Write-Log "Aktualisiere tenant-weite Partner-ID auf $partnerId..." -Level Info
    try {
        Update-AzManagementPartner -PartnerId $partnerId -ErrorAction Stop
        Write-Log "Partner-ID erfolgreich aktualisiert." -Level Success
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Log "Fehler beim Aktualisieren: $errorMessage" -Level Error
    }
    Get-MainMenu
}

function Remove-PartnerId {
    $partnerId = Read-Host "Geben Sie die Partner ID zum Entfernen ein"
    Write-Log "Entferne tenant-weite Verknüpfung für Partner-ID $partnerId..." -Level Info
    try {
        Remove-AzManagementPartner -PartnerId $partnerId -ErrorAction Stop
        Write-Log "Verknüpfung entfernt." -Level Success
    } catch {
        $errorMessage = $_.Exception.Message
        Write-Log "Fehler beim Entfernen: $errorMessage" -Level Error
    }
    Get-MainMenu
}

# ----------------------------
# Module prüfen / installieren
# ----------------------------
Write-Host $asciiTitle -ForegroundColor Blue
Install-RequiredModule -ModuleName Az.Accounts
Install-RequiredModule -ModuleName Az.ManagementPartner

# ----------------------------
# Start
# ----------------------------
Get-LoginMenu
Get-MainMenu
