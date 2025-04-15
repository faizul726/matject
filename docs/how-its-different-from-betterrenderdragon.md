# How it's different from BetterRenderdragon?

While both serves the same purpose, the way it's done is quite different.

<br>

* **Matject directly replaces internal game files to make shaders work.**  
BetterRenderDragon uses memory injection to make Minecraft load shaders from resource packs. No files are modified.  
---
* **You don't need to open Matject always to use shaders.**  
It's only needed once when you're `applying`/`changing`/`removing` shaders.  
\
BRD (BetterRenderDragon) on the other hand, while open, can adapt to resource packs on the fly. When it's closed shaders don't work.
::: info Note
When the game is updated, modified materials automatically gets replaced. You have to use Matject again to bring shaders back.
:::
---
* **Matject can't enable deferred rendering/RTX2Deferred like BRD.**  
Matject is only intended for RenderDragon shaders. Specifically shaders with `.material.bin` extension.  
HAL shaders are not supported. (Pre 1.16.200)  
---
* **Matject is "mostly" universal.**  
Since Matject works by modifying game files it doesn't need version specific changes.  
\
BRD relies on version specific "game things" to work properly. Which changes as the game updates, leaving BRD unusable, forcing its developers to reverse engineer the whole game to make BRD work for new version.