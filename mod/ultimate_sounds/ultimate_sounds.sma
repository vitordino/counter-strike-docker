/********************************************************************************
*  AMX Mod X script.
*
*   Ultimate Sounds (Ultimate_Sounds.sma)
*   Copyright (C) 2006-2008 Bmann_420 / Dizzy / Hoboman
*
*   This program is free software; you can redistribute it and/or
*   modify it under the terms of the GNU General Public License
*   as published by the Free Software Foundation; either version 2
*   of the License, or (at your option) any later version.
*
*   This program is distributed in the hope that it will be useful,
*   but WITHOUT ANY WARRANTY; without even the implied warranty of
*   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*   GNU General Public License for more details.
*
*   You should have received a copy of the GNU General Public License
*   along with this program; if not, write to the Free Software
*   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
*
*   In addition, as a special exception, the author gives permission to
*   link the code of this program with the Half-Life Game Engine ("HL
*   Engine") and Modified Game Libraries ("MODs") developed by Valve,
*   L.L.C ("Valve"). You must obey the GNU General Public License in all
*   respects for all of the code used other than the HL Engine and MODs
*   from Valve. If you modify this file, you may extend this exception
*   to your version of the file, but you are not obligated to do so. If
*   you do not wish to do so, delete this exception statement from your
*   version.
*
*********************************************************************************
*
*   AMXX Ultimate Sounds Vers. 1.7
*   Last Update: 1/26/2007
*
*   by  Dizzy / Bmann_420 & Hoboman
*   Link: http://forums.alliedmods.net/showthread.php?t=7342
*
*
*********************************************************************************
*
* ///////////////////////////////////////////////////
* //  AMXMOD[X]                                    //
* //   ::Ultimate sounds::                         //
* //    Origional: by Hephaistos 		   //
* //    Ported by: Dizzy 			   //
* //    Edited by: Hoboman, bmann_420 		   //
* //                                               //
* // cvar:                                         //
* //  streak_mode < flags >                        //
* //  "a" - messages                               //
* //  "b" - sounds                                 //
* //                                               //
* //  knife_mode < flags >                         //
* //  "a" - messages                               //
* //  "b" - sounds                                 //
* //                                               //
* //  hs_mode < flags >                            //
* //  "a" - messages                               //
* //  "b" - sounds                                 //
* //                                               //
* //  lastman_mode < flags >                       //
* //  "a" - messages                               //
* //  "b" - hp                                     //
* //  "c" - sounds                                 //
* ///////////////////////////////////////////////////
*
*********************************************************************************
*/

// Plugin Info
new const PLUGIN[]  = "Ultimate Sounds"
new const VERSION[] = "1.7"
new const AUTHOR[]  = "Dizzy / Bmann_420"

// Includes
#include <amxmodx>

//Defines
#define KNIFEMESSAGES 5
#define MESSAGESNOHP 5
#define MESSAGESHP 5
#define LEVELS 10

//Pcvars
new streak_mode, knife_mode, hs_mode, lastman_mode

new gmsgHudSync

new kills[33] = {0,...};
new deaths[33] = {0,...};
new alone_ann = 0
new levels[10] = {2, 3, 4, 5, 6, 7, 8, 9, 10, 11};

//Streak Sounds
new stksounds[10][] = 
{
	"misc/multikill",
	"misc/megakill",
	"misc/ultrakill",
	"misc/monsterkill",
	"misc/killingspree",
	"misc/wickedsick",
	"misc/rampage",
	"misc/ludacrisskill",
	"misc/godlike",
	"misc/holyshit"
}

new stkmessages[10][] = 
{
	"%s: Multi-Kill!",
	"%s: Mega-Kill!",
	"%s: Ultra-Kill!",
	"%s: Monster-Kill!",
	"%s: Killing Spree!",
	"%s: Wicked Sick!",
	"%s: Rampage!",
	"%s: Ludacriss-Kill",
	"%s: Godlike!",
	"%s: Holy Shit!"
}

new knifemessages[KNIFEMESSAGES][] = 
{
	"KNIFE_MSG_1",  
	"KNIFE_MSG_2",  
	"KNIFE_MSG_3",  
	"KNIFE_MSG_4",  
	"KNIFE_MSG_5"
}

new messagesnohp[MESSAGESNOHP][] = 
{
	"NOHP_MSG_1",  
	"NOHP_MSG_2",  
	"NOHP_MSG_3",  
	"NOHP_MSG_4",  
	"NOHP_MSG_5"
}

new messageshp[MESSAGESHP][] = 
{
	"HP_MSG_1",  
	"HP_MSG_2",  
	"HP_MSG_3",  
	"HP_MSG_4",  
	"HP_MSG_5"
}

public plugin_init()
{
	register_plugin(PLUGIN, VERSION, AUTHOR)
	register_cvar("ultimate_sounds",VERSION,FCVAR_SERVER|FCVAR_EXTDLL|FCVAR_UNLOGGED|FCVAR_SPONLY)
	register_dictionary("ultimate_sounds.txt")
	register_event("DeathMsg","hs","a","3=1")
	register_event("DeathMsg","knife_kill","a","4&kni")
	register_event("ResetHUD", "reset_hud", "b");
	register_event("DeathMsg", "death_event", "a", "1>0");
	register_event("DeathMsg","death_msg","a")
	register_event("SendAudio","roundend_msg","a","2=%!MRAD_terwin","2=%!MRAD_ctwin","2=%!MRAD_rounddraw")
	register_event("TextMsg","roundend_msg","a","2&#Game_C","2&#Game_w")

	lastman_mode = register_cvar("lastman_mode","abc")
	streak_mode = register_cvar("streak_mode","ab")
	knife_mode = register_cvar("knife_mode","ab")
	hs_mode = register_cvar("hs_mode","ab")

	gmsgHudSync = CreateHudSyncObj()

	return PLUGIN_CONTINUE
}

get_streak()
{
	new streak[3]
	get_pcvar_string(streak_mode,streak,2)
	return read_flags(streak)
}

public death_event(id)
{
	new streak = get_streak()

	if ((streak&1) || (streak&2))
	{
    		new killer = read_data(1);
    		new victim = read_data(2);

    		kills[killer] += 1;
    		kills[victim] = 0;
    		deaths[killer] = 0;
    		deaths[victim] += 1;

    		for (new i = 0; i < LEVELS; i++)
		{
        		if (kills[killer] == levels[i])
			{
         	  		 announce(killer, i);
         	  		 return PLUGIN_CONTINUE;
			}
		}
	}
	return PLUGIN_CONTINUE;
}

announce(killer, level)
{
	new streak = get_streak()

	if (streak&1)
	{
    		new name[32];

   		get_user_name(killer, name, 32);
		set_hudmessage(0, 100, 200, 0.05, 0.65, 2, 0.02, 6.0, 0.01, 0.1, 2);
		ShowSyncHudMsg(0, gmsgHudSync, stkmessages[level], name);
	}

	if (streak&2){
		for(new i=1;i<=get_maxplayers();i++) 
			if(is_user_connected(i)==1 )
				client_cmd(i, "spk %s", stksounds[level]); 
	}
}

public reset_hud(id)
{
	new streak = get_streak()

	if (streak&1)
	{

		if (kills[id] > levels[0])

		{
		        client_print(id, print_chat,"%L", id, "KILL_STREAK", kills[id]);
		}

		else if (deaths[id] > 1)

		{
			client_print(id, print_chat,"%L", id, "DEATH_STREAK", deaths[id]);
		}
	}
}

public client_connect(id)
{
	new streak = get_streak()

	if ((streak&1) || (streak&2))
	{
		kills[id] = 0;
		deaths[id] = 0;
	}
}

public knife_kill()
{
	new knifemode[4] 
	get_pcvar_string(knife_mode,knifemode,4) 
	new knifemode_bit = read_flags(knifemode)

	if (knifemode_bit & 1)
	{
		new killer_id = read_data(1)
		new victim_id = read_data(2)
		new killer_name[33], victim_name[33]

		get_user_name(killer_id,killer_name,33)
		get_user_name(victim_id,victim_name,33)


		set_hudmessage(200, 100, 0, -1.0, 0.30, 0, 6.0, 6.0, 0.5, 0.15, 1)
		ShowSyncHudMsg(0, gmsgHudSync, "%L", LANG_PLAYER, knifemessages[ random_num(0,KNIFEMESSAGES-1) ],killer_name,victim_name)
	}

	if (knifemode_bit & 2)
	{
		for(new i=1;i<=get_maxplayers();i++) 
			if( is_user_connected(i) == 1 )
				client_cmd(i,"spk misc/humiliation")
   	}
}


public roundend_msg(id)

	alone_ann = 0

public death_msg(id)
{

	new lmmode[8] 
	get_pcvar_string(lastman_mode,lmmode,8) 
	new lmmode_bit = read_flags(lmmode)

	new players_ct[32], players_t[32], ict, ite, last
	get_players(players_ct,ict,"ae","CT")   
	get_players(players_t,ite,"ae","TERRORIST")   

	if (ict==1&&ite==1)
	{
		new name1[32], name2[32]
		get_user_name(players_ct[0],name1,32)
		get_user_name(players_t[0],name2,32)
		set_hudmessage(200, 100, 0, -1.0, 0.30, 0, 6.0, 6.0, 0.5, 0.15, 1)

		if (lmmode_bit & 1)
		{
			if (lmmode_bit & 2)
			{
				ShowSyncHudMsg(0, gmsgHudSync, "%s (%i hp) vs. %s (%i hp)",name1,get_user_health(players_ct[0]),name2,get_user_health(players_t[0]))
			}

			else
			{
				ShowSyncHudMsg(0, gmsgHudSync, "%s vs. %s",name1,name2)
			}

			if (lmmode_bit & 4)
			{
				for(new i=1;i<=get_maxplayers();i++) 
					if( is_user_connected(i) == 1 )
						client_cmd(i,"spk misc/maytheforce")
			}
		}
	} 
	else
{   
	if (ict==1&&ite>1&&alone_ann==0&&(lmmode_bit & 4))
	{
		last=players_ct[0]
		client_cmd(last,"spk misc/oneandonly")

	}

	else if (ite==1&&ict>1&&alone_ann==0&&(lmmode_bit & 4))
	{
		last=players_t[0]
		client_cmd(last,"spk misc/oneandonly")
	}

	else
	{
		return PLUGIN_CONTINUE
	}
	alone_ann = last
	new name[32]   
	get_user_name(last,name,32)

	if (lmmode_bit & 1)
	{
		set_hudmessage(200, 100, 0, -1.0, 0.30, 0, 6.0, 6.0, 0.5, 0.15, 1)

		if (lmmode_bit & 2)
		{
			ShowSyncHudMsg(0, gmsgHudSync, "%L", LANG_PLAYER, messageshp[ random_num(0,MESSAGESHP-1) ],ite ,ict ,name,get_user_health(last))
		}

		else
		{
			ShowSyncHudMsg(0, gmsgHudSync, "%L", LANG_PLAYER, messagesnohp[ random_num(0,MESSAGESNOHP-1) ],ite ,ict ,name )
		}
	}

}
	return PLUGIN_CONTINUE   
}


public hs()
{
	new hsmode[4] 
	get_pcvar_string(hs_mode,hsmode,4) 
	new hsmode_bit = read_flags(hsmode)

	if (hsmode_bit & 1)
	{
	new killer_id = read_data(1)
	new victim_id = read_data(2)
	new victim_name[33]

	get_user_name(victim_id,victim_name,33)

	set_hudmessage(200, 100, 0, -1.0, 0.30, 0, 3.0, 3.0, 0.15, 0.15, 1)
	ShowSyncHudMsg(killer_id, gmsgHudSync, "::HEADSHOT::^nYou Owned %s !!",victim_name)
	}

	if (hsmode_bit & 2)
	{
		for(new i=1;i<=get_maxplayers();i++) 
			if( is_user_connected(i)==1 )
				client_cmd(i,"spk misc/headshot")
	}
}

public plugin_precache()
{
	precache_sound("misc/monsterkill.wav")
	precache_sound("misc/godlike.wav")
	precache_sound("misc/headshot.wav")
	precache_sound("misc/humiliation.wav")
	precache_sound("misc/killingspree.wav")
	precache_sound("misc/multikill.wav")
	precache_sound("misc/ultrakill.wav")
	precache_sound("misc/maytheforce.wav")
	precache_sound("misc/oneandonly.wav")
	precache_sound("misc/rampage.wav")
	precache_sound("misc/holyshit.wav")
	precache_sound("misc/megakill.wav")
	precache_sound("misc/wickedsick.wav")
	precache_sound("misc/ludacrisskill.wav")
        
	return PLUGIN_CONTINUE 
}