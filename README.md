# Matject v3.2.2
*Last updated: Dec 06, 2024*

</br>

**[How to use?](#how-to-use) | [Features](#features) | [Credits](#credits) | [Known issues](#known-issues) | [FAQ](#faq) | [Changelog](#changelog)**

</br>

![image](https://github.com/user-attachments/assets/c7b11840-a5b0-40b7-9957-a2a1debcebe2)
![image](https://github.com/user-attachments/assets/b8fdc436-ab01-4ef0-bf69-fa2d9194d195)

</br>

### What?
Matject is an **advanced material replacer** that allows users to use Minecraft shaders. It dynamically automates the process of replacing and restoring game files.

### How?
It uses IObit Unlocker to replace/restore game files since Windows doesn't normally allow modifying apps.

### Why?
**[BetterRenderDragon](https://github.com/ddf8196/BetterRenderDragon/) still doesn't support version above v1.21.2 (as of Dec 06).**  
Windows players who want to try shaders have to replace game files manually which is a pretty time consuming process.  
I made this script so that users don't have to go through the hassle of replacing game files by themselves.

</br>

>[!IMPORTANT]  
> Before you complain about game crashing/invisible blocks, make sure the shader you're using supports **Windows** and the **game version**.  
> 
> ***You can also enable material-updater in settings to fix invisible blocks.***
>
> **Non RenderDragon shaders (aka HAL) are not supported.**

</br>

## What's new in v3.2.2?
* Added custom Minecraft launcher support (thanks to [@TrngN0786](https://x.com/TrngN0786)) 
* [See full changelog](#changelog)

</br>

## Features
* Easy to use.
* Automatically inject shaders based on Global Resource Packs (matjectNEXT).
* Takes less than **60 seconds** to apply a shader.
* Uses [material-updater](https://github.com/mcbegamerxx954/material-updater) to update outdated materials. (not enabled by default)
* Dynamically replace game files. *saving you a lot of time*
* Automatically process provided MCPACK/ZIP file.
* Backup/restore game files.
* Many useful options in settings.
* Detect Minecraft version changes and adjust according to that.

</br>

## Credits
* **[IObit Unlocker](https://www.iobit.com/en/iobit-unlocker.php)** (backbone of Matject)
* **[jq](https://jqlang.github.io/jq)** (used to process JSON files for matjectNEXT)
* **[material-updater by @mcbegamerxx954](https://github.com/mcbegamerxx954/material-updater)** (used to update materials)  
* **[@jcau8](https://github.com/jcau8)** (critical bug fixes)
* **[@Veka0](https://github.com/Veka0)** (material compatibility checker)


**Honorable Mentions**  
People of [YSS](https://discord.gg/years-static-shader-group-738688684223889409) and [Newb Community](https://discord.gg/newb-community-844591537430069279) for their humble support.  

[@TrngN0786](https://x.com/TrngN0786) and [@Theffyxz](https://github.com/Theffyxz) for helping me to fix bugs.  
[@Sharkitty](https://github.com/Sharkitty), [@FlaredRoverCodes](https://github.com/FlaredRoverCodes) and all other people who tested and gave feedback.

</br>

> [!TIP]  
> Need help?  
> Join [YSS Discord server](https://discord.gg/years-static-shader-group-738688684223889409) and send message in `#windows`. I will be happy to assist you.

</br>

## How to use?

1. Install [IObit Unlocker](https://www.iobit.com/en/iobit-unlocker.php). (don't change its install location)

![screenshot](https://github.com/user-attachments/assets/4422464e-26a3-4068-993e-adc76817ca9c)

2. Download code as ZIP.

3. Extract the ZIP file.
4. Open `matject.bat`.
5. The rest is self explanatory.

</br>

### How to restore to default?
> [!TIP]  
> Original files will be restored automatically after the game is updated.

1. Open Matject.
2. Go to **[R] Restore & Others**.
3. Go to **[1] Restore default materials**
4. Select **Dynamic Restore** or **Full Restore** (full restore takes a bit more time).

</br>

## Known issues
* Some terms may be a bit too technical. Suggestions are appreciated.
* Doesn't support manifests with // or /**/ comments (matjectNEXT).
* Doesn't support long folder path and too many shader files.

</br>

## FAQ
**Q. What is matjectNEXT?**  
A. matjectNEXT is an advanced version of Matject that replaces materials based on the pack the user has set in Global Resource Packs, with help of **[jq](https://jqlang.github.io/jq)**.  
*Inspired by [Draco](https://github.com/mcbegamerxx954/draco-injector) by @mcbegamerxx954*.

**Q. How is this different from [BetterRenderDragon](https://github.com/ddf8196/BetterRenderDragon/)?**  
A. BetterRenderDragon uses *memory injection*, all the changes are made in memory and those don't persist. You have to open BRD each time to use shaders.  
*It's not universal, so BRD devs have to update it for newer Minecraft versions to make it work.*  
**Changes made by Matject persists until next game update.** It's mostly universal, so it should work with any Minecraft version.

**Q. Virus?**  
A. Well, depends on you. (2)

**Q. Does it require internet?**  
A. Yes, optionally...
* To check for updates and show the changelog. (it can't update itself yet)
* To get [jq](https://jqlang.github.io/jq) by itself (for matjectNEXT).  
* To get [material-updater](https://github.com/mcbegamerxx954/material-updater) by itself.  

**Q. What folders does it access?**  
A. It accesses the following folders:  
> ###### READ only:
> - `%ProgramFiles(x86)%\IObit\IObit Unlocker\IObitUnlocker` (backbone of Matject)
> - Minecraft app location. *Which is obtained using this PowerShell command:*
> ```powershell
> Get-AppxPackage -Name Microsoft.MinecraftUWP | Select-Object -ExpandProperty InstallLocation
> ```
> - `%LOCALAPPDATA%\Packages\Microsoft.MinecraftUWP_8wekyb3d8bbwe\LocalState\games\com.mojang\minecraftpe\global_resource_packs.json` (for matjectNEXT)
> - `%LOCALAPPDATA%\Packages\Microsoft.MinecraftUWP_8wekyb3d8bbwe\LocalState\games\com.mojang\resource_packs\*` (for matjectNEXT)
> - `.settings` `Backups\*` `logs` `MATERIALS` `MCPACK` `modules\*` `tmp`
> - `Custom Minecraft app, data, IObit Unlocker folder`
>
> ###### READ and WRITE:
> - `%ProgramFiles%\WindowsApps` (to unlock WindowsApps)
> - `%ProgramFiles%\WindowsApps\Microsoft.MinecraftUWP_*_*__8wekyb3d8bbwe\data\renderer\materials`
> - `%LOCALAPPDATA%\Packages\Microsoft.MinecraftUWP_8wekyb3d8bbwe\LocalState\games\com.mojang\minecraftpe\global_resource_packs.json` (to reset global packs)
> - `.settings` `Backups\*` `logs` `MATERIALS` `tmp`
> - `Custom Minecraft app, data`

</br>

**Q. মুরগি কি ধান খায়?** 🐓  
A. হ, খায়।


</br>


#### *Should I start taking donations?*

<!-- maybe add later? ¯\_(ツ)_/¯
## Support me / Donate / Donations
Matject is, and always wiil be, free, and open source (tho it already is).
You can however show me that you care by making a donation. (copied from Magisk lol)

Binance: <uid>
USDT BEP20: <address>
-->

## Changelog
<!--TEMPLATE

<details open><summary><b>v3.minor.patch - month day, 2024</b></summary>
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

<details open><summary><b>v3.2.2 - Dec 06, 2024</b></summary>
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
