-- Settings

local serverstockvaluesdeficits = {
  [1] = { ["value"] = 0.00 },
  [2] = { ["value"] = 0.00 },
  [3] = { ["value"] = 0.00 },
  [4] = { ["value"] = 0.00 },
  [5] = { ["value"] = 0.00 },
  [6] = { ["value"] = 0.00 },
}

local guiEnabled = false
local hasOpened = false

local endloop = false
-- Open Gui and Focus NUI
function openGui()
  SetPlayerControl(PlayerId(), 0, 0)
  guiEnabled = true
  SetNuiFocus(true)
  SendNUIMessage({openWarrants = true})

  -- If this is the first time we've opened the phone, load all warrants
  if hasOpened == false then
    lstContacts = {}
    hasOpened = true
  end
end

-- Close Gui and disable NUI
function closeGui()
  endloop = true
  SetNuiFocus(false)
  SendNUIMessage({openSection = "close"})
  guiEnabled = false
  SetPlayerControl(PlayerId(), 1, 0)
end

-- NUI Callback Methods
RegisterNUICallback('close', function(data, cb)
  closeGui()
  cb('ok')
end)

RegisterNetEvent('news:close')
AddEventHandler('news:close', function()
  closeGui()
end)


RegisterNetEvent('news:stocks')
AddEventHandler('news:stocks', function()
  closeGui()
end)

RegisterCommand('haberler', function()
  TriggerEvent('NewsStandCheckFinish')
end)

RegisterNetEvent('NewsStandCheckFinish')
AddEventHandler('NewsStandCheckFinish', function(newsArray1,newsArray2)
  openGui()
  guiEnabled = true
  SendNUIMessage({openSection = "newsUpdate", string = newsArray1, string2 = newsArray2})

  TriggerEvent("attachItem","newspaper01")
  endloop = false
  local plycoords = GetEntityCoords(PlayerPedId())
  while not endloop do

    local adist = math.ceil(#(plycoords - GetEntityCoords(PlayerPedId())))

    if not IsEntityPlayingAnim(PlayerPedId(), "amb@world_human_tourist_map@female@base", "base", 3) then
        RequestAnimDict('amb@world_human_tourist_map@female@base')
      while not HasAnimDictLoaded("amb@world_human_tourist_map@female@base") do
        Citizen.Wait(0)
      end
      TaskPlayAnim(PlayerPedId(), "amb@world_human_tourist_map@female@base", "base", 8.0, -8, -1, 49, 0, 0, 0, 0)
    end
    if adist > 2 then
      endloop = true
    end
    Citizen.Wait(1)
  end
  TriggerEvent("destroyProp")
  TriggerEvent("news:close")
  ClearPedTasksImmediately(PlayerPedId())

end)