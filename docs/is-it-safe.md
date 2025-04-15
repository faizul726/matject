# Is it safe?

Let's be honest.  

> If you have no idea about [batch scripts](https://en.wikipedia.org/wiki/Batch_file) then, no matter how much I try to explain, you simply wouldn't believe me.  
> So, it's up to you to trust Matject.

> No one's forcing you to use it.  
> If you don't trust it, then don't use it. But do not spread rumor without proper proof.

> Or... If you think "Command Prompt/Terminal = Virus" then please <u>do not use</u> Matject.

<br>

> **Straight to the point**
> * Matject is safe.
> * It involves downloading source. So, you get what you see.
> * All of its data is stored in the same folder as `matject.bat`  
> Nothing outside is modified. Of course, except the "commands" storing temporary data, `materials` folder and `global_resource_packs.json` of Minecraft.
> * It doesn't make any internet request unless you want. [see what internet requests it makes](#list-of-internet-requests-it-makes)  

<br>

### List of internet requests it makes
First of all, Windows built-in commands, IObit Unlocker, `curl`, `tar` can make unnecessary internet requests of their own and I have no control on that.  
But I didn't add anything that that makes them make internet requests.  

It explicitly makes web requests to these links on demand:  
> Note that virus scanners like [VirusTotal](https://www.virustotal.com/gui/home/upload) may show more links.  
> Those are `from README.md` or `printed on screen` or `just comments`.  
> &nbsp;
> &nbsp;
> * Check for updates  
> https://github.com/faizul726/matject/releases/latest
> &nbsp;  
> * Show update changelog  
> https://raw.githubusercontent.com/faizul726/faizul726.github.io/main/matject/changelog.txt
> &nbsp;  
> * Check update config (to see whether direct update is possible)  
> https://raw.githubusercontent.com/faizul726/faizul726.github.io/main/matject/updateconfig.txt  
> &nbsp;
> * Download update  
> https://github.com/faizul726/matject/archive/main.zip  
> or  
> `git clone` https://github.com/faizul726/matject.git  
> &nbsp;  
> * Show announcements  
> https://raw.githubusercontent.com/faizul726/faizul726.github.io/main/matject/announcement.txt  
> &nbsp;  
> * Download material-updater [[?]](/docs/what-is-material-updater)  
> https://github.com/mcbegamerxx954/material-updater/releases/latest/download/material-updater-x86_64-pc-windows-msvc.zip  
> &nbsp;  
> * Download jq [[?]](/docs/what-is-jq)  
> https://github.com/jqlang/jq/releases/latest/download/jq-windows-amd64.exe (64 bit)  
> or  
> https://github.com/jqlang/jq/releases/latest/download/jq-windows-i386.exe (32 bit)  
> &nbsp;