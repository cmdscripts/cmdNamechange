local ESX = exports.es_extended:getSharedObject()
local nameRules = Config.NameRules

RegisterNetEvent('cmdNamechange:submit', function(firstName, lastName)
  local src = source
  local xPlayer = ESX.GetPlayerFromId(src)
  if not xPlayer then
    return
  end

  if type(firstName) ~= 'string' or type(lastName) ~= 'string' then
    return
  end

  firstName = firstName:match('^%s*(.-)%s*$')
  lastName  = lastName:match('^%s*(.-)%s*$')

  if #firstName < nameRules.min or #firstName > nameRules.max or not firstName:match(nameRules.allow) then
    return TriggerClientEvent('cmdNamechange:result', src, false, Config.Locale.fnameErr)
  end

  if #lastName < nameRules.min or #lastName > nameRules.max or not lastName:match(nameRules.allow) then
    return TriggerClientEvent('cmdNamechange:result', src, false, Config.Locale.lnameErr)
  end

  local query = ('UPDATE %s SET %s = ?, %s = ? WHERE %s = ?'):format(
    Config.ESX.usersTable,
    Config.ESX.firstnameColumn,
    Config.ESX.lastnameColumn,
    Config.ESX.identifierColumn
  )

  local ok = pcall(MySQL.update.await, query, {
    firstName,
    lastName,
    xPlayer.identifier
  })

  if not ok then
    return TriggerClientEvent('cmdNamechange:result', src, false, Config.Locale.dbErr)
  end

  local fullName = ('%s %s'):format(firstName, lastName)

  if xPlayer.setName then
    xPlayer.setName(fullName)
  end

  if xPlayer.set then
    xPlayer.set('firstName', firstName)
    xPlayer.set('lastName', lastName)
  end

  TriggerClientEvent('cmdNamechange:result', src, true, Config.Locale.ok:format(firstName, lastName))
end)