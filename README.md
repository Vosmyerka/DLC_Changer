# DLC_Changer
Program for easy disabling and enabling DLCs for Euro Truck Simulator 2

---

Those who participate in Convoy Control on the TruckersMP project know that initially, in order to disable certain DLCs in Euro Truck Simulator 2, you need to go to the properties of the game in Steam, find the necessary DLCs and disable them, after which they are deleted from the files. And in order to get the DLCs back after the event they have to be downloaded again.

Convoy Control often has to disable unused DLCs in a game profile specially created for the event, otherwise, when entering the game, there will be an unsynchronization and the profile will have to be set again since the saves will not work.

This program developed in the PowerShell language makes it very easy to disable DLCs for several reasons:
1. In order to make the game profile work properly, all you need to do is disable the DLCs that are responsible for the map expansion
2. Steam does not disable DLCs, instead it deletes them, while this program moves them to a user-selected directory
3. If you want to manually transfer DLCs from the game directory to some other folder, you will encounter incomplete DLC names in .scs format. Most often it is an abbreviation, or the first 2 letters of the DLC name. This program translates those incomprehensible titles into full DLC titles from the Steam store

---

## Instructions

1. After launching the program, you will need to select two directories. In the first input field on the left side of the program, enter the full path to the directory where the game is installed. In my case, it is `C:\SteamLibrary\steamapps\common\Euro Truck Simulator 2`.

2. In the second input field on the right side of the program, enter the path to the folder where the disabled DLCs will be stored. In my case, it is `C:\Users\Vosmyerka\Desktop\ETS2 DLC`.

3. Once all directories have been specified, click the button in the middle labeled `Save Directories`, and your specified directories will be saved to the `Documents/dlcchangerdirs.txt` file.

4. From this point on, all map expansion DLCs you have should appear in the left window. All you need to do is select the DLCs you want to disable and click the `Turn DLCs OFF` button.

5. To return DLCs to the game folder, select the DLCs you want to restore in the right window and click the `Turn DLCs ON` button.

6. To select multiple items from the list, hold down the `Ctrl` key while clicking with the left mouse button.

**Attention! When you reboot your computer or update the game, Steam may reinstall missing DLCs. Be attentive and disable them just before launching the game.**
