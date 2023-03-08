CL_BLIPS_ENABLED = false;
CL_BLIP_SYNC_DATA = {};
CL_BLIP_CACHE = {};


RegisterNetEvent("knight-staffblips-lite:transmit", function(data)
  CL_BLIP_SYNC_DATA = data;
  CL_UPDATE_ALL();
end)


local function CL_NOTIFY(text)
  BeginTextCommandThefeedPost("STRING");
  AddTextComponentSubstringPlayerName(text);
  EndTextCommandThefeedPostTicker(true, true);
end

RegisterNetEvent("knight-staffblips-lite:noperms", function()
  CL_NOTIFY("~r~Not allowed.")
end)

RegisterNetEvent("knight-staffblips-lite:toggle", function(state)
  CL_BLIPS_ENABLED = state;
  if state then
    CL_NOTIFY("~g~Enabled ~w~player blips.");
  else
    CL_NOTIFY("~r~Disabled ~w~player blips.");
  end
end)


function CL_UPDATE_ALL()
  if CL_BLIPS_ENABLED then
    local _updated, _removed = 0, 0;
    for id,data in pairs(CL_BLIP_SYNC_DATA) do
      CL_UPDATE_BLIP(id,table.unpack(data))
      _updated = _updated + 1;
    end
    for id2,_ in pairs(CL_BLIP_CACHE) do
      if not CL_BLIP_SYNC_DATA[id2] then
        CL_REMOVE_BLIP(id2);
        _removed = _removed + 1;
      end
    end
  end
end


function CL_REMOVE_BLIP(id)
  RemoveBlip(CL_BLIP_CACHE[id]);
  CL_BLIP_CACHE[id] = nil;
end


function CL_UPDATE_BLIP(id,_x,_y,_z,_sprite,_color,_heading,_name)
  if CL_BLIP_CACHE[id] then
      SetBlipCoords(CL_BLIP_CACHE[id], _x, _y, _z);
      SetBlipRotation(CL_BLIP_CACHE[id], _heading);
  else
    CL_NEW_BLIP(id,_x,_y,_z,_sprite,_color,_heading,_name)
  end
end


function CL_NEW_BLIP(id,_x,_y,_z,_sprite,_color,_heading,_name)
  Citizen.CreateThread(function()
    CL_BLIP_CACHE[id] = AddBlipForCoord(_x, _y, _z);
    SetBlipSprite(CL_BLIP_CACHE[id], _sprite);
    SetBlipCategory(CL_BLIP_CACHE[id], 7);
    SetBlipDisplay(CL_BLIP_CACHE[id], 4);
    SetBlipScale(CL_BLIP_CACHE[id], 0.9);
    SetBlipColour(CL_BLIP_CACHE[id], _color);
    SetBlipAsShortRange(CL_BLIP_CACHE[id], true);
    ShowHeadingIndicatorOnBlip(CL_BLIP_CACHE[id], true);
    SetBlipRotation(CL_BLIP_CACHE[id], _heading);
    BeginTextCommandSetBlipName("STRING");
    AddTextComponentString(_name);
    EndTextCommandSetBlipName(CL_BLIP_CACHE[id]);
  end)
end