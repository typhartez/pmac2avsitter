# PMAC to AVsitter convertion tool

By Typhaine Artez. **Version 1.0** *- March 2021*

Provided under Creative Commons [Attribution-Non-Commercial-ShareAlike 4.0 International license](https://creativecommons.org/licenses/by-nc-sa/4.0/).
Please be sure you read and adhere to the terms of this license.

## Usage

When dropped in an object containing the PMAC engine, this script will parse menu notecards and will generate the according `AVpos` notecard for AVsitter2. You are on your own to finalize the change (removing unnecessary notecards and script), this script only does the most difficult part (`AVpos` notecard creation from `.menu*` notecards).

**WARNING** Any existing `AVpos` notecard is automatically replaced.

**WARNING** Support for 3 sitters max

This script uses OSSL functions so they must be enabled for the owner of the script:
* `osGetNotecard()`
* `osMakeNotecard()`

## Customize

The beginning of the script has some options you can adjust to your preferences:
* `OBJECT_TITLE`: if non-zero, will put the informative text at the top of `AVpos` with the AVsitter version the notecard is made for.
* `MENU_ON_TOUCH_ONLY`: if non-zero, will put `MTYPE 1` at the top of `AVpos` to show menu to user on touch only (no menu when sitting)
* `SWAP_TOPLEVEL_ONLY`: if non-zero, will put `SWAP 1` at the top of `AVpos`, showing the **SWAP** button on top level menu only
* `ADJUST_TOPLEVEL_ONLY`: if non-zero, will put `AMENU 1` at the top of `AVpos`, showing the **ADJUST** button on top level menu only
* `NPC_BUTTON_IF_NPC_NOTECARDS`: if non-zero and the object contains NPC notecards (notecard name beginning with `.NPC`), each sitter menu will have an extra **\[NPC\]** button to use the [AVsitter NPC plugin](https://github.com/typhartez/avsitter-plugin-npc).

