# PmOne - Azure Partner Linker

![PowerShell](https://img.shields.io/badge/Powershell-v7%2B-blue?logo=powershell)
![Azure](https://img.shields.io/badge/Azure-ManagementPartner-blue?logo=microsoft-azure)

> Ein interaktives PowerShell-Skript zur tenantweiten Verwaltung von Microsoft Partner-IDs in Azure. Es erlaubt Setzen, Prüfen, Aktualisieren und Entfernen der Partner-ID via Service Principal Login.


![Screenshot](/example.png)


---

## 📝 Inhaltsverzeichnis

- [Funktionen](#funktionen)
- [Anforderungen](#anforderungen)
- [Installation](#installation)
- [Benutzung](#benutzung)
- [Beispiel](#beispiel)
- [Troubleshooting](#troubleshooting)
- [Lizenz](#lizenz)

---

## ⚙️ Funktionen

- **Interaktive Konsolenmenüs** für alle Aktionen
- **Service Principal Authentifizierung** (sicher, keine Benutzerinteraktion bei automatisierbarer Anmeldung)
- **Partner-ID tenantweit setzen, überprüfen, updaten und entfernen**
- **Detailiertes, farbiges Logging** (inkl. Logfile unter `$env:USERPROFILE\azure_script_log.txt`)
- Prüft und installiert erforderliche Azure-Module vollautomatisch
- Fehlerbehandlung mit klaren Fehlermeldungen

---

## 🧩 Anforderungen

- **Betriebssystem:** Windows (Powershell 7.x)
- **Azure PowerShell Module:** 
  - `Az.Accounts`
  - `Az.ManagementPartner`
- **Berechtigungen:** Service Principal mit Berechtigung auf Tenant-Ebene  
  (zur Verwaltung von Partner-IDs)

---

## 🔧 Installation

1. **Klonen** Sie das Repository:
    ```powershell
    git clone https://github.com/IchiBati/AzurePartnerLinker.git
    ```

2. **Skript starten:**  
    ```powershell
    .\AzurePartnerLinker.ps1
    ```

Das Skript prüft automatisch, ob die benötigten Module vorhanden (oder als lokale Bundles bereitgestellt) sind und installiert/importiert diese bei Bedarf.

---

## 🚀 Benutzung

1. **Service Principal Login**:  
   Sie werden nach Tenant ID, App ID und Secret gefragt.
   > **Hinweis:** Die SP muss `Az.ManagementPartner` Aktionen ausführen dürfen.

2. **Menüauswahl**:  
   Nach erfolgreicher Anmeldung erscheint das Hauptmenü mit:
   - Partner ID setzen/verknüpfen
   - Verknüpfte Partner ID prüfen
   - Partner ID aktualisieren
   - Partner ID entfernen
   - Beenden

3. **Log-Vorgänge:**  
   Alle Vorgänge und Fehler werden auch nach `$env:USERPROFILE\azure_script_log.txt` geschrieben.

---

## 🖼️ Beispiel


```text
Geben Sie die Tenant-ID des Kunden ein: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Geben Sie die App-ID des SP ein: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
Geben Sie das Client-Secret ein: ******
ℹ️  Anmeldung erfolgreich!

Wählen Sie eine Aktion:
1. Partner ID setzen/verknüpfen (tenant-weit)
2. Verknüpfte Partner ID abrufen und prüfen
...
```
---

## ❔ Troubleshooting

- **Fehler bei Modul-Installation:**  
  Stellen Sie sicher, dass Ihr Benutzer PowerShell-Module installieren darf (`Set-ExecutionPolicy`) und eine aktive Internetverbindung besteht.

- **Authentifizierungsfehler:**  
  Überprüfen Sie Tenant ID, App ID, Client Secret sowie die Berechtigungen des Service Principals.

- **Modul-Konflikte:**  
  Entfernen Sie veraltete `AzureRM`-Module. Diese werden **nicht** unterstützt und können zu Konflikten führen.

- **Unbekannte Fehler:**  
  Sichten Sie die detaillierten Log-Einträge in der Datei  
  `%USERPROFILE%\azure_script_log.txt`  
  für weitere Hinweise.
     



📜 Lizenz 

Dieses Skript/Projekt steht unter der MIT-Lizenz . 
