# MCBE Material Injector

A batch script made for Windows to inject `.material.bin` files in Minecraft. (aka file replacement method)  

<br>

> [!CAUTION]
> This script is very experimental. May not work in all scenarios.

<br>

### Requirements
* Have [IObit Unlocker](https://www.iobit.com/en/iobit-unlocker.php) installed in default directory *Program Files (x86)*

<br>

### What this does?
1. Find **MinecraftUWP** location.
2. Backup vanilla materials to `%cd%\materials.bak`. *(optional)*
3. Check if `%cd%\materials` contains any file. If yes, list them.
4. After listing, list vanilla materials to delete.^
5. Delete vanilla materials then move user materials to game directory.^

*`^ IObit Unlocker required`*

<br>

### Usage
1. Download source code.  
![image](https://github.com/user-attachments/assets/4422464e-26a3-4068-993e-adc76817ca9c)

2. Extract it.
3. Put desired **.material.bin** files in the material folder. *(delete `blank` if you want)*
4. Run the script by double clicking *or by running `materialinjector`*.
5. Backup vanilla materials by pressing Y or N. *(optional)*
6. After everything is found it will ask if you want to proceed with injecting. Press Y or N to confirm.
7. It will ask for UAC prompt twice. Accept both or it will not work. *(first for deleting, second for moving)*
