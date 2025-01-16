# powershell_azure_vm_troubleshoot

I needed to create a VM that would help me investigate why an azure windows vm randomly rebooted, causing me to have a high severity ticket.

How to Use:
Open PowerShell as Administrator.
Copy and paste the script into the PowerShell window.
Run the script and review the output.

What the Script Does:
Reboot History: Fetches entries from Event ID 1074, 1076 (shutdown/reboot requests), 6005 (system start), 6006 (shutdown event), and 6008 (unexpected shutdown).
Recent Updates: Looks for recent Windows Updates requiring reboots (Event IDs 19, 20, 21).
Scheduled Tasks: Lists scheduled tasks with keywords "shutdown", "reboot", or "restart".
Critical Events: Collects critical errors or kernel power events (Event IDs 41, 6008).
