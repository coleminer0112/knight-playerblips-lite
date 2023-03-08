SV_BLIP_USERS = {}
SV_BLIP_DATA = {}

if not Config then
  Citizen.CreateThread(function()
    for i = 1, 10 do
      print("[ERROR] Couldn't load config! Ensure your configuration file is setup properly!")
      Wait(10000)
    end
  end)
end


RegisterCommand(Config.command, function(source,args,raw)
  if IsPlayerAceAllowed(source, Config.ace) then
    if SV_BLIP_USERS[source] then
      TriggerClientEvent("knight-playerblips-lite:toggle", source, false)
      print(source.." disabled playerblips.")
      SV_BLIP_USERS[source] = nil
    else
      TriggerClientEvent("knight-playerblips-lite:toggle", source, true)
      print(source.." enabled playerblips.")
      SV_BLIP_USERS[source] = true
    end
  else
    TriggerClientEvent("knight-playerblips-lite:noperms", source)
    print(source.." tried to use playerblips command without permission.")
  end
end, false)


function Transmit()
  for id,_ in pairs(SV_BLIP_USERS) do
    TriggerClientEvent("knight-playerblips-lite:transmit", id, SV_BLIP_DATA)
  end
end


Citizen.CreateThread(function()
  while true do
    Wait(250)
    SV_BLIP_DATA = {}
    Wait(0)
    for _,id in pairs(GetPlayers()) do
      if tonumber(id) < 65535 then
        local _ped = GetPlayerPed(id)
        local _xyz = GetEntityCoords(_ped)
        local _hdg = math.floor(GetEntityHeading(_ped))
        local _nam = GetPlayerName(id)
        SV_BLIP_DATA[id] = {_xyz.x,_xyz.y,_xyz.z,1,0,_hdg,_nam}
      end
    end
    Wait(0)
    Transmit()
  end
end)