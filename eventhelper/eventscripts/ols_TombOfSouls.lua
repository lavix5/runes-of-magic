local me = {
	strings = {
		BOSS1START = {"LUA_109015_AI_FIGHTBEGIN", true}, -- boss 1 fight begin
		BOSS1DEAD = {"LUA_109015_AI_BOSSDEAD", true},
		BOSS1RAGE = {"LUA_109015_AI_BOSSFRENZY", true},
		BOSS1WIN = {"LUA_109015_AI_BOSSWIN", true},
		BOSS2START = {"LUA_109016_AI_FIGHTBEGIN", true}, -- boss 1 fight begin

		BOSS2DEAD = {"LUA_109016_AI_BOSSDEAD", true},
		BOSS2RAGE = {"LUA_109016_AI_BOSSFRENZY", true},
		BOSS2WIN = {"LUA_109016_AI_BOSSWIN", true},
		BOSS2ADDS = {"LUA_109016_AI_SUMMONDEAD", true},
		BOSS2EARTHQUEAKE = {"LUA_109016_AI_SHAKEEARTH"},

		BOSS4START = { "LUA_109021_AI_FIGHTBEGIN", true}, -- Boss 4 fight begin
		ADDS4 = {"LUA_109021_AI_PHANTOM_CAST", true}, -- Boss 4 - adds (addy)
		ADDS4END = {"LUA_109021_AI_PHANTOM_TRUE", true}, -- Boss 4 - killed adds, boss shows (boss się pokazuje po zabiciu addów)
		SWEEP4 = {"LUA_109021_AI_CALLS", true}, -- Boss 4 - sweep (przyciągnięcie)
		BOSS4RAGE = {"LUA_109021_AI_BOSSFRENZY", true}, -- Boss 4 rage
		BOSS4END = {"LUA_109021_AI_BOSSDEAD", true}, -- Boss 4 end
		BOSS4PLAYERSDEAD = {"LUA_109021_AI_BOSSWIN", true}, -- Boss 4 players dead
	},
	vars = {
		Boss1_timer = false,
		timerstate = {[0]=10,[1]=20,[2]=29,[3]=30,[4]=31,[5]=32,[6]=33},
		--timerstate = {[0]=0,[1]=10,[2]=11,[3]=12,[4]=13,[5]=14,[6]=15,[7]=16,[8]=17,[9]=18,[10]=19, [11]=20,[12]=21,[13]=22,[14]=23,[15]=24,[16]=25,[17]=26,[18]=27,[19]=28,[20]=29,[21]=30,[22]=31,[23]=32,[24]=33,[25]=34,[26]=35,[27]=36,[28]=37,[29]=38,[30]=39,[31]=40,[32]=41,[33]=42,[34]=43,[35]=44,[36]=45,[37]=46,[38]=47,[39]=48,[40]=49,[41]=50,[42]=51,[43]=52,[44]=53,[45]=54,}, -- 10 sekund trwa takta, 54 sekundy są między taktykami
		--buffs = {TargetChange=false,TargetIcon=false,},
		--cast={},
		--savedstate = 0, --saved timer state when adds show
	},
	Settings = {
		active = true,
	},
}

function me.GetSettings()
	return me.Settings
end

function me.SetSettings(tbl)
	if type(tbl)=="table" then
		me.Settings=tbl
	end
end

function me.LoadEvent(frame)
	ev.fn.AddHook("SendSystemMsg")
	frame:RegisterEvent("CHAT_MSG_PARTY")
	frame:RegisterEvent("UNIT_BUFF_CHANGED")
	frame:RegisterEvent("UNIT_CASTINGTIME")
	me.strings = ev.helper.ReplaceTranslateRegex2(me.strings)
end

function me.GetName()
	return GetZoneLocalName(188)
end

function me.IsActive()
	local zone = GetZoneID()
	return zone == 187 or zone == 188 or zone == 189
end

function me.OnUpdate()
	if me.vars.Boss1_timer then -- Boss 1 tactic timer
		local tmr = GetTime() - me.vars.Boss1_timer.time
		local state = me.vars.Boss1_timer.state
		if tmr > me.vars.timerstate[state] then
			if state>1 then 
				tmr=tmr-1 
				ev.helper.PlaySound(string.format("Countdown/cd%d.mp3", 7-state))
			end
			
			ev.SendMessage(ev.helper.ReturnLoca("interrupt_boss", 34-tmr), nil, {warning=true})
			me.vars.Boss1_timer.state = state + 1
			--if #me.vars.timerstate==state then 
			--	me.vars.Boss1_timer = {time=GetTime(), state=1}
			--end
		end
		--[[
		if tmr == 0 then
			tmr = GetTime()
			state = 0
		end
		]]--
	end
	--[[
	if me.vars.Boss2_timer then -- Boss 1 tactic timer
		local tmr = GetTime() - me.vars.Boss2_timer.time
		local state = me.vars.Boss2_timer.state
		if tmr > me.vars.timerstate[state] then
			if state>1 then 
				tmr=tmr-1 
				ev.helper.PlaySound(string.format("Countdown/cd%d.mp3", 7-state))
			end
			
			ev.SendMessage(ev.helper.ReturnLoca("interrupt_boss", 34-tmr), nil, {warning=true})
			me.vars.Boss2_timer.state = state + 1
			if #me.vars.timerstate==state then 
				me.vars.Boss2_timer = {time=GetTime(), state=1}
			end
		end
		--[[
		if tmr == 0 then
			tmr = GetTime()
			state = 0
		end
		]--
	end
	if me.vars.Boss3_timer then -- Boss 1 tactic timer
		local tmr = GetTime() - me.vars.Boss3_timer.time
		local state = me.vars.Boss3_timer.state
		if tmr > me.vars.timerstate[state] then
			if state>1 then 
				tmr=tmr-1 
				ev.helper.PlaySound(string.format("Countdown/cd%d.mp3", 7-state))
			end
			
			ev.SendMessage(ev.helper.ReturnLoca("interrupt_boss", 34-tmr), nil, {warning=true})
			me.vars.Boss3_timer.state = state + 1
			if #me.vars.timerstate==state then 
				me.vars.Boss3_timer = {time=GetTime(), state=1}
			end
		end
		
		if tmr == 0 then
			tmr = GetTime()
			state = 0
		end
		
	end
	if me.vars.Boss4_timer then -- Boss 1 tactic timer
		local tmr = GetTime() - me.vars.Boss4_timer.time
		local state = me.vars.Boss4_timer.state
		if tmr > me.vars.timerstate[state] then
			if state>1 then 
				tmr=tmr-1 
				ev.helper.PlaySound(string.format("Countdown/cd%d.mp3", 7-state))
			end
			
			ev.SendMessage(ev.helper.ReturnLoca("interrupt_boss", 34-tmr), nil, {warning=true})
			me.vars.Boss4_timer.state = state + 1
			if #me.vars.timerstate==state then 
				me.vars.Boss4_timer = {time=GetTime(), state=1}
			end
		end
		--[
		if tmr == 0 then
			tmr = GetTime()
			state = 0
		end
		--
		--
	end
	]]--
end

------------------------------------------------
---------------- Hooked Functions --------------
------------------------------------------------

function me.SendSystemMsg(txt)
	local playername = UnitName("player")
	--if  string.find(txt, me.strings.BOSS4START) then -- fight starts
		--me.vars.Boss_timer = {time=GetTime(), state=1}
	if string.find(txt, me.strings.BOSS1START) then --fight starts
		me.vars.Boss1_timer = {time=GetTime(), state=1} -- 
	--elseif 	string.find(txt, me.strings.BOSS1END) or 
	--		string.find(txt, me.strings.BOSS1WIN) or
	--		string.find(txt, me.strings.BOSS1RAGE) or
	--		string.find(txt, me.strings.BOSS1DEAD) then
	--		me.vars.Boss1_timer = false
	--[[
	elseif string.find(txt, me.strings.ADDS4) then -- adds show
		me.vars.Boss4_timer = {time=GetTime(), savedstate=state}
	elseif string.find(txt, me.strings.ADDS4END) then -- boss shows after killing adds
		me.vars.Boss4_timer = {time=GetTime(), state=savedstate}
	elseif string.find(txt, me.strings.SWEEP4) then -- boss sweeps players
		me.vars.Boss4_timer = {time=GetTime(), state=state-3}
		]]--
	else
		return txt;
	end
end

------------------------------------------------
----------------- Event Handler ----------------
------------------------------------------------

function me.CHAT_MSG_PARTY(this, event, arg1,arg2,arg3,arg4)
	if arg4~=UnitName("player") then
		local id = string.match(arg1, "|Hev:(%d+)|h|h")
		if id == "501891" then
			ev.SendMessage(ev.helper.ReturnLoca("damagereflect_message2", string.format("%s %s",me.strings.targetchange, arg4)), "stopattack.mp3", {system=true})
		end
	end
end

function me.UNIT_CASTINGTIME(this, event, unit, timeORnil)
	if timeORnil==nil then me.vars.cast[UnitGUID(unit)]=nil return end -- if end of cast do delete cast
	name,_,curr = UnitCastingTime(unit);
	if type(me.vars.cast[UnitGUID(unit)])=="table" 
	and me.vars.cast[UnitGUID(unit)][1]==name -- if castname of target == saved cast
	and me.vars.cast[UnitGUID(unit)][2] < GetTime() then -- and the cast isn't finished -> do nothing
		return 
	end;
	me.vars.cast[UnitGUID(unit)] = {name,GetTime()+curr} -- else save the castname and time
	if name == me.strings.blackabyss then -- Black Abyss Terror - Mazzren (5)
		ev.SendMessage(ev.helper.ReturnLoca("interrupt_message", UnitName(unit), me.strings.blackabyss), "interrupt.mp3", {system=true})
	end
end

function me.UNIT_BUFF_CHANGED(this, event, arg1)
	if arg1=="player" then
		ev.helper.ReadBuffs()
		me.HandleBuffs()
	end
end

function me.HandleBuffs() 
	if ev.helper.GetBuff(501891) then -- Target Change - Nex of Tasuq (2)
		if not me.vars.buffs.TargetChange then
			me.vars.buffs.TargetChange=true;
			
			ev.SendMessage(ev.helper.ReturnLoca("damagereflect_message1",  me.strings.targetchange), "rip.mp3", {system=true})
			ev.SendChatMessage(ev.helper.ReturnLoca("buff_message1", UnitName("player"),  me.strings.targetchange).."|Hev:501891|h|h", nil, {"PARTY"})
		end
	else
		me.vars.buffs.TargetChange=false;
	end

	if ev.helper.GetBuff(502913) then -- Target Icon - Mazzren (5)
		if not me.vars.buffs.TargetIcon then
			me.vars.buffs.TargetIcon=true;
			
			ev.SendMessage(ev.helper.ReturnLoca("stayaway_message2",  me.strings.targeticon), "runawaymonster.mp3", {system=true})
			ev.SendChatMessage(ev.helper.ReturnLoca("buff_message1", UnitName("player"),  me.strings.targeticon).."|Hev:502913|h|h", nil, {"PARTY"})
		end
	else
		me.vars.buffs.TargetIcon=false;
	end
end

return me;
