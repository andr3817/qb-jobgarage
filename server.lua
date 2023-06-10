local QBCore = exports['qb-core']:GetCoreObject()


local function doIHaveCar(model, plate, id, callback)
    exports.oxmysql:execute('SELECT * FROM player_vehicles WHERE citizenid = ? AND vehicle = ?',{id, model}, function(result)
        if result and result[1] then
            callback(true)
        else
            callback(false)
        end
    end)
end

local function numberPlateCheck(plate, callback)
    exports.oxmysql:execute('SELECT * FROM player_vehicles WHERE plate = ?',{plate}, function(result)
        if result and result[1] then
            callback(true)
        else
            callback(false)
        end
    end)
end


RegisterNetEvent('qb-jobgarage:server:buyCar', function(data, moneyType, price, upgrade)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local randomPlate = data.platePrefix..math.random(11111, 99999)
    local cid = Player.PlayerData.citizenid
    if QBCore.Shared.Vehicles[data.model] then
        local props = '{}'
        if upgrade then
            props = '{"modHydrolic":-1,"modAirFilter":-1,"modSideSkirt":-1,"dashboardColor":0,"modHorns":-1,"wheelColor":156,"color2":1,"color1":1,"modExhaust":-1,"modEngine":3,"modXenon":1,"modVanityPlate":-1,"modTank":-1,"modFrontBumper":-1,"fuelLevel":99.29102934053518,"interiorColor":0,"modPlateHolder":-1,"modBrakes":2,"modSmokeEnabled":false,"model":970598228,"modArmor":4,"engineHealth":1000.0592475178704,"modLivery":-1,"plateIndex":0,"modAerials":-1,"modRightFender":-1,"modOrnaments":-1,"modDial":-1,"xenonColor":255,"modTrunk":-1,"windowTint":-1,"modSpeakers":-1,"modShifterLeavers":-1,"modEngineBlock":-1,"modCustomTiresF":false,"neonEnabled":[false,false,false,false],"modDashboard":-1,"modTrimB":-1,"dirtLevel":7.94328234724281,"modSteeringWheel":-1,"pearlescentColor":5,"modRearBumper":-1,"modCustomTiresR":false,"tyreSmokeColor":[255,255,255],"modFrontWheels":-1,"modWindows":-1,"wheels":0,"modTurbo":1,"modTransmission":2,"extras":{"12":false,"10":false},"modRoof":-1,"modTrimA":-1,"modAPlate":-1,"modFender":-1,"modDoorSpeaker":-1,"modSpoilers":-1,"modBackWheels":-1,"modSuspension":3,"modHood":-1,"modArchCover":-1,"modGrille":-1,"modSeats":-1,"neonColor":[255,255,255],"modStruts":-1}'
        end
        numberPlateCheck(randomPlate, function(plateExist)
            if plateExist == false then
                doIHaveCar(data.model, randomPlate, cid, function(hasCar)
                    if hasCar == false then
                        exports.oxmysql:insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, fuel, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', {
                            Player.PlayerData.license,
                            cid,
                            data.model,
                            GetHashKey(data.model),
                            props,
                            randomPlate,
                            data.defaultGarage,
                            100,
                            1
                        })
                        TriggerClientEvent('QBCore:Notify', src, Config.Lang.congratzNewCarnotify, "success", 3500)
                        Wait(200)
                        TriggerClientEvent("qb-jobgarage:client:sendMail", src, data.defaultGarage)
                        Player.Functions.RemoveMoney(moneyType, price, Config.Lang.bankStatementText)
                        
                        if moneyType == 'bank' then
                            local newBankBalance = Player.Functions.GetMoney('bank')
                            exports['qb-banking']:addBankStatement(Player.PlayerData.citizenid, 'Bank', 0, price, newBankBalance, Config.Lang.bankStatementText, {newBankBalance = newBankBalance})
                        end
                    else
                        TriggerClientEvent('QBCore:Notify', src, Config.Lang.AlreadyownedCarnotify, "error", 2500)
                    end
                end)
            else
                print("numberPlateChecked: "..randomPlate)
                print("Duplicate Plate cant go on.")
            end
        end)
    else
        TriggerClientEvent('QBCore:Notify', src, "This vehicle is not in your shared/vehicle.lua", "error", 2500)
    end
end)


