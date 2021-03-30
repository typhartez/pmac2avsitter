// .Pmac2AVsitter2 utility - converts a PMAC sitter to AVsitter2, generating AVpos
// Typhaine Artez 2021
//
// Provided under Creative Commons Attribution-Non-Commercial-ShareAlike 4.0 International license.
// Please be sure you read and adhere to the terms of this license: https://creativecommons.org/licenses/by-nc-sa/4.0/
//
// This script uses the following OSSL functions so they must be enabled for the owner of the script
// osGetNotecard(), osMakeNotecard()

// options
integer OBJECT_TITLE = 1;
integer MENU_ON_TOUCH_ONLY = 0;
integer SWAP_TOPLEVEL_ONLY = 1;
integer ADJUST_TOPLEVEL_ONLY = 1;
integer NPC_BUTTON_IF_NPC_NOTECARDS = 1;

// lists
list SEAT0;
list SEAT0menus;
list SEAT0adj;
list SEAT1;
list SEAT1menus;
list SEAT1adj;
list SEAT2;
list SEAT2menus;
list SEAT2adj;

// other variables
integer npc;

string rot2eulerStr(rotation r) {
    return (string)(llRot2Euler(r) * RAD_TO_DEG);
}

loadMenu(string menu, integer seats, string notecard) {

    string type = "POSE";
    if (seats > 1) type = "SYNC";

    SEAT0 += ["", "MENU "+menu];
    SEAT0menus += menu;
    if (seats > 1) {
        SEAT1 += ["", "MENU "+menu];
        SEAT1menus += menu;
    }
    if (seats > 2) {
        SEAT2 += ["", "MENU "+menu];
        SEAT2menus += menu;
    }

    list l = llParseString2List(osGetNotecard(notecard), ["\n"], []);
    integer i;
    string pose;
    integer c = llGetListLength(l);
    for (; i < c; ++i) {
        list line = llParseString2List(llList2String(l, i), ["|"], []);
        pose = llList2String(line, 0);
        SEAT0 += type+" "+pose+"|"+llList2String(line, 2);
        SEAT0adj += "{"+pose+"}"+llList2String(line, 3)+rot2eulerStr((rotation)llList2String(line, 4));
        if (seats > 1) {
            SEAT1 += type+" "+pose+"|"+llList2String(line, 5);
            SEAT1adj += "{"+pose+"}"+llList2String(line, 6)+rot2eulerStr((rotation)llList2String(line, 7));
        }
        if (seats > 2) {
            SEAT2 += type+" "+pose+"|"+llList2String(line, 8);
            SEAT2adj += "{"+pose+"}"+llList2String(line, 9)+rot2eulerStr((rotation)llList2String(line, 10));
        }
    }
}

genAVpos() {
    if (INVENTORY_NOTECARD == llGetInventoryType("AVpos")) {
        llRemoveInventory("AVpos");
        llSleep(0.3);
    }
    list content;
    integer i;
    integer n;

    if (OBJECT_TITLE) content += ["\""+llToUpper(llGetObjectName())+"\" AVsitter 2.2", ""];
    if (MENU_ON_TOUCH_ONLY) content += ["MTYPE 1"];
    if (SWAP_TOPLEVEL_ONLY) content += ["SWAP 1"];
    if (ADJUST_TOPLEVEL_ONLY) content += ["AMENU 1"];

    content += ["", "SITTER 0", ""];
    n = llGetListLength(SEAT0menus);
    for (i = 0; i < n; ++i) content += ["TOMENU "+llList2String(SEAT0menus, i)];
    if (npc) content += ["BUTTON [NPC]|90514"];
    content += SEAT0 + [""] + SEAT0adj;

    if ([] != SEAT1) {
        content += ["", "SITTER 1", ""];
        n = llGetListLength(SEAT1menus);
        for (i = 0; i < n; ++i) content += ["TOMENU "+llList2String(SEAT1menus, i)];
        if (npc) content += ["BUTTON [NPC]|90514"];
        content += SEAT1 + [""] + SEAT1adj;
    }
    if ([] != SEAT2) {
        content += ["", "SITTER 2", ""];
        n = llGetListLength(SEAT2menus);
        for (i = 0; i < n; ++i) content += ["TOMENU "+llList2String(SEAT2menus, i)];
        if (npc) content += ["BUTTON [NPC]|90514"];
        content += SEAT2 + [""] + SEAT2adj;
    }

    osMakeNotecard("AVpos", content);
}

default {
    state_entry() {
        integer n = llGetInventoryNumber(INVENTORY_NOTECARD);
        integer i;
        string name;
        for (; i < n; ++i) {
            name = llGetInventoryName(INVENTORY_NOTECARD, i);
            if (!llSubStringIndex(name, ".NPC") && NPC_BUTTON_IF_NPC_NOTECARDS) {
                ++npc;
            }
            else if (!llSubStringIndex(name, ".menu")) {
                integer p = llSubStringIndex(name, " ");
                if (!~p) jump nextNotecard;
                integer seats = (integer)llGetSubString(name, p-2, p-2);
                loadMenu(llGetSubString(name, p+1, -1), seats, name);
            }
@nextNotecard;
        }
        genAVpos();
    }
}
