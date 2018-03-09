#include <amxmodx>
#include <amxmisc>
#include <fakemeta>

#define MAX_PLAYERS 32

new bool:g_hs_mode
new display_hud
new bool:g_RestartAttempt[MAX_PLAYERS+1]
new g_fwid

public plugin_init() {
	register_plugin("HeadShot Mod", "1.1b", "ConnorMcLeod")
	register_dictionary("hs_only.txt")

	register_event("TextMsg", "eRestartAttempt", "a", "2=#Game_will_restart_in")
	register_event("ResetHUD", "eResetHUD", "be")

	register_concmd("amx_hs_mode", "switchCmd", ADMIN_KICK, "- <0|1> : Hs Only Mode = Disabled|Enabled")
	register_clcmd("clcmd_fullupdate", "fullupdateCmd")
	
	display_hud = register_cvar("amx_hs_display", "1")
}

public fullupdateCmd() {
	return PLUGIN_HANDLED_MAIN
}

public eRestartAttempt() {
	new players[MAX_PLAYERS], num
	get_players(players, num, "a")
	for (new i; i < num; ++i)
		g_RestartAttempt[players[i]] = true
}

public eResetHUD(id) {
	if (g_RestartAttempt[id]) {
		g_RestartAttempt[id] = false
		return
	}
	event_player_spawn(id)
}

event_player_spawn(id) {
	if( g_hs_mode && get_pcvar_num(display_hud) )
		display_status(id)
}

public switchCmd(id, level, cid) {
	if(!cmd_access(id, level, cid, 2))
		return PLUGIN_HANDLED

	new arg[2]
	read_argv(1, arg, 1)

	new temp = str_to_num(arg)
	
	switch(temp) {
		case 0: {
			if(!g_hs_mode) {
				client_print(id, print_console, "Hs Only Mod already Disabled")
			}
			else {
				unregister_forward(FM_TraceLine, g_fwid, 1)
				g_hs_mode = false
				client_print(id, print_console, "Hs Only Mod Disabled")
			}
		}
		case 1: {
			if(g_hs_mode) {
				client_print(id, print_console, "Hs Only Mod already Enabled")
			}
			else {
				g_fwid = register_forward(FM_TraceLine, "forward_traceline", 1)
				g_hs_mode = true
				client_print(id, print_console, "Hs Only Mod Enabled")
				display_status()
			}
		}
		default: {
			client_print(id, print_console, "amx_hs_mode <0|1> : Hs Only Mode = Disabled|Enabled")
		}
	}
	return PLUGIN_HANDLED
}

public forward_traceline(Float:v1[3], Float:v2[3], noMonsters, pentToSkip)
{
	if(!is_user_alive(pentToSkip))
		return FMRES_IGNORED

	static entity2 ; entity2 = get_tr(TR_pHit)
	if(!is_user_alive(entity2))
		return FMRES_IGNORED

	if(pentToSkip == entity2)
		return FMRES_IGNORED

	if(get_tr(TR_iHitgroup) != 1) {
		set_tr(TR_flFraction,1.0)
		return FMRES_SUPERCEDE
	}
	return FMRES_IGNORED
}

display_status(id=0){
	switch( get_pcvar_num(display_hud) )
	{
		case 1: {
			set_hudmessage(255, 10, 0, 0.05, 0.60, 2, 0.1, 6.0, 0.1, 0.15, -1)
			show_hudmessage(id, "%L", id ? id : LANG_PLAYER, "HS_MODE_ON")
		}
		case 2:client_print(id, print_chat, "%L", id ? id : LANG_PLAYER, "HS_MODE_ON")
	}
}