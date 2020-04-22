
include("Pup_include.lua")

HercHeadSTR = { name="Herculean Helm", augments={'Accuracy+28','Weapon skill damage +4%','STR+11','Attack+13'}}	
HercHeadPDT =  {name="Herculean Helm", augments={'CHR+7', 'Accuracy+29','Phys. dmg. taken -4%'}}
HercHeadMAB =  {name="Herculean Helm", augments={'Mag. Acc.+20 "Mag.Atk.Bns."+20','Phys. dmg. taken -2%','"Mag.Atk.Bns."+15'}}
HercBootMAB = { name="Herculean Boots", augments={'Mag. Acc.+18 "Mag.Atk.Bns."+18','Magic burst mdg.+4%','MND+2','Mag. Acc.+10','"Mag.Atk.Bns."+14'}}
HercBootAcc = { name="Herculean Boots", augments={'MND+9','Pet: STR+8','"Treasure Hunter"+2','Accuracy+18 Attack+18'}}
HercBootDEX = { name="Herculean Boots", augments={'Attack+18','"Triple Atk."+3','DEX+10'}}

--- DT
HercLegsPDT = { name="Herculean Trousers", augments={'Damage taken-3%','Attack+3'}}
HercGlovesPDT = { name="Herculean Gloves", augments={'Phys. dmg. taken -5%','Accuracy+2'}}
HercBootsPDT = { name="Herculean Boots", augments={'Damage taken-2%','STR+9','Attack+7'}}

HercBootBone = {name="Herculean Boots", augments={'Pet: Accuracy+5 Pet: Rng. Acc.+5','Pet: "Dbl.Atk."+2 Pet: Crit.hit rate +2','Pet: VIT+5'}}

HercLegsPET = { name="Herculean Trousers", augments={'Pet: Attack+21 Pet: Rng.Atk.+21','Pet: "Store TP"+10','Pet: VIT+7'}}
HercLegsPetDEX = { name="Herculean Trousers", augments={'Pet: Attack+10 Pet: Rng.Atk.+10','Pet: DEX+10','Pet: "Mag.Atk.Bns."+3'}}
include('organizer-lib')

JSECAPEPetHaste = {name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Accuracy+20 Attack+20','Pet: Haste+10','System: 1 ID: 1247 Val: 2'}}
JSECAPESTR = { name="Visucius's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+5','Crit.hit rate+10'}}

-- RAO WS
RAOWShead={ name="Rao Kabuto", augments={'STR+10','DEX+10','Attack+15'}}
RAOWShands={ name="Rao Kote", augments={'Accuracy+10','Attack+10','Evasion+15'}}
RAOWSlegs={ name="Rao Haidate", augments={'Accuracy+20','"Dbl.Atk."+3','Pet: Accuracy+20'}}
RAOWSfeet={ name="Rao Sune-Ate", augments={'Accuracy+10','Attack+10','Evasion+15'}}

RMasterS = "Idle"
MasterS = "Idle"
PetS = "Idle"
TotalS = "Idle"
flashbulbtimer = 40
strobetimer = 25
stroberecast = 0
flashbulbrecast = 0
flashbulbtime = 0
strobetime = 0
pdt = 0


function TotalSCalc()
	if ActualMode == "DD" then
		if buffactive['Overdrive'] then
			TotalS = "Overdrive"
		elseif MasterS == "Idle" and PetS == "Idle" then
			TotalS = "Idle"
		elseif MasterS == "Idle" and PetS == "Engaged" then
			TotalS = "Pet Only"
		elseif MasterS == "Engaged" and PetS == "Engaged" then
			TotalS = "Pet+Master"
		elseif MasterS == "Engaged" and PetS == "Idle" then
			TotalS = "Master Only"
		end
	elseif ActualMode == "Tank" then
		if PetS == "Idle" then
			TotalS = "Idle"
		else
			TotalS = "Tank"
		end
	else
		PetS = "Mage"
		if MasterS == "Idle" then
			TotalS = "Idle"
		else
			TotalS = "Master Only"
		end
	end
end

Burden = 0
BurdenLimit = 30+50
Mane = {"Wind","Fire", "Light"}
ManeRound = 1

TypeM = S{"Fire", "Water", "Earth", "Wind", "Dark", "Light", "Ice", "Thunder" }

--- SKILLCHAIN TABLE
SC = {}
SC['Valoredge Frame'] = {}
SC['Sharpshot Frame'] = {}
SC['Harlequin Frame'] = {}

SC['Valoredge Frame']['Stringing Pummel'] = "String Shredder"
SC['Valoredge Frame']['Victory Smite'] = "String Shredder"
SC['Valoredge Frame']['Shijin Spiral'] = "Bone Crusher"
SC['Valoredge Frame']['Howling Fist'] = "String Shredder"

SC['Sharpshot Frame']['Stringing Pummel'] = "Armor Shatterer"
SC['Sharpshot Frame']['Victory Smite'] = "Armor Shatterer"
SC['Sharpshot Frame']['Shijin Spiral'] = "Armor Piercer"
SC['Sharpshot Frame']['Howling Fist'] = "Arcuballista"
SC['Sharpshot Frame']['Dragon Kick'] = "Armor Shatterer"
SC['Sharpshot Frame']['One Inch Punch'] = "Daze"
SC['Sharpshot Frame']['Spinning Attack'] = "Armor Shatterer"
SC['Sharpshot Frame']['Base'] = "Arcuballista"


SC['Harlequin Frame']['Stringing Pummel'] = "Slapstick"
SC['Harlequin Frame']['Victory Smite'] = "Magic Mortar"
SC['Harlequin Frame']['Shijin Spiral'] = "Slapstick"
SC['Harlequin Frame']['Howling Fist'] = "Knockout"

Modifier = {}

Modifier['String Shredder'] = "VIT"
Modifier['Bone Crusher'] = "VIT"
Modifier['Armor Shatterer']  = "DEX"
Modifier['Armor Piercer']  = "DEX"
Modifier['Arcuballista']  = "DEXFTP"
Modifier['Daze']  = "DEXFTP"
Modifier['Slapstick'] = "DEX"
Modifier['Knockout'] = "AGI"


Colors = {}
Colors["Fire"] = "\\cs(102, 0, 0)"
Colors["Water"] = "\\cs(0, 51, 102)"
Colors["Wind"] = "\\cs(51, 102, 0)"
Colors["Dark"] = "\\cs(0, 0, 0)"
Colors["Light"] = "\\cs(255, 255, 255)"
Colors["Earth"] = "\\cs(139, 69, 19)"
Colors["Ice"] = "\\cs(0, 204, 204)"
Colors["Thunder"] = "\\cs(51, 0, 102)"

--- Pet modes references
PetMode = S{"Tank", "DD", "BLM", "RDM", "WHM"}
PetSubMode = {}
PetSubMode["Tank"] = {"PDT", "MDT", "Range"}
PetSubMode["DD"] = {"Normal", "Bone", "Spam", "OD", "ODAcc"}
NSubMode = {}
NSubMode["Tank"] = 3
NSubMode["DD"] = 5
ActualMode = "DD"
ActualSubMode = "Normal"

--- Styles Maneuvers and autocontrol
Style={}
-- Tank Ones
Style["PDT"] = {"paladin", "Light", "Fire", "Earth"}
Style["MDT"] = {"runefencer", "Light", "Fire", "Water"}
Style["Range"] = {"Paladin", "Light", "Fire", "Earth"}
-- DD Ones
Style["Normal"] = {"dd", "Light", "Fire", "Wind"}
Style["Bone"] = {"boneslayer", "Light", "Fire", "Wind"}
Style["Spam"] = {"ddspam", "Light", "Fire", "Wind"}
Style["OD"] = {"overdrive", "Light", "Fire", "Thunder"}
Style["ODAcc"] = {"overdriveacc", "Light", "Fire", "Thunder"}


tb_name = "puphelp"
visible = true
textinbox = ''

	textinbox = textinbox..' \\cs(0, 0, 0) Maneuvers :\\cr '..Colors[Mane[1]]..Mane[1]..'\\cr-'..Colors[Mane[2]]..Mane[2]..'\\cr-'..Colors[Mane[3]]..Mane[3]..' \\cr \n'
	--textinbox = textinbox..' \\cs(0, 0, 0) Burden : '..Burden..'('..BurdenLimit..')\\cr \n'
	
	

    windower.text.create(tb_name)
    windower.text.set_location(tb_name, 700, 150)
    windower.text.set_bg_color(tb_name, 200, 96, 96, 96)
    windower.text.set_color(tb_name, 255, 147, 161, 161)
    windower.text.set_font(tb_name, "Arial")
    windower.text.set_font_size(tb_name, 10)
    windower.text.set_bold(tb_name, true)
    windower.text.set_italic(tb_name, false)
    windower.text.set_text(tb_name, textinbox)
    windower.text.set_bg_visibility(tb_name, visible)

    local player = windower.ffxi.get_player()

function optic()
	value = 0
	ofone = 0
	oftwo = 0
	
	if pet.attachments["Optic Fiber"] then
		if buffactive["Light Maneuver"] and buffactive["Overdrive"] then
			ofone = Attach["Light"]["Optic Fiber"][5]	
		elseif buffactive["Light Maneuver"] then
			ofone = Attach["Light"]["Optic Fiber"][3]
		elseif buffactive["Light Maneuver"] == 2 then
			ofone = Attach["Light"]["Optic Fiber"][4]
		elseif buffactive["Light Maneuver"] == 3 then
			ofone = Attach["Light"]["Optic Fiber"][5]		
		else
			ofone = Attach["Light"]["Optic Fiber"][2]
		end
	end
	
	if pet.attachments["Optic Fiber II"] then
		if buffactive["Light Maneuver"] and buffactive["Overdrive"] then
			ofone = Attach["Light"]["Optic Fiber II"][5]	
		elseif buffactive["Light Maneuver"] then
			ofone = Attach["Light"]["Optic Fiber II"][3]
		elseif buffactive["Light Maneuver"] == 2 then
			ofone = Attach["Light"]["Optic Fiber II"][4]
		elseif buffactive["Light Maneuver"] == 3 then
			ofone = Attach["Light"]["Optic Fiber II"][5]		
		else
			ofone = Attach["Light"]["Optic Fiber II"][2]
		end
	end
	value = 1+ofone+oftwo
	return value
end
	
function get_maneuver()
	j = 1
	textinbox=""
	textt={}
	--print(Attach["Fire"][Attach["Fire"][1]][1])
	while j <= NA do
		i = 1
		textt[j] = ""
		--print(MAN[j].."-"..NAttach[MAN[j]])
		-- Pour chaque maneuver
		while i <= NAttach[MAN[j]] do
			mani={}
			-- Rechercher chaque attachment s'il est actif
			if pet.attachments[Attach[MAN[j]][i]] then
				-- Rechercher le bonus qui délivre
				Bonus=""
				Bonus = Attach[MAN[j]][Attach[MAN[j]][i]][1]
				if Attach[MAN[j]][i] ~= "Optic Fiber" or Attach[MAN[j]][i] ~= "Optic Fiber II" then
					if buffactive[MAN[j].." Maneuver"] then
						if Attach[MAN[j]][i][6] == "%" then
							BonusCalc = Attach[MAN[j]][Attach[MAN[j]][i]][3]*optic()
						elseif Attach[MAN[j]][i][6] == "Int" then
							BonusCalc = Attach[MAN[j]][Attach[MAN[j]][i]][3]*optic()
						else
							BonusCalc = Attach[MAN[j]][Attach[MAN[j]][i]][3]
						end
					elseif buffactive[MAN[j].." Maneuver"] == 2 then
						if Attach[MAN[j]][i][6] == "%" then
							BonusCalc = Attach[MAN[j]][Attach[MAN[j]][i]][4]*optic()
						elseif Attach[MAN[j]][i][6] == "Int" then
							BonusCalc = Attach[MAN[j]][Attach[MAN[j]][i]][4]*optic()
						else
							BonusCalc = Attach[MAN[j]][Attach[MAN[j]][i]][4]
						end
					elseif buffactive[MAN[j].." Maneuver"] == 3 then
						if Attach[MAN[j]][i][6] == "%" then
							BonusCalc = Attach[MAN[j]][Attach[MAN[j]][i]][5]*optic()
						elseif Attach[MAN[j]][i][6] == "Int" then
							BonusCalc = Attach[MAN[j]][Attach[MAN[j]][i]][5]*optic()
						else
							BonusCalc = Attach[MAN[j]][Attach[MAN[j]][i]][5]
						end
					else
						-- TYpe de bonus, %, Int ou String
						if Attach[MAN[j]][i][6] == "%" then
							BonusCalc = Attach[MAN[j]][Attach[MAN[j]][i]][2]*optic()
						elseif Attach[MAN[j]][i][6] == "Int" then
							BonusCalc = Attach[MAN[j]][Attach[MAN[j]][i]][2]*optic()
						else
							BonusCalc = Attach[MAN[j]][Attach[MAN[j]][i]][2]
						end
					end
				end
				textt[j]= textt[j]..""..Bonus.." +"..BonusCalc.."\n"
			end
			i=i+1
		end
		textinbox = textinbox..' \\cs(255, 0, 0) '..textt[j]..'\\cr'
		j=j+1
	end
	return textinbox
end
OverPower = false
OverCount = 0
NextWS = ""

function refresh()
	textinbox = ''
	
	-- GEO SPELL
	textinbox = textinbox..' \\cs(0, 0, 0) Maneuvers :\\cr '..Colors[Mane[1]]..Mane[1]..'\\cr-'..Colors[Mane[2]]..Mane[2]..'\\cr-'..Colors[Mane[3]]..Mane[3]..' \\cr \n'
	if (pet) then
	if pet.max_mp then
	textinbox = textinbox..' \\cs(0, 0, 0) '..pet.name..'\\cr \n- \\cs(0, 0, 125)HP : '..pet.hp..'/'..pet.max_hp..'\\cr \n- \\cs(0, 125, 0)MP : '..pet.mp..'/'..pet.max_mp..'\\cr \n- \\cs(125, 0, 0)TP : '..tostring(pet.tp)..' \\cr \n'
	end
	textinbox = textinbox..'- \\cs(0, 0, 0)Head : '..pet.head..' \\cr \n'
	textinbox = textinbox..'- \\cs(0, 0, 0)Frame : '..pet.frame..' \\cr \n'
	end
	textinbox = textinbox..'- \\cs(125, 125, 0)Mode : '..ActualMode..'\\cr \n'
	textinbox = textinbox..'- \\cs(0, 125, 125)Style : '..ActualSubMode..'\\cr \n'
	textinbox = textinbox..'\\cs(0, 75, 125)--------------------------------\\cr \n'
	textinbox = textinbox..'- \\cs(125, 125, 125)Master : '..MasterS..'\\cr \n'
	textinbox = textinbox..'- \\cs(125, 125, 125)Pet : '..PetS..'\\cr \n'
	textinbox = textinbox..'- \\cs(125, 125, 125)Total : '..TotalS..'\\cr \n'
	--- Recast for enmity gears
	if ActualMode == "Tank" then
	textinbox = textinbox..'\\cs(0, 75, 125)--------------------------------\\cr \n'
	-- Strobe recast
	if stroberecast == 0 then
		if buffactive['Fire Maneuver'] then
		textinbox = textinbox..'\\cs(125, 125, 125)-\\cr \\cs(125,0,0)Strobe\\cr \n'
		else
		textinbox = textinbox..'\\cs(125, 125, 125)- Strobe\\cr \n'
		end
	else
		textinbox = textinbox..'\\cs(125, 125, 125)- Strobe ('..stroberecast..')\\cr \n'
	end
	-- Flashbulb recast
	if flashbulbrecast == 0 then
		if buffactive['Light Maneuver'] then
		textinbox = textinbox..'\\cs(125, 125, 125)-\\cr \\cs(255,255,255)Flashbulb\\cr \n'
		else
		textinbox = textinbox..'\\cs(125, 125, 125)- Flashbulb\\cr \n'
		end
	else
		textinbox = textinbox..'\\cs(125, 125, 125)- Flashbulb ('..flashbulbrecast..')\\cr \n'
	end
	end
	
	if buffactive["Overdrive"] then
	if OverCount == 1 then
	NextWS = "Daze"
	elseif OverCount == 2 then
	NextWS = "Arcuballista"
	elseif OverCount == 3 then
	NextWS = "Armor Shatterer"
	else
	NextWS = "Armor Piercer"
	end
	textinbox = textinbox..'- \\cs(125, 5, 0)Next WS : '..NextWS..'\\cr \n'
	
	end
	--textinbox = textinbox..""..get_maneuver()
	
	
	--if (pet) and Burden <= BurdenLimit then
	--textinbox = textinbox..' \\cs(0, 0, 0) Burden : '..Burden..'('..BurdenLimit..')\\cr \n'
	--elseif (pet) and Burden > BurdenLimit then
	--textinbox = textinbox..' \\cs(255, 0, 0) Burden : '..Burden..'('..BurdenLimit..') - COOLDOWN ASAP\\cr \n'
	--risk = Burden - BurdenLimit + 5
	--textinbox = textinbox..' \\cs(255, 0, 0) Overload risk estimated = '..risk..'%\\cr \n'
	--end
	
	-- Checking Attachments

	windower.text.set_text(tb_name, textinbox)
end

function user_setup()
-- Default macro set/book
set_macro_page(1, 9)
end

function get_sets()
	sets.precast = {}
 
    -- Precast Sets

    -- Fast cast sets for spells
    sets.precast.FC = {head="Haruspex Hat",body="Zendik Robe", legs="Orvail Pants +1" ,ear2="Loquacious Earring",hands="Thaumas Gloves", ring1="Prolix Ring",ring2="Lebeche Ring", ear2="Loquac. Earring", neck="Orunmila's Torque"}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

    sets.precast.JA = {}
    -- Precast sets to enhance JAs
    sets.precast.JA['Tactical Switch'] = {feet="Cirque Scarpe +2"}
	sets.precast.JA['Ventriloquy'] = {legs="Pitre Churidars +3"}
	sets.precast.JA['Role Reversal'] = {feet="Pitre Babouches +2"}
	 sets.precast.JA['Overdrive'] = {feet="Pitre Tobe +3"}
    
    sets.precast.JA['Repair'] = {feet="Foire Babouches", "Guignol Earring"}

    sets.precast.JA.Maneuver = {neck="Buffoon's Collar",body="Karagoz Farsetto",hands="Foire Dastanas",back="Dispersal Mantle", ear1="Burana Earring"}
	
	sets.precast.JA['Activate'] = {back="Visucius's Mantle"}
	sets.precast.JA['Deus Ex Automata'] = sets.precast.JA['Activate'] 
	
	sets.precast.JA['Provoke'] = {feet="Ahosi Leggings", neck="Unmoving Collar", feet="Rager Ledel. +1", hands="Kurys Gloves", ring1="Provocare Ring"}



    -- Waltz set (chr and vit)
    sets.precast.Waltz = {
        head="Whirlpool Mask",ear1="Roundel Earring",
        body="Otronif Harness +1",hands="Otronif Gloves",ring1="Spiral Ring",
        back="Iximulew Cape",legs="Nahtirah Trousers",feet="Thurandaut Boots +1"}
        
    -- Don't need any special gear for Healing Waltz.
    sets.precast.Waltz['Healing Waltz'] = {}

       
    -- Weaponskill sets
    -- Default set for any weaponskill that isn't any more specifically defined
    sets.precast.WS = {
        head=RAOWShead,neck="Rancor Collar",ear1="Ishvara Earring",ear2="Moonshade Earring",
        body="Abnoba Kaftan",hands="Pitre Dastanas +3",ring1="Shukuyu Ring",ring2="Rufescent Ring",
        back=JSECAPESTR,waist="Moonbow Belt",legs="Pitre Churidars +3",feet="Ryuo Sune-Ate"} --"Hiza. Hizayoroi +2"

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Stringing Pummel'] = sets.precast.WS
    sets.precast.WS['Stringing Pummel'].Mod = sets.precast.WS

    sets.precast.WS['Victory Smite'] = sets.precast.WS

    sets.precast.WS['Shijin Spiral'] = set_combine(sets.precast.WS, {head="Pitre Taj +3", body="Pitre Tobe +3", hands="Pitre Dastanas +3", legs="Pitre Churidars +3", feet="Heyoka leggings", ring1="Apate Ring", ring2="Petrov Ring"})
	
	sets.precast.WS['Howling Fist'] = {
        head=RAOWShead,neck="Fotia Gorget",ear1="Ishvara Earring",ear2="Moonshade Earring",
        body="Foire Tobe +3",hands="Pitre Dastanas +3",ring1="Shukuyu Ring",ring2="Rufescent Ring",
        back=JSECAPESTR,waist="Moonbow Belt",legs="Hiza. Hizayoroi +2",feet="Ryuo Sune-Ate"}

    
    -- Midcast Sets
	sets.midcast ={}
    sets.midcast.FastRecast = {
        head="Haruspex Hat",ear2="Loquacious Earring",
        body="Otronif Harness +1",hands="Regimen Mittens",
        legs="Manibozho Brais",feet="Otronif Boots +1"}
        

    -- Midcast sets for pet actions
	sets.midcast.Pet = {}
    sets.midcast.Pet.Cure = {legs="Foire Churidars"}

    sets.midcast.Pet['Elemental Magic'] = {feet="Naga Kyahan", ear1="Burana Earring", ear2="Cirque Earring", legs="Pitre Churidars +3"}

    sets.midcast.Pet.WeaponSkillNoAcc = {neck="Empath Necklace",head="Karagoz Capello +1", body="Tali'ah Manteel +1", waist="Incarnation Sash", hands="Karagoz Guanti +1", ring1="Varar Ring", ring2="Varar Ring", legs=HercLegsPET, feet="Punchinellos", back="Dispersal Mantle"}
	sets.midcast.Pet.WSNoFTP = {
		neck="Empath Necklace",
		head="Pitre Taj +3", 
		body="Tali'ah Manteel +1", 
		waist="Incarnation Sash", 
		hands="Karagoz Guanti +1", 
		ring1="Thurandaut Ring", 
		ring2="Varar Ring", 
		legs="Kara. Pantaloni +1", 
		feet="Naga Kyahan", 
		back=JSECAPEPetHaste}
	sets.midcast.Pet.WSFTP = {
		neck="Empath Necklace",
		head="Karagoz Capello +1", 
		body="Tali'ah Manteel +1", 
		waist="Incarnation Sash", 
		hands="Karagoz Guanti +1", 
		ring1="Thurandaut Ring", 
		ring2="Varar Ring", 
		legs="Kara. Pantaloni +1", 
		feet="Naga Kyahan", 
		back="Dispersal Mantle"}
	 sets.midcast.Pet.WeaponSkill = sets.midcast.Pet.WSNoFTP
	sets.midcast.Pet.WS = {}
	--Chimera Ripper, String Clipper
	 sets.midcast.Pet.WS["STR"] = set_combine(sets.midcast.Pet.WeaponSkill, {})
	 -- Bone crusher, String Shredder
	 sets.midcast.Pet.WS["VIT"] = set_combine(sets.midcast.Pet.WeaponSkill, {head="Karagoz Capello +1", legs=HercLegsPET, waist="Incarnation Sash", feet=HercBootBone})
	 -- Cannibal Blade
	 sets.midcast.Pet.WS["MND"] = set_combine(sets.midcast.Pet.WeaponSkill, {})
	 -- Armor Piercer, Armor Shatterer
	 sets.midcast.Pet.WS["DEX"] = set_combine(sets.midcast.Pet.WeaponSkill, {legs=HercLegsPetDEX})
	 -- Arcuballista, Daze
	 sets.midcast.Pet.WS["DEXFTP"] = set_combine(sets.midcast.Pet.WS["DEX"], {head="Karagoz Capello +1",back="Dispersal Mantle"})
	 
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {head="Pitre Taj",neck="Wiglen Gorget",
        ring1="Sheltered Ring",ring2="Paguroidea Ring"}
    

    -- Idle sets

    sets.idle = {
        head=RAOWShead,neck="Wiglen Gorget",ear1="Infused Earring",ear2="Dawn Earring",
        body="Hiza. Haramaki +1",hands=RAOWShands,ring1="Sheltered Ring",ring2="Paguroidea Ring",
        back="Mecisto. Mantle",waist="Incarnation Sash",legs=RAOWSlegs,feet="Hermes' Sandals"}

    sets.idle.Town = sets.idle

	
	------------------------------------------------------------------ PET SETS
    -- Set for idle while pet is out (eg: pet regen gear)
    sets.idle.Pet = sets.idle

    -- Idle sets to wear while pet is engaged
    sets.idle.Pet.EngagedO =	{
        head="Tali'ah Turban +2" ,neck="Empath Necklace",ear1="Burana Earring",ear2="Domes. Earring",
        body="Pitre Tobe +3",hands="Tali'ah Gages +1",ring1="Varar Ring",ring2="Varar Ring",
        back=JSECAPEPetHaste,waist="Incarnation Sash",legs=HercLegsPET,feet="Tali'ah Crackows +2"}

	sets.idle.Pet.Engaged = sets.idle.Pet.EngagedO
    sets.idle.Pet.Engaged.Ranged = set_combine(sets.idle.Pet.Engaged, {legs="Kara. Pantaloni +1"})

    sets.idle.Pet.Engaged.Nuke = set_combine(sets.idle.Pet.Engaged, {legs="Pitre Churidars +3", feet="Pitre Babouches +2", ear1="Burana Earring"})

    sets.idle.Pet.Engaged.Magic = set_combine(sets.idle.Pet.Engaged, {legs="Pitre Churidars +3", feet="Pitre Babouches +2", ear1="Burana Earring"})
	
	sets.petTank = {
        head="Taeon Chapeau",neck="Loricate Torque", ear1="Domes. Earring", ear2="Handler's Earring +1",
        body="Taeon Tabard",hands="Taeon Gloves",ring1="Thurandaut Ring",ring2="Overbearing Ring",
        back=JSECAPEPetHaste,waist="Isa Belt",legs="Taeon Tights",feet="Taeon Boots"}
	sets.petEnmity = {head="Heyoka Cap", body="Heyoka Harness", hands="Heyoka Mittens", legs="Heyoka Subligar", feet="Heyoka Leggings", ear1="Domesticator's Earring" }

    -- Defense sets
	sets.defense = {}
    sets.defense.Evasion = {
        head="Whirlpool Mask",neck="Loricate Torque",
        body="Otronif Harness +1",hands="Otronif Gloves",ring1="Defending Ring",ring2="Beeline Ring",
        back="Ik Cape",waist="Incarnation Sash",legs="Nahtirah Trousers",feet="Otronif Boots +1"}
		
	

    sets.defense.PDT = {
        head=HercHeadPDT,neck="Loricate Torque",
        body="Vrikodara Jupon",hands=HercGlovesPDT,ring1="Defending Ring",ring2="Dark Ring",
        back="Solemnity Cape",waist="Moonbow Belt", legs=HercLegsPDT, feet=HercBootsPDT}

    sets.defense.MDT = {
        head="Whirlpool Mask",neck="Loricate Torque",
        body="Otronif Harness +1",hands="Otronif Gloves",ring1="Defending Ring",ring2="Shadow Ring",
        back="Tuilha Cape",waist="Incarnation Sash",legs="Nahtirah Trousers",feet="Otronif Boots +1"}

    sets.Kiting = {feet="Hermes' Sandals"}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
	sets.aftercast= sets.idle
    sets.engaged = {
        head="Tali'ah Turban +2" ,neck="Clotharius Torque",ear1="Cessance Earring",ear2="Domes. Earring",
        body="Pitre Tobe +3",hands="Heyoka Mittens",ring1="Varar Ring",ring2="Varar Ring",
        back=JSECAPEPetHaste,waist="Moonbow Belt",legs="Heyoka Subligar",feet="Heyoka Leggings"}
	sets.engagedN = {
        head="Tali'ah Turban +2" ,neck="Clotharius Torque",ear1="Cessance Earring",ear2="Domes. Earring",
        body="Herculean Vest",hands="Heyoka Mittens",ring1="Varar Ring",ring2="Varar Ring",
        back=JSECAPEPetHaste,waist="Moonbow Belt",legs="Heyoka Subligar",feet="Heyoka Leggings"}
	sets.engagedMO = {
        head=HercHeadPDT ,neck="Clotharius Torque",ear1="Cessance Earring",ear2="Brutal Earring",
        body="Herculean Vest",hands="Herculean Gloves",ring1="Petrov Ring",ring2="Epona's Ring",
        back=JSECAPEPetHaste,waist="Moonbow Belt",legs="Samnuha Tights",feet=HercBootDEX}
	
    sets.engaged.Acc = {
        head="Whirlpool Mask",neck="Ej Necklace",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Qaaxo Harness",hands="Otronif Gloves",ring1="Rajas Ring",ring2="Epona's Ring",
        back="Dispersal Mantle",waist="Incarnation Sash",legs="Manibozho Brais",feet=HercBootDEX}
    sets.engaged.DT = {
        head="Karagoz Capello +1",neck="Asperity Necklace",ear1="Burana Earring",ear2="Domes. Earring",
        body="Rawhide Vest",hands=RAOWShands,ring1="Petrov Ring",ring2="Epona's Ring",
        back="Dispersal Mantle",waist="Incarnation Sash",legs=RAOWSlegs,feet=RAOWSfeet}
    sets.engaged.Acc.DT = {
        head="Whirlpool Mask",neck="Loricate Torque",ear1="Bladeborn Earring",ear2="Steelflash Earring",
        body="Otronif Harness +1",hands="Regimen Mittens",ring1="Defending Ring",ring2="Beeline Ring",
        back="Iximulew Cape",waist="Incarnation Sash",legs="Manibozho Brais",feet="Otronif Boots +1"}
	
end

function realaftercast()
	if ActualMode == "Tank" then
		sets.aftercast = sets.petTank
	elseif TotalS == "Idle" then
		sets.aftercast = sets.idle
	elseif TotalS == "Master Only" then
		sets.aftercast = sets.engagedMO
	elseif TotalS == "Pet Only" then
		sets.aftercast = sets.engaged
	elseif TotalS == "Pet+Master" then
		sets.aftercast = sets.engagedN
	elseif TotalS == "Overdrive" then
		sets.aftercast = sets.engaged
	end
	equip(sets.aftercast)
end


--Auto Boost on Certain WS
function precast(spell,action)
	if spell.english == "Deploy" and pet.tp >= 950 then
		if ActualMode == "Tank" then
			-- Nothing
		else
		equip(sets.midcast.Pet.WeaponSkill)
		end
	elseif sets.precast.JA[spell.english] then
		equip(sets.precast.JA[spell.english])
	elseif sets.precast.WS[spell.english] then
		equip(sets.precast.WS[spell.english])
		if TotalS == "Pet+Master" then
			sets.aftercast = sets.midcast.Pet.WeaponSkill 
		end
	elseif string.find(spell.english,'Maneuver') then
		if ActualSubMode == "Spam" then
			equip(sets.precast.JA.Maneuver)
		else
			if spell.english ~= Mane[ManeRound]..' Maneuver' and windower.ffxi.get_ability_recasts()[210] and not buffactive.amnesia then
				equip(sets.precast.JA.Maneuver)
			--if buffactive['Food'] then
				cancel_spell()
				send_command('input /ja "'..Mane[ManeRound]..' Maneuver" <me>')
			--else
			--	cancel_spell()
			--	send_command('input /item "Akamochi" <me>;wait 5;input /ja "'..Mane[ManeRound]..' Maneuver" <me>')
			--end
			end
		end
	else
		equip(sets.precast.FC)
	end
end

function midcast(spell,action)
end

function aftercast(spell,action)
	enable("ear1")
	if spell.name == null then
			return -- Cancel Aftercast for outofrange/unable to see.
	end	
	
	if (spell.english == "Shijin Spiral" or spell.english == "Victory Smite" or spell.english == "Stringing Pummel" or spell.english == "Howling Fist") and pet.tp >= 850 then
		ws = SC[pet.frame][spell.english]
		modif = Modifier[ws]
		add_to_chat(392,'*-*-*-*-*-*-*-*-* [ '..pet.name..' is about to '..ws..' ('..modif..') ] *-*-*-*-*-*-*-*-*')
		equip(sets.midcast.Pet.WS[modif])
	else
		if ActualSubMode == "Spam" then
			equip(sets.precast.JA.Maneuver)
		else
		if string.find(spell.english,'Maneuver') then
			if ManeRound == 1 then
				ManeRound = 2
			elseif ManeRound == 2 then
				ManeRound = 3
			else 
				ManeRound = 1
			end
			Burden = Burden +15
		elseif spell.english == "Cooldown" then
			Burden = round(Burden/2)
		end
		end
		if sets.precast.WS[spell.english] and TotalS == "Pet+Master" then
			equip(sets.aftercast)
		else
		realaftercast()
		end
	end
	
end

function status_change(new,old)
	if new == 'Engaged' then
		MasterS = "Engaged"
		TotalSCalc()
		add_to_chat(392,'*-*-*-*-*-*-*-*-* [ Engaged ] *-*-*-*-*-*-*-*-*')
	else
		MasterS="Idle"
		TotalSCalc()
		add_to_chat(392,'*-*-*-*-*-*-*-*-* [ Idle ] *-*-*-*-*-*-*-*-*')
	end
	realaftercast()
	
end

function pet_status_change(new,old)
	if new == 'Engaged' then
		PetS = "Engaged"
		TotalSCalc()
		add_to_chat(392,'*-*-*-*-*-*-*-*-* [ PetEngaged ] *-*-*-*-*-*-*-*-*')
	else
		PetS="Idle"
		TotalSCalc()
			add_to_chat(392,'*-*-*-*-*-*-*-*-* [ PetIdle ] *-*-*-*-*-*-*-*-*')
	end
	realaftercast()
end

function pet_aftercast(spell)
	realaftercast()
end

function buff_change(status,gain_or_loss)
	if status == "sleep" then
		if gain_or_loss then
			equip({neck="Opo-opo Necklace"})
		end
	end
	
	if status == "Overdrive" then
		if gain_or_loss then
			OverPower = true
			OverCount = 1
			sets.midcast.Pet.WeaponSkill = sets.midcast.Pet.WSFTP
		else
			OverPower = false
			OverCount = 0
			sets.midcast.Pet.WeaponSkill = sets.midcast.Pet.WSNoFTP
		end
	end
	
	
end

-- Toggles -- SE Macros: /console gs c "command" [case sensitive]
function self_command(command)
		if command == 'PDT' then
		 if pdt == 0 then
			pdt = 1
			add_to_chat(392,'*-*-*-*-*-*-*-*-* [ PDT ON ] *-*-*-*-*-*-*-*-*')
			equip(sets.defense.PDT)
			disable("head")
			disable("neck")
			disable("body")
			disable("hands")
			disable("ring1")
			disable("ring2")
			disable("waist")
			disable("legs")
			disable("feet")
		 else
			pdt = 0
			add_to_chat(392,'*-*-*-*-*-*-*-*-* [ PDT OFF ] *-*-*-*-*-*-*-*-*')
			enable("head")
			enable("neck")
			enable("body")
			enable("hands")
			enable("ring1")
			enable("ring2")
			enable("waist")
			enable("legs")
			enable("feet")
			equip(sets.aftercast)
		 end
		elseif command == 'normal' then
		
		end
		
end




local clock = os.clock
function sleep(n)  -- seconds
  local t0 = clock()
  while clock() - t0 <= n do end
end



fps = 1
sec = 0

enga=0
oldtiming = os.time()

windower.register_event('prerender', function()

    if fps < 50 then
		fps = fps +1
	else
		fps = 1
	end
	
	if fps == 1 then
		timing = os.time()
		
		if ActualMode == "Tank" then
			if buffactive['Fire Maneuver'] then
				if stroberecast <= 2 then
					equip(sets.petEnmity)
				end
			end
			
			if buffactive['Light Maneuver'] then
				if flashbulbrecast <= 2 then
					equip(sets.petEnmity)
				end
			end
			if stroberecast > 0 then
				stroberecast = strobetimer -(os.time() - strobetime)
				--add_to_chat(204,"Recast :"..stroberecast)
			end
			if flashbulbrecast > 0 then
				flashbulbrecast = flashbulbtimer -(os.time() - flashbulbtime)
				--add_to_chat(204,"Recast :"..stroberecast)
			end
		end
		TotalSCalc()
		if(timing-oldtiming > 3) then
			if Burden > 0 then
				Burden = Burden -1
			end
			oldtiming = os.time()
		end
		
		if sets.aftercast == sets.idle then
		
		else
			if TotalS == "Idle" then
			sets.aftercast = sets.idle
			equip(sets.aftercast)
			end
		end
		
		if ActualMode == "Tank" then
			-- Nothing
		elseif TotalS == "Pet Only" or TotalS == "Overdrive" then
			if pet.tp >= 850 then
				equip(sets.midcast.Pet.WeaponSkill)
			else
				equip(sets.aftercast)
			end
		end
		--print(player.status)
		--[[if player.status == 1 then
			add_to_chat(204,"Engaged")
			if enga == 0 then
			send_command("input /p go")
			add_to_chat(204,"Engaging")
			enga = 1
			end
		elseif player.status == 0 then
			add_to_chat(204,"Idled")
			if enga == 1 then
			send_command("input /p fc")
			add_to_chat(204,"Idling")
			enga = 0
			end
		end]]--
		
		--- AUTOMANEUVER
		--if not buffactive[Mane[1]..' Maneuver'] and autos then
		--	add_to_chat(204,"Maneuver lost")
		--	send_command('input /ja "Fire Maneuver" <me>')
		--elseif not buffactive[Mane[2]..' Maneuver'] and autos then
		--	add_to_chat(204,"Maneuver lost")
		--	send_command('input /ja "Fire Maneuver" <me>')
		--elseif not buffactive[Mane[2]..' Maneuver'] and autos then
		--	add_to_chat(204,"Maneuver lost")
		--	send_command('input /ja "Fire Maneuver" <me>')
		--end
		
		
		refresh()
	end
	
end)



choosing = false		
wchoos = 0		
modchos = false	
submodechos = false	
windower.register_event('chat message', function(original, sender, mode, gm)
    local match

				if sender == player.name then
					if (original == "mode" or original == "MODE" or original == "Mode" or original == "mod") and modchos == false then
						add_to_chat(204,"Choose your pet mode(Tank, DD, BLM, WHM, RDM)")
						modchos = true
						submodechos = false
					elseif modchos == true and PetMode:contains(original) then
						ActualMode = original
						stext = ""
						i = 1
						if ActualMode == "Tank" then
						sets.aftercast = sets.petTank
						else
						sets.aftercast = sets.idle
						end
						while i <= NSubMode[ActualMode] do
							stext = stext..PetSubMode[ActualMode][i].." - "
							i=i+1
						end
						add_to_chat(204,"Choose your "..ActualMode.." style : "..stext)
						submodechos = true
						modchos = false
					elseif submodechos == true then
						i = 1
						while i <= NSubMode[ActualMode] do
							if original == PetSubMode[ActualMode][i] then
								ActualSubMode = original
								send_command('input //autocontrol equipset '..Style[ActualSubMode][1])
								Mane[1] = Style[ActualSubMode][2]
								Mane[2] = Style[ActualSubMode][3]
								Mane[3] = Style[ActualSubMode][4]
								submodechos = false
							end
							i=i+1
						end
						
					elseif original == "man" or original == "Man" or original == "Maneuver" or original == "maneuver" then
						if ManeRound == 1 and windower.ffxi.get_ability_recasts()[210] and not buffactive.amnesia then
							send_command('input /ja "'..Mane[1]..' Maneuver" <me>')
						elseif ManeRound == 2 and windower.ffxi.get_ability_recasts()[210] and not buffactive.amnesia then
							send_command('input /ja "'..Mane[2]..' Maneuver" <me>')
						elseif ManeRound == 3 and windower.ffxi.get_ability_recasts()[210] and not buffactive.amnesia then
							send_command('input /ja "'..Mane[3]..' Maneuver" <me>')
						end
					elseif original == "1" and not choosing then
						wchoos = 1
						add_to_chat(204,"Choose your First maneuver :")
						choosing = true
					elseif original == "2" and not choosing then
						wchoos = 2
						add_to_chat(204,"Choose your Second maneuver :")
						choosing = true
					elseif original == "3" and not choosing then
						wchoos = 3
						add_to_chat(204,"Choose your Third maneuver :")
						choosing = true
					elseif choosing then
						if TypeM:contains(original) then
							add_to_chat(204,""..original.." Maneuver choosed")
							Mane[wchoos] = original
							wchoos = 0
							choosing = false
						end
					elseif original == "start" then
						autos= true
						add_to_chat(204,"AutoManeuver started")
						--print(autos)
					elseif original == "stop" then
						autos= false
						add_to_chat(204,"AutoManeuver stoped")
					else
						comd = string.split(original, ",")
						for i=1, 3, 1 do
						
							if TypeM:contains(comd[i]) then
								add_to_chat(204,"Maneuver "..i.." = "..comd[i].."")
								Mane[i] = comd[i]
							end
						end
					end
				end
				
				

    return sender, mode, gm
end)

function round(num, dec)
  local mult = 10^(dec or 0)
  return math.floor(num * mult + 0.5) / mult
end

RWSTrigger = S{"Arcuballista", "Daze", "Armor Piercer", "Armor Shatterer"}
MWSTrigger = S{"Slapstick", "Knockout", "Chimera Ripper", "String Clipper", "Cannibal Blade", "Bone Crusher", "String Shredder"}
HPWSTrigger = S{"Magic Mortar"}
wscount=0
--- Delve Assistant
windower.register_event('incoming text', function(original, modified, mode)
    local match
		
		-- OVERDRIVE OPTIMIZER
			if buffactive["Overdrive"] then
				match = original:match(pet.name..' readies ([%s%w]+)%.')
				if match=="Daze" then
					sets.midcast.Pet.WeaponSkill = sets.midcast.Pet.WSFTP
					add_to_chat(204, '*-*-*-*-*-*-*-*-* [ '..match..' done ] *-*-*-*-*-*-*-*-*')
					refresh()
					OverCount = 2
				elseif match=="Arcuballista" then
					sets.midcast.Pet.WeaponSkill = sets.midcast.Pet.WSNoFTP
					add_to_chat(204, '*-*-*-*-*-*-*-*-* [ '..match..' done ] *-*-*-*-*-*-*-*-*')
					refresh()
					OverCount = 3
				elseif match=="Armor Shatterer" then
					sets.midcast.Pet.WeaponSkill = sets.midcast.Pet.WSNoFTP
					add_to_chat(204, '*-*-*-*-*-*-*-*-* [ '..match..' done ] *-*-*-*-*-*-*-*-*')
					refresh()
					OverCount = 4
				elseif match=="Armor Piercer" then
					sets.midcast.Pet.WeaponSkill = sets.midcast.Pet.WSFTP
					add_to_chat(204, '*-*-*-*-*-*-*-*-* [ '..match..' done ] *-*-*-*-*-*-*-*-*')
					refresh()
					OverCount = 1
				end
			end
			-- Checking timer for enmity sets
			if ActualMode == "Tank" then
				if buffactive['Fire Maneuver'] then
					match = original:match(pet.name..' uses Provoke')
					
					if match then
						add_to_chat(204, '*-*-*-*-*-*-*-*-* [ Strobe done ] *-*-*-*-*-*-*-*-*')
						strobetime = os.time()
						stroberecast = strobetimer
						equip(sets.aftercast)
					end
				end
				
				if buffactive['Light Maneuver'] then
					match = original:match(pet.name..' uses Flashbulb.')
					
					if match then
						add_to_chat(204, '*-*-*-*-*-*-*-*-* [ Flashbulb done ] *-*-*-*-*-*-*-*-*')
						flashbulbtime = os.time()
						flashbulbrecast = flashbulbtimer
						equip(sets.aftercast)
					end
				end
			end
		-- AutoWS trigger
		
			--match = original:match('Genta readies ([%s%w]+)%.')
		
			--if RWSTrigger:contains(match) then
			--	equip(sets.midcast.Pet.WeaponSkill)
			--	add_to_chat(204, '*-*-*-*-*-*-*-*-* [ Genta is Range WSing ] *-*-*-*-*-*-*-*-*')
			--elseif MWSTrigger:contains(match) then
			--	equip(sets.midcast.Pet.WeaponSkill)
			--	add_to_chat(204, '*-*-*-*-*-*-*-*-* [ Genta is Melee WSing ] *-*-*-*-*-*-*-*-*')
			--elseif HPWSTrigger:contains(match) then
			--	equip(sets.midcast.Pet.WeaponSkill)
			--	add_to_chat(204, '*-*-*-*-*-*-*-*-* [ Genta is Magic Mortaring ] *-*-*-*-*-*-*-*-*')		
			--end
		--[[	match = original:match('Genta uses')
			if match then
				-- After Bone crusher
				equip(sets.engaged)
			end
			match = original:match('defeats the Apex Eft')
			if match then
				
				add_to_chat(204, '*-*-*-*-*-*-*-*-* [ dead ] *-*-*-*-*-*-*-*-*')
				send_command('wait 1; input /p fc')
			end
		
		if original then
		--if player.target.name then
			
			match = original:match('Trueamerstwin uses Cross Reaper.')
			if match then
				wscount=wscount+1
				add_to_chat(204, '*-*-*-*-*-*-*-*-* [ Dark SC started, closing with LS -WS = '..wscount..' ] *-*-*-*-*-*-*-*-*')
				send_command('wait 3; input /ws "Stringing Pummel" <t>')
			end
			
		--end
		end]]--
		
    return modified, mode
end)