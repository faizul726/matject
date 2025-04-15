# Using shader with Matject

Bedrock shaders come in many types. You have to know what type it is before you give it to Matject.  

[**TL;DR**](#so-which-method-should-you-use)
<br>

* **RenderDragon shaders:**  For Minecraft "with" RenderDragon graphics engine.  
The ONLY KIND SUPPORTED by Matject and Minecraft.  
Files have `.material.bin` extension (file name suffix), most of the times stored in `renderer\materials` structure.  
&nbsp;
* **HAL shaders (old shaders):** For old Minecraft "without" RenderDragon graphics engine.  
NOT SUPPORTED by Matject or current versions of Minecraft.  
Files usually have `.fragment`/`.vertex` extension, stored in `shaders` folder as `glsl`/`hlsl`.  
&nbsp;
* **Deferred/PBR/RTX:** These are technically not shaders. Used to enable/enhance deferred rendering or RTX on Minecraft. (only for rich people <img style="display: inline; vertical-align: text-bottom;" width="24px" alt=":doggysmurk:" src="/stolen_emojis/doggysmurk.png" title="stolen from YSS discord server">)  
NOT SUPPORTED by Matject.

&nbsp;  
<hr>
&nbsp;  

Shaders also come in different types of packaging.  
* **MCPACK:** ZIP file with different extension. Usually contains `.material.bin` files alongside related textures. Can be opened with Minecraft.  
Also supported by Matject auto method.  
&nbsp;
* **ZIP:** Can be a MCPACK or just a bunch of `.material.bin` files.  
Also supported by Matject auto method.

## So, which method should you use?
For beginners **auto method** is always the best as it works well for most types.  

It will guide you step-by-step.  
You don't have to worry about what file you give to it. It will automatically detect file type, available subpacks, as well as check if the shader is for Windows.  

[**How to use auto method?**](/docs/method-auto)


<br>

**Manual method** can be used when you just have `*.material.bin` files.  
Intended for a bit advanced users including shader creators.  

[**How to use manual method?**](/docs/method-manual)

<br>

**matjectNEXT** <Badge type="warning" text="BETA"/> is somewhat like Minecraft patched.  
Instead of taking files from user it checks what's the first activated global resource pack. Then it can automatically bring files from the activated pack.  
Still in BETA. Intended for curious testers. May not work properly for all.  
(definitely not for you if you don't know how to describe a software bug efficiently <img style="display: inline; vertical-align: text-bottom;" width="24px" alt=":doggysmurkw:" src="/stolen_emojis/doggysmurkw.png" title="stolen from YSS discord server">)  

[**How to use matjectNEXT?**](/docs/method-matjectnext)