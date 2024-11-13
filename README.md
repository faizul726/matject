# Matject v3.0.1
*Last updated: Nov 13, 2024*

**[How to use?](#how-to-use) | [Known issues](#known-issues) | [FAQ](#faq) | [Changelog](#changelog)**

### What?
Matject is a material replacer that allows users to use Minecraft shaders. It automates the process of replacing and restoring game files.

### How?
It uses IObit Unlocker to replace/restore game files since Windows doesn't normally allow modifying apps.

### Why?
[BetterRenderDragon](https://github.com/ddf8196/BetterRenderDragon/) still doesn't support version above v1.21.2 (as of Nov 13).  
Windows players who want to try shaders have to replace game files manually which is a pretty time consuming process.  
So, I made this script so users don't have to go through the hassle of replacing game files by themselves.

<br>

>[!IMPORTANT]  
> Before you complain about game crashing/invisible blocks, make sure the shader you're using supports **Windows** and the **game version**.  
> 
> *You can also enable material-updater in settings to fix invisible blocks*

<br>

## What's new in v3.0.1?
See [Changelog](#changelog).

<br>

## Features
* Easy to use.
* Takes less than 2 minutes to use a shader.
* Uses [material-updater](https://github.com/mcbegamerxx954/material-updater) to update outdated materials. (not enabled by default)
* Dynamically replace game files.
* Automatically process provided MCPACK/ZIP file.
* Backup/restore game files.
* Detect Minecraft version changes and adjust according to that.

<br><br>

Thanks to **[Sharkitty](https://github.com/Sharkitty) , anonymous_user8** and all other people who tested and gave feedback.

> [!TIP]  
> Need help? Join [YSS Discord server](https://discord.gg/yss) and send message in `#windows`. I will be happy to assist you.

<br>

## How to use?

1. Install [IObit Unlocker](https://www.iobit.com/en/iobit-unlocker.php). (don't change its install location)

![image](https://github.com/user-attachments/assets/4422464e-26a3-4068-993e-adc76817ca9c)

2. Download code as ZIP.

3. Extract the ZIP file.
4. Open `matject.bat`.
5. Further instructions will be there. Follow them.
<br>

### How to restore to default?
> [!TIP]  
> Original files will be restored automatically after the game is updated.

1. Open `restoreVanillaShaders.bat`.
2. Select **Full restore (restore all materials)**.

<br>

## Known issues
* Doesn't support long folder path and too many user provided shader files.

<br>

## FAQ
**Q. How is this different from [BetterRenderDragon](https://github.com/ddf8196/BetterRenderDragon/)?**  
A. BetterRenderDragon uses far more superior 'memory injection', all the changes are made in memory and those don't persist. You have to open BRD each time to use shaders. It's not universal, so BRD devs have to update it for newer Minecraft versions to make it work.  
Changes made by Matject persists until next update. It's mostly universal, so it will work with any Minecraft version.

**Q. Virus?**  
A. Well, depends on you. (2)

**Q. Does it require internet?**  
A. ~~It doesn't. It runs fully offline.~~ Starting from v3.0 Matject can use internet if user decides to download [material-updater](https://github.com/mcbegamerxx954/material-updater) within the window.

**Q. What folders does it access? (OUTDATED)**  
A. It accesses the following folders:  
> ###### READ only:
> - `%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker` (backbone of Matject)
> - `%ProgramFiles%\WindowsApps` (to unlock WindowsApps)
> - Minecraft app location. *Which is obtained using this PowerShell command:*
> ```powershell
> Get-AppxPackage -Name Microsoft.MinecraftUWP | Select-Object -ExpandProperty InstallLocation
> ```
> - `%~dp0\.settings` `%~dp0\MATERIALS` `%~dp0\materials.bak` `%~dp0\MCPACK` `%~dp0\tmp` (**%~dp0** means script location)
>
> ###### READ and WRITE:
> - `Minecraft app location\data\renderer\materials`
> - `%~dp0\.settings` `%~dp0\MATERIALS` `%~dp0\materials.bak` `%~dp0\tmp`

</br>

**Q. মুরগি কি ধান খায়?** 🐓  
A. হ, খায়।


<br>

## Changelog
<details open><summary><b>v3.0.1 - Nov 13, 2024</summary>
<ul>
  <li>Fix unlockWindowsApps not saving result</li>
  <li>Updated "about" details</li>
  <li>Semantic Versioning (something that I still don't understand properly)
</ul>
</br>
</details>

<details>
  <summary><b>v3.0 - Nov 06, 2024</b></summary>
  <ul>
    <li>Fix dynamic restore</li>
    <li>Added <a href=https://github.com/mcbegamerxx954/material-updater>material-updater</a> support</li>
    <li>Added help (but not helpful)</li>
    <li>Added settings</li>
    <li>Added date for backup</li>
    <li>Added the ability to open MCPACK automatically after injection</li>
    <li>Added first run message</li>
    <li>Made backup mandatory</li>
    <li>Improved home screen</li>
    <li>Only accept <code>.material.bin</code> files</li>
    <li>Removed <code>openMinecraftFolder.bat</code> and added it as a separate option</li>
  </ul>
  <br>
</details>
<details> 
<summary><b>v2.5 - Oct 20, 2024</b></summary>
<ul>
  <li>Add colored texts.</li>
  <li>Removed settings.bat placeholder as it's not required before v3.0.</li>
</ul>
  <br>
</details>

<details>
<summary><b>v2.0</b></summary>
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
  <br>
</details>

<details><summary><b>v1.0</b></summary>
<ul><li>Initial release.</li></ul>
</details>
