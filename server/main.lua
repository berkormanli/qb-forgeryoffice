local QBCore = exports['qb-core']:GetCoreObject()
RegisterNetEvent('QBCore:Server:UpdateObject')
AddEventHandler('QBCore:Server:UpdateObject', function()
	QBCore = exports['qb-core']:GetCoreObject()
end)

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    local resource_name = GetCurrentResourceName()
    local current_version = GetResourceMetadata(resource_name, 'version', 0)
    PerformHttpRequest('https://raw.githubusercontent.com/berkormanli/ZeixnaScriptingVersions/main/qb-forgeryoffice.txt',function(error, result, headers)
        if not result then return end
        local new_version = result:sub(1, -2)
        if new_version ~= current_version then
            print('^2[qb-forgeryoffice] - New Update Available.^0\nCurrent Version: ^5'..current_version..'^0\nNew Version: ^5'..new_version..'^0')
        end
    end,'GET')
end)

Citizen.CreateThread(function()
    local itemList = {
        ["blank_card"] = {["name"] = "blank_card", ["label"] = "Blank Card", ["weight"] = 100, ["type"] = "item", ["image"] = "blank_card.png", ["unique"] = false, ["useable"] = false, ["shouldClose"] = false, ["combinable"] = nil, ["description"] = "This blank card can be turned into anything under a professional hands"},
        ["blank_usb"] = {["name"] = "blank_usb", ["label"] = "Blank USB", ["weight"] = 100, ["type"] = "item", ["image"] = "usb_device.png", ["unique"] = false, ["useable"] = false, ["shouldClose"] = false, ["combinable"] = nil, ["description"] = "This blank USB stick can be turned into anything under a professional hands"},
        ["usb"] = {["name"] = "usb", ["label"] = "USB", ["weight"] = 100, ["type"] = "item", ["image"] = "usb_device.png", ["unique"] = true, ["useable"] = false, ["shouldClose"] = false, ["combinable"] = nil, ["description"] = "This USB stick contains some information"},
        ["corrupted_card"] = {["name"] = "corrupted_card", ["label"] = "?????", ["weight"] = 100, ["type"] = "item", ["image"] = "blank_card.png", ["unique"] = true, ["useable"] = false, ["shouldClose"] = false, ["combinable"] = nil, ["description"] = "?????"},
    }
    bool, msg = exports['qb-core']:AddItems(itemList)

    --print(bool, msg)
end)

-- Functions

RegisterServerEvent('qb-forgeryoffice:server:createForgeryUSB')
AddEventHandler('qb-forgeryoffice:server:createForgeryUSB', function(data)
    local src = source
    local computerItems = exports['qb-inventory']:GetStashItems("forgeryoffice_computer")
    if computerItems and computerItems[1] then
        local itemName = computerItems[1].name
        if itemName == "usb" then
            TriggerClientEvent("QBCore:Notify", src, Lang:t("info.usb_overwritten"))
            local info = data
            computerItems[1].info = data
            TriggerEvent('qb-inventory:server:SaveStashItems', "forgeryoffice_computer", computerItems)
        elseif itemName == "blank_usb" then
            local info = data
            computerItems[1].info = data
            computerItems[1].label = "USB"
            computerItems[1].name = "usb"
            computerItems[1].description = "This USB stick contains some information"
            TriggerEvent('qb-inventory:server:SaveStashItems', "forgeryoffice_computer", computerItems)
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.wrong_inserted_pc"))
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.nothing_inserted_pc"))
    end
end)

RegisterServerEvent('qb-forgeryoffice:server:target:printerUse')
AddEventHandler('qb-forgeryoffice:server:target:printerUse', function()
    local src = source
    local printerUSBItems = exports['qb-inventory']:GetStashItems("forgeryoffice_printerUSB")

    if printerUSBItems and printerUSBItems[1] then
        local usb = printerUSBItems[1]

        if usb.name == "usb" then
            if usb.info.documentType ~= "id_card" and usb.info.documentType ~= "driver_license" and usb.info.documentType ~= "weaponlicense" and usb.info.documentType ~= "lawyerpass" then
                --------- Give Corrupted Card
                print("?")
            else
                local printerBlankCardContainerItems = exports['qb-inventory']:GetStashItems("forgeryoffice_printerIn")

                if printerBlankCardContainerItems and printerBlankCardContainerItems[1] then
                    local blankCards = printerBlankCardContainerItems[1]

                    if blankCards.name == "blank_card" then
                        printerBlankCardContainerItems[1].amount = printerBlankCardContainerItems[1].amount - 1
                        if printerBlankCardContainerItems[1].amount == 0 then printerBlankCardContainerItems = {} end
                        TriggerEvent('qb-inventory:server:SaveStashItems', "forgeryoffice_printerIn", printerBlankCardContainerItems)

                        local documentType = usb.info.documentType
                        usb.info.documentType = nil

                        local printerPrintedCardsContainerItems = exports['qb-inventory']:GetStashItems("forgeryoffice_printerOut")

                        local tempItem = {
                            name = documentType,
                            label = QBCore.Shared.Items[documentType].label,
                            useable = QBCore.Shared.Items[documentType].useable,
                            image = QBCore.Shared.Items[documentType].image,
                            type = QBCore.Shared.Items[documentType].type,
                            unique = QBCore.Shared.Items[documentType].unique,
                            weight = QBCore.Shared.Items[documentType].weight,
                            slot = #printerPrintedCardsContainerItems + 1,
                            amount = 1,
                            info = usb.info
                        }
                        printerPrintedCardsContainerItems[#printerPrintedCardsContainerItems + 1] = tempItem

                        TriggerEvent('qb-inventory:server:SaveStashItems', "forgeryoffice_printerOut", printerPrintedCardsContainerItems)

                    else
                        TriggerClientEvent("QBCore:Notify", src, Lang:t("error.other_than_blank_cards"), "error")
                    end
                else
                    TriggerClientEvent("QBCore:Notify", src, Lang:t("error.none_blank_card_left"), "error")
                end
            end
        elseif usb.name == "blank_usb" then
            TriggerClientEvent("QBCore:Notify", src, Lang:t("error.empty_usb"), "error")
        else
            TriggerClientEvent('QBCore:Notify', src, Lang:t("error.wrong_inserted_printer"), "error")
        end
    else
        TriggerClientEvent('QBCore:Notify', src, Lang:t("error.nothing_inserted_printer"), "error")
    end
end)