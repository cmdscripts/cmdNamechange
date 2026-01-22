local uiOpen = false

local function setUi(isOpen)
  uiOpen = isOpen

  SetNuiFocus(isOpen, isOpen)

  SendNUIMessage({
    action = isOpen and 'open' or 'close',
    title = Config.Locale.title,
    rule = Config.Locale.rule
  })
end

local function openUi()
  if uiOpen then
    return
  end
  setUi(true)
end

local function closeUi()
  if not uiOpen then
    return
  end
  setUi(false)
end

RegisterNUICallback('close', function(_, cb)
  closeUi()
  cb(true)
end)

RegisterNUICallback('submit', function(data, cb)
  TriggerServerEvent('cmdNamechange:submit', data.firstName, data.lastName)
  cb({ ok = true })
end)

RegisterNetEvent('cmdNamechange:result', function(success, msg)
  if success then
    SendNUIMessage({ action = 'success', msg = msg })
    SetTimeout(1200, function()
      closeUi()
    end)
    return
  end

  SendNUIMessage({ action = 'error', msg = msg })
end)

CreateThread(function()
  if Config.UseTarget then
    for i = 1, #Config.Points do
      local point = Config.Points[i]

      exports.ox_target:addBoxZone({
        name = ('namechange:zone:%d'):format(i),
        coords = point.coords,
        size = point.zoneSize,
        rotation = point.heading,
        debug = false,
        options = {
          {
            label = Config.Locale.targetLabel,
            icon = 'fa-solid fa-pen',
            onSelect = openUi
          }
        }
      })
    end
    return
  end

  for i = 1, #Config.Points do
    local point = Config.Points[i]

    lib.points.new({
      coords = point.coords,
      distance = Config.Marker.drawDist,
      nearby = function()
        if uiOpen then
          return
        end

        local ped = PlayerPedId()
        local dist = #(GetEntityCoords(ped) - point.coords)

        if dist > Config.Marker.drawDist then
          lib.hideTextUI()
          return
        end

        if Config.Marker.enabled then
          local c = Config.Marker.rgba
          DrawMarker(
            Config.Marker.type,
            point.coords.x, point.coords.y, point.coords.z + Config.Marker.zOffset,
            0.0, 0.0, 0.0,
            0.0, 0.0, 0.0,
            Config.Marker.scale.x, Config.Marker.scale.y, Config.Marker.scale.z,
            c[1], c[2], c[3], c[4],
            false, true, 2, nil, nil, false
          )
        end

        if dist <= Config.Marker.interactDist then
          lib.showTextUI(Config.Locale.help, { position = 'left-center' })

          if IsControlJustReleased(0, Config.Key) then
            lib.hideTextUI()
            openUi()
          end
          return
        end

        lib.hideTextUI()
      end
    })
  end
end)