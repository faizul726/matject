<h1 align="center"><img src="https://raw.githubusercontent.com/faizul726/faizul726.github.io/refs/heads/main/matject-misc/logo.png" height="54px"></img>Matject v3.5.2</h1>

*Last updated: Feb 23, 2025*

</br>

**[💡 How to use?](#-quick-guide)**

[Features](#-features) | [Credits](#-credits) | [Known issues](#%EF%B8%8F-known-issues) | [FAQ](#-faq) | [Changelog](#-changelog)

</br>

<h3 align="center">❌ DO NOT MIRROR/REUPLOAD THIS ANYWHERE! ❌</h3><br>

<br>

> [!WARNING]  
> Versions including v3.5.0 and older ones have a dangerous bug that deletes all user files.  
> The bug has been fixed in v3.5.1.  
>
> **For your safety, you should always use the latest version** and avoid links from Google/YouTube.  
>
> DO NOT use old versions.  
> [github.com/faizul726/matject](https://github.com/faizul726/matject) is the ONLY official source for Matject.

<br>

![matject_1](https://raw.githubusercontent.com/faizul726/faizul726.github.io/main/matject/screenshots/matject_1.png)

| <img src="https://raw.githubusercontent.com/faizul726/faizul726.github.io/main/matject/screenshots/matject_2.png" width="100%"><br><b>Settings</b> | <img src="https://raw.githubusercontent.com/faizul726/faizul726.github.io/main/matject/screenshots/matject_3.png" width="100%"><br><b>Custom paths</b> |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/faizul726/faizul726.github.io/main/matject/screenshots/matject_4.png" width="100%"><br><b>matjectNEXT</b> | <img src="https://raw.githubusercontent.com/faizul726/faizul726.github.io/main/matject/screenshots/matject_5.png" width="100%"><br><b>Restore materials</b> |

</br>

![20250115_183159](https://github.com/user-attachments/assets/740da8aa-0177-482a-a065-4f4f48ac857f)

<p align=center><i>You can also call it Matjet because it's as fast as a jet.<br><code>I know I'm exaggerating...</code></i></p>

<br>

**What?**  
Matject is an **advanced material replacer** that allows users to use Minecraft shaders. It dynamically automates the process of replacing and restoring game files.
 
**How?**  
It uses IObit Unlocker to replace/restore game files since Windows doesn't allow modifying apps.

**Why?**  
**[BetterRenderDragon](https://github.com/ddf8196/BetterRenderDragon/) still doesn't support version above v1.21.2 (as of Feb 21).**  
Windows players who want to try shaders have to replace game files manually which is a pretty time consuming process.  
I made this script so that users don't have to go through the hassle of replacing game files by themselves.

<br>
<hr>
<br>

>[!IMPORTANT]  
> Make sure the shader you're using supports **Windows** and the **game version**.  
> Otherwise, you will see invisible blocks or the game will crash.
> 
> ***You can also enable material-updater in settings to fix invisible blocks.***
>
> * **Non RenderDragon shaders (aka HAL) are not supported.**  
> * You don't need BetterRenderDragon to use Matject.
> * You don't have to open Matject every time for shaders.
> * DO NOT USE Matject on debloated/optimized Windows (Atlas/Revi/Tiny/Chris Titus Tool)
> * Matject ≠ Patched

</br>

## ✨ What's new in v3.5.2?
* Added MIT license
* Improved admin permission detection
* Other minor improvements
* [See full changelog...](#-changelog)

</br><br>


# 💡 Quick Guide

**See [Guide for Beginners](https://faizul726.github.io/matject/docs/guide-for-beginners) for a better explanation.**

<br>

1. Install [IObit Unlocker](https://www.iobit.com/en/iobit-unlocker.php). (don't change its install location)  

![screenshot](https://github.com/user-attachments/assets/4422464e-26a3-4068-993e-adc76817ca9c)

<br>

2. Download code as ZIP.  
Or use `git clone https://github.com/faizul726/matject.git` if you prefer.

3. Extract the ZIP file.
4. Open `matject.bat`.
5. The rest is self explanatory.  

**See 📘 [Detailed Guide](https://faizul726.github.io/matject/docs/guide-for-beginners)**

<br><br>

## 🔄 How to restore to default / uninstall shaders?
> [!TIP]  
> Original files are restored automatically when the game is updated.

1. Open Matject.
2. Go to **[R] Remove Shaders/Tools**.
3. Go to **[1] Restore default materials**
4. Select **[1] Dynamic Restore** or **[2] Full Restore** (full restore takes a bit more time).

</br>

## ⭐ Features
* **Easy to use:** <u>no Command Prompt/Terminal knowledge</u> is required.
* **Fully offline:** Can be used offline. Internet is optionally used to enhance experience.
* **Fast as jet**: Takes less than <u>60 seconds</u> to apply a shader. 
* **Automatic backups:** Backups are made automatically when game is updated.
* **Restore game files:** You can go back to original whenever you want. 
* **Automatic processing:** MCPACK/ZIPs are automatically processed.
* **Auto shader updater:** Shaders can be updated using [material-updater](https://github.com/mcbegamerxx954/material-updater) (also fixes invisible blocks).
* **Auto updater:** Can automatically update itself if you want.
* **Dynamic file replacement:** Keeps track of modified files and restores if needed.
* **Highly customizable:** Adjustments according to your needs can be made in Matject Settings.
* **matjectNEXT:** Applies shaders based on the first activated pack in Global Resource Packs.

</br><br>

## 🤝 Credits
* **[IObit Unlocker](https://www.iobit.com/en/iobit-unlocker.php)** (backbone of Matject)
* **[@mcbegamerxx954](https://github.com/mcbegamerxx954/)** (for [material-updater](https://github.com/mcbegamerxx954/material-updater) and speed improvements)
* **[jq](https://jqlang.github.io/jq)** (used to process JSON files for matjectNEXT)
* **[@jcau8](https://github.com/jcau8)** (critical bug fixes)
* **[@Veka0](https://github.com/Veka0)** (material compatibility checker)


**Honorable Mentions**  
People of [YSS](https://discord.gg/UJdvR6WBAe) and [Newb Community](https://faizul726.github.io/newb-discord) for their humble support.  

[@TrngN0786](https://x.com/TrngN0786) and [@Theffyxz](https://github.com/Theffyxz) for helping me to fix bugs.  
[@Sharkitty](https://github.com/Sharkitty), [@FlaredRoverCodes](https://github.com/FlaredRoverCodes) and all other people who tested and gave feedback.

</br>

> [!TIP]  
> **Need help?**  
> Join [Newb Discord server](https://faizul726.github.io/newb-discord) and send message in `#newb-support`. I will be happy to assist you.
> You can also ask for help in [YSS Discord Server -> #windows](https://discord.gg/UJdvR6WBAe) or [Bedrock Graphics -> #matject](https://discord.gg/XrQhnTP89R)

</br>

## ⚠️ Known issues
* Doesn't support long folder path and too many shader files.
* Antivirus may prevent IObit Unlocker from working. (AVG and Norton are known to do this)
* Some shaders crash. It's not an issue of Matject.

</br>

## 🤔 FAQ
**Q. What is matjectNEXT?**  
A. matjectNEXT is an advanced version of Matject that replaces materials based on the pack the user has set in Global Resource Packs, with help of **[jq](https://jqlang.github.io/jq)**.  
Inspired by [Draco](https://github.com/mcbegamerxx954/draco-injector) which is made by [@mcbegamerxx954](https://github.com/mcbegamerxx954/).

**Q. How is this different from [BetterRenderDragon](https://github.com/ddf8196/BetterRenderDragon/)?**  
A. BetterRenderDragon uses *memory injection*, all the changes are made in memory and those don't persist. You have to open BRD each time to use shaders.  
*It's not universal, so BRD devs have to update it for newer Minecraft versions to make it work.*  
Changes made by Matject will stay until Minecraft is updated or user restores default materials from Matject.  
It's mostly universal, so it should work with any Minecraft version.

**Q. Virus?**  
A. Well, depends on you. (2) `(hint: it's not.)`

**Q. Does it require internet to work?**  
A. No, internet is optionally used to enhance user experience
* To check for updates and show the changelog. Updating is optional.
* To show Matject announcements
* To get [jq](https://jqlang.github.io/jq) by itself (for matjectNEXT).  
* To get [material-updater](https://github.com/mcbegamerxx954/material-updater) by itself.  

**Q. I have questions/need help.**  
A. Join [Newb Discord Server](https://faizul726.github.io/newb-discord) and send message in `#newb-support`. I will try to help.  


**Q. What folders does it access?**  
<details closed>
<summary>A. It accesses the following folders: </summary>

> ###### READ only:
> - `%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker` (backbone of Matject)
> - Minecraft app location. *Which is obtained using this PowerShell command:*
> ```powershell
> (Get-AppxPackage -Name Microsoft.Minecraft*).InstallLocation
> ```
> - `%LOCALAPPDATA%\Packages\Microsoft.Minecraft*_8wekyb3d8bbwe\LocalState\games\com.mojang\minecraftpe\global_resource_packs.json` (for matjectNEXT)
> - `%LOCALAPPDATA%\Packages\Microsoft.Minecraft*_8wekyb3d8bbwe\LocalState\games\com.mojang\resource_packs\*` (for matjectNEXT)
> - `.settings` `Backups\*` `Backups (Preview)\*` `logs` `MATERIALS` `MCPACKS` `modules\*` `tmp`
> - `Custom paths: Minecraft app, data, IObit Unlocker`
>
> ###### READ and WRITE:
> - `%ProgramFiles%\WindowsApps` (to unlock WindowsApps)
> - `%ProgramFiles%\WindowsApps\Microsoft.Minecraft*_*_*__8wekyb3d8bbwe\data\renderer\materials`
> - `%LOCALAPPDATA%\Packages\Microsoft.Minecraft*_8wekyb3d8bbwe\LocalState\games\com.mojang\minecraftpe\global_resource_packs.json` (to reset global packs)
> - `.settings` `Backups\*` `Backups (Preview)\*` `logs` `MATERIALS` `modules` `tmp`
> - `Custom paths: Minecraft app, data`

</details>
</br>

**Q. মুরগি কি ধান খায়?** 🐓  
A. হ, খায়।

</br><br>


## Donate
**Matject is free,** and it always will be.

If you genuinely like Matject, you can [donate](https://faizul726.github.io/matject/docs/donate) to support its development.  
You can still show your support by giving a star to this project :)

<br><br>

## 🕓 Changelog
<!--TEMPLATE

<details open><summary><b>v3.5.patch - month day, 2025</b></summary>
<ul>
  <li>placeholder</li>
  <li>placeholder</li>
  <li>placeholder</li>
  <li>placeholder</li>
  <li>placeholder</li>
  <li>placeholder</li>
  <li>placeholder</li>
  <li>placeholder</li>
  <li>placeholder</li>
  <li>placeholder</li>
</ul>
</br>
</details>

-->

<details open><summary><b>v3.5.2 - Feb 21, 2025</b></summary>
<ul>
  <li>Fixed WindowsApps unlock failure</li>
  <li>Fixed Minecraft Preview backup handling</li>
  <li>Auto closing for IObit Unlocker no longer shows a separate window</li>
  <li>Shortcuts can now open Matject in Windows Terminal</li>
  <li>Added notification sound in some confirmation screens</li>
  <li>Added a setting to force using PowerShell for extracting ZIPs</li>
  <li>Added 10 new Matject tips</li>
  <li>Added MIT license</li>
  <li>Improved Matject opening behavior</li>
  <li>Improved admin permission detection</li>
  <li>Improved shortcut creation/deletion</li>
  <li>Minor UI improvements</li> 
</ul>
</br>
</details>


<details><summary><b>v3.5.1 - Feb 02, 2025</b></summary>
<ul>
  <li>Fixed a CRITICAL BUG that deletes all user files.</li>
  <li>Added module verification to ensure reliability.</li>
  <li>Matject no longer runs when tried to run without extracting.</li>
  <li>Matject now uses more "specific" locations.</li>
  <li>Fixed an issue with Matject updater.</li>
  <li>Fixed an issue with full restore.</li>
  <li>Other minor changes.</li>
</ul>
</br>
</details>


<details><summary><b>v3.5.0 - Jan 15, 2025</b></summary>
<ul>
  <li>Added Matject updater.</li>
  <li>Added multiple MCPACK/ZIP support for MCPACKS folder.</li>
  <li>Added Matject tips.</li>
  <li>Added "Show announcements" setting.</li>
  <li>Added "Disable tips" setting.</li>
  <li>Added "Run Matject as admin always" setting.</li>
  <li>Added "Run IObit Unlocker as admin" setting to reduce admin permission requests.</li>
  <li>Added manifest checker for matjectNEXT.</li>
  <li>Added more bugs to fix later.</li>
  <li>Auto mode now shows last MCPACK and subpack name.</li>
  <li>Restore screen now shows restore date.</li>
  <li>ZIPs now can also be opened as MCPACK.</li>
  <li>IObit Unlocker messages are now automatically closed when Matject is run as admin.</li>
  <li>Getting Minecraft details is now faster.</li>
  <li>First run now asks to download material-updater.</li>
  <li>curl should no longer be able to execute using variables.</li>
  <li>Fixed a math related issue with update checker.</li>
  <li>Fixed a issue with how MCPACKs are processed <code>Thanks to raden</code></li>
  <li>Cursor is now hidden where it's not needed.</li>
  <li>Some UI improvements.</li>
</ul>
</br>
</details>


<details><summary><b>v3.4.0 - Dec 23, 2024</b></summary>
<ul>
  <li>Added subpack support for auto method.</li>
  <li>Added zipped materials support for auto method.</li>
  <li>Added new settings: Don't open folder automatically.</li>
  <li>Added loading text (not everywhere)</li>
  <li>Added reset settings option.</li>
  <li>Added Drop to shell (needs debug mode)</li>
  <li>Can now make shortcuts.</li>
  <li>New icon if using shortcut.</li>
  <li>Optimized folder opening.</li>
  <li>Optimized update checker.</li>
  <li>Should no longer cause crashes when folder name contains space.</li>
  <li>Should no longer fully exit if something goes wrong.</li>
  <li>Preview mode now is automatically disabled when not installed.</li>
  <li>Other minor changes.</li>
</ul>
</br>
</details>


<details><summary><b>v3.3.0 - Dec 10, 2024</b></summary>
<ul>
  <li>Added Minecraft Preview support.</li>
  <li>matjectNEXT now can be used without DEBUG MODE.</li>
  <li>Improved matjectNEXT functionality.</li>
  <li>Improved extract speed by using <code>tar</code>.</li>
  <li>Improved settings functionality.</li>
  <li>Improved backup ZIP check.</li>
  <li>Fixed Dynamic Restore comparison.</li>
  <li>Fixed OLDVERSION variable.</li>
  <li>Delete Backups folder if empty.</li>
  <li>Other minor changes.</li>
</ul>
</br>
</details>

<details><summary><b>v3.2.2 - Dec 06, 2024</b></summary>
<ul>
  <li>Added custom Minecraft launcher support (thanks to <a href=https://x.com/TrngN0786>@TrngN0786</a>)</li>
  <li>Added custom Minecraft data path support</li>
  <li>Added custom IObit Unlocker path support</li>
  <li>Added interruption check</li>
  <li>Added restore confirmation</li>
  <li>Added an easter egg</li>
  <li>Update checker now shows the changelog</li>
  <li>Fixed colors in some texts</li>
  <li>Fixed RESTORELIST variable (thanks to <a href=https://x.com/TrngN0786>@TrngN0786</a>)</li>
  <li>Fixed Minecraft app path and Just sync and exit toggle</li>
  <li>Other minor bug fixes</li>
</ul>
</br>
</details>

<details><summary><b>v3.2.1 - Dec 04, 2024</b></summary>
<ul>
  <li>Fixed matjectNEXT unable to find pack path (once again thanks to <a href=https://github.com/jcau8>@jcau8</a>)</li>
  <li>Added compatibility check for materials (thanks to <a href=https://github.com/Veka0>@Veka0</a>)</li>
  <li>Revamped settings page with tabs</li>
  <li>Several small improvements to functionality</li>
  <li>Added development_resource_packs support (matjectNEXT)</li>
  <li>Improved MCPACK detection</li>
  <li>Added the ability to replace backup using ZIP file (Restore & Others)</li>
</ul>
</br>
</details>

<details><summary><b>v3.2.0 - Nov 26, 2024</b></summary>
<ul>
  <li>Added matjectNEXT.</li>
  <li>Fixed writing on encrypted drives. (thanks to <a href=https://github.com/jcau8>@jcau8</a>)</li>
  <li>Added curl check.</li>
  <li>Renamed Partial Restore to Dynamic Restore.</li>
  <li>Improved Dynamic Restore speed.</li>
  <li>Fixed some typos.</li>
  <li>Other minor bug fixes.</li>
</ul>
</br>
</details>

<details><summary><b>v3.1.0 - Nov 18, 2024</b></summary>
<ul>
  <li>Bump version.</li>
  <li>Fix credit names <a href=https://github.com/faizul726/matject/pull/4>PR #4</a>.</li>
</ul>
</br>
</details>

<details><summary><b>v3.0.3 - Nov 16, 2024</b></summary>
<ul>
  <li>Added update checker (thanks to <a href=https://github.com/jcau8>@jcau8</a>).</li>
  <li>Moved variables to variables.bat.</li>
  <li>Fixed some typos.</li>
  <li>Delete backup date file after full restore.</li>
  <li>Added GitHub link in others.</li>
  <li>Changed <code>pushd</code> to <code>cd /d</code>.</li>
</ul>
</br>
</details>

<details><summary><b>v3.0.2 - Nov 15, 2024</b></summary>
<ul>
  <li>Fixed directory changing and unlockWindowsApps (thanks to <a href=https://github.com/Theffyxz>@Theffyxz</a>).</li>
  <li>Added update checker module as a placeholder.</li>
  <li>Added credits section in README.</li>
</ul>
</br>
</details>

<details><summary><b>v3.0.1 - Nov 13, 2024</b></summary>
<ul>
  <li>Fixed unlockWindowsApps not saving result.</li>
  <li>Updated "about" details.</li>
  <li>Semantic Versioning (something that I still don't understand properly).</li>
</ul>
</br>
</details>

<details>
  <summary><b>v3.0 - Nov 06, 2024</b></summary>
  <ul>
    <li>Fixed partial restore.</li>
    <li>Added <a href=https://github.com/mcbegamerxx954/material-updater>material-updater</a> support.</li>
    <li>Added help (but not helpful).</li>
    <li>Added settings.</li>
    <li>Added date for backup.</li>
    <li>Added the ability to open MCPACK automatically after injection.</li>
    <li>Added first run message.</li>
    <li>Made backup mandatory.</li>
    <li>Improved home screen.</li>
    <li>Only accept <code>*.material.bin</code> files.</li>
    <li>Removed <code>openMinecraftFolder.bat</code> and added it as a separate option.</li>
  </ul>
</br>
</details>

<details><summary><b>v2.5 - Oct 20, 2024</b></summary>
<ul>
  <li>Added colored texts.</li>
  <li>Removed settings.bat placeholder as it's not required before v3.0.</li>
</ul>
</br>
</details>

<details><summary><b>v2.0</b></summary>
<ul>
  <li>Much more user-friendly than before.</li>
  <li>Dynamically finds Minecraft location.</li>
  <li>Skips questions if user meets requirements.</li>
  <li>Prompts to delete backup if it detects a different Minecraft version.</li>
  <li>Restores vanilla shaders <strong>(BETA)</strong>.</li>
  <li>Shows error if user declines UAC and asks again.</li>
  <li>Automatically opens MCPACK/MATERIALS folder for user to put files.</li>
  <li>Extracts materials from user-provided MCPACK/ZIP (still can't detect if it's an RD shader).</li>
  <li>Dynamically restores <strong>only</strong> modified bins from previous inject to ensure consistency among different shaders <strong>(BETA)</strong> (works only if user has made a backup before).</li>
  <li>Added <code>settings.bat</code> for tweaking options (WIP).</li>
  <li>Added <code>openMinecraftFolder.bat</code> to open the Minecraft folder.</li>
  <li>Simplified <code>WindowsApps</code> unlock procedure; now it unlocks instantly.</li>
</ul>
</br>
</details>

<details><summary><b>v1.0</b></summary>
<ul><li>Initial release.</li></ul>
</details>