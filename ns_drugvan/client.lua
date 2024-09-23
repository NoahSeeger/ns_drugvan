ESX = exports["es_extended"]:getSharedObject()

local journeyModelHash = GetHashKey(Config.Van)
local modelFilter = {[journeyModelHash] = true}
local point = nil
local stillAtVan = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local closestDrugVan = ESX.Game.GetClosestVehicle(playerCoords, modelFilter)

        if closestDrugVan ~= 0 then
            local vanCoords = GetEntityCoords(closestDrugVan)
            local dist = #(vanCoords - playerCoords)

            if dist < 6 then
                if not GetIsVehicleEngineRunning(closestDrugVan) then
                    local doorOffset = GetOffsetFromEntityInWorldCoords(closestDrugVan, -1.5, 0.0, 0.0)

                    if point then
                        point:remove()
                    end

                    point = lib.points.new({
                        coords = doorOffset,
                        distance = 4,
                        onEnter = function(self)
                            -- print('entered range of point', self.id)
                            stillAtVan = true
                        end,
                        onExit = function(self)
                            -- print('left range of point', self.id)
                            stillAtVan = false
                        end,
                        nearby = function(self)
                          DisplayHelpText("Drücke ~INPUT_CONTEXT~ um mit dem Kochen zu beginnen")
                            stillAtVan = true
                            Marker = DrawMarker(27, self.coords.x, self.coords.y, self.coords.z-0.3, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 200, 20, 20, 50, false, true, 2, false, nil, nil, false)
                            if self.currentDistance < 1 and IsControlJustReleased(0, 38) then
                                SetNuiFocus(true, true)
                                SendNUIMessage({ action = 'openMenu' })
                            end
                        end
                    })
                    -- if point.currentDistance > point.distance then
                    --   print("forcefully not at Van")
                    --   stillAtVan = false
                    -- end
                  else
                    lib.hideTextUI()
                    if lib.points.getClosestPoint() then
                      lib.points.getClosestPoint():remove()
                    end
                end
            end
        end
    end
end)

function DisplayHelpText(text)
  SetTextComponentFormat("STRING")
  AddTextComponentString(text)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

RegisterNUICallback('startCooking', function(data, cb)
  local cookType = nil
    if data.auto then
      cookType = "Automatisches"
    else
      cookType = "Manuelles"
    end
      lib.notify({
        title = "Meth Kochen",
        icon = "syringe",
        position = "bottom-right",
        description = cookType.." Kochen begonnen",
        type = "success"
      })
      TriggerServerEvent("ns_drugvan:startCooking", data.auto)
    cb('ok')
end)

RegisterNUICallback('closeMenu', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

lib.callback.register("ns_drugvan:stillAtVan", function()
  return stillAtVan
end)

lib.callback.register("ns_drugvan:skillCheck", function(difficulty, inputs)
  local success = lib.skillCheck(difficulty, inputs)
  return success
end)