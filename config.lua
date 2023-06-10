Config = {}
Config.PolyDebug = false

Config.Locations = {
    ["police"] = {
        job = "police",
        platePrefix = "pol", -- This need to be 3 characters long.
        defaultGarage = "vesppd_garage",
        usePed = true,
        pedModel = "csb_cop",
        pedCoords = vector4(-1107.11, -855.607, 13.573, 76.01),
        coords = vector4(0, 0, 0, 22),
        width = 2,
        lenght = 2,
        minZ = 1,
        maxZ = 1,
        zoneId = nil -- Dont touch this
    },
    -- ["policeSandy"] = {
    --     job = "bcso",
    --     platePrefix = "bcs", -- This need to be 3 characters long.
    --     usePed = true,
    --     pedModel = "csb_cop",
    --     pedCoords = vector4(-1108.20, -833.974, 13.336, 141.8),
    --     coords = vector4(0, 0, 0, 22),
    --     width = 2,
    --     lenght = 2,
    --     minZ = 1,
    --     maxZ = 1,
    --     zoneId = nil -- Dont touch this
    -- }
}

Config.Cars = {
    ["police"] = {
        ["code318charg"] = {
            label = "Police Charger",
            fullTune = true,
            price = 15000,
            requiredRank = {4, 5, 6, 7, 8}
        },
        ["code3camero"] = {
            label = "Police Camero",
            fullTune = true,
            price = 15000,
            requiredRank = {1, 2, 3, 4, 5, 6, 7, 8}
        },
        ["code3durango"] = {
            label = "Police Durango",
            fullTune = true,
            price = 15000,
            requiredRank = {4, 5, 6, 7, 8}
        },
        ["code3ram"] = {
            label = "Police Ram",
            fullTune = true,
            price = 15000,
            requiredRank = {4, 5, 6, 7, 8}
        },
    },
}

Config.Lang = {
    carMenuHeader = "This is the header",
    openMenu = "Open menu",
    sureMenuHeader = "Do you want to puchase this car?",
    sayYes = "Yes, i want to purchase this car",
    sayNo = "No, i dont want to purchase this car",
    sayNoNotifier = "You said no to buying the car",
    congratzNewCarnotify = "Congratulation You just purchased a new car",
    bankStatementText = "Bought job car",
    AlreadyownedCarnotify = "You already own this car",
    notEnoughMoney = "You dont have enough money",
}