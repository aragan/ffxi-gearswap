-------------------------------------------------------------------------------------------------------------------
-- Setup functions for this job.  Generally should not be modified.
-------------------------------------------------------------------------------------------------------------------

-- Initialization function for this job file.
function get_sets()
    mote_include_version = 2

    -- Load and initialize the include file.
    include('Mote-Include.lua')
end


-- Setup vars that are user-independent.  state.Buff vars initialized here will automatically be tracked.
function job_setup()
    -- List of pet weaponskills to check for
    petWeaponskills = S{"Slapstick", "Knockout", "Magic Mortar",
        "Chimera Ripper", "String Clipper",  "Cannibal Blade", "Bone Crusher", "String Shredder",
        "Arcuballista", "Daze", "Armor Piercer", "Armor Shatterer"}
    
    -- Map automaton heads to combat roles
    petModes = {
        ['Harlequin Head'] = 'Melee',
        ['Sharpshot Head'] = 'Ranged',
        ['Valoredge Head'] = 'Tank',
        ['Stormwaker Head'] = 'Magic',
        ['Soulsoother Head'] = 'Heal',
        ['Spiritreaver Head'] = 'Nuke'
        }

    -- Subset of modes that use magic
    magicPetModes = S{'Nuke','Heal','Magic'}
    
    -- Var to track the current pet mode.
    state.PetMode = M{['description']='Pet Mode', 'None', 'Melee', 'Ranged', 'Tank', 'Magic', 'Heal', 'Nuke'}
end

-------------------------------------------------------------------------------------------------------------------
-- User setup functions for this job.  Recommend that these be overridden in a sidecar file.
-------------------------------------------------------------------------------------------------------------------

-- Setup vars that are user-dependent.  Can override this function in a sidecar file.
function user_setup()
    state.OffenseMode:options('Normal', 'Acc', 'Fodder')
    state.HybridMode:options('Normal', 'DT')
    state.WeaponskillMode:options('Normal', 'Acc', 'Fodder')
    state.PhysicalDefenseMode:options('PDT', 'Evasion')

    -- Default maneuvers 1, 2, 3 and 4 for each pet mode.
    defaultManeuvers = {
        ['Melee'] = {'Fire Maneuver', 'Thunder Maneuver', 'Wind Maneuver', 'Light Maneuver'},
        ['Ranged'] = {'Wind Maneuver', 'Fire Maneuver', 'Thunder Maneuver', 'Light Maneuver'},
        ['Tank'] = {'Earth Maneuver', 'Dark Maneuver', 'Light Maneuver', 'Wind Maneuver'},
        ['Magic'] = {'Ice Maneuver', 'Light Maneuver', 'Dark Maneuver', 'Earth Maneuver'},
        ['Heal'] = {'Light Maneuver', 'Dark Maneuver', 'Water Maneuver', 'Earth Maneuver'},
        ['Nuke'] = {'Ice Maneuver', 'Dark Maneuver', 'Light Maneuver', 'Earth Maneuver'}
    }

    update_pet_mode()
    select_default_macro_book()
end


-- Define sets used by this job file.
function init_gear_sets()
    
    -- Precast Sets

    -- Fast cast sets for spells
    sets.precast.FC = {head="Haruspex Hat",ear2="Loquacious Earring",hands="Thaumas Gloves"}

    sets.precast.FC.Utsusemi = set_combine(sets.precast.FC, {neck="Magoraga Beads"})

    
    -- Precast sets to enhance JAs
    sets.precast.JA['Tactical Switch'] = {feet="Cirque Scarpe +2"}
    
    sets.precast.JA['Repair'] = {
        main={ name="Nibiru Sainti", augments={'Melee skill +20','Ranged skill +20','Magic skill +20',}},
        ammo = "Automat. Oil +3",
        feet = "Artifact_Foire.Feet_Repair_PMagic"
    }

    sets.precast.JA.Maneuver = {
        main={ name="Midnights", augments={'Pet: Attack+25','Pet: Accuracy+25','Pet: Damage taken -3%',}},
        neck = "Buffoon's Collar +1",
        body = "Karagoz Farsetto",
        hands = "Artifact_Foire.Hands_Mane_Overload",
        back = "Visucius's Mantle",
        ear1 = "Burana Earring"
    }



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
         
    main={ name="Ohtas", augments={'Accuracy+70','Pet: Accuracy+70','Pet: Haste+10%',}},
    range="Animator P +1",
    ammo="Automat. Oil +3",
    head={ name="Pitre Taj +3", augments={'Enhances "Optimization" effect',}},
    body={ name="Pitre Tobe +1", augments={'Enhances "Overdrive" effect',}},
    hands="Karagoz Guanti +1",
    legs="Kara. Pantaloni +1",
    feet={ name="Naga Kyahan", augments={'Pet: HP+100','Pet: Accuracy+25','Pet: Attack+25',}},
    neck="Shulmanu Collar",
    waist="Klouskap Sash",
    left_ear="Rimeice Earring",
    right_ear="Enmerkar Earring",
    left_ring="Varar Ring",
    right_ring="Overbearing Ring",
    back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Pet: "Regen"+10','Pet: Damage taken -5%',}},
    }

    -- Specific weaponskill sets.  Uses the base set if an appropriate WSMod version isn't found.
    sets.precast.WS['Stringing Pummel'] = set_combine(sets.precast.WS, {neck="Rancor Collar",ear1="Brutal Earring",ear2="Moonshade Earring",
        ring1="Spiral Ring",waist="Soil Belt"})
    sets.precast.WS['Stringing Pummel'].Mod = set_combine(sets.precast.WS['Stringing Pummel'], {legs="Nahtirah Trousers"})

    sets.precast.WS['Victory Smite'] = set_combine(sets.precast.WS, {neck="Rancor Collar",ear1="Brutal Earring",ear2="Moonshade Earring",
        waist="Thunder Belt"})

    sets.precast.WS['Shijin Spiral'] = set_combine(sets.precast.WS, {neck="Light Gorget",waist="Light Belt"})

    
    -- Midcast Sets

    sets.midcast.FastRecast = {
        head="Haruspex Hat",ear2="Loquacious Earring",
        body="Otronif Harness +1",hands="Regimen Mittens",
        legs="Manibozho Brais",feet="Otronif Boots +1"}
        

    -- Midcast sets for pet actions
    sets.midcast.Pet.Cure = {legs="Foire Churidars"}

    sets.midcast.Pet['Elemental Magic'] = {feet="Pitre Babouches"}

    sets.midcast.Pet.WeaponSkill = {
    main={ name="Midnights", augments={'Pet: Attack+25','Pet: Accuracy+25','Pet: Damage taken -3%',}},
    range="Animator P +1",
    ammo="Automat. Oil +3",
    head={ name="Pitre Taj +3", augments={'Enhances "Optimization" effect',}},
    body={ name="Pitre Tobe +3", augments={'Enhances "Overdrive" effect',}},
    hands="Karagoz Guanti +1",
    legs={ name="Herculean Trousers", augments={'Pet: "Dbl. Atk."+5','Pet: DEX+4','Pet: "Mag.Atk.Bns."+1',}},
    feet={ name="Naga Kyahan", augments={'Pet: HP+100','Pet: Accuracy+25','Pet: Attack+25',}},
    neck="Shulmanu Collar",
    waist="Klouskap Sash",
    left_ear="Rimeice Earring",
    right_ear="Enmerkar Earring",
    left_ring="Varar Ring",
    right_ring="Overbearing Ring",
    back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10','Pet: Damage taken -5%',}},
}

    
    -- Sets to return to when not performing an action.
    
    -- Resting sets
    sets.resting = {head="Pitre Taj",neck="Wiglen Gorget",
        ring1="Sheltered Ring",ring2="Paguroidea Ring"}
    

    -- Idle sets

    sets.idle = {
    main={ name="Midnights", augments={'Pet: Attack+25','Pet: Accuracy+25','Pet: Damage taken -3%',}},
    range="Animator P +1",
    ammo="Automat. Oil +3",
    head={ name="Herculean Helm", augments={'Pet: Mag. Acc.+14','Pet: "Dbl. Atk."+4','Pet: INT+3','Pet: Attack+6 Pet: Rng.Atk.+6','Pet: "Mag.Atk.Bns."+6',}},
    body={ name="Pitre Tobe +3", augments={'Enhances "Overdrive" effect',}},
    hands={ name="Herculean Gloves", augments={'Pet: "Mag.Atk.Bns."+30','Pet: "Dbl. Atk."+5','Pet: INT+4',}},
    legs={ name="Herculean Trousers", augments={'Pet: "Dbl. Atk."+5','Pet: DEX+4','Pet: "Mag.Atk.Bns."+1',}},
    feet={ name="Herculean Boots", augments={'Pet: Attack+15 Pet: Rng.Atk.+15','Pet: "Dbl. Atk."+4','Pet: AGI+10','Pet: "Mag.Atk.Bns."+11',}},
    neck="Shulmanu Collar",
    waist="Klouskap Sash",
    left_ear="Rimeice Earring",
    right_ear="Enmerkar Earring",
    left_ring="Varar Ring",
    right_ring="Varar Ring",
    back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10','Pet: Damage taken -5%',}},
}

    sets.idle.Town = set_combine(sets.idle, {main="Tinhaspa"})

    -- Set for idle while pet is out (eg: pet regen gear)
    sets.idle.Pet = sets.idle

    -- Idle sets to wear while pet is engaged
    sets.idle.Pet.Engaged = {
    main={ name="Midnights", augments={'Pet: Attack+25','Pet: Accuracy+25','Pet: Damage taken -3%',}},
    range="Animator P +1",
    ammo="Automat. Oil +3",
    head={ name="Herculean Helm", augments={'Pet: Mag. Acc.+14','Pet: "Dbl. Atk."+4','Pet: INT+3','Pet: Attack+6 Pet: Rng.Atk.+6','Pet: "Mag.Atk.Bns."+6',}},
    body={ name="Pitre Tobe +3", augments={'Enhances "Overdrive" effect',}},
    hands={ name="Herculean Gloves", augments={'Pet: "Mag.Atk.Bns."+30','Pet: "Dbl. Atk."+5','Pet: INT+4',}},
    legs={ name="Herculean Trousers", augments={'Pet: "Dbl. Atk."+5','Pet: DEX+4','Pet: "Mag.Atk.Bns."+1',}},
    feet={ name="Herculean Boots", augments={'Pet: Attack+15 Pet: Rng.Atk.+15','Pet: "Dbl. Atk."+4','Pet: AGI+10','Pet: "Mag.Atk.Bns."+11',}},
    neck="Shulmanu Collar",
    waist="Klouskap Sash",
    left_ear="Rimeice Earring",
    right_ear="Enmerkar Earring",
    left_ring="Varar Ring",
    right_ring="Varar Ring",
    back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10','Pet: Damage taken -5%',}},
}

    sets.idle.Pet.Engaged.Ranged = set_combine(sets.idle.Pet.Engaged, {hands="Cirque Guanti +2",legs="Cirque Pantaloni +2"})

    sets.idle.Pet.Engaged.Nuke = set_combine(sets.idle.Pet.Engaged, {legs="Cirque Pantaloni +2",feet="Cirque Scarpe +2"})

    sets.idle.Pet.Engaged.Magic = set_combine(sets.idle.Pet.Engaged, {legs="Cirque Pantaloni +2",feet="Cirque Scarpe +2"})


    -- Defense sets

    sets.defense.Evasion = {
    main={ name="Midnights", augments={'Pet: Attack+25','Pet: Accuracy+25','Pet: Damage taken -3%',}},
    range="Animator P +1",
    ammo="Automat. Oil +3",
    head={ name="Herculean Helm", augments={'Pet: Mag. Acc.+14','Pet: "Dbl. Atk."+4','Pet: INT+3','Pet: Attack+6 Pet: Rng.Atk.+6','Pet: "Mag.Atk.Bns."+6',}},
    body={ name="Pitre Tobe +3", augments={'Enhances "Overdrive" effect',}},
    hands={ name="Herculean Gloves", augments={'Pet: "Mag.Atk.Bns."+30','Pet: "Dbl. Atk."+5','Pet: INT+4',}},
    legs={ name="Herculean Trousers", augments={'Pet: "Dbl. Atk."+5','Pet: DEX+4','Pet: "Mag.Atk.Bns."+1',}},
    feet={ name="Herculean Boots", augments={'Pet: Attack+15 Pet: Rng.Atk.+15','Pet: "Dbl. Atk."+4','Pet: AGI+10','Pet: "Mag.Atk.Bns."+11',}},
    neck="Shulmanu Collar",
    waist="Klouskap Sash",
    left_ear="Rimeice Earring",
    right_ear="Enmerkar Earring",
    left_ring="Varar Ring",
    right_ring="Varar Ring",
    back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10','Pet: Damage taken -5%',}},
}

    sets.defense.PDT = {
           main="Denouements",
    range="Animator P +1",
    ammo="Automat. Oil +3",
    head={ name="Rao Kabuto", augments={'Pet: HP+100','Pet: Accuracy+15','Pet: Damage taken -3%',}},
    body={ name="Taeon Tabard", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    hands={ name="Rao Kote", augments={'Pet: HP+100','Pet: Accuracy+15','Pet: Damage taken -3%',}},
    legs="Tali'ah Sera. +1",
    feet={ name="Rao Sune-Ate", augments={'Pet: HP+100','Pet: Accuracy+15','Pet: Damage taken -3%',}},
    neck="Empath Necklace",
    waist="Isa Belt",
    left_ear="Enmerkar Earring",
    right_ear="Handler's Earring +1",
    left_ring="Varar Ring",
    right_ring="Overbearing Ring",
    back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Pet: "Regen"+10','Pet: Damage taken -5%',}},
    

    }

    sets.defense.MDT = {
    main={ name="Midnights", augments={'Pet: Attack+25','Pet: Accuracy+25','Pet: Damage taken -3%',}},
    range="Animator P +1",
    ammo="Automat. Oil +3",
    head={ name="Herculean Helm", augments={'Pet: Mag. Acc.+14','Pet: "Dbl. Atk."+4','Pet: INT+3','Pet: Attack+6 Pet: Rng.Atk.+6','Pet: "Mag.Atk.Bns."+6',}},
    body={ name="Pitre Tobe +3", augments={'Enhances "Overdrive" effect',}},
    hands={ name="Herculean Gloves", augments={'Pet: "Mag.Atk.Bns."+30','Pet: "Dbl. Atk."+5','Pet: INT+4',}},
    legs={ name="Herculean Trousers", augments={'Pet: "Dbl. Atk."+5','Pet: DEX+4','Pet: "Mag.Atk.Bns."+1',}},
    feet={ name="Herculean Boots", augments={'Pet: Attack+15 Pet: Rng.Atk.+15','Pet: "Dbl. Atk."+4','Pet: AGI+10','Pet: "Mag.Atk.Bns."+11',}},
    neck="Shulmanu Collar",
    waist="Klouskap Sash",
    left_ear="Rimeice Earring",
    right_ear="Enmerkar Earring",
    left_ring="Varar Ring",
    right_ring="Varar Ring",
    back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10','Pet: Damage taken -5%',}},
}

    sets.Kiting = {}

    -- Engaged sets

    -- Variations for TP weapon and (optional) offense/defense modes.  Code will fall back on previous
    -- sets if more refined versions aren't defined.
    -- If you create a set with both offense and defense modes, the offense mode should be first.
    -- EG: sets.engaged.Dagger.Accuracy.Evasion
    
    -- Normal melee group
    sets.engaged = {
    main={ name="Midnights", augments={'Pet: Attack+25','Pet: Accuracy+25','Pet: Damage taken -3%',}},
    range="Animator P +1",
    ammo="Automat. Oil +3",
    head={ name="Herculean Helm", augments={'Pet: Mag. Acc.+14','Pet: "Dbl. Atk."+4','Pet: INT+3','Pet: Attack+6 Pet: Rng.Atk.+6','Pet: "Mag.Atk.Bns."+6',}},
    body={ name="Pitre Tobe +3", augments={'Enhances "Overdrive" effect',}},
    hands={ name="Herculean Gloves", augments={'Pet: "Mag.Atk.Bns."+30','Pet: "Dbl. Atk."+5','Pet: INT+4',}},
    legs={ name="Herculean Trousers", augments={'Pet: "Dbl. Atk."+5','Pet: DEX+4','Pet: "Mag.Atk.Bns."+1',}},
    feet={ name="Herculean Boots", augments={'Pet: Attack+15 Pet: Rng.Atk.+15','Pet: "Dbl. Atk."+4','Pet: AGI+10','Pet: "Mag.Atk.Bns."+11',}},
    neck="Shulmanu Collar",
    waist="Klouskap Sash",
    left_ear="Rimeice Earring",
    right_ear="Enmerkar Earring",
    left_ring="Varar Ring",
    right_ring="Varar Ring",
    back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10','Pet: Damage taken -5%',}},
}
    sets.engaged.Acc = {
    main={ name="Midnights", augments={'Pet: Attack+25','Pet: Accuracy+25','Pet: Damage taken -3%',}},
    range="Animator P +1",
    ammo="Automat. Oil +3",
    head={ name="Herculean Helm", augments={'Pet: Mag. Acc.+14','Pet: "Dbl. Atk."+4','Pet: INT+3','Pet: Attack+6 Pet: Rng.Atk.+6','Pet: "Mag.Atk.Bns."+6',}},
    body={ name="Pitre Tobe +3", augments={'Enhances "Overdrive" effect',}},
    hands={ name="Herculean Gloves", augments={'Pet: "Mag.Atk.Bns."+30','Pet: "Dbl. Atk."+5','Pet: INT+4',}},
    legs={ name="Herculean Trousers", augments={'Pet: "Dbl. Atk."+5','Pet: DEX+4','Pet: "Mag.Atk.Bns."+1',}},
    feet={ name="Herculean Boots", augments={'Pet: Attack+15 Pet: Rng.Atk.+15','Pet: "Dbl. Atk."+4','Pet: AGI+10','Pet: "Mag.Atk.Bns."+11',}},
    neck="Shulmanu Collar",
    waist="Klouskap Sash",
    left_ear="Rimeice Earring",
    right_ear="Enmerkar Earring",
    left_ring="Varar Ring",
    right_ring="Varar Ring",
    back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+10 /Mag. Eva.+10','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10','Pet: Damage taken -5%',}},
}
    sets.engaged.DT ={
           main="Denouements",
    range="Animator P +1",
    ammo="Automat. Oil +3",
    head={ name="Rao Kabuto", augments={'Pet: HP+100','Pet: Accuracy+15','Pet: Damage taken -3%',}},
    body={ name="Taeon Tabard", augments={'Pet: Mag. Evasion+20','Pet: "Regen"+3','Pet: Damage taken -3%',}},
    hands={ name="Rao Kote", augments={'Pet: HP+100','Pet: Accuracy+15','Pet: Damage taken -3%',}},
    legs="Tali'ah Sera. +1",
    feet={ name="Rao Sune-Ate", augments={'Pet: HP+100','Pet: Accuracy+15','Pet: Damage taken -3%',}},
    neck="Empath Necklace",
    waist="Isa Belt",
    left_ear="Enmerkar Earring",
    right_ear="Handler's Earring +1",
    left_ring="Varar Ring",
    right_ring="Overbearing Ring",
    back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Pet: "Regen"+10','Pet: Damage taken -5%',}},
    

    }
    sets.engaged.Acc.DT = {
           
    main={ name="Ohtas", augments={'Accuracy+70','Pet: Accuracy+70','Pet: Haste+10%',}},
    range="Animator P +1",
    ammo="Automat. Oil +3",
    head={ name="Herculean Helm", augments={'Pet: Mag. Acc.+14','Pet: "Dbl. Atk."+4','Pet: INT+3','Pet: Attack+6 Pet: Rng.Atk.+6','Pet: "Mag.Atk.Bns."+6',}},
    body={ name="Pitre Tobe +1", augments={'Enhances "Overdrive" effect',}},
    hands={ name="Herculean Gloves", augments={'Pet: "Store TP"+10','Pet: DEX+5','Pet: "Mag.Atk.Bns."+8',}},
    legs={ name="Herculean Trousers", augments={'Pet: "Mag.Atk.Bns."+16','Pet: "Store TP"+11',}},
    feet={ name="Herculean Boots", augments={'Pet: Mag. Acc.+24','Pet: "Store TP"+10','Pet: AGI+5','Pet: "Mag.Atk.Bns."+13',}},
    neck="Shulmanu Collar",
    waist="Klouskap Sash",
    left_ear="Rimeice Earring",
    right_ear="Enmerkar Earring",
    left_ring="Varar Ring",
    right_ring="Varar Ring",
    back={ name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Pet: "Regen"+10','Pet: Damage taken -5%',}},

    }
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for standard casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when pet is about to perform an action
function job_pet_midcast(spell, action, spellMap, eventArgs)
    if petWeaponskills:contains(spell.english) then
        classes.CustomClass = "Weaponskill"
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Job-specific hooks for non-casting events.
-------------------------------------------------------------------------------------------------------------------

-- Called when a player gains or loses a buff.
-- buff == buff gained or lost
-- gain == true if the buff was gained, false if it was lost.
function job_buff_change(buff, gain)
    if buff == 'Wind Maneuver' then
        handle_equipping_gear(player.status)
    end
end

-- Called when a player gains or loses a pet.
-- pet == pet gained or lost
-- gain == true if the pet was gained, false if it was lost.
function job_pet_change(pet, gain)
    update_pet_mode()
end

-- Called when the pet's status changes.
function job_pet_status_change(newStatus, oldStatus)
    if newStatus == 'Engaged' then
        display_pet_status()
    end
end


-------------------------------------------------------------------------------------------------------------------
-- User code that supplements standard library decisions.
-------------------------------------------------------------------------------------------------------------------

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
    update_pet_mode()
end


-- Set eventArgs.handled to true if we don't want the automatic display to be run.
function display_current_job_state(eventArgs)
    display_pet_status()
end


-------------------------------------------------------------------------------------------------------------------
-- User self-commands.
-------------------------------------------------------------------------------------------------------------------

-- Called for custom player commands.
function job_self_command(cmdParams, eventArgs)
    if cmdParams[1] == 'maneuver' then
        if pet.isvalid then
            local man = defaultManeuvers[state.PetMode.value]
            if man and tonumber(cmdParams[2]) then
                man = man[tonumber(cmdParams[2])]
            end

            if man then
                send_command('input /pet "'..man..'" <me>')
            end
        else
            add_to_chat(123,'No valid pet.')
        end
    end
end


-------------------------------------------------------------------------------------------------------------------
-- Utility functions specific to this job.
-------------------------------------------------------------------------------------------------------------------

-- Get the pet mode value based on the equipped head of the automaton.
-- Returns nil if pet is not valid.
function get_pet_mode()
    if pet.isvalid then
        return petModes[pet.head] or 'None'
    else
        return 'None'
    end
end

-- Update state.PetMode, as well as functions that use it for set determination.
function update_pet_mode()
    state.PetMode:set(get_pet_mode())
    update_custom_groups()
end

-- Update custom groups based on the current pet.
function update_custom_groups()
    classes.CustomIdleGroups:clear()
    if pet.isvalid then
        classes.CustomIdleGroups:append(state.PetMode.value)
    end
end

-- Display current pet status.
function display_pet_status()
    if pet.isvalid then
        local petInfoString = pet.name..' ['..pet.head..']: '..tostring(pet.status)..'  TP='..tostring(pet.tp)..'  HP%='..tostring(pet.hpp)
        
        if magicPetModes:contains(state.PetMode.value) then
            petInfoString = petInfoString..'  MP%='..tostring(pet.mpp)
        end
        
        add_to_chat(122,petInfoString)
    end
end

-- Select default macro book on initial load or subjob change.
function select_default_macro_book()
    -- Default macro set/book
    if player.sub_job == 'DNC' then
        set_macro_page(9,1 )
    elseif player.sub_job == 'NIN' then
        set_macro_page(9,1 )
    elseif player.sub_job == 'THF' then
        set_macro_page(9,1 )
    else
        set_macro_page(9,1 )
    end
end


