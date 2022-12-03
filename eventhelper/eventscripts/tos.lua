local me = {
	strings = {
		BOSS1START = {"LUA_109015_AI_FIGHTBEGIN", true}, -- boss 1 fight begin
		BOSS1DEAD = {"LUA_109015_AI_BOSSDEAD", true},
		BOSS1RAGE = {"LUA_109015_AI_BOSSFRENZY", true},
		BOSS1WIN = {"LUA_109015_AI_BOSSWIN", true},

		BOSS2START = {"LUA_109016_AI_FIGHTBEGIN", true},
		BOSS2DEAD = {"LUA_109016_AI_BOSSDEAD", true},
		BOSS2RAGE = {"LUA_109016_AI_BOSSFRENZY", true},
		BOSS2WIN = {"LUA_109016_AI_BOSSWIN", true},
		BOSS2ADDS = {"LUA_109016_AI_SUMMONDEAD", true},
		BOSS2EARTHQUAKE = {"LUA_109016_AI_SHAKEEARTH", true},

		BOSS3START = {"LUA_109018_AI_FIGHTBEGIN", true},
		BOSS3DEAD = {"LUA_109018_AI_BOSSDEAD", true},
		BOSS3RAGE = {"LUA_109018_AI_BOSSFRENZY", true},
		BOSS3WIN = {"LUA_109018_AI_BOSSWIN", true},
		BOSS3HIDE = {"LUA_109018_AI_SANDSTORM", true}, --22 seconds of being hidden

		BOSS4START = { "LUA_109021_AI_FIGHTBEGIN", true},
		BOSS4ADDS = {"LUA_109021_AI_PHANTOM_CAST", true}, 
		BOSS4ADDEND = {"LUA_109021_AI_PHANTOM_TRUE", true}, 
		BOSS4SWEEP = {"LUA_109021_AI_CALLS", true}, 
		BOSS4RAGE = {"LUA_109021_AI_BOSSFRENZY", true},
		BOSS4DEAD = {"LUA_109021_AI_BOSSDEAD", true},
		BOSS4WIN = {"LUA_109021_AI_BOSSWIN", true},

		lightofannihilation = {"Sys495521_name", true} -- Light of Annihilation - 4th boss

		
	},
	vars = {
		Boss1_timer = false,
		Boss2_timer = false,
		Boss3_timer = false,
		Boss3_timer2 = false,
		Boss4_timer = false,
		timer1state = {[0]=0,[1]=10,[2]=20,[3]=21,[4]=22,[5]=23,[6]=24},
		timer2state = {[0]=0,[1]=10,[2]=16,[3]=17,[4]=18,[5]=19,[6]=20},
		timer3state = {[0]=0,[1]=20,[2]=26,[3]=27,[4]=28,[5]=29,[6]=30},
		timer32state = {[0]=0,[1]=10,[2]=17,[3]=18,[4]=19,[5]=20,[6]=21},
		timer4state = {[0]=0,[1]=10,[2]=44,[3]=50,[4]=52,[5]=53,[6]=54},
		Boss4_addstime = false,
		Boss4_savedtime = false,
		Boss4_savedstate = false,
		
		cast={}

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

	if me.vars.Boss1_timer then -- timer; Boss 1
		local tmr = GetTime() - me.vars.Boss1_timer.time
		local state = me.vars.Boss1_timer.state
		if tmr > me.vars.timer1state[state] then
			if state>1 then 
				tmr=tmr-1 
				ev.helper.PlaySound(string.format("Countdown/cd%d.mp3", 7-state))
			end
			
			ev.SendMessage(ev.helper.ReturnLoca("interrupt_boss", 24-math.floor(tmr)), nil, {warning=true})
			me.vars.Boss1_timer.state = state + 1
			if #me.vars.timer1state==state then me.vars.Boss1_timer = {time=GetTime(), state=0} end
		end
		if me.vars.Boss1_timer.time < -2 then
			me.vars.Boss1_timer = false
		end
	end
	

	if me.vars.Boss2_timer then -- timer; Boss 2
		local tmr = GetTime() - me.vars.Boss2_timer.time
		local state = me.vars.Boss2_timer.state
		if tmr > me.vars.timer2state[state] then
			if state>1 then 
				tmr=tmr-1 
				ev.helper.PlaySound(string.format("Countdown/cd%d.mp3", 7-state))
			end
			
			ev.SendMessage(ev.helper.ReturnLoca("interrupt_boss", 20-math.floor(tmr)), nil, {warning=true})
			me.vars.Boss2_timer.state = state + 1
			if #me.vars.timer2state==state then me.vars.Boss2_timer = {time=GetTime(), state=0} end
		end
		if me.vars.Boss2_timer.time < -2 then
			me.vars.Boss2_timer = false
		end
	end

	if me.vars.Boss3_timer then -- timer; Boss 3
		local tmr = GetTime() - me.vars.Boss3_timer.time
		local state = me.vars.Boss3_timer.state
		if tmr > me.vars.timer3state[state] then
			if state>1 then 
				tmr=tmr-1 
				ev.helper.PlaySound(string.format("Countdown/cd%d.mp3", 7-state))
			end
			
			ev.SendMessage(ev.helper.ReturnLoca("mobs_spawn", 30-math.floor(tmr)), nil, {warning=true})
			me.vars.Boss3_timer.state = state + 1
			if #me.vars.timer3state==state then me.vars.Boss3_timer = {time=GetTime(), state=0} end
			end
		if me.vars.Boss3_timer.time < -2 then
			me.vars.Boss3_timer = false
		end
	end

	if me.vars.Boss3_timer2 then -- timer; Boss 3 - when boss is hidden
		local tmr = GetTime() - me.vars.Boss3_timer2.time
		local state = me.vars.Boss3_timer2.state
		if tmr > me.vars.timer32state[state] then
			if state>1 then 
				tmr=tmr-1 
				ev.helper.PlaySound(string.format("Countdown/cd%d.mp3", 7-state))
			end
			
			ev.SendMessage(ev.helper.ReturnLoca("boss_shows", 21-math.floor(tmr)), nil, {warning=true})
			me.vars.Boss3_timer2.state = state + 1
			if #me.vars.timer32state==state then me.vars.Boss3_timer2=false end
		end
	end

	if me.vars.Boss4_timer then -- timer; Boss 4
		local tmr = GetTime() - me.vars.Boss4_timer.time
		local state = me.vars.Boss4_timer.state
		if tmr > me.vars.timer4state[state] then
			if state>1 then 
				tmr=tmr-1 
				ev.helper.PlaySound(string.format("Countdown/cd%d.mp3", 7-state))
			end
			
			ev.SendMessage(ev.helper.ReturnLoca("boss4_circles", 54-math.floor(tmr)), nil, {warning=true})
			me.vars.Boss4_timer.state = state + 1
			if #me.vars.timer4state==state then me.vars.Boss4_timer = {time=GetTime(), state=0} end
		end
		if me.vars.Boss4_timer.time < -2 then
			me.vars.Boss4_timer = false
		end
	end

end

------------------------------------------------
---------------- Hooked Functions --------------
------------------------------------------------

function me.SendSystemMsg(txt)
	local playername = UnitName("player")
	if string.find(txt, me.strings.BOSS1START) then
		--SendChatMessage("start of boss", "SAY")
		me.vars.Boss1_timer = {time=GetTime(), state=0}
	elseif 	string.find(txt, me.strings.BOSS1DEAD) or
			string.find(txt, me.strings.BOSS1RAGE) or
			string.find(txt, me.strings.BOSS1WIN) then
				--SendChatMessage("end of boss", "SAY")
				me.vars.Boss1_timer = false				

	elseif string.find(txt, me.strings.BOSS2START) then
		me.vars.Boss2_timer = {time=GetTime()-2, state=0}
		--SendChatMessage("start of boss", "SAY")
	elseif string.find(txt, me.strings.BOSS2DEAD) or
		string.find(txt, me.strings.BOSS2RAGE) or
		string.find(txt, me.strings.BOSS2WIN) then
			me.vars.Boss2_timer = false
			--SendChatMessage("end of boss", "SAY")
	elseif string.find(txt, me.strings.BOSS2ADDS) then
			me.vars.Boss2_timer.time = me.vars.Boss2_timer.time + 2
	elseif	string.find(txt, me.strings.BOSS2EARTHQUAKE) then
			me.vars.Boss2_timer.time = me.vars.Boss2_timer.time + 1

	elseif string.find(txt, me.strings.BOSS3START) then
		--SendChatMessage("start of boss", "SAY")
		me.vars.Boss3_timer = {time=GetTime()-1, state=0}
	elseif string.find(txt, me.strings.BOSS3DEAD) or
			string.find(txt, me.strings.BOSS3RAGE) or
			string.find(txt, me.strings.BOSS3WIN) then
				me.vars.Boss3_timer = false
				--SendChatMessage("end of boss", "SAY")
	elseif string.find(txt, me.strings.BOSS3HIDE) then
		--SendChatMessage("boss hides", "SAY")
		me.vars.Boss3_timer.time = me.vars.Boss3_timer.time + 21
		me.vars.Boss3_timer2 = {time=GetTime(), state=0}

	elseif string.find(txt, me.strings.BOSS4START) then
		me.vars.Boss4_timer = {time=GetTime()-13, state=0}
		--SendChatMessage("start of boss", "SAY")
	elseif string.find(txt, me.strings.BOSS4DEAD) or
		string.find(txt, me.strings.BOSS4RAGE) or
		string.find(txt, me.strings.BOSS4WIN) then
			me.vars.Boss4_timer = false
			--SendChatMessage("end of boss", "SAY")
	elseif string.find(txt, me.strings.BOSS4ADDS) then
		me.vars.Boss4_addstime = GetTime()
		me.vars.Boss4_savedtime = me.vars.Boss4_timer.time
		me.vars.Boss4_savedstate = me.vars.Boss4_timer.state
		me.vars.Boss4_timer = false
		--SendChatMessage("adds", "SAY")
		--SendChatMessage("till circles left", "SAY")
		--SendChatMessage(54-math.floor(me.vars.Boss4_addstime-me.vars.Boss4_savedtime), "SAY")
		--SendChatMessage("seconds", "SAY")
	elseif string.find(txt, me.strings.BOSS4ADDEND) then
		--SendChatMessage("boss shows", "SAY")
		me.vars.Boss4_timer = {time=GetTime()-me.vars.Boss4_addstime+me.vars.Boss4_savedtime, state=me.vars.Boss4_savedstate}
		--SendChatMessage("Adds killed in", "SAY")
		--SendChatMessage(math.floor(GetTime()-me.vars.Boss4_addstime), "SAY")
		--SendChatMessage("seconds", "SAY")
	elseif string.find(txt, me.strings.BOSS4SWEEP) then 
			me.vars.Boss4_timer.time = me.vars.Boss4_timer.time + 3
			--SendChatMessage("Interrupt!", "SAY")

	else
		return txt;
	end
end

------------------------------------------------
----------------- Event Handler ----------------
------------------------------------------------

function me.UNIT_CASTINGTIME(this, event, unit, timeORnil)
	if timeORnil==nil then me.vars.cast[UnitGUID(unit)]=nil return end -- if end of cast do delete cast
	name,_,curr = UnitCastingTime(unit);

	me.vars.cast[UnitGUID(unit)] = {name,GetTime()+curr} -- else save the castname and time
	--SendChatMessage("cast", "SAY")
	if name == me.strings.lightofannihilation then -- Light of Annihilation - 4th Boss
		ev.SendMessage(ev.helper.ReturnLoca("interrupt_message", UnitName(unit), me.strings.lightofannihilation), "interrupt.mp3", {system=true})
		me.vars.Boss4_timer.time = me.vars.Boss4_timer.time + 3
	end
end

return me;
