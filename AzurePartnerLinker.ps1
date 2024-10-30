# Funktion zur Installation und Prüfung des Moduls
function Ensure-Module {
    param (
        [string]$ModuleName
    )
    if (-not (Get-Module -ListAvailable -Name $ModuleName)) {
        Write-Host "Das Modul $ModuleName ist nicht installiert. Installation wird durchgeführt..." -ForegroundColor Yellow
        Install-Module -Name $ModuleName -AllowClobber -Force -Scope CurrentUser
    }
    Import-Module $ModuleName -ErrorAction Stop
    Write-Host "Modul $ModuleName wurde erfolgreich geladen." -ForegroundColor Green
}

# Funktion zum Speichern der Anmeldedaten
function Save-Credentials {
    param (
        [string]$tenantId,
        [string]$appId,
        [string]$clientSecret
    )

    $credentials = @{
        TenantId = $tenantId
        AppId = $appId
        ClientSecret = $clientSecret
    }

    # Pfad zur Datei, in der die Anmeldedaten gespeichert werden
    $filePath = "$env:USERPROFILE\service_principal_credentials.json"

    # Anmeldedaten als JSON speichern
    $credentials | ConvertTo-Json | Set-Content -Path $filePath -Force
    Write-Host "Anmeldedaten erfolgreich gespeichert." -ForegroundColor Green
}

# Funktion zum Laden der gespeicherten Anmeldedaten
function Load-Credentials {
    $filePath = "$env:USERPROFILE\service_principal_credentials.json"

    if (Test-Path $filePath) {
        $credentials = Get-Content -Path $filePath | ConvertFrom-Json
        return $credentials
    }
    return $null
}

# Funktion zur Authentifizierung mit Service Principal
function Authenticate-ServicePrincipal {
    param (
        [string]$tenantId,
        [string]$appId,
        [string]$clientSecret
    )

    try {
        $securePassword = ConvertTo-SecureString $clientSecret -AsPlainText -Force
        $cred = New-Object System.Management.Automation.PSCredential ($appId, $securePassword)
        Connect-AzAccount -ServicePrincipal -Credential $cred -Tenant $tenantId -ErrorAction Stop

        # Überprüfen, ob die Verbindung erfolgreich war
        $context = Get-AzContext
        if ($context -ne $null) {
            Write-Host "Erfolgreich bei Azure als Service Principal angemeldet." -ForegroundColor Green
            return $true
        } else {
            Write-Host "Die Verbindung konnte nicht hergestellt werden." -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "Fehler bei der Anmeldung: $_" -ForegroundColor Red
        return $false
    }
}

# Funktion für das Login-Menü
function Login-Menu {
    Write-Host "Willkommen zum Azure Login Menü" -ForegroundColor Cyan
    # Frage, ob gespeicherte Anmeldedaten verwendet werden sollen
    $useSavedCredentials = Read-Host "Möchten Sie gespeicherte Anmeldedaten verwenden? (Ja/Nein)"
    
    if ($useSavedCredentials -eq "Ja") {
        $credentials = Load-Credentials
        if ($credentials -ne $null) {
            $tenantId = $credentials.TenantId
            $appId = $credentials.AppId
            $clientSecret = $clientSecret = ConvertTo-SecureString -String $credentials.ClientSecret -AsPlainText -Force

            $clientSecretPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($clientSecret))
        } else {
            Write-Host "Keine gespeicherten Anmeldedaten gefunden." -ForegroundColor Red
            $tenantId = Read-Host "Geben Sie die Tenant-ID ein"
            $appId = Read-Host "Geben Sie die App-ID ein"
            $clientSecret = Read-Host "Geben Sie das Client-Secret ein" -AsSecureString
            $clientSecretPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($clientSecret))
        }
    } else {
        $tenantId = Read-Host "Geben Sie die Tenant-ID ein"
        $appId = Read-Host "Geben Sie die App-ID ein"
        $clientSecret = Read-Host "Geben Sie das Client-Secret ein" -AsSecureString
        $clientSecretPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($clientSecret))
    }

    # Authentifizierung durchführen
    if (Authenticate-ServicePrincipal -tenantId $tenantId -appId $appId -clientSecret $clientSecretPlain) {
        $saveCredentials = Read-Host "Möchten Sie die Anmeldedaten speichern? (Ja/Nein)"
        if ($saveCredentials -eq "Ja") {
            Save-Credentials -tenantId $tenantId -appId $appId -clientSecret $clientSecretPlain
        }
        Main-Menu
    }
    else {
        Write-Host "Anmeldung fehlgeschlagen. Bitte versuchen Sie es erneut." -ForegroundColor Red
        Login-Menu
    }
}

# Hauptmenü für die Auswahl
function Main-Menu {
    Write-Host "Wählen Sie eine Aktion:" -ForegroundColor Cyan
    Write-Host "1. Partner ID setzen"
    Write-Host "2. Verknüpfte Partner ID abrufen"
    Write-Host "3. Partner ID aktualisieren"
    Write-Host "4. Partner ID entfernen"
    Write-Host "5. Beenden"

    $choice = Read-Host "Ihre Auswahl (1-6)"
    switch ($choice) {
        #1 { Get-AppRegistration }
        1 { Set-PartnerId }
        2 { Get-PartnerId }
        3 { Update-PartnerId }
        4 { Remove-PartnerId }
        5 { exit }
        default {
            Write-Host "Ungültige Auswahl, bitte erneut versuchen." -ForegroundColor Red
            Main-Menu
        }
    }
}

# Funktionen für die verschiedenen Optionen
function Get-AppRegistration {
    $appName = Read-Host "Geben Sie den Namen der App-Registrierung ein"
    try {
        $app = Get-AzADApplication -DisplayName $appName
        Write-Host "App-Registrierung gefunden:" -ForegroundColor Green
        Write-Output $app
    }
    catch {
        Write-Host "Fehler beim Abrufen der App-Registrierung: $_" -ForegroundColor Red
    }
    Main-Menu
}

function Set-PartnerId {
    $partnerId = Read-Host "Geben Sie die Partner ID ein"
    try {
        New-AzManagementPartner -PartnerId $partnerId
        Write-Host "Partner ID erfolgreich gesetzt." -ForegroundColor Green
    }
    catch {
        Write-Host "Fehler beim Setzen der Partner ID: $_" -ForegroundColor Red
    }
    Main-Menu
}

function Get-PartnerId {
    try {
        $partner = Get-AzManagementPartner
        Write-Host "Verknüpfte Partner ID:" -ForegroundColor Green
        Write-Output $partner
    }
    catch {
        Write-Host "Fehler beim Abrufen der Partner ID: $_" -ForegroundColor Red
    }
    Main-Menu
}

function Update-PartnerId {
    $partnerId = Read-Host "Geben Sie die neue Partner ID ein"
    try {
        Update-AzManagementPartner -PartnerId $partnerId
        Write-Host "Partner ID erfolgreich aktualisiert." -ForegroundColor Green
    }
    catch {
        Write-Host "Fehler beim Aktualisieren der Partner ID: $_" -ForegroundColor Red
    }
    Main-Menu
}

function Remove-PartnerId {
    $partnerId = Read-Host "Geben Sie die Partner ID zum Entfernen ein"
    try {
        Remove-AzManagementPartner -PartnerId $partnerId
        Write-Host "Partner ID erfolgreich entfernt." -ForegroundColor Green
    }
    catch {
        Write-Host "Fehler beim Entfernen der Partner ID: $_" -ForegroundColor Red
    }
    Main-Menu
}

# Vorbereitende Schritte: Installation und Prüfung der Module
Ensure-Module -ModuleName "Az"
Ensure-Module -ModuleName "AzureAD"

# Authentifizierungsmenü starten
Login-Menu
