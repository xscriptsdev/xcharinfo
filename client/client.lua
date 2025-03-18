local isUIVisible = false
local ESX = nil

CreateThread(function()
    while ESX == nil do
   ESX = exports['es_extended']:getSharedObject()
        Wait(100)
    end
    SendNUIMessage({ action = 'hideUI' })
end)

RegisterNUICallback('hideUI', function(_, cb)
    SetNuiFocus(false, false)
    isUIVisible = false
    cb({})
end)


function ToggleCharUI()
    isUIVisible = not isUIVisible
    SetNuiFocus(isUIVisible, isUIVisible)
    
    if isUIVisible then
        TriggerServerEvent('xscripts:charinfo:requestData')
    end
    
    SendNUIMessage({
        action = isUIVisible and 'showUI' or 'hideUI',
    })
end
RegisterNetEvent('xscripts:charinfo:receiveData')
AddEventHandler('xscripts:charinfo:receiveData', function(data)
    UpdateCharacterData(data)
end)

RegisterNetEvent('esx:setAccountMoney', function(account)
    if account.name == 'bank' or account.name == 'money' then
        if isUIVisible then
            TriggerServerEvent('xscripts:charinfo:requestData')
        end
    end
end)

RegisterNetEvent('esx:setJob', function(job)
    if isUIVisible then
        TriggerServerEvent('xscripts:charinfo:requestData')
    end
end)

RegisterNetEvent('esx:addInventoryItem', function(item, count)
    if item == 'money' and isUIVisible then
        TriggerServerEvent('xscripts:charinfo:requestData')
    end
end)

RegisterNetEvent('esx:removeInventoryItem', function(item, count)
    if item == 'money' and isUIVisible then
        TriggerServerEvent('xscripts:charinfo:requestData')
    end
end)

CreateThread(function()
    while true do
        Wait(5000) 
        if isUIVisible then
            TriggerServerEvent('xscripts:charinfo:requestData')
        end
    end
end)
function UpdateCharacterData(data)
    local cash = data.cash and '$' .. ESX.Math.GroupDigits(data.cash) or '$0'
    local bank = data.bank and '$' .. ESX.Math.GroupDigits(data.bank) or '$0'
    local job = data.job or 'Unemployed'
    local grade = data.grade or ''

    SendNUIMessage({
        action = 'updateData',
        data = {
            name = (data.firstname or 'Unknown') .. ' ' .. (data.lastname or 'Unknown'),
            id = data.serverId or 'N/A',
            cash = cash,
            bank = bank,
            job = job .. (grade ~= '' and ' - ' .. grade or '')
        }
    })
end

RegisterKeyMapping(Config.Command, 'Character Info', 'keyboard', Config.Keybind)
RegisterCommand(Config.Command, function()
    if Config.EnableCommand then
        ToggleCharUI()
    end
end)

RegisterNetEvent('xscripts:charinfo:toggle')
AddEventHandler('xscripts:charinfo:toggle', function()
    ToggleCharUI()
end)