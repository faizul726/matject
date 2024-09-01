# MCBE Material Injector


A batch script made for Windows to inject `.material.bin` files in Minecraft Bedrock Edition. (aka file replacement method)  

Thanks to [ChatGPT](https://chatgpt.com) for assistance.

<br>

> [!CAUTION]
> THIS SCRIPT IS EXPERIMENTAL.

#### ⭐️ Star if you like it. PRs are welcome.

<br>

### Known issues
* Can't find Minecraft location if it's installed in any where other than `C:\Program Files\WindowsApps`.
* Can replace vanilla backup with modified files if the user accidentally confirms backup, despite already having a vanilla backup.
* Doesn't work with large number of shader files and long %cd% path.
* Can't detect if the user has accepted UAC for IObit Unlocker, but it will still show success message.
* May not work properly if MC Preview is also installed. (not confirmed)

<br>

### Prerequisites
* Have [IObit Unlocker](https://www.iobit.com/en/iobit-unlocker.php) installed in default directory.

<br>

### Usage
1. Download source code.  
![image](https://github.com/user-attachments/assets/4422464e-26a3-4068-993e-adc76817ca9c)

2. Extract it.

> [!TIP]
> Extract it in shortest %cd% path possible so it doesn't have any problem working with large number of shader files.  
>
> Like, extracting in `C:\script` or `C:\Users\YOURNAME\script`  
>
> If you have few files to inject then it shouldn't have problem running from anywhere. 

3. Put desired **.material.bin** files in the `materials` folder.

4. Run the script by double clicking.

5. Confirm if you have [IObit Unlocker](https://www.iobit.com/en/iobit-unlocker.php) installed. If not, install it.

6. Unlock `WindowsApps` if you already haven't.

7. Backup vanilla materials if needed.

8. After everything is done, it will ask if you want to proceed with injecting. (press Y or N to confirm)

9. It will ask for UAC prompt twice. **Accept both or it will not work**. *(first for deleting, second for moving)*

<br>

### What this does?
1. Find **Microsoft.MinecraftUWP** location.
2. Backup vanilla materials to `%cd%\materials.bak`. *(optional)*
3. Check if `%cd%\materials` contains any file. If yes, list them.
4. After listing, list vanilla materials to delete.^
5. Delete vanilla materials then move user materials to game directory.^

*`^ IObit Unlocker required`*

