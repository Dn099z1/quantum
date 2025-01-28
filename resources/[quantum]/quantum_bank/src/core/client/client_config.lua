local Tunnel = module("quantum","lib/Tunnel")
local Proxy = module("quantum","lib/Proxy")
quantum = Proxy.getInterface("quantum")
func = Tunnel.getInterface("ld_bank")

vCLIENT = {}
Tunnel.bindInterface("ld_bank",vCLIENT)
-------------------------------------------------------------------------------------------------------------------------
-- CONFIGURAÇÃO LADO CLIENT
-------------------------------------------------------------------------------------------------------------------------
quantum_bank = {}
quantum_bank['config'] = {
    ['banks'] = { -- Localização dos BANCOS
        [1]     = vector3(149.88, -1040.34, 29.37),
        [2]     = vector3(-350.83, -49.6, 49.04),
        [3]     = vector3(314.36, -278.46, 54.17),
        [4]     = vector3(-1212.98, -330.26, 37.79),
        [5]     = vector3(-2963.45, 482.81, 15.7),
        [6]     = vector3(1175.15, 2706.07, 38.09),
        [7]     = vector3(1653.78, 4850.56, 41.99),
        [8]     = vector3(-1074.67, -2559.01, 13.97),
        [9]     = vector3(-112.22, 6468.92, 31.63),
        [10]    = vector3(242.1, 224.44, 106.29),
    },

    ['blip'] = { -- Blips no mapa (MENU DO GTA)
        enabled     = true,
        blipName    = "Banco",
        blipType    = 108,
        blipColor   = 2,
        blipScale   = 0.8
    },
    
    ['atmModels'] = { -- PROPS QUE SERÃO RECONHECIDOS COMO ATM (CAIXINHA) (só mexa se souber o que está fazendo)
        "prop_atm_01",
        "prop_atm_02",
        "prop_atm_03",
        "prop_fleeca_atm"
    },
	
    ['popupText']     = false, -- Ativar texto via hud ao em vez de markers nos BANCOS (Levemente mais otimizado) 
    ['atmPopupText']  = false, -- Ativar texto via hud ao em vez de markers nas ATMS (Levemente mais otimizado)
	['blip_RGB'] = { 252, 186, 3 }, -- COR DO BLIP DO CHÃO NO BANCO
	
}


-------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES LADO CLIENT (SÓ MEXA SE SOUBER O QUE ESTÁ FAZENDO)
-------------------------------------------------------------------------------------------------------------------------
local createdBlips = {}
isPopup = false
isATMPopup = false
atmCoords = nil

quantum_bank['functions'] = {
	
	startPlayerThread = function()
		CreateThread(function()
			while true do
				local ped = PlayerPedId()
				local pos = GetEntityCoords(ped)
				local closestBank, closestDst, banco = quantum_bank['functions'].GetClosestBank(pos)
				local waitTime = 700

				if closestDst < 4.0 then
					waitTime = 3
					if IsControlJustPressed(0, 38) then
						quantum_bank['functions'].OpenNui()
					end

					if quantum_bank['config']['popupText'] and not isPopup then
						quantum_bank['functions'].PopupText(true, 'bank', 'E')
					else
						if not quantum_bank['config']['popupText'] then
							quantum_bank['functions'].DrawText3D(banco.x, banco.y, banco.z, Locales['BlipText']['bank'])
							DrawMarker(23, banco.x, banco.y, banco.z-0.99, 0, 0, 0, 0, 0, 0, 0.7, 0.7, 0.5,  quantum_bank['config']['blip_RGB'][1],quantum_bank['config']['blip_RGB'][2],quantum_bank['config']['blip_RGB'][3], 180, 0, 0, 0, 0)
						end
					end
				end

				Citizen.Wait(waitTime)
			end
		end)
		
		CreateThread(function()
			while true do
				local ped = PlayerPedId()
				local pos = GetEntityCoords(ped)
				local waitTime = 1000
				if atmCoords ~= nil then
					waitTime = 1
					if IsControlJustPressed(0, 38) then
						TaskStartScenarioInPlace(ped, "PROP_HUMAN_ATM", 0, true)
						Wait(3000)
						ExecuteCommand('atm')
						ClearPedTasksImmediately(ped)
					end

					if quantum_bank['config']['atmPopupText'] and not isPopup then
						quantum_bank['functions'].PopupText(true, 'atm', 'E')
					else
						if not quantum_bank['config']['atmPopupText'] then
							quantum_bank['functions'].DrawText3D(atmCoords["x"], atmCoords["y"], atmCoords["z"]+1.1, Locales['BlipText']['atm'])
						end
					end
				end

				Citizen.Wait(waitTime)
			end
		end)
		
		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(250)
				local ply = GetPlayerPed(-1)
				local plyCoords = GetEntityCoords(ply)
				for k, v in pairs(quantum_bank['config']['atmModels']) do
					local atmobj = GetClosestObjectOfType(plyCoords["x"],plyCoords["y"],plyCoords["z"],1.5,GetHashKey(v),false,true,true)
					if DoesEntityExist(atmobj) then
						if atmCoords ~= GetEntityCoords(atmobj) then
							atmCoords = GetEntityCoords(atmobj)
						end
					end
				end
			end 
		end)

		Citizen.CreateThread(function()
			while true do
				local timings = 2000
				local ply = GetPlayerPed(-1)
				local plyCoords = GetEntityCoords(ply)
				if atmCoords ~= nil then
					timings = 1
					local distance = GetDistanceBetweenCoords(plyCoords["x"], plyCoords["y"], plyCoords["z"], atmCoords["x"], atmCoords["y"], atmCoords["z"])
					if distance > 4.0 then
						atmCoords = nil
					end
				end
				Citizen.Wait(timings)
			end
		end)
	end,
	
    CreateBlips = function()
        for k, v in pairs(quantum_bank['config']['banks']) do
            local newBlip = AddBlipForCoord(tonumber(v.x), tonumber(v.y), tonumber(v.z))
            SetBlipSprite(newBlip, quantum_bank['config']['blip']['blipType'])
            SetBlipDisplay(newBlip, 4)
            SetBlipScale(newBlip, quantum_bank['config']['blip']['blipScale'])
            SetBlipColour(newBlip, quantum_bank['config']['blip']['blipColor'])
            SetBlipAsShortRange(newBlip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(quantum_bank['config']['blip']['blipName'])
            EndTextCommandSetBlipName(newBlip)
            table.insert(createdBlips, newBlip)
        end
        return true
    end,

    DeleteBlips = function()
        for k, v in pairs(createdBlips) do
            RemoveBlip(v)
        end
        createdBlips = {}
        return true
    end,

    GetClosestBank = function(pos)
        local closestBank, closestDst = 0, 999999.9
		local banco = nil
        for k, v in pairs(quantum_bank['config']['banks']) do
            local dst = #(pos - v)
            if dst < closestDst then
                closestDst, closestBank = dst, k
				banco = v
            end
        end
        return closestBank, closestDst, banco
    end,

    OpenNui = function(message)
        local playerData = func.getPlayerData()
		while not playerData do Wait(0) end
		SetNuiFocus(true, true)
		SendNUIMessage({
			type = 'create',
			data = playerData,
			message = message,
		})
    end,

	DrawText3D = function (x,y,z, text)
		local onScreen,_x,_y=World3dToScreen2d(x,y,z)
		local px,py,pz=table.unpack(GetGameplayCamCoords())

		SetTextScale(0.28, 0.28)
		SetTextFont(4)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, 215)
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
		local factor = (string.len(text)) / 370
		DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 41, 11, 41, 68)
	end,

    PopupText = function(enable, type, key)
        if type == 'bank' then
            isPopup = enable
            SendNUIMessage({
                type = 'popup',
                popupTrigger = enable,
                popupType = type,
                popupKey = key
            })
        elseif type == 'atm' then
            isATMPopup = enable
            SendNUIMessage({
                type = 'popup',
                popupTrigger = enable,
                popupType = type,
                popupKey = key
            })
        end
    end,

    Notify = function(txt, typ)
        TriggerEvent("Notify",typ, txt)
    end
}