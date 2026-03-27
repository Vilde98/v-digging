Locales = {}
Config = {}

Config.Debug = false
Config.Locale = 'en'

function _U(str, ...)
    if Locales[Config.Locale] and Locales[Config.Locale][str] then
        local text = Locales[Config.Locale][str]
        if select('#', ...) > 0 then
            return string.format(text, ...)
        end
        return text
    end
    return "Translation not found: " .. str
end


Config.ShovelItem = 'shovel'
Config.DurabilityLoss = 3
Config.DigTime = 15000

Config.AnimDict = 'random@burial'
Config.AnimLib = 'a_burial'

Config.LootTable = {
    { item = 'garbage', label = 'Garbage', chance = 60, min = 1, max = 1 },
    { item = 'plastic', label = 'Plastic', chance = 40, min = 1, max = 3 },
    { item = 'metalscrap', label = 'Metalscrap', chance = 30, min = 1, max = 2 },
    { item = 'glass', label = 'Glass', chance = 20, min = 1, max = 4 },
    { item = 'goldchain', label = 'Goldchain', chance = 5, min = 1, max = 1 },
    { item = 'rolex', label = 'Rolex', chance = 1, min = 1, max = 1 },
}


Config.SandHashes = {
    [581794674]         = true,
    [-1595148316]       = true,
    [-1885547121]       = true,
    [-1915425863]       = true,
    [2128369009]        = true,
    [-840216541]        = true,
    [-1554827148]       = true,
    [951832588]         = true,
    [1333033863]        = true,
    [826794159]         = true,
    [-461750719]        = true,
    [-1286696947]       = true,
    [-1942898710]       = true,
    [223086562]         = true,
    [-1907520769]       = true,
}