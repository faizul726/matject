# Matject v2.0
*Previously known as **materialinjector**.*

<br>

A batch script made for Windows to dynamically replace Minecraft `.material.bin` shader files of Minecraft Bedrock Edition (aka. file replacement method)  

Thanks to [Stack Overflow](https://stackoverflow.com/) and [ChatGPT](https://chatgpt.com) for some snippets.

<br>

**Known issues**
* Does not work with long folder path and too many user provided materials.

<br>

### Usage
1. Install [IObit Unlocker](https://www.iobit.com/en/iobit-unlocker.php). *Should be under **Program Files (x86)**.*


![image](https://github.com/user-attachments/assets/4422464e-26a3-4068-993e-adc76817ca9c)  

2. Download code as ZIP.

3. Extract the ZIP file.

4. Open `matject.bat`.

5. Further instructions will be there. If you can read English you shouldn't have any problem.

<br>
<br>
<br>

## Notable changes in v2.0
* Much more user-friendly than before
* Dynamically find Minecraft location
* Skip questions if user meets requirements
* Prompt to delete backup if it detects different Minecraft version
* Restore vanilla shaders **(BETA)**
* Show error if user declines UAC and asks again
* Automatically open MCPACK/MATERIALS folder for user to put files
* Extract materials from user provided MCPACK/ZIP (still can't detect if it's RD shader)
* Dynamically restore **only** modified bins from previous inject to ensure consistency among different shaders **(BETA)** (works only if user has made backup before)
* Added `settings.bat` for tweaking options (WIP)
* Added `openMinecraftFolder.bat` to open Minecraft folder
* Simplified `WindowsApps` unlock procedure. Now it unlocks instantly.

<br>

### FAQ
**Q. How is this different from [BetterRenderDragon](https://github.com/ddf8196/BetterRenderDragon/)?**  
A. BetterRenderDragon uses far more superior 'memory injection', all the changes are made in memory and those don't persist. You have to open BRD each time to use shaders. It's not universal, so BRD devs have to update it for newer Minecraft versions to make it work. *Changes made by Matject persists until next update. It's mostly universal, so it will work with any Minecraft version.*

**Q. Virus?**  
A. Well, depends on you. (2)

<br>

> *It took me a lot of testing to make sure it works and is user friendly. I am really tired now, so I won't be working on this for some time. I hope my creation makes your life easier.*
>
> *Thank you <3*

<br>

#### Will do later?
- [x] Add GitHub pages
- [x] Remove remnants
- [ ] Optimize script and improve readability
- [ ] Other todos in `matject.bat`

<br>
