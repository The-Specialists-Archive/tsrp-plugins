/* Plugin generated by AMXX-Studio */

#include <amxmodx>
#include <amxmisc>
#include <ApolloRP>
#include <ApolloRP_Chat>

new Class:g_Class[33]

new p_Table
new g_JailTime[33]

new g_Jailer[33]

public plugin_init() 
{
	register_event("DeathMsg","EventDeathMsg","a")
	ARP_AddChat(_,"CmdSay")
	register_cvar("arp_jail_release_x","0")
	register_cvar("arp_jail_release_y","0")
	register_cvar("arp_jail_release_z","0")
}

public ARP_Init()
{
	ARP_RegisterPlugin("JailTimer","1.0","EagleEye","Allows cops to set a user's jailtime. When that time is up, the user is released.")	
	
	ARP_RegisterEvent("HUD_Render","EventHudRender")
	
	p_Table = register_cvar("arp_jailmod_table","arp_jailusers")
}

public CmdSay(id,Mode,Args[])
{
	if(!is_user_alive(id))
		return PLUGIN_HANDLED
	if(equali(Args,"/timereset",10))
	{
		new Index,Body
		get_user_aiming(id,Index,Body,200)
		
		if(!Index || !is_user_alive(Index))
			return PLUGIN_HANDLED
		if(g_JailTime[Index] > 0)
		{
			if(task_exists(Index)) remove_task(Index)
			if(task_exists(Index+100)) remove_task(Index+100)
			g_JailTime[Index] = 0
			new Name[33], JailerName[33]
			get_user_name(Index,Name,32)
			get_user_name(id,JailerName,32)
			client_print(id,print_chat,"[ARP] You have reset %s's jailtime!",Name)
			client_print(Index,print_chat,"[ARP] Your jailtime has been reset by %s!",JailerName)
		}
		else
			client_print(id,print_chat,"[ARP] That person is not jailed!")
		return PLUGIN_HANDLED
	}
	if(equali(Args,"/release",8))
	{
		if(!ARP_IsCop(id))
		{
			client_print(id,print_chat,"[ARP] You are not a cop.")
			return PLUGIN_HANDLED
		}
		
		new Index,Body
		get_user_aiming(id,Index,Body,200)
		
		if(!Index || !is_user_alive(Index))
			return PLUGIN_HANDLED
		
		if(!IsJailed(Index))
		{
			client_print(id,print_chat,"[ARP] That person is not jailed!")
			return PLUGIN_HANDLED
		}
		
		JailRelease(Index)
		return PLUGIN_HANDLED
	}
		
	if(equali(Args,"/jailtime",9))
	{
		if(!ARP_IsCop(id))
		{
			client_print(id,print_chat,"[ARP] You are not a cop.")
			return PLUGIN_HANDLED
		}
		
		new Index,Body
		get_user_aiming(id,Index,Body,200)
		
		if(!Index || !is_user_alive(Index))
			return PLUGIN_HANDLED
		
		if(ARP_IsCop(Index))
		{
			client_print(id,print_chat,"[ARP] You cannot set other cops' jailtime.")
			return PLUGIN_HANDLED
		}
		if(IsJailed(Index) == 0)
		{
			client_print(id,print_chat,"[ARP] That person is not jailed!")
			return PLUGIN_HANDLED
		}
		if(g_JailTime[Index] > 0)
		{
			client_print(id,print_chat,"[ARP] That peroson already has a jailtime set. Type /timereset to remove it!")
			return PLUGIN_HANDLED
		}
		new Temp[33]
		parse(Args,Args,255,Temp,32)
		new Float:time = str_to_float(Temp)
		
		if(time <= 0.0)
		{
			client_print(id,print_chat,"[ARP] Invalid Time - Usage: /jailtime <minutes>")
			return PLUGIN_HANDLED
		}
		new Name[33], JailerName[33]
		get_user_name(Index,Name,32)
		get_user_name(id,JailerName,32)
		
		client_print(Index,print_chat,"[ARP] Your jailtime has been set to %f minutes by %s.",time,JailerName)
		client_print(id,print_chat,"[ARP] You have set %s's jailtime to %f minutes",Name,time)
		g_Jailer[Index] = id
		
		time = (time * 60.0)
		g_JailTime[Index] = floatround(time)
		set_task(1.0,"JailCount",Index+100,"",0,"a",g_JailTime[Index])
		set_task(time,"JailRelease",Index)
		return PLUGIN_HANDLED
	}
	return PLUGIN_CONTINUE
}

IsJailed(id)
{
	return ARP_ClassGetInt(g_Class[id],"jail")
}

IsCuffed(id)
{
	return ARP_ClassGetInt(g_Class[id],"cuff")
}

public JailCount(id)
{
	id -=100
	if(!IsJailed(id))
	{
		remove_task(id+100)
		g_JailTime[id] = 0
	}
	else
	{
		if(g_JailTime[id] > 0)
		{
			g_JailTime[id]--
		}
	}
	return PLUGIN_HANDLED
}

public JailRelease(id)
{
	if(!IsJailed(id))
		return PLUGIN_CONTINUE
	
	if(task_exists(id)) remove_task(id)
	if(task_exists(id+100)) remove_task(id+100)
	g_JailTime[id] = 0
	
	new jailpos[3]
	jailpos[0] = get_cvar_num("arp_jail_release_x")
	jailpos[1] = get_cvar_num("arp_jail_release_y")
	jailpos[2] = get_cvar_num("arp_jail_release_z")
	set_user_origin(id,jailpos)
	
	client_print(id,print_chat,"[ARP] Your time is up!")	
	ARP_ClassSetInt(g_Class[id],"jail",0)
	
	if(IsCuffed(id))
	{
		new Data[3]
		Data[0] = id
		Data[1] = g_Jailer[id]
		Data[2] = !IsCuffed(id)
		callfunc_begin("EventCuffed","ARP_JailMod.amxx")
		callfunc_push_str("")
		callfunc_push_array(Data,3)
		callfunc_push_int(3)
		callfunc_end()
	}
	
	return PLUGIN_HANDLED
} 

public client_disconnect(id)
{
	if(task_exists(id)) remove_task(id)
	if(task_exists(id+100)) remove_task(id+100)
	g_JailTime[id] = 0
	g_Jailer[id] = 0
}

public client_putinserver(id)
{
	new Data[10],Authid[36],Table[33]
	get_user_authid(id,Authid,35)
	
	num_to_str(id,Data,9)

	get_pcvar_string(p_Table,Table,32)
	
	ARP_ClassLoad(Authid,"ClassLoad",Data,Table)
}
public ClassLoad(Class:class_id,const class[],data[])
{
	new id = str_to_num(data)
	g_Class[id] = class_id
	
}
public EventDeathMsg()
{	
	new id = read_data(2)
	if(!is_user_connected(id))
		return

	if(task_exists(id)) remove_task(id)
	if(task_exists(id+100)) remove_task(id+100)
	g_JailTime[id] = 0
	g_Jailer[id] = 0

}
public EventHudRender(Name[],Data[],Len)
{	
	new id = Data[0]
	if(!is_user_alive(id) || Data[1] != HUD_PRIM)
		return
		
	if(IsJailed(id))
	{
		if(g_JailTime[id] > 0)
		{
			ARP_AddHudItem(id,HUD_PRIM,0,"Jail Time Remaining: %i seconds",g_JailTime[id])
		}
		else
		{
			ARP_AddHudItem(id,HUD_PRIM,0,"Jail time not set")
		}
	}	
}
