# Matject v2.0

### What?
Matject is a material replacer that allows users to use Minecraft shaders. It automates the process of replacing and restoring game files.

### How?
It uses IObit Unlocker to replace/restore game files since Windows doesn't normally allow modifying apps.

### Why?
[BetterRenderDragon](https://github.com/ddf8196/BetterRenderDragon/) still doesn't support version above v1.21.2. Windows players who want to try shaders have to replace game files manually which is a pretty time consuming process.  
So, I made this script so users don't have to go through the hassle of replacing game files by themselves.

<br>

>[!IMPORTANT]  
> Before you complain about game crashing/unable to see blocks, make sure the shader you're using supports **Windows** and the game version. 

<br>

## Features
* Easy to use.
* Takes less than 2 minutes to use a shader.
* Dynamically replace game files.
* Automatically process provided MCPACK/ZIP file.
* Backup/restore game files.
* Detect Minecraft version changes and adjust according to that.

<details>
<summary>Planned features (v3.0)</summary>
<ul>
<li>Add colored texts.</li>
<li>Auto open MCPACK after replacing.</li>
<li>Add Minecraft Preview support.</li>
<li>Add more pictures here for better understanding.</li>
<li>Update <code>settings.bat</code> for more customizable experience.</li>
<li>🐥 Touch some grass.</li>
</ul>
</details>

<br><br>

> Thanks to **@JKnife0 , anonymous_user8** and all other people who tested and gave feedback.

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
2. Select **full restore**.

<br>

## Known issues
* Doesn't support long folder path and too many user provided shader files.

<br>

## FAQ
**Q. How is this different from [BetterRenderDragon](https://github.com/ddf8196/BetterRenderDragon/)?**  
A. BetterRenderDragon uses far more superior 'memory injection', all the changes are made in memory and those don't persist. You have to open BRD each time to use shaders. It's not universal, so BRD devs have to update it for newer Minecraft versions to make it work. *Changes made by Matject persists until next update. It's mostly universal, so it will work with any Minecraft version.*

**Q. Virus?**  
A. Well, depends on you. (2)

<br>

## Changelogs
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
</details>

<details><summary><b>v1.0</b></summary>
<ul><li>Initial release.</li></ul>
</details>