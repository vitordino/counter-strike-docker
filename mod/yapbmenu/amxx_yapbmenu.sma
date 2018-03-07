/*------------------------------------------------------------------------------

Ultimate POD-Bot Menu v1.2 by g4s|figurE.09
Edited for YaPB by The Goomba Mattress

Visit http://g4s.netfirms.com for updates.

Console Commands:

	amx_yapbmenu - displays YaPB main menu.
	amx_yapbaddbot - adds specific number of bots.

------------------------------------------------------------------------------*/

#include <amxmodx>
#include <amxmisc>

new g_botSkill = -1
new g_botPersonality = -1
new g_botTeam = -1
new g_botModel = -1
new g_fillServer = 0

public plugin_init() {
	register_plugin("YaPB Menu", "1.3", "g4s|figurE.09")
	register_concmd("amx_yapbaddbot", "cmdAddyapb", ADMIN_MENU, "<number of bots> - adds bots.")
	register_concmd("amx_yapbkickbot", "cmdKickyapb", ADMIN_MENU, "<number of bots> - kicks bots.")
	register_menucmd(register_menuid("\yYaPB Menu"), 1023, "actionYAPBMenu")
	register_menucmd(register_menuid("\yPlease choose a Skill"), 1023, "actionYACSMenu")
	register_menucmd(register_menuid("\yPlease choose a Personality"), 1023, "actionYACPMenu")
	register_menucmd(register_menuid("\yPlease choose a Team"), 1023, "actionYACTMenu")
	register_menucmd(register_menuid("\yPlease choose a Model"), 1023, "actionYACMMenu")
	register_menucmd(register_menuid("\yWeapon Mode"), 1023, "actionYAWMMenu")
	register_clcmd("amx_yapbmenu", "showYAPBMenu", ADMIN_MENU, "- displays YaPB menu.")
	register_clcmd("amx_yapbcsmenu", "showYACSMenu", ADMIN_MENU, "- displays YaPB add bot(choose skill) menu.")
	register_clcmd("amx_yapbcpmenu", "showYACPMenu", ADMIN_MENU, "- displays YaPB add bot(choose personality) menu.")
	register_clcmd("amx_yapbctmenu", "showYACTMenu", ADMIN_MENU, "- displays YaPB add bot(choose team) menu.")
	register_clcmd("amx_yapbcmmenu", "showYACMMenu", ADMIN_MENU, "- displays YaPB add bot(choose model) menu.")
	register_clcmd("amx_yapbwmmenu", "showYAWMMenu", ADMIN_MENU, "- displays YaPB weapon mode menu.")
	return PLUGIN_CONTINUE
}

/*--- Add Bots ---------------------------------------------------------------*/

public addYapb() {
	server_cmd("yapb add")
}

public cmdAddyapb(id, level, cid) {
	if (!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED
	new botsNum[32]
	read_argv(1, botsNum, 31)
	new botsnumber = str_to_num(botsNum)
	set_task(1.0, "addYapb", 12120, "", 0, "a", botsnumber - 1)
	new name[32], authid[16]
	get_user_name(id, name, 31)
	get_user_authid(id, authid, 16)
	log_amx("[YaPB] ^"%s<%d><%s><>^" add %d bots", name, get_user_userid(id), authid, botsnumber)
	console_print(id, "* [YaPB] Added %d Bots.", botsnumber)
	return PLUGIN_HANDLED
}

/*--- Add Specific Bot -------------------------------------------------------*/

public addSpecificBot() {
	if (g_botSkill == -1)
		g_botSkill = random_num(0, 100)
	if (g_botPersonality == -1)
		g_botPersonality = 5
	if (g_botTeam == -1)
		g_botTeam = (1, 2)
	if (g_botModel == -1)
		g_botModel = random_num(1, 4)
	server_cmd("yapb add %d %d %d * %d", g_botSkill, g_botPersonality, g_botTeam, g_botModel)
}

/*--- Fill Server ------------------------------------------------------------*/

public fillServer() {
	if (g_botSkill == -1)
		g_botSkill = random_num(0, 100)
	if (g_botPersonality == -1)
		g_botPersonality = 5
	if (g_botTeam == -1)
		g_botTeam = 5
	if (g_botModel == -1)
		g_botModel = random_num(1, 4)
	server_cmd("yapb fill %d %d %d * %d", g_botSkill, g_botPersonality, g_botTeam, g_botModel)
}

/*--- Main Menu --------------------------------------------------------------*/

public actionYAPBMenu(id, key) {
	new name[32], authid[16]
	get_user_name(id, name, 31)
	get_user_authid(id, authid, 16)
	switch(key) {
		case 0: {
			server_cmd("yapb add")
			client_cmd(id, "amx_yapbmenu")
			log_amx("[YaPB] ^"%s<%d><%s><>^" add a random bot", name, get_user_userid(id), authid)
		}
		case 1: {
			g_fillServer = 0
			client_cmd(id, "amx_yapbcsmenu")
		}
		case 2: {
			server_cmd("yapb killbots")
			log_amx("[YaPB] ^"%s<%d><%s><>^" kill all bots", name, get_user_userid(id), authid)
		}
		case 3: {
			new plist[32], pnum
			get_players(plist, pnum, "a")
			for (new i = 0; i < pnum; i++) {
				user_kill(plist[i], 1)
			}
			log_amx("[YaPB] ^"%s<%d><%s><>^" new round", name, get_user_userid(id), authid)
		}
		case 4: {
			g_fillServer = 1
			client_cmd(id, "amx_yapbcsmenu")
		}
		case 5: {
			server_cmd("yapb removerandombot")
			client_cmd(id, "amx_yapbmenu")
			log_amx("[YaPB] ^"%s<%d><%s><>^" kick random bot", name, get_user_userid(id), authid)
		}
		case 6: {
			server_cmd("yapb remove")
			log_amx("[YaPB] ^"%s<%d><%s><>^" kick all bots", name, get_user_userid(id), authid)
		}
		case 7: {
			client_cmd(id, "amx_yapbwmmenu")
		}
	}
	return PLUGIN_HANDLED
}

public showYAPBMenu(id, level, cid) {
        if (!cmd_access(id, level, cid, 1))
		return PLUGIN_HANDLED
        new menu[256]
        format(menu, 255, "\yYaPB Menu^n^n\w1. Quick Add Bot^n2. Add Specific Bot^n3. Kill All Bots^n4. New Round^n5. Fill Server^n6. Kick Random Bot^n7. Kick All Bots^n8. Weapon Mode^n^n\w0. Exit")
        show_menu(id, ((1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<7)|(1<<9)), menu)
        return PLUGIN_HANDLED
}

/*--- Choose Skill Menu ------------------------------------------------------*/

public actionYACSMenu(id, key) {
	switch(key) {
		case 0: {
			g_botSkill = random_num(0, 19)
			client_cmd(id, "amx_yapbcpmenu")
		}
		case 1: {
			g_botSkill = random_num(20, 39)
			client_cmd(id, "amx_yapbcpmenu")
		}
		case 2: {
			g_botSkill = random_num(40, 59)
			client_cmd(id, "amx_yapbcpmenu")
		}
		case 3: {
			g_botSkill = random_num(60, 79)
			client_cmd(id, "amx_yapbcpmenu")
		}
		case 4: {
			g_botSkill = random_num(80, 99)
			client_cmd(id, "amx_yapbcpmenu")
		}
		case 5: {
			g_botSkill = 100
			client_cmd(id, "amx_yapbcpmenu")
		}
		case 6: {
			g_botSkill = random_num(0, 100)
			client_cmd(id, "amx_yapbcpmenu")
		}
		case 8: {
			client_cmd(id, "amx_yapbmenu")
		}
	}
	return PLUGIN_HANDLED
}

public showYACSMenu(id, level, cid) {
        if (!cmd_access(id, level, cid, 1))
		return PLUGIN_HANDLED
        new menu[256]
        format(menu, 255, "\yPlease choose a Skill^n^n\w1. Stupid(0-19)^n2. Newbie(20-39)^n3. Average(40-59)^n4. Advanced(60-79)^n5. Professional(80-99)^n6. Godlike(100)^n^n7. Random(0-100)^n^n\w9. Back^n\w0. Exit")
        show_menu(id, ((1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<8)|(1<<9)), menu)
        return PLUGIN_HANDLED
}

/*--- Choose Personality Menu ------------------------------------------------*/

public actionYACPMenu(id, key) {
	switch(key) {
		case 0: {
			g_botPersonality = 1
			client_cmd(id, "amx_yapbctmenu")
		}
		case 1: {
			g_botPersonality = 2
			client_cmd(id, "amx_yapbctmenu")
		}
		case 2: {
			g_botPersonality = 3
			client_cmd(id, "amx_yapbctmenu")
		}
		case 3: {
			g_botPersonality = 5
			client_cmd(id, "amx_yapbctmenu")
		}
		case 8: {
			client_cmd(id, "amx_yapbcsmenu")
		}
	}
	return PLUGIN_HANDLED
}

public showYACPMenu(id, level, cid) {
        if (!cmd_access(id, level, cid, 1))
		return PLUGIN_HANDLED
        new menu[256]
        format(menu, 255, "\yPlease choose a Personality^n^n\w1. Normal^n2. Aggresive^n3. Defensive^n^n4. Random^n^n\w9. Back^n\w0. Exit")
        show_menu(id, ((1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<8)|(1<<9)), menu)
        return PLUGIN_HANDLED
}

/*--- Choose Team Menu -------------------------------------------------------*/

public actionYACTMenu(id, key) {
	new name[32], authid[16]
	get_user_name(id, name, 31)
	get_user_authid(id, authid, 16)
	switch(key) {
		case 0: {
			g_botTeam = 1
			client_cmd(id, "amx_yapbcmmenu")
		}
		case 1: {
			g_botTeam = 2
			client_cmd(id, "amx_yapbcmmenu")
		}
		case 2: {
			if (g_fillServer == 0) {
				g_botTeam = random_num(1, 2)
				client_cmd(id, "amx_yapbcmmenu")
			}
			else {
				g_botTeam = 5
				set_task(0.1, "fillServer", 12121)
				log_amx("[YaPB] ^"%s<%d><%s><>^" fill server", name, get_user_userid(id), authid)
			}
		}
		case 8: {
			client_cmd(id, "amx_yapbcpmenu")
		}
	}
	return PLUGIN_HANDLED
}

public showYACTMenu(id, level, cid) {
        if (!cmd_access(id, level, cid, 1))
		return PLUGIN_HANDLED
        new menu[256]
        format(menu, 255, "\yPlease choose a Team^n^n\w1. Terrorist^n2. Counter-Terrorist^n^n3. Auto-Assign^n^n\w9. Back^n\w0. Exit")
        show_menu(id, ((1<<0)|(1<<1)|(1<<2)|(1<<8)|(1<<9)), menu)
        return PLUGIN_HANDLED
}

/*--- Choose Model Menu ------------------------------------------------------*/

public actionYACMMenu(id, key) {
	new name[32], authid[16]
	get_user_name(id, name, 31)
	get_user_authid(id, authid, 16)
	switch(key) {
		case 0: {
			g_botModel = 1
			if (g_fillServer == 0) {
				set_task(0.1, "addSpecificBot", 12121)
				log_amx("[YaPB] ^"%s<%d><%s><>^" add a bot", name, get_user_userid(id), authid)
				client_cmd(id, "amx_yapbmenu")
			}
			else if (g_fillServer == 1) {
				set_task(0.1, "fillServer", 12121)
				log_amx("[YaPB] ^"%s<%d><%s><>^" fill server", name, get_user_userid(id), authid)
			}
		}
		case 1: {
			g_botModel = 2
			if (g_fillServer == 0) {
				set_task(0.1, "addSpecificBot", 12121)
				log_amx("[YaPB] ^"%s<%d><%s><>^" add a bot", name, get_user_userid(id), authid)
				client_cmd(id, "amx_yapbmenu")
			}
			else if (g_fillServer == 1) {
				set_task(0.1, "fillServer", 12121)
				log_amx("[YaPB] ^"%s<%d><%s><>^" fill server", name, get_user_userid(id), authid)
			}
		}
		case 2: {
			g_botModel = 3
			if (g_fillServer == 0) {
				set_task(0.1, "addSpecificBot", 12121)
				log_amx("[YaPB] ^"%s<%d><%s><>^" add a bot", name, get_user_userid(id), authid)
				client_cmd(id, "amx_yapbmenu")
			}
			else if (g_fillServer == 1) {
				set_task(0.1, "fillServer", 12121)
				log_amx("[YaPB] ^"%s<%d><%s><>^" fill server", name, get_user_userid(id), authid)
			}
		}
		case 3: {
			g_botModel = 4
			if (g_fillServer == 0) {
				set_task(0.1, "addSpecificBot", 12121)
				log_amx("[YaPB] ^"%s<%d><%s><>^" add a bot", name, get_user_userid(id), authid)
				client_cmd(id, "amx_yapbmenu")
			}
			else if (g_fillServer == 1) {
				set_task(0.1, "fillServer", 12121)
				log_amx("[YaPB] ^"%s<%d><%s><>^" fill server", name, get_user_userid(id), authid)
			}
		}
		case 4: {
			g_botModel = random_num(1, 4)
			if (g_fillServer == 0) {
				set_task(0.1, "addSpecificBot", 12121)
				log_amx("[YaPB] ^"%s<%d><%s><>^" add a bot", name, get_user_userid(id), authid)
				client_cmd(id, "amx_yapbmenu")
			}
			else if (g_fillServer == 1) {
				set_task(0.1, "fillServer", 12121)
				log_amx("[YaPB] ^"%s<%d><%s><>^" fill server", name, get_user_userid(id), authid)
			}
		}
		case 8: {
			client_cmd(id, "amx_yapbmenu")
		}
	}
	return PLUGIN_HANDLED
}

public showYACMMenu(id, level, cid) {
        if (!cmd_access(id, level, cid, 1))
		return PLUGIN_HANDLED
        new menu[256]
        format(menu, 255, (g_botTeam == 1) ? "\yPlease choose a Model^n^n\w1. Phoenix Connektion^n2. L337 Krew^n3. Arctic Avengers^n4. Guerilla Warfare^n^n5. Auto-Select^n^n\w9. Back^n\w0. Exit" : "\yPlease choose a Model^n^n\w1. Seal Team 6(DEVGRU)^n2. German GSG-9^n3. UK SAS^n4. French GIGN^n^n5. Auto-Select^n^n\w9. Back^n\w0. Exit")
        show_menu(id, ((1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<8)|(1<<9)), menu)
        return PLUGIN_HANDLED
}


/*--- Kick Random Bot ----------------------------------------------------------*/

public kickYapb() {
	server_cmd("yapb removerandombot")
}

public cmdKickyapb(id, level, cid) {
	if (!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED
	new botsNum[32]
	read_argv(1, botsNum, 31)
	new botsnumber = str_to_num(botsNum)
	set_task(1.0, "kickYapb", 12120, "", 0, "a", botsnumber - 1)
	new name[32], authid[16]
	get_user_name(id, name, 31)
	get_user_authid(id, authid, 16)
	log_amx("[YaPB] ^"%s<%d><%s><>^" kick %d bots", name, get_user_userid(id), authid, botsnumber)
	console_print(id, "* [YaPB] Kicked %d Bots.", botsnumber)
	return PLUGIN_HANDLED
}


/*--- Weapon Mode Menu -------------------------------------------------------*/

public actionYAWMMenu(id, key) {
	new name[32], authid[16]
	get_user_name(id, name, 31)
	get_user_authid(id, authid, 16)
	switch(key) {
		case 0: {
			server_cmd("yapb wpnmode 1")
			log_amx("[YaPB] ^"%s<%d><%s><>^" weapon mode: knife", name, get_user_userid(id), authid)
		}
		case 1: {
			server_cmd("yapb wpnmode 2")
			log_amx("[YaPB] ^"%s<%d><%s><>^" weapon mode: pistols", name, get_user_userid(id), authid)
		}
		case 2: {
			server_cmd("yapb wpnmode 3")
			log_amx("[YaPB] ^"%s<%d><%s><>^" weapon mode: shotguns", name, get_user_userid(id), authid)
		}
		case 3: {
			server_cmd("yapb wpnmode 4")
			log_amx("[YaPB] ^"%s<%d><%s><>^" weapon mode: machine guns", name, get_user_userid(id), authid)
		}
		case 4: {
			server_cmd("yapb wpnmode 5")
			log_amx("[YaPB] ^"%s<%d><%s><>^" weapon mode: rifles", name, get_user_userid(id), authid)
		}
		case 5: {
			server_cmd("yapb wpnmode 6")
			log_amx("[YaPB] ^"%s<%d><%s><>^" weapon mode: snipers", name, get_user_userid(id), authid)
		}
		case 6: {
			server_cmd("yapb wpnmode 7")
			log_amx("[YaPB] ^"%s<%d><%s><>^" weapon mode: all weapons", name, get_user_userid(id), authid)
		}
		case 8: {
			client_cmd(id, "amx_yapbmenu")
		}
	}
	return PLUGIN_HANDLED
}

public showYAWMMenu(id, level, cid) {
        if (!cmd_access(id, level, cid, 1))
		return PLUGIN_HANDLED
        new menu[256]
        format(menu, 255, "\yWeapon Mode^n^n\w1. Knife^n2. Pistols^n3. Shotguns^n4. Machine Guns^n5. Rifles^n6. Snipers^n^n7. All Weapons^n^n\w9. Back^n\w0. Exit")
        show_menu(id, ((1<<0)|(1<<1)|(1<<2)|(1<<3)|(1<<4)|(1<<5)|(1<<6)|(1<<8)|(1<<9)), menu)
        return PLUGIN_HANDLED
}