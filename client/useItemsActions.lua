local IsDrunk = false
local DrunkTime = nil
local DrunkEffects = false
local IsDrank = false
local DrankTime = nil
local DrankEffects = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if IsDrunk and not DrunkEffects then
            DoScreenFadeOut(500)
            Citizen.Wait(500)
            local walkingStyle = { "default", "very_drunk" }
			Citizen.InvokeNative(0x923583741DC87BCE, PlayerPedId(), walkingStyle[1])
			Citizen.InvokeNative(0x89F5E7ADECCCB49C, PlayerPedId(), walkingStyle[2])
            AnimpostfxPlay("PlayerDrunk01")
            --Citizen.InvokeNative(0xCAB4DD2D5B2B7246, 0.5) -- AnimPostfxSetStrength
            --"PlayerDrunk01",
            --"PlayerDrunk01_PassOut",
            --"PlayerDrunkAberdeen",
            --"PlayerDrunkSaloon1"
            DrunkEffects = true
            Citizen.Wait(100)
            DoScreenFadeIn(500)
        end
        if IsDrunk and DrunkEffects and DrunkTime then
            if GetGameTimer() - DrunkTime > 6000 then
                DoScreenFadeOut(500)
                Citizen.Wait(500)
                local walkingStyle = { "default", "normal" }
                Citizen.InvokeNative(0x923583741DC87BCE, PlayerPedId(), walkingStyle[1])
                Citizen.InvokeNative(0x89F5E7ADECCCB49C, PlayerPedId(), walkingStyle[2])
                AnimpostfxStop("PlayerDrunk01")
                IsDrunk = false
                DrunkEffects = false
                DrunkTime = nil
                Citizen.Wait(100)
                DoScreenFadeIn(500)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if IsDrank and not DrankEffects then
            DoScreenFadeOut(500)
            Citizen.Wait(500)
            local walkingStyle = { "default", "MODERATELY_DRUNK" }
			Citizen.InvokeNative(0x923583741DC87BCE, PlayerPedId(), walkingStyle[1])
			Citizen.InvokeNative(0x89F5E7ADECCCB49C, PlayerPedId(), walkingStyle[2])
            AnimpostfxPlay("PlayerDrunkAberdeen")
            --Citizen.InvokeNative(0xCAB4DD2D5B2B7246, 0.5) -- AnimPostfxSetStrength
            --"PlayerDrunk01",
            --"PlayerDrunk01_PassOut",
            --"PlayerDrunkAberdeen",
            --"PlayerDrunkSaloon1"
            DrankEffects = true
            Citizen.Wait(100)
            DoScreenFadeIn(500)
        end
        if IsDrank and DrankEffects and DrankTime then
            if GetGameTimer() - DrankTime > 6000 then
                DoScreenFadeOut(500)
                Citizen.Wait(500)
                local walkingStyle = { "default", "normal" }
                Citizen.InvokeNative(0x923583741DC87BCE, PlayerPedId(), walkingStyle[1])
                Citizen.InvokeNative(0x89F5E7ADECCCB49C, PlayerPedId(), walkingStyle[2])
                AnimpostfxStop("PlayerDrunkAberdeen")
                IsDrank = false
                DrankEffects = false
                DrankTime = nil
                Citizen.Wait(100)
                DoScreenFadeIn(500)
            end
        end
    end
end)



RegisterNetEvent('vorpmetabolism:useItem', function(index, label)
    PlaySoundFrontend("Core_Fill_Up", "Consumption_Sounds", true, 0)

    if (Config["ItemsToUse"][index]["Thirst"] ~= 0) then
        local newThirst = PlayerStatus["Thirst"] + Config["ItemsToUse"][index]["Thirst"]

        if (newThirst > 1000) then
            newThirst = 1000
        end

        if (newThirst < 0) then
            newThirst = 0
        end
        PlayerStatus["Thirst"] = newThirst
    end
    if (Config["ItemsToUse"][index]["Hunger"] ~= 0) then
        local newHunger = PlayerStatus["Hunger"] + Config["ItemsToUse"][index]["Hunger"]

        if (newHunger > 1000) then
            newHunger = 1000
        end

        if (newHunger < 0) then
            newHunger = 0
        end

        PlayerStatus["Hunger"] = newHunger
    end
    if (Config["ItemsToUse"][index]["Metabolism"] ~= 0) then
        local newMetabolism = PlayerStatus["Metabolism"] + Config["ItemsToUse"][index]["Metabolism"]

        if (newMetabolism > 10000) then
            newMetabolism = 10000
        end

        if (newMetabolism < -10000) then
            newMetabolism = -10000
        end

        PlayerStatus["Metabolism"] = newMetabolism
    end
    if (Config["ItemsToUse"][index]["Stamina"] ~= 0) then
        local stamina = GetAttributeCoreValue(PlayerPedId(), 1)
        local newStamina = stamina + Config["ItemsToUse"][index]["Stamina"]

        if (newStamina > 100) then
            newStamina = 100
        end

        Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 1, newStamina) -- SetAttributeCoreValue native
    end
    if (Config["ItemsToUse"][index]["InnerCoreHealth"] ~= 0) then
        local health = GetAttributeCoreValue(PlayerPedId(), 0)
        local newhealth = health + Config["ItemsToUse"][index]["InnerCoreHealth"]

        if (newhealth > 100) then
            newhealth = 100
        end

        Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 0, newhealth) -- SetAttributeCoreValue native
    end
    if (Config["ItemsToUse"][index]["OuterCoreHealth"] ~= 0) then
        local health = GetEntityHealth(PlayerPedId(), 0)
        local newhealth = health + Config["ItemsToUse"][index]["OuterCoreHealth"]

        if (newhealth > 150) then
            newhealth = 150
        end
        SetEntityHealth(PlayerPedId(), newhealth, 0)
    end
    -- Golds
    if (Config["ItemsToUse"][index]["OuterCoreHealthGold"] ~= 0.0) then
        EnableAttributeOverpower(PlayerPedId(), 0, Config["ItemsToUse"][index]["OuterCoreHealthGold"], true)
    end
    if (Config["ItemsToUse"][index]["InnerCoreHealthGold"] ~= 0.0) then
        EnableAttributeOverpower(PlayerPedId(), 0, Config["ItemsToUse"][index]["InnerCoreHealthGold"], true)
    end

    if (Config["ItemsToUse"][index]["OuterCoreStaminaGold"] ~= 0.0) then
        EnableAttributeOverpower(PlayerPedId(), 1, Config["ItemsToUse"][index]["OuterCoreStaminaGold"], true)
    end
    if (Config["ItemsToUse"][index]["InnerCoreStaminaGold"] ~= 0.0) then
        EnableAttributeOverpower(PlayerPedId(), 1, Config["ItemsToUse"][index]["InnerCoreStaminaGold"], true)
    end

    if (Config["ItemsToUse"][index]["Animation"] == 'eat') then
        PlayAnimEat(Config["ItemsToUse"][index]["PropName"])
    end

    if (Config["ItemsToUse"][index]["Animation"] == 'drink') then
        PlayAnimDrink(Config["ItemsToUse"][index]["PropName"])
    end

    if (Config["ItemsToUse"][index]["Animation"] == 'beer') then
        Beer(Config["ItemsToUse"][index]["PropName"])
    end

    if (Config["ItemsToUse"][index]["Animation"] == 'eatbowl') then
        EatBowl(Config["ItemsToUse"][index]["PropName"])
    end

    if (Config["ItemsToUse"][index]["Animation"] == 'whisky') then
        Whisky(Config["ItemsToUse"][index]["PropName"])
    end

    if (Config["ItemsToUse"][index]["Animation"] == 'rum') then
        Rum(Config["ItemsToUse"][index]["PropName"])
    end

    if (Config["ItemsToUse"][index]["Animation"] == 'cognac') then
        Cognac(Config["ItemsToUse"][index]["PropName"])
    end

    if (Config["ItemsToUse"][index]["Animation"] == 'moonshine') then
        Moonshine(Config["ItemsToUse"][index]["PropName"])
    end

    if (Config["ItemsToUse"][index]["Animation"] == 'wine') then
        Wine(Config["ItemsToUse"][index]["PropName"])
    end

    if (Config["ItemsToUse"][index]["Animation"] == 'coffe') then
        Coffe(Config["ItemsToUse"][index]["PropName"])
    end

    if (Config["ItemsToUse"][index]["Animation"] == 'shampan') then
        Shampan(Config["ItemsToUse"][index]["PropName"])
    end


    TriggerEvent("vorp:Tip", string.format(Translation["OnUseItem"], label), 3000)
end)


function FPrompt(text, button, hold)
    Citizen.CreateThread(function()
        proppromptdisplayed=false
        PropPrompt=nil
        local str = text or "Drop"
        local buttonhash = button or 0x3B24C470
        local holdbutton = hold or false
        PropPrompt = PromptRegisterBegin()
        PromptSetControlAction(PropPrompt, buttonhash)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(PropPrompt, str)
        PromptSetEnabled(PropPrompt, false)
        PromptSetVisible(PropPrompt, false)
        PromptSetHoldMode(PropPrompt, holdbutton)
        PromptRegisterEnd(PropPrompt)
    end)
end

function LMPrompt(text, button, hold)
    Citizen.CreateThread(function()
        UsePrompt=nil
        local str = text or "Use"
        local buttonhash = button or 0x07B8BEAF
        local holdbutton = hold or false
        UsePrompt = PromptRegisterBegin()
        PromptSetControlAction(UsePrompt, buttonhash)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(UsePrompt, str)
        PromptSetEnabled(UsePrompt, false)
        PromptSetVisible(UsePrompt, false)
        PromptSetHoldMode(UsePrompt, holdbutton)
        PromptRegisterEnd(UsePrompt)
    end)
end

function EPrompt(text, button, hold)
    Citizen.CreateThread(function()
        ChangeStance=nil
        local str = text or "Use"
        local buttonhash = button or 0xD51B784F
        local holdbutton = hold or false
        ChangeStance = PromptRegisterBegin()
        PromptSetControlAction(ChangeStance, buttonhash)
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(ChangeStance, str)
        PromptSetEnabled(ChangeStance, false)
        PromptSetVisible(ChangeStance, false)
        PromptSetHoldMode(ChangeStance, holdbutton)
        PromptRegisterEnd(ChangeStance)
    end)
end

function PlayAnimEat(propName)
        if (propName == nil) then
            propName = "P_BREAD05X"
          end
        local dict = "mech_inventory@eating@multi_bite@sphere_d8-2_sandwich"
        local playerPed = PlayerPedId()
        local pos = GetEntityCoords(playerPed)
        local prop = GetHashKey(propName)
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Citizen.Wait(10)
        end
        RequestModel(prop)
        while not HasModelLoaded(prop) do
            Wait(10)
        end
        local tempObj2 = CreateObject(prop, pos.x, pos.y, pos.z, true, true, false)
        local boneIndex = GetEntityBoneIndexByName(playerPed, "SKEL_R_HAND")
        AttachEntityToEntity(tempObj2, playerPed, boneIndex, 0.1, -0.01, -0.07, -90.0, 100.0, 0.0, true, true, false, true, 1, true)
        TaskPlayAnim(PlayerPedId(), dict, "quick_right_hand", 1.0, 8.0, -1, 31, 0, false, false, false)
        Citizen.Wait(2000)
        ClearPedTasks(PlayerPedId())
        DeleteObject(tempObj2)
        SetModelAsNoLongerNeeded(prop)
end

function PlayAnimDrink(propName)
    if (propname == nil) then
        propname = "P_BOTTLE008X"
      end
    local dict = "amb_rest_drunk@world_human_drinking@male_a@idle_a"
    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)
    local prop = GetHashKey(propname)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(10)
    end
    RequestModel(prop)
    while not HasModelLoaded(prop) do
        Wait(10)
    end
    local tempObj2 = CreateObject(prop, pos.x, pos.y, pos.z, true, true, false)
    local boneIndex = GetEntityBoneIndexByName(playerPed, "SKEL_R_HAND")
    AttachEntityToEntity(tempObj2, playerPed, boneIndex, 0.05, -0.07, -0.05, -75.0, 60.0, 0.0, true, true, false, true,  1, true)
    TaskPlayAnim(PlayerPedId(), dict, "idle_a", 1.0, 8.0, -1, 31, 0, false, false, false)
    Citizen.Wait(4000)
    ClearPedTasks(PlayerPedId())
    DeleteObject(tempObj2)
    SetModelAsNoLongerNeeded(prop)
end

function Beer()
    local propEntity = CreateObject(GetHashKey('p_bottlebeer01a'), GetEntityCoords(PlayerPedId()), false, true, false, false, true)
    local amount = 0
    TaskItemInteraction_2(PlayerPedId(), GetHashKey("CONSUMABLE_SALOON_BEER"), propEntity,GetHashKey('p_bottleBeer01x_PH_R_HAND'), 1587785400, 1, 0, -1082130432)
    while true do
        Wait(500)
        if Citizen.InvokeNative(0x6AA3DCA2C6F5EB6D, PlayerPedId()) == 1183277175 then
            amount = amount + 1
            if amount >= 3 then
                DrankTime = GetGameTimer()
                IsDrank = true
                break
            end
        elseif Citizen.InvokeNative(0x6AA3DCA2C6F5EB6D, PlayerPedId()) == false then
            break
        else
            amount = 0
        end
    end
end

function EatBowl()
    local bowl = CreateObject("p_bowl04x_stew", GetEntityCoords(PlayerPedId()), true, true, false, false, true)
    local spoon = CreateObject("p_stewspoon01x", GetEntityCoords(PlayerPedId()), true, true, false, false, true)
    Citizen.InvokeNative(0x669655FFB29EF1A9, bowl, 0, "Stew_Fill", 1.0)
    Citizen.InvokeNative(0xCAAF2BCCFEF37F77, bowl, 20)
    Citizen.InvokeNative(0xCAAF2BCCFEF37F77, spoon, 82)
    TaskItemInteraction_2(PlayerPedId(), 599184882, bowl, GetHashKey("p_bowl04x_stew_ph_l_hand"), -583731576, 1, 0, -1.0)
    TaskItemInteraction_2(PlayerPedId(), 599184882, spoon, GetHashKey("p_stewspoon01x_ph_r_hand"), -583731576, 1, 0, -1.0)
    Citizen.InvokeNative(0xB35370D5353995CB, PlayerPedId(), -583731576, 1.0)
end

function Whisky()
    local propEntity = CreateObject(GetHashKey('p_bottlesnakeoil_cs01x'), GetEntityCoords(PlayerPedId()), false, true, false, false, true)
    local amount = 0
    TaskItemInteraction_2(PlayerPedId(), -1199896558, propEntity, GetHashKey('p_bottlesnakeoil_cs01x_ph_r_hand'), GetHashKey('DRINK_BOTTLE@Bottle_Cylinder_D1-3_H30-5_Neck_A13_B2-5_CHUG_TRANS'), 1, 0, -1.0)
    while true do
        Wait(500)
        if Citizen.InvokeNative(0x6AA3DCA2C6F5EB6D, PlayerPedId()) == 1204708816 then
            amount = amount + 1
            if amount >= 5 then
                DrunkTime = GetGameTimer()
                IsDrunk = true
                break
            end
        elseif Citizen.InvokeNative(0x6AA3DCA2C6F5EB6D, PlayerPedId()) == false then
            break
        else
            amount = 0
        end
    end
end

function Rum()
    local propEntity = CreateObject(GetHashKey('p_bottlemedicine20x'), GetEntityCoords(PlayerPedId()), false, true, false, false, true)
    local amount = 0
    TaskItemInteraction_2(PlayerPedId(), -1199896558, propEntity, GetHashKey('p_bottlemedicine20x_ph_r_hand'), GetHashKey('DRINK_BOTTLE@Bottle_Cylinder_D1-3_H30-5_Neck_A13_B2-5_CHUG_TRANS'), 1, 0, -1.0)
    while true do
        Wait(500)
        if Citizen.InvokeNative(0x6AA3DCA2C6F5EB6D, PlayerPedId()) == 1204708816 then
            amount = amount + 1
            if amount >= 3 then
                DrunkTime = GetGameTimer()
                IsDrunk = true
                break
            end
        elseif Citizen.InvokeNative(0x6AA3DCA2C6F5EB6D, PlayerPedId()) == false then
            break
        else
            amount = 0
        end
    end
end

function Cognac()
    local propEntity = CreateObject(GetHashKey('p_bottlecognac01x'), GetEntityCoords(PlayerPedId()), false, true, false, false, true)
    local amount = 0
    TaskItemInteraction_2(PlayerPedId(), -1199896558, propEntity, GetHashKey('p_bottlecognac01x_ph_r_hand'), GetHashKey('DRINK_BOTTLE@Bottle_Cylinder_D1-3_H30-5_Neck_A13_B2-5_CHUG_TRANS'), 1, 0, -1.0)
    while true do
        Wait(500)
        if Citizen.InvokeNative(0x6AA3DCA2C6F5EB6D, PlayerPedId()) == 1204708816 then
            amount = amount + 1
            if amount >= 3 then
                DrunkTime = GetGameTimer()
                IsDrunk = true
                break
            end
        elseif Citizen.InvokeNative(0x6AA3DCA2C6F5EB6D, PlayerPedId()) == false then
            break
        else
            amount = 0
        end
    end
end

function Moonshine()
    local propEntity = CreateObject(GetHashKey('s_inv_moonshine01x'), GetEntityCoords(PlayerPedId()), false, true, false, false, true)
    local amount = 0
    TaskItemInteraction_2(PlayerPedId(), -1199896558, propEntity, GetHashKey('p_bottleJD01x_ph_r_hand'), GetHashKey('DRINK_BOTTLE@Bottle_Cylinder_D1-3_H30-5_Neck_A13_B2-5_CHUG_TRANS'), 1, 0, -1.0)
    while true do
        Wait(500)
        if Citizen.InvokeNative(0x6AA3DCA2C6F5EB6D, PlayerPedId()) == 1204708816 then
            amount = amount + 1
            if amount >= 5 then
                DrunkTime = GetGameTimer()
                IsDrunk = true
                break
            end
        elseif Citizen.InvokeNative(0x6AA3DCA2C6F5EB6D, PlayerPedId()) == false then
            break
        else
            amount = 0
        end
    end
end

function Wine()
    local propEntity = CreateObject(GetHashKey('p_bottlewine01x'), GetEntityCoords(PlayerPedId()), false, true, false, false, true)
    local amount = 0
    TaskItemInteraction_2(PlayerPedId(), -1679900928, propEntity, GetHashKey('p_bottlewine01x_PH_R_HAND'), -68870885, 1,  0, -1082130432)
    while true do
        Wait(500)
        if Citizen.InvokeNative(0x6AA3DCA2C6F5EB6D, PlayerPedId()) == 1204708816 then
            amount = amount + 1
            if amount >= 3 then
                IsDrunk = true
                break
            end
        elseif Citizen.InvokeNative(0x6AA3DCA2C6F5EB6D, PlayerPedId()) == false then
            break
        else
            amount = 0
        end
    end
end

function Coffe()
    local object = CreateObject(GetHashKey("P_MUGCOFFEE01X"), GetEntityCoords(PlayerPedId()), true, false, false, false, true)
    Citizen.InvokeNative(0x669655FFB29EF1A9, object, 0, "CTRL_cupFill", 1.0)
    TaskItemInteraction_2(PlayerPedId(), GetHashKey("CONSUMABLE_COFFEE"), object, GetHashKey("P_MUGCOFFEE01X_PH_R_HAND"), GetHashKey("DRINK_COFFEE_HOLD"), 1, 0, -1082130432)
end

function Shampan()
    local propEntity = CreateObject(GetHashKey('P_GLASS001X'), GetEntityCoords(PlayerPedId()), false, true, false, false, true)
    local amount = 0
    TaskItemInteraction_2(PlayerPedId(), GetHashKey("CONSUMABLE_WHISKEY"), propEntity, GetHashKey('P_GLASS001X_PH_R_HAND'), GetHashKey("DRINK_CHAMPAGNE_HOLD"), 1, 0, -1082130432)
    while true do
        Wait(500)
        if Citizen.InvokeNative(0x6AA3DCA2C6F5EB6D, PlayerPedId()) == 642357238 then
            amount = amount + 1
            if amount >= 7 then
                DrunkTime = GetGameTimer()
                IsDrunk = true
                break
            end
        elseif Citizen.InvokeNative(0x6AA3DCA2C6F5EB6D, PlayerPedId()) == false then
            break
        else
            amount = 0
        end
    end
end

function Anim(actor, dict, body, duration, flags, introtiming, exittiming)
    Citizen.CreateThread(function()
        RequestAnimDict(dict)
        local dur = duration or -1
        local flag = flags or 1
        local intro = tonumber(introtiming) or 1.0
        local exit = tonumber(exittiming) or 1.0
        timeout = 5
        while (not HasAnimDictLoaded(dict) and timeout>0) do
            timeout = timeout-1
            if timeout == 0 then 
                --print("Animation Failed to Load")
            end
            Citizen.Wait(300)
        end
        TaskPlayAnim(actor, dict, body, intro, exit, dur, flag --[[1 for repeat--]], 1, false, false, false, 0, true)
    end)
end

function StopAnim(dict, body)
    Citizen.CreateThread(function()
        StopAnimTask(PlayerPedId(), dict, body, 1.0)
    end)
end