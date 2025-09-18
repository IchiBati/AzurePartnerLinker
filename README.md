Azure Partner Linker

A PowerShell script for managing the Microsoft Partner ID (MPN ID) linkage on Azure customer tenants.

📖 Description

This script provides a user-friendly menu to connect to an Azure tenant using a Service Principal and then manage the Partner ID association. This is crucial for Microsoft Partners to get credit for their work and be eligible for incentives and rewards. The script handles authentication, module installation, and all relevant Partner ID operations (CRUD: Create, Read, Update, Delete) in an interactive way. A log file is automatically created in the user's home directory ($env:USERPROFILE\azure_script_log.txt) to record all actions.

✨ Features

    Interactive Menus: Simple and clear menus guide the user through the login and management process.

    Service Principal Authentication: Securely connects to the customer's Azure tenant without needing user credentials.

    Automatic Module Check: Automatically checks if the required PowerShell modules (Az.Accounts, Az.ManagementPartner) are installed and installs them if they are missing.

    Comprehensive Partner ID Management:

        Set (link) a new Partner ID.

        Get (view) the currently linked Partner ID.

        Update an existing Partner ID.

        Remove a Partner ID association.

    Logging: All operations are logged with timestamps to a file for easy tracking and debugging.

    User-friendly Feedback: Provides clear success, warning, and error messages with color-coding in the console.

🚀 Getting Started

✅ Prerequisites

    Windows PowerShell 7+

    An Azure Service Principal with the necessary permissions (at least Contributor role) on the target tenant. You will need its App ID, Tenant ID, and Client Secret.

💻 Installation & Execution

    Clone the repository or download the script
    Bash

git clone https://github.com/[Your-Username]/[Your-Repo-Name].git

Navigate to the script directory
PowerShell

cd [Your-Repo-Name]

Run the script
You may need to adjust your script execution policy first.
PowerShell

    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process
    ./azure-partner-admin.ps1 # Or your script's filename

🛠️ Usage

The script is fully interactive. Once started, it will guide you through the necessary steps.

    Authentication:
    The script will first prompt you to enter the credentials for the Service Principal.

        Tenant ID: The Azure Tenant ID of your customer.

        App ID: The Application (client) ID of your Service Principal.

        Client Secret: The secret for your Service Principal.

    Main Menu:
    After a successful login, you will be presented with the main menu where you can choose the desired action.

    Wählen Sie eine Aktion:

    1. Partner ID setzen/verknüpfen (tenant-weit)
    2. Verknüpfte Partner ID abrufen und prüfen
    3. Partner ID aktualisieren
    4. Partner ID entfernen
    5. Beenden

    Simply enter the number corresponding to the action you want to perform and follow the on-screen instructions.

🙌 Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are greatly appreciated.

    Fork the Project

    Create your Feature Branch (git checkout -b feature/AmazingFeature)

    Commit your Changes (git commit -m 'Add some AmazingFeature')

    Push to the Branch (git push origin feature/AmazingFeature)

    Open a Pull Request

📜 License

This project is licensed under the MIT License. See the LICENSE file for more information.
