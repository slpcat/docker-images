# Thoughts
This is a generic template. Since it does WMI calls I would recommend cloning this template and leaving the Blank AMD template as a starting point for other AMD templates. This template isn't 100% it will need tweaking, especially if you have AMD rigs that have different configurations, i.e. two rigs have 6 cards, one rig has 3 cards and another might have 8. While this template will show you all of the cards on the three card rig it will only show you four cards on the other three rigs. It’s a good starting point... Also, if you plan on doing something special like a smart plugin restart when the GPU load drops to 50% for 5 minutes, you wouldn't want this same template on 4 different rigs, it could get wacky.  Also the Template has graphs so you will need to adjust those accordingly.

## Little Back Story.
Here is my setup. I have one rig running one card and another rig running four cards. On the four card rig I have a smart plugin that I can remotely turn off and on. What I have done is cloned two templates from the “AMD Monitoring Template”. I edited the template for the one card rig by deleting all the items that aren’t needed. On the four card rig… I left the template the same since I originally created the “AMD Monitoring Template” based on the four card rig. I did add a trigger for the four card rig to watch for when the GPU load goes before 50% for a certain time. After the trigger happens Zabbix then runs an Action I created that will run a reboot script for the smart plugin.  It auto reboots and the Machine is mining again in about 8 minutes. This was a big step as my machine would always seem to die at the wrong time….. So no more constantly watching. Zabbix will auto restart the troublesome machine and then just email me about it... I did the email so I know to check my hash rate. While I trust the system I put in place, it’s still money if they aren’t running correctly.


# Steps to get going.
This folder is for the Zabbix AMD template. This will assist you in Monitoring AMD GPUs on windows machines using WMI calls.
Using Open Hardware Monitor.

Import the AMD Monitoring Template into Zabbix.

You will need to have open hardware monitor on the machine you want to monitor AMD GPUs on.

Download the openhardwaremonitor.zip file from my GitHub or from open hardware monitor website (I've only test this with the version I have).

Unzip openhardwaremonitor.zip and put in the root of C:\

Run Open Hardware Monitor

Once open hardware monitor is running make sure you go into options and check the box to make it run on startup... this is so monitoring will happen even after the box is restarted.

These are the options I prefer but it’s your choice:
Start Minimized
Minimize To Tray
Minimize On Close
Run On Windows Startup

I also run open hardware monitor to only show GPUs since Zabbix already does most of the other hardware (less bloat)
Make sure only GPU is checked.
Go to: File >> Hardware >> GPU



Ok so you have Zabbix template and open hardware monitor running... but Zabbix may or may not be working correctly yet.
This is due to using WMI calls. If you look at the items in the template you will see the Key. The key is looking at a certain Parent. In the example it looks at Parent="atigpu/0"

wmi.get[root\openhardwaremonitor,SELECT Value FROM Sensor WHERE Parent="/atigpu/0" and SensorType="Load"]

You will need to use a WMI explorer to find the Parent values of your AMD cards... now they could be the same or different. The 4 AMD cards that I'm running the Parents are atigpu/0, atigpu/6, atigpu/12 and atigpu/18

Download wmiexplorer.zip
Extract it and then run the wmiexplorer.exe
Connect the wmiexplorer to the NameSpace: Root\OpenHardwareMonitor
You can either hunt through the interface for 1 or 2 locations: Hardware or Sensor. Since the template has most of the wanted Sensor Types selected you can just run this query: select * from Hardware

The Query will show you all of the GPU cards. You can then get the Identifier value (this is what is in the parent of the wmi call) from each card, it will look something like /atigpu/#.

Once you have the Parent value you can go into each item and edit the Parent value. I did it in numeric order but the numeric order might not equal how the cards are plugged into the board, so it’s your choice if you want to take a little extra time to change the order.

Once you get the Parent value changed in each WMI call Zabbix should start to pull correct data once you have added the template to a host running AMD cards.




## Credits
Thanks to [Open Hardware Monitor]( http://openhardwaremonitor.org/downloads/) for creating the program that allows GPU WMI calls
Thanks to [WMI Explorer]( https://www.ks-soft.net/hostmon.eng/wmi/) and [WMI Explorer 2.0]( https://blogs.technet.microsoft.com/gladiatormsft/2014/11/11/wmi-explorer-2-0-is-now-on-codeplex/) creators. Makes finding the WMI settings easier.
And of course to Zabbix for making a WMI.GET built into Zabbix

No Thanks given to AMD… They need to learn to make an SMI tool or something equivalent 
