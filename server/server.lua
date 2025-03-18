ESX = exports['es_extended']:getSharedObject()
local cachedUserData = {}

RegisterNetEvent('xscripts:charinfo:requestData')
AddEventHandler('xscripts:charinfo:requestData', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if not xPlayer then return end

    if cachedUserData[xPlayer.identifier] then
        local cachedData = cachedUserData[xPlayer.identifier]
        cachedData.serverId = src
        cachedData.cash = xPlayer.getMoney()
        cachedData.bank = xPlayer.getAccount('bank') and xPlayer.getAccount('bank').money or 0
        cachedData.job = xPlayer.job and xPlayer.job.label or 'Unemployed'
        cachedData.grade = xPlayer.job and xPlayer.job.grade_label or ''

        TriggerClientEvent('xscripts:charinfo:receiveData', src, cachedData)
    else
        MySQL.query('SELECT firstname, lastname FROM users WHERE identifier = ?', {xPlayer.identifier}, function(result)
            if not result or #result == 0 then
                return
            end

            local userData = {
                serverId = src,
                firstname = result[1].firstname or 'Unknown',
                lastname = result[1].lastname or 'Unknown',
                cash = xPlayer.getMoney(),
                bank = xPlayer.getAccount('bank') and xPlayer.getAccount('bank').money or 0,
                job = xPlayer.job and xPlayer.job.label or 'Unemployed',
                grade = xPlayer.job and xPlayer.job.grade_label or ''
            }

            cachedUserData[xPlayer.identifier] = userData
            TriggerClientEvent('xscripts:charinfo:receiveData', src, userData)
        end)
    end
end)