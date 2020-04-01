# Restart Smart Plugin when Zabbix event is triggered 

I'm pulling some of this from Max Anderson 95's TPLink Plug Controller Module for PowerShell. 

In the zip file you will find a .bat and .ps1 file. I use the .bat file for Zabbix action to restart a Plugin when a trigger is fired. You will need to edit the .ps1 file. You need to put the IP of the device in the script. Max tells you how to find the IP address. 

Install the Module for powershell by following Max guide and then unzip the Restart_TPLink.zip into C:\scripts (you will need to create that directory).  Then create an Action by going to Configuration >> Actions and click on Create Action. Give the action a name. In the New Condition Select trigger from the drop down. Use the Select button to actually select the trigger you want to use, I used a trigger called "GPU Load is Low trigger" (don't forget to click the small blue add button. Go to the operations tab. Click on New in Operation Details. Change the Operation Type to "Remote command". Click New under Target List. This is the computer that you want to run the command, I chose a reliable server. Make sure you click the blue add button after you select the host. In the Commands box, put the .bat file i.e. <code>"C:\scripts\Restart_TPLink.bat",nowait</code> Make sure you click that little blue add button again. Then click the big Add button at the bottom so its all created. It should now show in your Actions panel. 

## How I have it setup:
Zabbix server is a VM on my main server. I have Zabbix run a remote command on main server to restart Smart Plugin when mining rig goes on the fritz and triggers alarm. I did it this way because I originally was running this script with Claymore Monitoring tool... That was a rush. So since I already had the powershell piece setup on Windows Server I went the route that was easier for me since I'm not a linux person. There is a linux variation out there for TP-Link Smart Plugs so if you feel spunky go for it.



# TPLink Plug Controller Module for PowerShell
This is a PowerShell module that can be used for controlling a TPLink HS100 or HS110 smart plug. The plug receives requests and this module sends requests on tcp port 9999, so theoretically this can traverse networks or the internet with proper port forwarding/NAT rules. However this can allow someone to control the device plugged into the TPLink plug, so do this with caution.

## Usage Instructions
1. Begin by downloading or cloning the repository to a directory of your choice. Preferably a directory in your `$env:PSModulePath` so that the module will auto-load itself when running any of the exported functions.
![Cloning the repo gif](https://i.imgur.com/4jYVufF.gif)

2. Determine the IP address of your plug using `Find-TPLinkSmartPlug`.
![Finding Smart Plugs](https://i.imgur.com/Ky4i5bU.gif)

3. Send a command to your unit. For example we can turn on the unit.
![Sending the command Friendly](https://i.imgur.com/AsSGV5L.gif)
Or Send the command using raw JSON.
![Sending the command](https://i.imgur.com/QhuCZtW.gif)

*Optional*

4. `The Send-TPLinkCommand` outputs a PSCustomObject with the respose. This is generated from the raw JSON response from the plug. This response can be placed in a variable and analyzed.
![Analyzing the output](https://i.imgur.com/AiXksBt.gif)

### List of Available JSON Commands
Click [here](https://github.com/MaxAnderson95/TPLink-PlugController-PowerShell/blob/master/Sources/Resources/TPLink-Smarthome-commands.txt) to find a list of valid JSON commands the HS100 or HS110 will accept.

## Credit
Big thanks to [MaxAnderson95](https://github.com/MaxAnderson95/TPLink-PlugController-PowerShell) for making the main powershell script to get this to work.
