local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local InsideForgeryOffice = false


-- zone check
local isInsideEntranceTarget = false
local isInsideExitTarget = false
local isInsideComputerTarget = false
local isInsidePrinterTarget = false

------- IPL THREAD -------

Citizen.CreateThread(function()
    -- Getting the object to interact with
    BikerDocumentForgery = exports['bob74_ipl']:GetBikerDocumentForgeryObject()


    -- Loading Ipls
    BikerDocumentForgery.Ipl.Interior.Load()

    -- Setting the style
    BikerDocumentForgery.Style.Clear( true)
    BikerDocumentForgery.Style.Set(BikerDocumentForgery.Style.upgrade, true)
    
    -- Setting the equipments
    BikerDocumentForgery.Equipment.Clear(true)
    BikerDocumentForgery.Equipment.Set(BikerDocumentForgery.Equipment.upgrade, true)

    -- Setting the security
    BikerDocumentForgery.Security.Clear(true)
    BikerDocumentForgery.Security.Set(BikerDocumentForgery.Security.basic, true)


    -- Enabling details
    BikerDocumentForgery.Details.Enable(BikerDocumentForgery.Details.production, true, true)
    BikerDocumentForgery.Details.Enable(BikerDocumentForgery.Details.setup, false, true)
    BikerDocumentForgery.Details.Enable(BikerDocumentForgery.Details.furnitures, true, true)
    BikerDocumentForgery.Details.Enable(BikerDocumentForgery.Details.clutter, false, true)
    BikerDocumentForgery.Details.Enable(BikerDocumentForgery.Details.Chairs, false, true)
    BikerDocumentForgery.Details.Enable(BikerDocumentForgery.Details.Chairs.A, true, true)
    
    -- Refreshing the interior to the see the result
    RefreshInterior(BikerDocumentForgery.interiorId)
end)


-- Functions

local function RegisterOfficeEntranceTarget(officeData)
    local coords = officeData.coords['enter']
    local boxName = 'forgeryOfficeEntrance'
    local boxData = officeData.polyzoneBoxData['enter']
    exports['qb-target']:AddBoxZone(boxName, coords, boxData.length, boxData.width, {
        name = boxName,
        heading = boxData.heading,
        debugPoly = boxData.debug,
        minZ = coords.z - 1.0,
        maxZ = coords.z + 1.0,
    }, {
        options = {
            {
                type = 'client',
                event = 'qb-forgeryoffice:client:EnterOffice',
                label = Lang:t('targetInfo.enter'),
            },
        },
        distance = boxData.distance
    })

    Config.ForgeryOffice.polyzoneBoxData['enter'].created = true
end

local function RegisterOfficeEntranceZone(officeData)
    local coords = officeData.coords['enter']
    local boxName = 'forgeryOfficeEntrance'
    local boxData = officeData.polyzoneBoxData['enter']

    local zone = BoxZone:Create(coords, boxData.length, boxData.width, {
        name = boxName,
        heading = boxData.heading,
        debugPoly = boxData.debug,
        minZ = coords.z - 1.0,
        maxZ = coords.z + 1.0,
    })

    zone:onPlayerInOut(function (isPointInside)
        if isPointInside then
            exports['qb-core']:DrawText('[E] ' .. Lang:t('targetInfo.enter'), 'left')
        else
            exports['qb-core']:HideText()
        end

        isInsideEntranceTarget = isPointInside
    end)

    boxData.created = true
    boxData.zone = zone
end

local function SetOfficeEntranceTargets()
    if Config.ForgeryOffice and next(Config.ForgeryOffice) then
        if Config.ForgeryOffice.coords and Config.ForgeryOffice.coords['enter'] then
            if Config.UseTarget then
                RegisterOfficeEntranceTarget(Config.ForgeryOffice)
            else
                RegisterOfficeEntranceZone(Config.ForgeryOffice)
            end
        end
    end
end

local function RegisterOfficeInteractionZone(officeData)
    local coords = officeData.coords['forgerydetailsZone']
    local boxName = 'forgeryDetailsForgeryOfficeInteraction'
    local boxData = officeData.polyzoneBoxData['forgerydetailsZone']
    
    local zone = BoxZone:Create(coords, boxData.length, boxData.width, {
        name = boxName,
        heading = boxData.heading,
        debugPoly = boxData.debug,
        minZ = coords.z - 1.0,
        maxZ = coords.z + 1.0,
    })

    zone:onPlayerInOut(function (isPointInside)
        if isPointInside then
            exports['qb-core']:DrawText('[E] ' .. Lang:t('targetInfo.pc_option'), 'left')
        else
            exports['qb-core']:HideText()
            TriggerEvent('qb-forgeryoffice:client:target:CloseMenu')
        end

        isInsideComputerTarget = isPointInside
    end)

    boxData.created = true
    boxData.zone = zone

    -----------------------------------------------------------------------------------------------

    local coords2 = officeData.coords['printdocumentZone']
    local boxName2 = 'printDocumentForgeryOfficeInteraction'
    local boxData2 = officeData.polyzoneBoxData['printdocumentZone']
    
    local zone2 = BoxZone:Create(coords2, boxData2.length, boxData2.width, {
        name = boxName2,
        heading = boxData2.heading,
        debugPoly = boxData2.debug,
        minZ = coords.z - 1.0,
        maxZ = coords.z + 1.0,
    })

    zone2:onPlayerInOut(function (isPointInside)
        if isPointInside then
            exports['qb-core']:DrawText('[E] ' .. Lang:t('targetInfo.printer_option'), 'left')
        else
            exports['qb-core']:HideText()
            TriggerEvent('qb-forgeryoffice:client:target:CloseMenu')
        end

        isInsidePrinterTarget = isPointInside
    end)

    boxData2.created = true
    boxData2.zone = zone2
end

local function RegisterOfficeInteractionTarget(officeData)
    local coords = officeData.coords['forgerydetails']
    local boxName = 'forgeryDetailsForgeryOfficeInteraction'
    local boxData = officeData.polyzoneBoxData['forgerydetails']
    
    local options = nil
    options = {
        {
            type = "client",
            event = "qb-forgeryoffice:client:target:ViewInventory",
            label = Lang:t("targetInfo.usb_slot_inventory"),
            forgeryOfficeData = {"computer", "Computer USB Slots", officeData}
        },
        {
            type = "client",
            event = "qb-forgeryoffice:client:target:createFakeID",
            label = Lang:t('targetInfo.create_fake_id'),
        },
        {
            type = "client",
            event = "qb-forgeryoffice:client:target:createFakeDrivingLicense",
            label = Lang:t('targetInfo.create_fake_driving_license'),
        },
        {
            type = "client",
            event = "qb-forgeryoffice:client:target:createFakeWeaponLicense",
            label = Lang:t('targetInfo.create_fake_weapon_license'),
        },
        {
            type = "client",
            event = "qb-forgeryoffice:client:target:createFakeLawyerPass",
            label = Lang:t('targetInfo.create_fake_lawyer_pass'),
        },
    }

    exports['qb-target']:AddBoxZone(boxName, coords, boxData.length, boxData.width, {
        name = boxName,
        heading = boxData.heading,
        debugPoly = boxData.debug,
        minZ = coords.z - 0.5,
        maxZ = coords.z + 0.5,
    }, {
        options = options,
        distance = boxData.distance
    })

    boxData.created = true

    -----------------------------------------------------------------------------------------------

    local coords2 = officeData.coords['printdocument']
    local boxName2 = 'printDocumentForgeryOfficeInteraction'
    local boxData2 = officeData.polyzoneBoxData['printdocument']
    
    local options2 = nil
    options2 = {
        {
            type = "client",
            event = "qb-forgeryoffice:client:target:ViewInventory",
            label = Lang:t("targetInfo.printer_blank_card_inventory"),
            forgeryOfficeData = {"printerIn", "Printer Blank Card Container", officeData}
        },
        {
            type = "client",
            event = "qb-forgeryoffice:client:target:ViewInventory",
            label = Lang:t("targetInfo.printer_usb_inventory"),
            forgeryOfficeData = {"printerUSB", "Printer USB Slot", officeData}
        },
        {
            type = "client",
            event = "qb-forgeryoffice:client:target:ViewInventory",
            label = Lang:t("targetInfo.printer_printed_card_inventory"),
            forgeryOfficeData = {"printerOut", "Printer Printed Card Container", officeData}
        },
        {
            type = "client",
            event = "qb-forgeryoffice:client:target:printerUse",
            label = Lang:t("targetInfo.use_printer"),
        }
    }

    exports['qb-target']:AddBoxZone(boxName2, coords2, boxData2.length, boxData2.width, {
        name = boxName2,
        heading = boxData2.heading,
        debugPoly = boxData2.debug,
        minZ = coords2.z - 0.5,
        maxZ = coords2.z + 0.5,
    }, {
        options = options2,
        distance = boxData2.distance,
    })

    boxData2.created = true

end

local function RegisterOfficeExitZone(officeData)
    local coords = officeData.coords['exit']
    local boxName = 'forgeryOfficeExit'
    local boxData = officeData.polyzoneBoxData['exit']
    
    local zone = BoxZone:Create(coords, boxData.length, boxData.width, {
        name = boxName,
        heading = boxData.heading,
        debugPoly = boxData.debug,
        minZ = coords.z - 1.0,
        maxZ = coords.z + 1.0,
    })

    zone:onPlayerInOut(function (isPointInside)
        if isPointInside then
            exports['qb-core']:DrawText('[E] ' .. Lang:t("targetInfo.leave"), 'left')
        else
            exports['qb-core']:HideText()
        end

        isInsideExitTarget = isPointInside
    end)

    boxData.created = true
    boxData.zone = zone
end

local function RegisterOfficeExitTarget(officeData)
    local coords = officeData.coords['exit']
    local boxName = 'forgeryOfficeExit'
    local boxData = officeData.polyzoneBoxData['exit']
    local zort = exports['qb-target']:AddBoxZone(boxName, coords, boxData.length, boxData.width, {
        name = boxName,
        heading = boxData.heading,
        debugPoly = boxData.debug,
        minZ = coords.z - 1.0,
        maxZ = coords.z + 1.0,
    }, {
        options = {
            {
                type = "client",
                event = "qb-forgeryoffice:client:target:ExitOffice",
                label = Lang:t("targetInfo.leave"),
            },
        },
        distance = boxData.distance
    })

    boxData.created = true
end

local function OpenComputerMenu(data)
    local headerMenu = {}


    QBCore.Functions.TriggerCallback('qb-inventory:server:GetStashItems', function(result)

        headerMenu[#headerMenu+1] = {
            header = Lang:t("targetInfo.pc_option"),
            isMenuHeader = true
        }
    
        headerMenu[#headerMenu+1] = {
            header = Lang:t("targetInfo.usb_slot_inventory"),
            params = {
                event = "qb-forgeryoffice:client:target:ViewInventory",
                args = {
                    forgeryOfficeData = {"computer", "Computer USB Slots", data}
                }
            }
        }

        local computerItems = result
        if computerItems and next(computerItems) then
            if computerItems[1].name == "usb" or computerItems[1].name == "blank_usb" then
                headerMenu[#headerMenu+1] = {
                    header = Lang:t('targetInfo.create_fake_id'),
                    params = {
                        event = "qb-forgeryoffice:client:target:createFakeID"
                    }
                }
                headerMenu[#headerMenu+1] = {
                    header = Lang:t('targetInfo.create_fake_driving_license'),
                    params = {
                        event = "qb-forgeryoffice:client:target:createFakeDrivingLicense"
                    }
                }
                headerMenu[#headerMenu+1] = {
                    header = Lang:t('targetInfo.create_fake_weapon_license'),
                    params = {
                        event = "qb-forgeryoffice:client:target:createFakeWeaponLicense"
                    }
                }
                headerMenu[#headerMenu+1] = {
                    header = Lang:t('targetInfo.create_fake_lawyer_pass'),
                    params = {
                        event = "qb-forgeryoffice:client:target:createFakeLawyerPass"
                    }
                }
            end
        end

        headerMenu[#headerMenu+1] = {
            header = Lang:t("targetInfo.close_menu"),
            params = {
                event = "qb-forgeryoffice:client:target:CloseMenu",
            }
        }
    
        exports['qb-menu']:openMenu(headerMenu)

    end, "forgeryoffice_computer")
end

local function OpenPrinterMenu(data)
    local headerMenu = {}

    
    QBCore.Functions.TriggerCallback('qb-inventory:server:GetStashItems', function(result)
        headerMenu[#headerMenu+1] = {
            header = Lang:t("targetInfo.printer_option"),
            isMenuHeader = true
        }
    
        headerMenu[#headerMenu+1] = {
            header = Lang:t("targetInfo.printer_blank_card_inventory"),
            params = {
                event = "qb-forgeryoffice:client:target:ViewInventory",
                args = {
                    forgeryOfficeData = {"printerIn", "Printer Blank Card Container", data}
                }
            }
        }
        headerMenu[#headerMenu+1] = {
            header = Lang:t('targetInfo.printer_usb_inventory'),
            params = {
                event = "qb-forgeryoffice:client:target:ViewInventory",
                args = {
                    forgeryOfficeData = {"printerUSB", "Printer USB Slot", data}
                }
            }
        }
        headerMenu[#headerMenu+1] = {
            header = Lang:t('targetInfo.printer_printed_card_inventory'),
            params = {
                event = "qb-forgeryoffice:client:target:ViewInventory",
                args = {
                    forgeryOfficeData = {"printerOut", "Printer Printed Card Container", data}
                }
            }
        }
        
        local printerItems = result
        if printerItems and next(printerItems) then
            if printerItems[1].name == "usb" or printerItems[1].name == "blank_usb" then

                headerMenu[#headerMenu+1] = {
                    header = Lang:t("targetInfo.use_printer"),
                    params = {
                        event = "qb-forgeryoffice:client:target:printerUse",
                    }
                }

            end
        end

        headerMenu[#headerMenu+1] = {
            header = Lang:t("targetInfo.close_menu"),
            params = {
                event = "qb-forgeryoffice:client:target:CloseMenu",
            }
        }
    
        exports['qb-menu']:openMenu(headerMenu)

    end, "forgeryoffice_printerUSB")
end

local function EnterOffice()
    local ped = PlayerPedId()
    DoScreenFadeOut(1000)
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    Wait(1000)
    local coords = Config.ForgeryOffice.coords['exit']
    SetEntityCoords(ped, coords.x, coords.y, coords.z)
    SetEntityHeading(ped, coords.a)
    InsideOffice = true
    Wait(1000)
    DoScreenFadeIn(1000)
end

local function LeaveOffice(data)
    local ped = PlayerPedId()
    TriggerServerEvent("InteractSound_SV:PlayOnSource", "houses_door_open", 0.25)
    DoScreenFadeOut(1000)
    Wait(1000)
    local coords = Config.ForgeryOffice.coords['enter']
    SetEntityCoords(ped, coords.x, coords.y, coords.z)
    SetEntityHeading(ped, coords.a)
    InsideOffice = false

    if Config.UseTarget then
        exports['qb-target']:RemoveZone('forgeryDetailsForgeryOfficeInteraction')
        data.polyzoneBoxData['forgerydetails'].created = false
        
        exports['qb-target']:RemoveZone('printDocumentForgeryOfficeInteraction')
        data.polyzoneBoxData['printdocument'].created = false

        exports['qb-target']:RemoveZone('forgeryOfficeExit')
        data.polyzoneBoxData['exit'].created = false
    else
        if Config.ForgeryOffice and Config.ForgeryOffice.polyzoneBoxData['forgerydetailsZone'] and Config.ForgeryOffice.polyzoneBoxData['forgerydetailsZone'].zone then
            Config.ForgeryOffice.polyzoneBoxData['forgerydetailsZone'].zone:destroy()
            Config.ForgeryOffice.polyzoneBoxData['forgerydetailsZone'].created = false
            Config.ForgeryOffice.polyzoneBoxData['forgerydetailsZone'].zone = nil
        end

        if Config.ForgeryOffice and Config.ForgeryOffice.polyzoneBoxData['printdocumentZone'] and Config.ForgeryOffice.polyzoneBoxData['printdocumentZone'].zone then
            Config.ForgeryOffice.polyzoneBoxData['printdocumentZone'].zone:destroy()
            Config.ForgeryOffice.polyzoneBoxData['printdocumentZone'].created = false
            Config.ForgeryOffice.polyzoneBoxData['printdocumentZone'].zone = nil
        end

        if Config.ForgeryOffice and Config.ForgeryOffice.polyzoneBoxData['exit'] and Config.ForgeryOffice.polyzoneBoxData['exit'].zone then
            Config.ForgeryOffice.polyzoneBoxData['exit'].zone:destroy()
            Config.ForgeryOffice.polyzoneBoxData['exit'].created = false
            Config.ForgeryOffice.polyzoneBoxData['exit'].zone = nil
        end

        isInsideExitTarget = false
        isInsideComputerTarget = false
        isInsidePrinterTarget = false
    end
    
    Wait(1000)
    DoScreenFadeIn(1000)
end

-- Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
end)

RegisterNetEvent('qb-forgeryoffice:client:EnterOffice', function()
    EnterOffice()
end)

RegisterNetEvent('qb-forgeryoffice:client:target:ViewInventory', function (data)
    print(json.encode(data))
    local officeDataInventory = {}
    officeDataInventory.label = data.forgeryOfficeData[2]
    --officeDataInventory.items = data.forgeryOfficeData.inventory
    officeDataInventory.slots = 1
    if data.forgeryOfficeData[1] == "printerOut" then officeDataInventory.slots = 50 end
    TriggerServerEvent("inventory:server:OpenInventory", "stash", "forgeryoffice_"..data.forgeryOfficeData[1], officeDataInventory)
    TriggerEvent("inventory:client:SetCurrentStash", "forgeryoffice_"..data.forgeryOfficeData[1])
end)

RegisterNetEvent('qb-forgeryoffice:client:target:createFakeID', function()
    local id_card = exports['qb-input']:ShowInput({
        header = "ID Card",
        submitText = "Format & Write",
        inputs = {
            {
                text = "Citizen ID", -- text you want to be displayed as a place holder
                name = "citizenid", -- name of the input should be unique otherwise it might override
                type = "text", -- type of the input
                isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                -- default = "CID-1234", -- Default text option, this is optional
            },
            {
                text = "Firstname", -- text you want to be displayed as a place holder
                name = "firstname", -- name of the input should be unique otherwise it might override
                type = "text", -- type of the input
                isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                -- default = "CID-1234", -- Default text option, this is optional
            },
            {
                text = "Lastname", -- text you want to be displayed as a place holder
                name = "lastname", -- name of the input should be unique otherwise it might override
                type = "text", -- type of the input
                isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                -- default = "CID-1234", -- Default text option, this is optional
            },
            {
                text = "Birthdate", -- text you want to be displayed as a place holder
                name = "birthdate", -- name of the input should be unique otherwise it might override
                type = "text", -- type of the input
                isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                -- default = "CID-1234", -- Default text option, this is optional
            },
            {
                text = "Gender", -- text you want to be displayed as a input header
                name = "gender", -- name of the input should be unique otherwise it might override
                type = "select", -- type of the input - Select is useful for 3+ amount of "or" options e.g; someselect = none OR other OR other2 OR other3...etc
                options = { -- Select drop down options, the first option will by default be selected
                    { value = "male", text = "Male"}, -- Options MUST include a value and a text option
                    { value = "female", text = "Female" }, -- Options MUST include a value and a text option
                },
                default = 'male', -- Default select option, must match a value from above, this is optional
            },
            {
                text = "Nationality", -- text you want to be displayed as a place holder
                name = "nationality", -- name of the input should be unique otherwise it might override
                type = "text", -- type of the input
                isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                -- default = "CID-1234", -- Default text option, this is optional
            },
        },
    })

    if id_card ~= nil then
        id_card.documentType = "id_card"
        TriggerServerEvent("qb-forgeryoffice:server:createForgeryUSB", id_card)
    end
end)

RegisterNetEvent('qb-forgeryoffice:client:target:createFakeDrivingLicense', function()
    local driver_license = exports['qb-input']:ShowInput({
        header = "Driving License",
        submitText = "Format & Write",
        inputs = {
            {
                text = "Citizen ID", -- text you want to be displayed as a place holder
                name = "citizenid", -- name of the input should be unique otherwise it might override
                type = "text", -- type of the input
                isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                -- default = "CID-1234", -- Default text option, this is optional
            },
            {
                text = "Firstname", -- text you want to be displayed as a place holder
                name = "firstname", -- name of the input should be unique otherwise it might override
                type = "text", -- type of the input
                isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                -- default = "CID-1234", -- Default text option, this is optional
            },
            {
                text = "Lastname", -- text you want to be displayed as a place holder
                name = "lastname", -- name of the input should be unique otherwise it might override
                type = "text", -- type of the input
                isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                -- default = "CID-1234", -- Default text option, this is optional
            },
            {
                text = "Birthdate", -- text you want to be displayed as a place holder
                name = "birthdate", -- name of the input should be unique otherwise it might override
                type = "text", -- type of the input
                isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                -- default = "CID-1234", -- Default text option, this is optional
            },
            {
                text = "Type", -- text you want to be displayed as a place holder
                name = "type", -- name of the input should be unique otherwise it might override
                type = "text", -- type of the input
                isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                -- default = "CID-1234", -- Default text option, this is optional
            },
        },
    })

    if driver_license ~= nil then
        driver_license.documentType = "driver_license"
        TriggerServerEvent("qb-forgeryoffice:server:createForgeryUSB", driver_license)
    end
end)

RegisterNetEvent('qb-forgeryoffice:client:target:createFakeWeaponLicense', function()
    local weaponlicense = exports['qb-input']:ShowInput({
        header = "Weapon License",
        submitText = "Format & Write",
        inputs = {
            {
                text = "Firstname", -- text you want to be displayed as a place holder
                name = "firstname", -- name of the input should be unique otherwise it might override
                type = "text", -- type of the input
                isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                -- default = "CID-1234", -- Default text option, this is optional
            },
            {
                text = "Lastname", -- text you want to be displayed as a place holder
                name = "lastname", -- name of the input should be unique otherwise it might override
                type = "text", -- type of the input
                isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                -- default = "CID-1234", -- Default text option, this is optional
            },
            {
                text = "Birthdate", -- text you want to be displayed as a place holder
                name = "birthdate", -- name of the input should be unique otherwise it might override
                type = "text", -- type of the input
                isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                -- default = "CID-1234", -- Default text option, this is optional
            },
        },
    })

    if weaponlicense ~= nil then
        weaponlicense.documentType = "weaponlicense"
        TriggerServerEvent("qb-forgeryoffice:server:createForgeryUSB", weaponlicense)
    end
end)

RegisterNetEvent('qb-forgeryoffice:client:target:createFakeLawyerPass', function()
    local lawyerpass = exports['qb-input']:ShowInput({
        header = "Weapon License",
        submitText = "Format & Write",
        inputs = {
            {
                text = "Citizen ID", -- text you want to be displayed as a place holder
                name = "citizenid", -- name of the input should be unique otherwise it might override
                type = "text", -- type of the input
                isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                -- default = "CID-1234", -- Default text option, this is optional
            },
            {
                text = "Firstname", -- text you want to be displayed as a place holder
                name = "firstname", -- name of the input should be unique otherwise it might override
                type = "text", -- type of the input
                isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                -- default = "CID-1234", -- Default text option, this is optional
            },
            {
                text = "Lastname", -- text you want to be displayed as a place holder
                name = "lastname", -- name of the input should be unique otherwise it might override
                type = "text", -- type of the input
                isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                -- default = "CID-1234", -- Default text option, this is optional
            },
            {
                text = "Pass-ID", -- text you want to be displayed as a place holder
                name = "id", -- name of the input should be unique otherwise it might override
                type = "text", -- type of the input
                isRequired = true, -- Optional [accepted values: true | false] but will submit the form if no value is inputted
                -- default = "CID-1234", -- Default text option, this is optional
            },
        },
    })

    if lawyerpass ~= nil then
        lawyerpass.documentType = "lawyerpass"
        TriggerServerEvent("qb-forgeryoffice:server:createForgeryUSB", lawyerpass)
    end
end)

RegisterNetEvent('qb-forgeryoffice:client:target:printerUse', function()
    TriggerServerEvent('qb-forgeryoffice:server:target:printerUse')
end)

RegisterNetEvent('qb-forgeryoffice:client:target:SeePinCode', function (data)
    QBCore.Functions.Notify(Lang:t('info.pin_code', { value = data.forgeryOfficeData.pincode }))
end)

RegisterNetEvent('qb-forgeryoffice:client:target:ExitOffice', function (data)
    LeaveOffice(Config.ForgeryOffice)
end)

RegisterNetEvent('qb-forgeryoffice:client:SyncData', function(data)
    Config.ForgeryOffice = data

    if Config.UseTarget then
        exports['qb-target']:RemoveZone('forgeryDetailsForgeryOfficeInteraction')
        Config.ForgeryOffice.polyzoneBoxData['forgerydetails'].created = false
        exports['qb-target']:RemoveZone('printDocumentForgeryOfficeInteraction')
        Config.ForgeryOffice.polyzoneBoxData['printdocument'].created = false
    else
        if Config.ForgeryOffice and Config.ForgeryOffice.polyzoneBoxData['forgerydetailsZone'] and Config.ForgeryOffice.polyzoneBoxData['forgerydetailsZone'].zone then
            Config.ForgeryOffice.polyzoneBoxData['forgerydetailsZone'].zone:destroy()
            Config.ForgeryOffice.polyzoneBoxData['forgerydetailsZone'].created = false
            Config.ForgeryOffice.polyzoneBoxData['forgerydetailsZone'].zone = nil
        end

        if Config.ForgeryOffice and Config.ForgeryOffice.polyzoneBoxData['printdocumentZone'] and Config.ForgeryOffice.polyzoneBoxData['printdocumentZone'].zone then
            Config.ForgeryOffice.polyzoneBoxData['printdocumentZone'].zone:destroy()
            Config.ForgeryOffice.polyzoneBoxData['printdocumentZone'].created = false
            Config.ForgeryOffice.polyzoneBoxData['printdocumentZone'].zone = nil
        end

        isInsideComputerTarget = false
        isInsidePrinterTarget = false
    end
end)

RegisterNetEvent('qb-forgeryoffice:client:target:CloseMenu', function () 
    TriggerEvent('qb-menu:client:closeMenu')
end)


-- NUI

RegisterNUICallback('close', function(data)
    SetNuiFocus(false, false)
    SendNUIMessage({
        enable = false
    })
end)

RegisterNUICallback('newDocument', function(data)
    TriggerServerEvent("qb-forgeryoffice:server:createForgeryUSB", data)
    SetNuiFocus(false, false)
    SendNUIMessage({
        enable = false
    })
end)

-- Threads

CreateThread(function ()
    local wait = 500
    while not LocalPlayer.state.isLoggedIn do
        -- do nothing
        Wait(wait)
    end

    SetOfficeEntranceTargets()

    if QBCore.Functions.GetPlayerData() ~= nil then
        PlayerData = QBCore.Functions.GetPlayerData()
    end

    while true do
        wait = 500

        if not InsideOffice then
            if isInsideEntranceTarget then
                wait = 0
                if IsControlJustPressed(0, 38) then
                    TriggerEvent("qb-forgeryoffice:client:EnterOffice")
                    exports['qb-core']:HideText()
                end
            end
        else
            local data = Config.ForgeryOffice
            if not data.polyzoneBoxData['exit'].created then
                local exitCoords = data.coords['exit']
                if Config.UseTarget then
                    RegisterOfficeExitTarget(data)
                else
                    RegisterOfficeExitZone(data)
                end
            end

            if not data.polyzoneBoxData['forgerydetailsZone'].created then
                if Config.UseTarget then
                    RegisterOfficeInteractionTarget(data)
                else
                    RegisterOfficeInteractionZone(data)
                end
            end

            if isInsideExitTarget then
                wait = 0
                if IsControlJustPressed(0, 38) then
                    LeaveOffice(data)
                    exports['qb-core']:HideText()
                end
            end

            if isInsideComputerTarget then
                wait = 0
                if IsControlJustPressed(0, 38) then
                    OpenComputerMenu(data)
                    exports['qb-core']:HideText()
                end
            end

            if isInsidePrinterTarget then
                wait = 0
                if IsControlJustPressed(0, 38) then
                    OpenPrinterMenu(data)
                    exports['qb-core']:HideText()
                end
            end
        end
        Wait(wait)
    end
end)
