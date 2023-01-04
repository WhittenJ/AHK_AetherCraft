# AHK-AetherCraft
A collection of AHK scripts for use for the Jenova Free Company, Aether Craft

## Requirements
- 7-zip is required for Auto Update functionality.  It is a free download that you can get from here: https://www.7-zip.org/
	- Ensure that you add 7z to the Windows PATH variable.
	- You can check if this is installed correctly by typing "7z" (without quotes) at the command prompt.
	- You can turn this check off if you set AutoUpdate=0 under [ScriptOptions]

## AetherCraft.ini Setup
- Do NOT change anything under the [GameLocation] section unless you know what to put here.
- Change [StaticUserSettings] to your Up, Down, Right, Esc, and Confirm keybinds from FFXIV.
- If you notice AHK is too fast (or too slow) for you, adjust the settings under [DelaySettings].
	- Delay controls the overall delay (in milliseconds).
	- TextInputDelay controls the delay for the text AHK enters.  This is a multipler for Delay.
	- MultiCraftDelay controls the delay between each craft.  This is a multipler for Delay.
	- SitDownDelay controls the delay before the CraftMacroButton can be safely pressed.  This is a multipler for Delay.
- [LastCraft] is just there to store your previous crafting session.  So if you frequently run the script with the same settings, it will remember them.

## Crafting Specific Macros (Must have FF14 as active Window)
- `F6`  - Opens the Scanning GUI window.
- `F10` - Opens the Crafting GUI window.  *** Warning: Currently only works for 1 button macros ***
- `F12` - Aborts crafting.

### How to use Scanning GUI
- Note: Ensure the Hand is showing on the top most item in the Market Board.
- Total Items - Enter in the Total Number of items in the Market Board Window.  Leave blank for all 100 items.

### How to use Crafting GUI
- Note: Ensure the Hand is showing on the item you want to craft, NOT the synthesize button.
- Total Crafts - Enter in the number of crafts you would like to make.
- Macro Duration - Enter the duration of the macro (in seconds).  Find this information on FF14 Teamcraft.
- Macro Button - Enter the key where the macro you wish to run resides.  Eg. Numpad5  *** Warning: Do not use Key Combinations, such as Ctrl + 1 ***

## General Macros
- `Ctrl + S` - Saves (S only) and Reloads the Script.  Only works in NotePad++.
- `Ctrl + R` - Reloads the Script.  Only works in NotePad++.
- `Ctrl + Alt + H` - Displays this ReadMe file.