local QBCore = exports['qb-core']:GetCoreObject()
local entitys = {}

local function canBuy(data, PlayerData)
    for i = 1, #data do
        if data[i] <= PlayerData.job.grade.level then
            return true
        else
            return false
        end
    end
end

local function openMenu(job, platePrefix, defaultGarage, payWithBossMenu, moneyType)
    local PlayerData = QBCore.Functions.GetPlayerData()
    local menu = {}
    menu[#menu+1] = {
        header = Config.Lang.carMenuHeader,
        icon = 'fas fa-code',
        isMenuHeader = true, -- Set to true to make a nonclickable title
    }
        for k, v in pairs(Config.Cars[job]) do
            if canBuy(v.requiredRank, PlayerData) then
                menu[#menu+1] = {
                    header = v.label,
                    txt = v.price,
                    icon = 'fas fa-star',
                    isServer = false,
                    params = {
                        event = 'qb-jobgarage:client:ForMeOrForOther',
                        args = {
                            model = k,
                            price = v.price,
                            tune = v.fullTune,
                            job = job,
                            platePrefix = platePrefix,
                            defaultGarage = defaultGarage,
                            payWithBossMenu = payWithBossMenu,
                            moneyType = moneyType,
                            origrinalPlayer = PlayerData.source,
                        }
                    }
                }
            end
        end
    exports["qb-menu"]:openMenu(menu)
end

local function openSureMenu(data)
    local menu = {}
    menu[#menu+1] = {
        header = Config.Lang.sureMenuHeader,
        icon = 'fas fa-code',
        isMenuHeader = true, -- Set to true to make a nonclickable title
    }
    menu[#menu+1] = {
        header = Config.Lang.sayYes,
        icon = 'fas fa-star',
        -- isServer = true,
        params = {
            event = 'qb-jobgarage:client:sayYes',
            args = {
                model = data.model,
                price = data.price,
                tune = data.tune,
                job = data.job,
                platePrefix = data.platePrefix,
                defaultGarage = data.defaultGarage,
                payWithBossMenu = data.payWithBossMenu,
                moneyType = data.moneyType,
                id = data.id,
                origrinalPlayer = data.origrinalPlayer,
            }
        }
    }
    menu[#menu+1] = {
        header = Config.Lang.sayNo,
        icon = 'fas fa-star',
        isServer = false,
        params = {
            event = 'qb-jobgarage:client:sayNo',
        }
    }
    exports["qb-menu"]:openMenu(menu)
end

RegisterNetEvent('qb-jobgarage:client:ForMeOrForOther', function(data)
    local menu = {}
    menu[#menu+1] = {
        header = Config.Lang.meOrOtherMenuHeader,
        icon = 'fas fa-code',
        isMenuHeader = true, -- Set to true to make a nonclickable title
    }
    menu[#menu+1] = {
        header = Config.Lang.meHeader,
        icon = 'fas fa-star',
        isServer = true,
        params = {
            event = 'qb-jobgarage:client:Sure',
            args = {
                id = nil,
                model = data.model,
                price = data.price,
                tune = data.tune,
                job = data.job,
                platePrefix = data.platePrefix,
                defaultGarage = data.defaultGarage,
                payWithBossMenu = data.payWithBossMenu,
                moneyType = data.moneyType,
            }

        }
    }
    menu[#menu+1] = {
        header = Config.Lang.otherHeader,
        icon = 'fas fa-star',
        isServer = false,
        params = {
            event = 'qb-jobgarage:client:Who',
            args = {
                model = data.model,
                price = data.price,
                tune = data.tune,
                job = data.job,
                platePrefix = data.platePrefix,
                defaultGarage = data.defaultGarage,
                payWithBossMenu = data.payWithBossMenu,
                moneyType = data.moneyType,
                origrinalPlayer = data.origrinalPlayer,
            }
        }
    }
    exports["qb-menu"]:openMenu(menu)
end)

RegisterNetEvent('qb-jobgarage:client:Sure', function(data)
    openSureMenu(data)
end)


RegisterNetEvent('qb-jobgarage:client:Who', function(data)
    local dialog = exports['qb-input']:ShowInput({
        header = Config.Lang.whoHeader,
        submitText = "Submit",
        inputs = {
            {
                text = "ID:",
                name = "id",
                type = "number",
                isRequired = true,
            },
        }
    })
    if dialog ~= nil then
        if tonumber(dialog.id) ~= 0 then
            -- openSureMenu(dialog.id, data)
            TriggerServerEvent('qb-jobgarage:server:Sure', dialog.id, data)
        end
    end
end)




RegisterNetEvent('qb-jobgarage:client:sayNo', function()
    QBCore.Functions.Notify(Config.Lang.sayNoNotifier, 'error', 2500)
end)

RegisterNetEvent('qb-jobgarage:client:sayYes', function(data)
    local PlayerData = QBCore.Functions.GetPlayerData()
    TriggerServerEvent('qb-jobgarage:server:buyCar', data, data.price, data.tune, data.id)
end)

RegisterNetEvent('qb-jobgarage:client:sendMail', function(defaultGarage)
    local gender = "Mr."
    if QBCore.Functions.GetPlayerData().charinfo.gender == 1 then
        gender = "Mrs."
    end
    local charinfo = QBCore.Functions.GetPlayerData().charinfo
    TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = "Garage Dawg",
        subject = "New Car",
        message = "Dear " .. gender .. " " .. charinfo.lastname .. ",<br /><br />Congratulations with you new car.<br />Your car will be located at: <strong>"..defaultGarage.."</strong><br /><br />Good luck!",
        button = {}
    })
end)

CreateThread(function()
    for k, v in pairs(Config.Locations) do
        if v.usePed then
            local model = v.pedModel
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(0)
            end
            local entity = CreatePed(0, v.pedModel, vector3(v.pedCoords.x, v.pedCoords.y, v.pedCoords.z - 1), v.pedCoords.w, false, false)
            SetBlockingOfNonTemporaryEvents(entity, true)
            FreezeEntityPosition(entity, true)
            SetEntityInvincible(entity, true)
            exports['qb-target']:AddTargetEntity(entity, { -- The specified entity number
                options = {
                    {
                        action = function()
                            openMenu(v.job, v.platePrefix, v.defaultGarage, v.payWithBossMenu, v.moneyType)
                        end,
                        job = v.job,
                        icon = "fas fa-sign-in-alt",
                        label = Config.Lang.openMenu,
                        
                    },
                },
                distance = 2.5
            })
        else
            local randonmizer = math.random(111111, 999999)
            exports['qb-target']:AddBoxZone(k..""..randonmizer, vector3(v.coords.x, v.coords.y, v.coords.z), v.width, v.lenght, {
                name=k..""..randonmizer,
                heading=v.coords.w,
                debugPoly=Config.PolyDebug,
                minZ=v.minZ,
                maxZ=v.maxZ
            }, {
                options = {
                    {
                        action = function()
                            openMenu(v.job, v.platePrefix, v.defaultGarage, v.payWithBossMenu, v.moneyType)
                        end,
                        job = v.job,
                        icon = "fas fa-sign-in-alt",
                        label = Config.Lang.openMenu,
                        
                    },
                },
                distance = 2.5
            })
        end
    end
end)



-- AddEventHandler('onResourceStart', function(resource)
--     if resource == GetCurrentResourceName() then
--         CreateTarget()
--     end
--  end)

