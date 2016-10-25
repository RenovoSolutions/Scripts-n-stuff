# Creating portable versions of legacy Chrome browsers

### Prerequisites

* Use a VM or something without Chrome installed previously
* Install [chocolatey](https://chocolatey.org/install)
* Note which version of Chrome you need for testing or other purposes

### Steps

1. Go to the [chocolatey page for Chrome](https://chocolatey.org/packages/GoogleChrome)
2. Scroll down to version history
3. Click the appropriate version on the list (example, `54.0.2840.59`)
4. Open an elevated (run as admin) command prompt
5. Run the chocolatey install `choco install googlechrome -version 54.0.2840.59`
..* Make sure you use the appropriate version number
6. After the install completes open `C:\Program Files (x86)\Google\Chrome\Application`
7. You should see a `chrome.exe` and a folder name `54.0.2840.71` or whichever version you chose
8. Copy both the above to a new folder
9. Run the chrome.exe from here to launch the legacy version

### Notes

* These should not update
* These are portable
* You can store them pretty much anywhere
* You can probably do this without a VM but this is the clean approach