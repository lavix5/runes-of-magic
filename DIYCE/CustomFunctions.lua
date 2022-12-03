 
local WHITE = "|cffffffff"
local SILVER = "|cffc0c0c0"
local GREEN = "|cff00ff00"
local LTBLUE = "|cffa0a0ff"
function DIYCE_DebugSkills(skillList)
    DEFAULT_CHAT_FRAME:AddMessage(GREEN.."Skill List:")
    
    for i,v in ipairs(skillList) do
        DEFAULT_CHAT_FRAME:AddMessage(SILVER.."  ["..WHITE..i..SILVER.."]: "..LTBLUE.."\" "..WHITE..v.name..LTBLUE.."\"  use = "..WHITE..(v.use and "true" or "false"))
    end
    DEFAULT_CHAT_FRAME:AddMessage(GREEN.."----------")
end
function DIYCE_DebugBuffList(buffList)
    DEFAULT_CHAT_FRAME:AddMessage(GREEN.."Buff List:")
    
    for k,v in pairs(buffList) do
        -- We ignore numbered entries because both the ID and name 
        -- are stored in the list. This avoids doubling the output.
        if type(k) ~= "number" then
            DEFAULT_CHAT_FRAME:AddMessage(SILVER.."  ["..WHITE..k..SILVER.."]:  "..LTBLUE.."id: "..WHITE..v.id..LTBLUE.."  stack: "..WHITE..v.stack..LTBLUE.."  time: "..WHITE..v.time)
        end
    end
    
    DEFAULT_CHAT_FRAME:AddMessage(GREEN.."----------")    
end
local silenceList = {
  ["Tajemna Interwencja"]  = true,
  ["Płonąca Kula Ognia"]  = true,
  ["Strumień Płomienia"]  = true,
  ["Pajęcza Pieczęć"]  = true,
  ["Rozrzucenie Sieci"]  = true,
  ["Boski Wstrząs"]  = true,
  ["Wyrzut"]  = true,
  ["Telekineza"]  = true,
  ["Wściekła Lecąca Pięść"]  = true,
  ["Trzęsienie"]  = true,
  ["Zmiażdżenie Duszy"]  = true,
  ["Dryf Duszy"]  = true,
  ["Przywołanie Umarłych"]  = true,
  ["Światło Anihilacji"]  = true,
  ["Nekromanta"]  = true,
  ["Ziemny Pług"]  = true,
  ["Burza Piaskowa"]  = true,
  ["Rzut Kulką Gnoju"]  = true,
  ["Annihilation"]  = true,
  ["Gorejący Płomień"]  = true,
  ["King Bug Shock"]  = true,
  ["Mana Rift"]   = true,
  ["Dream of Gold"]  = true,
  ["Flame"]    = true,
  ["Flame Spell"]  = true,
  ["Wave Bomb"]   = true,
  ["Silence"]   = true,
  ["Recover"]   = true,
  ["Restore Life"]  = true,
  ["Heal"]    = true,
  ["Curing Shot"]  = true,
  ["Leaves of Fire"]  = true,
  ["Urgent Heal"]  = true,
  ["Merging Rune"]  = true, --Jacklin Sardo
  ["Heavy Shelling"]  = true, --Juggler Apprentice in Grafu
  ["Dark Healing"]    = true, --Mini-boss in Sardo
     }
function KillSequence(arg1, goat2, healthpot, manapot, foodslot)
--arg1 = "v1" or "v2" for debugging
--healthpot = # of actionbar slot for health potions
--manapot = # of actionbar slot for mana potions
--foodslot = # of actionbar slot for food (add more args for more foodslots if needed)
    local Skill = {}
    local Skill2 = {}
    local i = 0
    
    -- Player and target status.
    local combat = GetPlayerCombatState()
    local enemy = UnitCanAttack("player","target")
    local EnergyBar1 = UnitMana("player")
    local EnergyBar2 = UnitSkill("player")
    local pctEB1 = PctM("player")
    local pctEB2 = PctS("player")
    local tbuffs = BuffList("target")
    local pbuffs = BuffList("player")
    local tDead = UnitIsDeadOrGhost("target")
    local behind = (not UnitIsUnit("player", "targettarget"))
    local melee = GetActionUsable(61) -- # is your melee range spell slot number
    local a1,a2,a3,a4,a5,ASon = GetActionInfo(14)  -- # is your Autoshot slot number
    local phealth = PctH("player")
    local thealth = PctH("target")
    local LockedOn = UnitExists("target")
    local boss = UnitSex("target") > 2
    local elite = UnitSex("target") == 2
    local party = GetNumPartyMembers() >= 2
	local PsiPoints, PsiStatus = GetSoulPoint()
	local UpionyAnubis = UnitName("target") == "Upiorny Anubis"
	local KarwarSzczatekZeba = UnitName("target") == "Karwar Szczątek Zęba"
    
    --Determine Class-Combo
    mainClass, subClass = UnitClassToken( "player" )
    --Silence Logic
    local tSpell,tTime,tElapsed = UnitCastingTime("target")
    local silenceThis = tSpell and silenceList[tSpell] and ((tTime - tElapsed) > 0.1)
    
    --Potion Checks
    healthpot = healthpot or 0
    manapot = manapot or 0
    



--Begin Player Skill Sequences
    
        --Priest = AUGUR, Druid = DRUID, Mage = MAGE, Knight = KNIGHT, 
        --Scout = RANGER, Rogue = THIEF, Warden = WARDEN, Warrior = WARRIOR

-- Class: Warrior/Warden
            if mainClass == "WARRIOR" and subClass == "WARDEN" then
   --Timers for this class
 CreateDIYCETimer("SSBleed", 6.5) 
 --Change the value between 6 -> 7.5 depending on your lag.
 --Potions and Buffs
Skill = {
{ name = "Instynkt Przetrwania",      use = (phealth <= .49) },
{ name = "Amulet Elfów",       use = (EnergyBar2 >= 150) and (phealth <= .35) },
}
--Combat
if enemy then
Skill = { 
--{ name = "Przebudzenie Dzikości",      use = (tbuffs[501502]) },
{ name = "Wybuchowy Cyklon",      use = (tbuffs[502112]) and (EnergyBar2 >= 35) },
{ name = "Naładowane Cięcie",      use = (EnergyBar2 >= 320) },
{ name = "Dziki Wir",      use = (EnergyBar2 >= 470) },
{ name = "Odsłonięta Flanka",      use = (EnergyBar1 >= 10) and (tbuffs[501502]) },
{ name = "Atak Taktyczny",      use = ((tbuffs[500081]) and (EnergyBar1 >= 15)) },
{ name = "Próbny Atak",      use = (EnergyBar1 >= 20) },
{ name = "Cięcie",      use = (EnergyBar1 >= 25), timer = "SSBleed", ignoretimer = (pbuffs["Agresywność"]) },
{ name = "Naładowane Cięcie",      use = (EnergyBar2 >= 320) },
{ name = "Atak",      use =    true},timer = "SSBleed",
}
end

-- Class: Warden/Warrior
            elseif mainClass == "WARDEN" and subClass == "WARRIOR" then
			
if enemy then
Skill = { 
{ name = "Naładowane Cięcie",      use = (EnergyBar1 >= 320) },
{ name = "Mistrz Pulsu",      use = ((tbuffs[620690]) and(EnergyBar2 >= 20)) },
{ name = "Bestialskie Cięcie",      use = (EnergyBar2 >= 20) },
{ name = "Podwójne Cięcie", use = (EnergyBar1 >= 200) },
{ name = "Cięcie",      use = (EnergyBar2 >= 25) },
{ name = "Ukośne Cięcie",      use = (EnergyBar1 >= 800) },
{ name = "Action: 5",      use = (EnergyBar1 >= 300) },
{ name = "Dzikie Ciernie",      use = (EnergyBar1 >= 1100) },
{ name = "Naładowane Cięcie",      use = (EnergyBar1 >= 320) },
{ name = "Atak",      use =    true},
}
end

-- Class: Warrior/Scout
            elseif mainClass == "WARRIOR" and subClass == "RANGER" then


if enemy then
Skill = { 
{ name = "Ostatnia Bitwa",      use = ( EnergyBar1 >= 25 and thealth < 0.3) },
{ name = "Wybuchowy Cyklon",      use = (tbuffs[502112]) and (EnergyBar2 >= 35) },
{ name = "Odsłonięta Flanka",      use = (tbuffs[501502]) and (EnergyBar1 >= 10) },
{ name = "Atak Taktyczny",      use = ((tbuffs[500081]) and (EnergyBar1 >= 15)) },
{ name = "Próbny Atak",      use = (EnergyBar1 >= 20) },
{ name = "Cięcie",      use = (EnergyBar1 >= 26) },
{ name = "Łamacz Czaszek",      use = (EnergyBar2 >= 30) },
{ name = "Atak",      use =    true},
}
end

-- Class: Warden/Scout
            elseif mainClass == "WARDEN" and subClass == "RANGER" then
			
if enemy then
Skill = { 
{ name = "Naładowane Cięcie",      use = (EnergyBar1 >= 320) },
{ name = "Podporządkowanie",      use = (EnergyBar2 >= 40) },
{ name = "Ukośne Cięcie",      use = (EnergyBar1 >= 800) },
{ name = "Action: 5",      use = (EnergyBar1 >= 300) },
{ name = "Dzikie Ciernie",      use = (EnergyBar1 >= 1100) },
{ name = "Naładowane Cięcie",      use = (EnergyBar1 >= 320) },
{ name = "Atak",      use =    true},
}
end

-- Class: CH/P
            elseif mainClass == "PSYRON" and subClass == "AUGUR" then
			
if enemy then
Skill = { 
{ name = "Kuźnia",      use = (not pbuffs["Kuźnia"]) },
{ name = "Przypływ Energii Runicznej",      use = (EnergyBar1 >= 10 and not pbuffs["Przypływ Energii Runicznej"]) },
--{ name = "Wzrost Runiczny",      use = (not pbuffs["Runa Ochrony Sprzętu"] and not pbuffs["Runa Zwiększenia Ataku"]) },
{ name = "Runiczny Puls",      use = (pbuffs["Napęd Łańcuchowy"]) },
{ name = "Ciężkie Uderzenie",            use = (EnergyBar1 >= 20) and (not tbuffs[621164] or tbuffs[621164].stack<3 or tbuffs[621164].time < 3 ) },
{ name = "Nieustraszony Cios",      use = (EnergyBar1 >= 15) and thealth < 0.30 },
{ name = "Uderzenie Szoku",      use = (EnergyBar1 >= 25) },
{ name = "Pulsy Światła",      use = (EnergyBar2 >= 0.01) },
{ name = "Boska Zemsta",      use = (EnergyBar1 >= 15) },
{ name = "Atak",      use =    true},
}
end

-- Class: CH/Wr
            elseif mainClass == "PSYRON" and subClass == "HARPSYN" then
			
if enemy then
Skill = { 
{ name = "Uderzenie Szoku",      use = (silenceThis) },
{ name = "Porażenie Prądem",      use = (silenceThis) },
{ name = "Fala Próżni",                    use = (silenceThis) },
{ name = "Nieposkromiony Duch",      use = (EnergyBar1 >= 20) and (phealth <= .64) },
{ name = "Psychiczna Plaga",      use = (not pbuffs["Psychiczna Plaga"]) },
{ name = "Tajemnica Kuźni Dusz",      use = (not pbuffs["Tajemnica Kuźni Dusz"]) },
{ name = "Kuźnia",      use = (not pbuffs["Kuźnia"]) },
--{ name = "Pokaranie Mroczną Energią",      use = (not pbuffs["Pokaranie Mroczną Energią"]) },
--{ name = "Item: Kanapka z Kawiorem",use = (not pbuffs["Kanapka z Kawiorem"]) and boss },
--{ name = "Action: 8 (Demontaż Pogromcy)" , use = (pbuffs["Napęd Łańcuchowy"] and pbuffs["Tryb Demontażu"]) and (not pbuffs[624395] or tbuffs[624395].stack<4 or tbuffs[624395].time < 3 ) },
{ name = "Uderzenie Mrocznej Energii",      use = (EnergyBar1 >= 20) and (pbuffs["Postać Tarczy"]) and (pbuffs["Nieposkromiony Duch"]) },
{ name = "Runiczny Puls",      use = (pbuffs["Napęd Łańcuchowy"]) and (phealth >= .64) },
{ name = "Szarża Wypaczenia",      use = (EnergyBar2 >= 30) and (not pbuffs["Szarża Wypaczenia"]) },
{ name = "Niekończący się Puls",      use = (not pbuffs["Niekończący się Puls"]) and (pbuffs["Postać Tarczy"]) and (phealth >= .90) },
{ name = "Niekończący się Puls",      use = (not pbuffs["Niekończący się Puls"]) and (not pbuffs["Postać Tarczy"]) and (phealth >= .50) },
{ name = "Przypływ Energii Runicznej",      use = (EnergyBar1 >= 40 and pbuffs["Postać Tarczy"] and not pbuffs["Przypływ Energii Runicznej"] and not boss) },
{ name = "Wzrost Runiczny",      use = (not pbuffs["Runa Ochrony Sprzętu"] and not pbuffs["Runa Zwiększenia Ataku"]) },
{ name = "Nieustraszony Cios",      use = (EnergyBar1 >= 15) },
--{ name = "Runiczny Syfon",      use = (EnergyBar1 >= 10) and (EnergyBar2 >= 30) },
--{ name = "Runa Zbierania Serc",      use = (EnergyBar2 >= 35) },
--{ name = "Action: 2 (Straszny Demontaż)", use = (EnergyBar1 >= 10 and pbuffs["Tryb Demontażu"] ) },
--{ name = "Porażenie Prądem",      use = (EnergyBar1 >= 20) },
{ name = "Uderzenie Mrocznej Energii",      use = (EnergyBar1 >= 20) and (not pbuffs["Postać Tarczy"]) },
{ name = "Atak",      use =    true},
}
end

-- Class: CH/M
            elseif mainClass == "PSYRON" and subClass == "MAGE" and goat2=="dps" then
			
if enemy then
Skill = { 
{ name = "Kuźnia",      use = (not pbuffs["Kuźnia"]) },
{ name = "Postać Tarczy",      use = (not pbuffs["Postać Tarczy"] and not pbuffs["Tryb Demontażu"]) },
{ name = "Plaga Żywiołów", use = (tbuffs["Władne Odstraszanie"] and tbuffs["Cisza"]) },
{ name = "Błyskawica",      use = (silenceThis) and boss},
{ name = "Cisza",      use = (silenceThis) and boss},
{ name = "Fala Próżni",                    use = (silenceThis) and boss},
{ name = "Bariera Wysokiej Energii",      use = (not pbuffs["Bariera Wysokiej Energii"]) },
--{ name = "Action: 63 (Obronny Transfer Bitewny",      use = (EnergyBar1 >= 30 and not pbuffs["Transfer Obrony Bitewnej"]) },
--{ name = "Przypływ Energii Runicznej",      use = (EnergyBar1 >= 10 and not pbuffs["Przypływ Energii Runicznej"]) },
{ name = "Wzrost Runiczny",      use = (not pbuffs["Runa Ochrony Sprzętu"] and not pbuffs["Runa Zwiększenia Ataku"]) },
{ name = "Runiczny Puls",      use = (pbuffs["Napęd Łańcuchowy"]) },
{ name = "Przemodelowane Ciało", use = (phealth < .2) },
{ name = "Niekończący się Szał",      use = (_type == "DODGE") },
{ name = "Ciężkie Uderzenie",            use = (EnergyBar1 >= 20) },
{ name = "Nieustraszony Cios",      use = (EnergyBar1 >= 15) },
{ name = "Uderzenie Szoku",      use = (EnergyBar1 >= 25) },
{ name = "Porażenie Prądem",      use = (EnergyBar1 >= 20) },
{ name = "Gwałtowny Rozrzut",      use = (EnergyBar2 >= 576) },
{ name = "Zbroja Odwetu",      use = (EnergyBar2 >= 432) },
{ name = "Krwawe Doświadczenie",      use = (EnergyBar1 >= 10) },
{ name = "Miażdżąca Ofensywa",      use = (EnergyBar2 >= 25) },
{ name = "Wzrost Runiczny",      use = (not pbuffs["Runa Ochrony Sprzętu"] and not pbuffs["Runa Zwiększenia Ataku"]) },
{ name = "Atak",      use =    true},
}
end

-- Class: CH/M
            elseif mainClass == "PSYRON" and subClass == "MAGE" and goat2=="tank" then
			
if enemy then
Skill = { 
{ name = "Kuźnia",      use = (not pbuffs["Kuźnia"]) },
{ name = "Postać Tarczy",      use = (not pbuffs["Postać Tarczy"]) },
{ name = "Błyskawica",      use = (silenceThis) and boss},
{ name = "Cisza",      use = (silenceThis) and boss},
{ name = "Fala Próżni",                    use = (silenceThis) and boss},
{ name = "Bariera Wysokiej Energii",      use = (not pbuffs["Bariera Wysokiej Energii"]) },
--{ name = "Action: 63 (Obronny Transfer Bitewny",      use = (EnergyBar1 >= 30 and not pbuffs["Transfer Obrony Bitewnej"]) },
{ name = "Przypływ Energii Runicznej",      use = (EnergyBar1 >= 10 and not pbuffs["Przypływ Energii Runicznej"]) },
{ name = "Wzrost Runiczny",      use = (not pbuffs["Runa Ochrony Sprzętu"] and not pbuffs["Runa Zwiększenia Ataku"]) },
{ name = "Runiczny Puls",      use = (pbuffs["Napęd Łańcuchowy"]) },
{ name = "Przemodelowane Ciało", use = (phealth < .2) },
{ name = "Niekończący się Szał",      use = (_type == "DODGE") },
{ name = "Ciężkie Uderzenie",            use = (EnergyBar1 >= 20) and (not tbuffs[621164] or tbuffs[621164].stack<3 or tbuffs[621164].time < 3 ) },
{ name = "Nieustraszony Cios",      use = (EnergyBar1 >= 15) },
{ name = "Uderzenie Szoku",      use = (EnergyBar1 >= 25) },
{ name = "Porażenie Prądem",      use = (EnergyBar1 >= 20) },
{ name = "Gwałtowny Rozrzut",      use = (EnergyBar2 >= 576) },
{ name = "Zbroja Odwetu",      use = (EnergyBar2 >= 432) },
{ name = "Krwawe Doświadczenie",      use = (EnergyBar1 >= 10) },
{ name = "Miażdżąca Ofensywa",      use = (EnergyBar2 >= 25) },
{ name = "Wzrost Runiczny",      use = (not pbuffs["Runa Ochrony Sprzętu"] and not pbuffs["Runa Zwiększenia Ataku"]) },
{ name = "Atak",      use =    true},
}
end

-- Class: CH/R dps
            elseif mainClass == "PSYRON" and subClass == "THIEF" and goat2 == "dps" then
			
if enemy then
Skill = { 
{ name = "Porażenie Prądem",                    use = (silenceThis) and boss},
{ name = "Uderzenie Szoku",      use = (silenceThis) and boss},
{ name = "Fala Próżni",                    use = (silenceThis) and boss},
{ name = "Przemodelowane Ciało", use = (phealth < 0.15 and pbuffs["Postać Tarczy"]) },
{ name = "Runiczny Puls",      use = (pbuffs["Napęd Łańcuchowy"]) },
{ name = "Rzut",      use = true },
{ name = "Puls Cienia", use = (not boss and EnergyBar2 > 20) },
{ name = "Postać Tarczy",		use = (not pbuffs["Tryb Demontażu"] and pbuffs["Postać Tarczy"] and boss and not pbuffs["Runa Zwiększenia Ataku"]) },
{ name = "Wzrost Runiczny",      use = (not pbuffs["Runa Ochrony Sprzętu"] and not pbuffs["Runa Zwiększenia Ataku"]) },
{ name = "Postać Tarczy",		use = (not pbuffs["Tryb Demontażu"] and not pbuffs["Postać Tarczy"] and pbuffs["Runa Zwiększenia Ataku"] and boss) },
{ name = "Cienisty Wybuch",      use = (not pbuffs["Cienisty Wybuch"]) },
--{ name = "Action: 41(Kanapka z Kawiorem)",use = (not pbuffs["Kanapka z Kawiorem"]) and boss},
{ name = "Kuźnia",      use = (not pbuffs["Kuźnia"]) },
--{ name = "Przypływ Energii Runicznej",      use = (EnergyBar1 >= 10 and pbuffs["Postać Tarczy"] and not pbuffs["Przypływ Energii Runicznej"] and not boss) },
{ name = "Cienisty Krok",      use = (EnergyBar2 >= 20) and boss and not UpionyAnubis and not KarwarSzczatekZeba and not UnitName("target") == "Brama" and not UnitName("target") == "Główna Brama Fortecy"},
{ name = "Nieustraszone Ciosy",      use = (EnergyBar1 >= 15) },
{ name = "Cieniste Pchnięcie",      use = (EnergyBar2 >= 20) },
{ name = "Ciężkie Uderzenie",      use = (EnergyBar2 < 20) and (EnergyBar1 >= 60) and not pbuffs["Przeładowanie Runiczne"] },
{ name = "Atak",      use =    true},
}
end

-- Class: CH/R tank
            elseif mainClass == "PSYRON" and subClass == "THIEF" and goat2 == "tank" then
			
if enemy then
Skill = { 
{ name = "Porażenie Prądem",                    use = (silenceThis) and boss},
{ name = "Uderzenie Szoku",      use = (silenceThis) and boss},
{ name = "Fala Próżni",                    use = (silenceThis) and boss},
{ name = "Runiczny Puls",      use = (pbuffs["Napęd Łańcuchowy"]) },
{ name = "Przemodelowane Ciało", use = (phealth < 0.15) },
{ name = "Postać Tarczy",		use = (not pbuffs["Postać Tarczy"] ) },
{ name = "Rzut",      use = true },
{ name = "Cienisty Wybuch",      use = (not pbuffs["Cienisty Wybuch"]) },
--{ name = "Action: 41(Kanapka z Kawiorem)",use = (not pbuffs["Kanapka z Kawiorem"]) and boss},
{ name = "Kuźnia",      use = (not pbuffs["Kuźnia"]) },
{ name = "Przypływ Energii Runicznej",      use = (EnergyBar1 >= 10 and not pbuffs["Przypływ Energii Runicznej"]) },
{ name = "Wzrost Runiczny",      use = (not pbuffs["Runa Ochrony Sprzętu"] and not pbuffs["Runa Zwiększenia Ataku"]) },
{ name = "Nieustraszone Ciosy",      use = (EnergyBar1 >= 15) },
{ name = "Cieniste Pchnięcie",      use = (EnergyBar2 >= 20) },
{ name = "Ciężkie Uderzenie",            use = (EnergyBar1 >= 60) and (not tbuffs[621164] or tbuffs[621164].stack<3 or tbuffs[621164].time < 3 ) and not pbuffs["Przeładowanie Runiczne"] },
{ name = "Atak",      use =    true},
}
end

-- Class: CH/R no form
            elseif mainClass == "PSYRON" and subClass == "THIEF" and goat2 == "bezpostaci" then
			
if enemy then
Skill = { 
{ name = "Porażenie Prądem",                    use = (silenceThis) and boss},
{ name = "Uderzenie Szoku",      use = (silenceThis) and boss},
{ name = "Fala Próżni",                    use = (silenceThis) and boss},
{ name = "Przemodelowane Ciało", use = (phealth < 0.15 and pbuffs["Postać Tarczy"]) },
{ name = "Runiczny Puls",      use = (pbuffs["Napęd Łańcuchowy"]) },
{ name = "Rzut",      use = true },
{ name = "Puls Cienia", use = (not boss and EnergyBar2 > 20) },
--{ name = "Postać Tarczy",		use = (not pbuffs["Tryb Demontażu"] and pbuffs["Postać Tarczy"] and boss and not pbuffs["Runa Zwiększenia Ataku"]) },
{ name = "Wzrost Runiczny",      use = (not pbuffs["Runa Ochrony Sprzętu"] and not pbuffs["Runa Zwiększenia Ataku"]) },
--{ name = "Postać Tarczy",		use = (not pbuffs["Tryb Demontażu"] and not pbuffs["Postać Tarczy"] and pbuffs["Runa Zwiększenia Ataku"] and boss) },
{ name = "Cienisty Wybuch",      use = (not pbuffs["Cienisty Wybuch"]) },
--{ name = "Action: 41(Kanapka z Kawiorem)",use = (not pbuffs["Kanapka z Kawiorem"]) and boss},
{ name = "Kuźnia",      use = (not pbuffs["Kuźnia"]) },
--{ name = "Przypływ Energii Runicznej",      use = (EnergyBar1 >= 10 and pbuffs["Postać Tarczy"] and not pbuffs["Przypływ Energii Runicznej"] and not boss) },
{ name = "Cienisty Krok",      use = (EnergyBar2 >= 20) and boss and not UpionyAnubis and not KarwarSzczatekZeba},
{ name = "Nieustraszone Ciosy",      use = (EnergyBar1 >= 15) },
{ name = "Cieniste Pchnięcie",      use = (EnergyBar2 >= 20) },
{ name = "Atak",      use =    true},
}
end

-- Class: CH/-
--[[            elseif mainClass == "PSYRON" and subClass == "" and then
			
if enemy then
Skill = { 
{ name = "Kuźnia",      use = (not pbuffs["Kuźnia"]) },
--{ name = "Postać Tarczy",      use = (not pbuffs["Postać Tarczy"] and not pbuffs["Tryb Demontażu"]) },
--{ name = "Fala Próżni",                    use = (silenceThis) and boss},
--{ name = "Action: 63 (Obronny Transfer Bitewny",      use = (EnergyBar1 >= 30 and not pbuffs["Transfer Obrony Bitewnej"]) },
--{ name = "Przypływ Energii Runicznej",      use = (EnergyBar1 >= 10 and not pbuffs["Przypływ Energii Runicznej"]) },
{ name = "Wzrost Runiczny",      use = (not pbuffs["Runa Ochrony Sprzętu"] and not pbuffs["Runa Zwiększenia Ataku"]) },
{ name = "Runiczny Puls",      use = (pbuffs["Napęd Łańcuchowy"]) },
{ name = "Przemodelowane Ciało", use = (phealth < .2) },
{ name = "Ciężkie Uderzenie",            use = (EnergyBar1 >= 20) },
{ name = "Nieustraszony Cios",      use = (EnergyBar1 >= 15) },
--{ name = "Uderzenie Szoku",      use = (EnergyBar1 >= 25) },
--{ name = "Porażenie Prądem",      use = (EnergyBar1 >= 20) },
{ name = "Atak",      use =    true},
}
end
--]]

-- Class: Wr/M
            elseif mainClass == "HARPSYN" and subClass == "MAGE" then
			
if enemy then
Skill = { 
{ name = "Cisza",      use = (tbuffs["Władne Odstraszanie"]) },
{ name = "Błyskawica",      use = (silenceThis) and boss},
{ name = "Konstrukcja Siły Woli",      use = (PsiPoints == 6) and boss },
{ name = "Ostrze Siły Woli",      use = (PsiPoints == 6) and not boss },
{ name = "Ciąg Znamienia Duszy",      use = (pbuffs["Ostrze Siły Woli"]) and (PsiPoints >= 6) and not boss },
{ name = "Zdobycie Wiedzy",      use = (pbuffs["Ostrze Siły Woli"]) and (not pbuffs["Zdobycie Wiedzy"]) and not boss },
{ name = "Pocięta Świadomość",      use = (pbuffs["Ostrze Siły Woli"]) and (PsiPoints >= 2) and not boss },
{ name = "Niszczące Zaklęcie Sacesa",      use = (pbuffs["Konstrukcja Siły Woli"]) and not tbuffs["Niszczące Zaklęcie Sacesa"] and (PsiPoints >= 6) and boss },
--{ name = "Szept Innego Świata",      use = (pbuffs["Konstrukcja Siły Woli"]) and (PsiPoints >= 3) and tbuffs[506027] },
{ name = "Cios Skradania Serc", use = (EnergyBar1 <= 50) },
--{ name = "Fala Świadomości",      use = (EnergyBar1 >= 25) },
{ name = "Szarża Wypaczenia",      use = (EnergyBar1 >= 30) },
{ name = "Zakłopotanie",      use = (EnergyBar1 >= 20) and (PsiPoints <= 4) and (not pbuffs["Ostrze Siły Woli"]) and (not pbuffs["Konstrukcja Siły Woli"]) },
{ name = "Cios Płonącego Serca",      use = (EnergyBar2 >= 270) and (PsiPoints <= 3) and (not pbuffs["Ostrze Siły Woli"]) and (not pbuffs["Konstrukcja Siły Woli"]) },
{ name = "Action: 32 (Siła Ducha Królowej Mrówek)",      use = (EnergyBar1 >= 35) and (PsiPoints <= 5) and  boss },
{ name = "Ekstrakcja Spostrzegawczości",            use = (EnergyBar1 >= 15) and (PsiPoints <= 4) and (not tbuffs[621446] or tbuffs[621446].stack<4 or tbuffs[621446].time < 4) and boss },
{ name = "Klątwa Osłabienia", use = (EnergyBar1 >= 20) and (PsiPoints <= 3) and not boss },
{ name = "Fala Nikczemności", use = (EnergyBar1 >= 20) and (PsiPoints <= 3) and not boss },
{ name = "Psychiczne Strzały",      use = (EnergyBar1 >= 20) and (not pbuffs["Konstrukcja Siły Woli"]) },
{ name = "Atak",      use =    false},
}
end
-- r/m 
			elseif mainClass == "THIEF" and subClass == "MAGE" then
if enemy then
Skill = {
{ name = "Cisza",                    use = (silenceThis) and boss},
{ name = "Błyskawica",      use = (silenceThis) and boss},
{ name = "Zaklęty Rzut", use = (not pbuffs["Zaklęty Rzut"]) },
{ name = "Rzut",      use = true },
{ name = "Cieniste Pchnięcie", use = (EnergyBar1 >= 20 and not tbuffs["Krwawienie"]) },
{ name = "Cios w Ranę", use = (EnergyBar1 >= 35 and tbuffs["Poważna Rana"]) },
--{ name = "Cios Poniżej Pasa", use = (EnergyBar1 >= 30 and tbuffs["Poważna Rana"] and GetSkillCooldown(4,3) >= 1) },
{ name = "Cios Poniżej Pasa", use = (EnergyBar1 >= 30 and tbuffs["Krwawienie"] and not tbuffs["Poważna Rana"]) },
{ name = "Podwójny Rzut", use = true },
{ name = "Atak",      use =    true},
}
end			

-- wrl/ch

			elseif mainClass == "HARPSYN" and subClass == "PSYRON" then
if enemy then
Skill = { 
--{ name = "Konstrukcja Siły Woli",      use = (PsiPoints == 6) and boss },
--{ name = "Ostrze Siły Woli",      use = (PsiPoints == 6) and not boss },
--{ name = "Ciąg Znamienia Duszy",      use = (pbuffs["Ostrze Siły Woli"]) and (PsiPoints >= 6) and not boss },
--{ name = "Zdobycie Wiedzy",      use = (pbuffs["Ostrze Siły Woli"]) and (not pbuffs["Zdobycie Wiedzy"]) and not boss },
--{ name = "Pocięta Świadomość",      use = (pbuffs["Ostrze Siły Woli"]) and (PsiPoints >= 2) and not boss },
--{ name = "Niszczące Zaklęcie Sacesa",      use = (pbuffs["Konstrukcja Siły Woli"]) and not tbuffs["Niszczące Zaklęcie Sacesa"] and (PsiPoints >= 6) and boss },
--{ name = "Szept Innego Świata",      use = (pbuffs["Konstrukcja Siły Woli"]) and (PsiPoints >= 3) and tbuffs[506027] },
{ name = "Runa Umysłu", use = (not pbuffs["Runa Umysłu"]) },
{ name = "Cios Skradania Serc", use = (EnergyBar1 <= 50) },
--{ name = "Fala Świadomości",      use = (EnergyBar1 >= 25) },
{ name = "Szarża Wypaczenia",      use = (EnergyBar1 >= 30) },
{ name = "Zakłopotanie",      use = (EnergyBar1 >= 20 and not boss) },
{ name = "Zakłopotanie",      use = (EnergyBar1 >= 20) and boss and (PsiPoints <= 4) and (not pbuffs["Ostrze Siły Woli"]) and (not pbuffs["Konstrukcja Siły Woli"]) },
--{ name = "Cios Płonącego Serca",      use = (EnergyBar2 >= 270) and (PsiPoints <= 3) and (not pbuffs["Ostrze Siły Woli"]) and (not pbuffs["Konstrukcja Siły Woli"]) },
{ name = "Action: 32 (Siła Ducha Królowej Mrówek)",      use = (EnergyBar1 >= 35) and (PsiPoints <= 4) and  boss },
{ name = "Ekstrakcja Spostrzegawczości",            use = (EnergyBar1 >= 15 and not tbuffs["Ekstrakcja Spostrzegawczości"]) },
{ name = "Ból Duszy", use = (EnergyBar1 >= 15 and not tbuffs["Ból Duszy"] ) },
{ name = "Klątwa Osłabienia", use = (EnergyBar1 >= 20) },
{ name = "Fala Nikczemności", use = (EnergyBar1 >= 20) },
{ name = "Psychiczne Strzały",      use = (EnergyBar1 >= 20) and (not pbuffs["Konstrukcja Siły Woli"]) },
{ name = "Atak",      use =    false},
}
end		

-- Class: W/M
            elseif mainClass == "WARRIOR" and subClass == "MAGE" then
			
if enemy then
Skill = { 
{ name = "Broń Płonącej Błyskawicy",      use = (not pbuffs["Broń Płonącej Błyskawicy"]) },
{ name = "Instynkt Przetrwania",      use = (phealth <= .49) },
{ name = "Zmysł Niebezpieczeństwa",      use = (phealth <= .29) },
{ name = "Action: 41(Mieszana Kiełbasa Motiego)",use = (not pbuffs["Mieszana Kiełbasa Motiego"]) and boss},
{ name = "Rozwścieczenie",      use = (combat) and (EnergyBar1 >= 10) and boss},
{ name = "Agresywność",      use = (combat) and boss},
{ name = "Elektryczna Wściekłość",            use = (EnergyBar1 >= 15) and (not pbuffs[622954] or pbuffs[622954].stack<3 or pbuffs[622954].time < 3 ) },
{ name = "Wzmocnienie",      use = (combat) and (not pbuffs["Wzmocnienie"]) and boss},
{ name = "Action: 42(Silny Stymulant)",use = (not pbuffs["Eliksir Amoku"]) and (pbuffs[622954]) and boss},
{ name = "Action: 43(Eliksir Wygaszenia)",use = (not pbuffs["Eliksir Wygaszenia"]) and (pbuffs[622954]) and boss},
{ name = "Amok",      use = (pbuffs[622954]) and boss},
{ name = "Action: 44(Eliksir Amoku)",use = (not pbuffs["Silny Stymulant"]) and (pbuffs[622954]) and boss},
{ name = "Błyskawica",      use = (silenceThis) and boss},
{ name = "Cisza",      use = (silenceThis) and boss},
{ name = "Wybuchowy Cyklon",      use = (EnergyBar1 >= 35) and (silenceThis) and boss},
{ name = "Dotknięcie Błyskawicy",      use = (EnergyBar2 >= 10000) },
{ name = "Atak",      use =    true},
}
end
--ADD MORE CLASS COMBOS HERE. 
            --USE AN "ELSEIF" TO CONTINUE WITH MORE CLASS COMBOS.
            --THE NEXT "END" STATEMENT IS THE END OF THE CLASS COMBOS STATEMENTS.
            --DO NOT POST BELOW THE FOLLOWING "END" STATEMENT!
            end
    --End Player Skill Sequences
    
 if (arg1=="debugskills") then  --Used for printing the skill table, and true/false usability
  DIYCE_DebugSkills(Skill)
  DIYCE_DebugSkills(Skill2)
 elseif (arg1=="debugpbuffs") then --Used for printing your buff names, and buffID
  DIYCE_DebugBuffList(pbuffs)
 elseif (arg1=="debugtbuffs") then --Used for printing target buff names, and buffID
  DIYCE_DebugBuffList(tbuffs)
 elseif (arg1=="debugall") then  --Used for printing all of the above at the same time
  DIYCE_DebugSkills(Skill)
  DIYCE_DebugSkills(Skill2)
  DIYCE_DebugBuffList(pbuffs)
  DIYCE_DebugBuffList(tbuffs)
 end
 
    if (not MyCombat(Skill, arg1)) then
        MyCombat(Skill2, arg1)
    end
        
    --Select Next Enemy
 if (tDead) then
  TargetUnit("")
  return
 end
 if mainClass == "MAGE" and (not party) then  --To keep scouts from pulling mobs without meaning to.
  if (not LockedOn) or (not enemy) then
   TargetNearestEnemy()
   return
  end
 elseif mainClass ~= "MAGE" then     --Let all other classes auto target.
  if (not LockedOn) or (not enemy) then
   TargetNearestEnemy()
   return
  end
 end
end
DEFAULT_CHAT_FRAME:AddMessage("CustomFunctions.lua has loaded")
