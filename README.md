# AzurePartnerLinker

# Azure Service Principal Partner ID Management

Dieses PowerShell-Skript ermöglicht die Verwaltung von Partner IDs für Azure Service Principals. Es umfasst Funktionen zum Setzen, Aktualisieren, Abrufen und Entfernen von Partner IDs. Das Skript bietet auch eine Authentifizierungsmöglichkeit über einen Service Principal, inklusive der Speicherung und des Ladens von Anmeldedaten.

## Voraussetzungen

Bevor Sie das Skript ausführen, stellen Sie sicher, dass folgende Voraussetzungen erfüllt sind:

- **PowerShell**: Installiert auf Ihrem System (idealerweise PowerShell 5.1 oder höher).
- **Azure PowerShell Module**: Das Skript benötigt die Module `Az` und `AzureAD`. Diese werden automatisch installiert, wenn sie nicht vorhanden sind.
- **Berechtigungen**: Der Service Principal, mit dem Sie sich anmelden, benötigt die Berechtigung `Application.ReadWrite.OwnedBy`, um Partner IDs verwalten zu können.

## Installation

1. Klonen Sie dieses Repository oder laden Sie die Skriptdatei herunter.
2. Öffnen Sie PowerShell als Administrator.
3. Führen Sie das Skript aus.

## Verwendung

1. **Authentifizierung**: 
   - Bei der ersten Ausführung werden Sie nach Ihrer Tenant-ID, App-ID und dem Client-Secret gefragt. Sie haben die Möglichkeit, diese Anmeldedaten zu speichern.
   - Bei späteren Ausführungen können Sie gespeicherte Anmeldedaten verwenden.

2. **Menüoptionen**:
   - Wählen Sie eine der folgenden Aktionen:
     - **1**: Partner ID setzen
     - **2**: Verknüpfte Partner ID abrufen
     - **3**: Partner ID aktualisieren
     - **4**: Partner ID entfernen
     - **5**: Beenden

## Funktionen

- `Ensure-Module`: Überprüft und installiert notwendige PowerShell-Module.
- `Save-Credentials`: Speichert die Anmeldedaten in einer JSON-Datei.
- `Load-Credentials`: Lädt die gespeicherten Anmeldedaten aus der JSON-Datei.
- `Authenticate-ServicePrincipal`: Authentifiziert den Benutzer über einen Service Principal.
- `Login-Menu`: Zeigt das Anmelde- und Hauptmenü an.
- `Main-Menu`: Bietet Auswahlmöglichkeiten für die Partner ID-Verwaltung.
- `Set-PartnerId`: Setzt eine neue Partner ID.
- `Get-PartnerId`: Ruft die derzeit verknüpfte Partner ID ab.
- `Update-PartnerId`: Aktualisiert die vorhandene Partner ID.
- `Remove-PartnerId`: Entfernt die angegebene Partner ID.

## Hinweis

Achten Sie darauf, die Anmeldedaten sicher zu speichern und nicht öffentlich zugänglich zu machen. Verwenden Sie dieses Skript nur in einer sicheren Umgebung.

## Lizenz

Dieses Projekt steht unter der MIT-Lizenz - siehe die [LICENSE](LICENSE) Datei für Einzelheiten.
