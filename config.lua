Config = {}


Config = {
    DebugPoly = false, -- Shop to purchase license and buy bait also to sell your fish you catch, shows the location of all 3 
    SetEntityDrawOutline = false, -- To see where the models are located at
    SetEntityDrawOutlineColor = {0, 0, 255, 255},  -- Set your color here for outline of the object only when SetEntityDrawOutline = true
    FishingSpots = {
        --Paleto Cove---------------------------------------
        vec4(-1590.33, 5213.49, 4.07, 27.85), --FishingSpot1
        --GrapeSeed---------------------------------------
        vec4(1306.07, 4254.31, 33.91, 167.43), --FishingSpot2
        --Sandy Shores---------------------------------------
        --vec4(1306.07, 4254.31, 33.91, 167.43), --FishingSpot3
    },
    -- ↓ Below is the object model and location on where they are at in the world ↓
    ObjectModels = {
--Paleto Cove ↓
        {model = "prop_fncsec_02pole", coords = vec3(-1606.44, 5204.71, 3.30), heading = 300.0}, --Spot 1
        {model = "prop_fncsec_02pole", coords = vec3(-1589.24, 5219.51, 2.94), heading = 292.92}, --Spot 2
        {model = "prop_fncsec_02pole", coords = vec3(-1601.31, 5229.88, 2.94), heading = 292.92}, --Spot 3
        {model = "prop_fncsec_02pole", coords = vec3(-1601.77, 5246.5, 2.94), heading = 1292.92}, --Spot 4
        {model = "prop_fncsec_02pole", coords = vec3(-1612.09, 5262.82, 2.94), heading = 300.0}, --Spot 5
--GrapeSeed ↓
        {model = "prop_fncsec_02pole", coords = vec3(1316.42151, 4227.84229, 32.9256363), heading = 157.57}, --Spot 1
        {model = "prop_fncsec_02pole", coords = vec3(1309.539, 4229.2666, 32.9256363), heading = 157.57}, --Spot 2
        {model = "prop_fncsec_02pole", coords = vec3(1323.32593, 4226.51465, 32.9256363), heading = 157.57}, --Spot 3
        {model = "prop_fncsec_02pole", coords = vec3(1330.53027, 4225.125, 32.9256363), heading = 157.57}, --Spot 4
        {model = "prop_fncsec_02pole", coords = vec3(1337.54211, 4223.713, 32.9256363), heading = 157.57} --Spot 5
--Sandy Shores ↓
        --{model = "prop_fncsec_02pole", coords = vec3(-1606.44, 5204.71, 3.30), heading = 300.0}, --Spot 1
        --{model = "prop_fncsec_02pole", coords = vec3(-1589.24, 5219.51, 2.94), heading = 292.92}, --Spot 2
        --{model = "prop_fncsec_02pole", coords = vec3(-1601.31, 5229.88, 2.94), heading = 292.92}, --Spot 3
        --{model = "prop_fncsec_02pole", coords = vec3(-1601.77, 5246.5, 2.94), heading = 1292.92}, --Spot 4
        --{model = "prop_fncsec_02pole", coords = vec3(-1612.09, 5262.82, 2.94), heading = 300.0} --Spot 5
    },
}
-- ↓ Shop where you can buy youre fishing license from ↓
Config.LicensePurchaseLocation = vec4(386.86, 792.48, 187.69, 355.28)
-- ↓ Bait shop where you can purchase bait from ↓
Config.BaitPurchaseLocation = vec4(-1600.68, 5204.27, 4.31, 194.35)
-- ↓ Location to sell the fish you have caught ↓
Config.SellingPointLocation = vec4(-399.8, 6377.79, 14.05, 195.25)

-- ↓ blips for the locations ↓ --
Config.Blips = {
    -- Example {title="", colour=, id=, x=, y=, z=},
     {title="SellingPointLocation", colour=28, id=356, x = -400.06, y = 6377.67, z = 14.04},
     {title="BaitPurchaseLocation", colour=17, id=356, x = -1600.77, y = 5204.2, z = 4.31},
     {title="LicensePurchaseLocation", colour=25, id=356, x = 386.86, y = 792.48, z = 187.69}
  }

-- ↓ This is the ColorPalette you can add more or change it ↓
Config.ColorPalette = {
    red = '#cf4030',
    green = '#479423',
    blue = '#3789bb',
    yellow = '#fdd041',
    orange = '#f7931a'
  }

-- ↓ This is all the FishTypes you can change or add more ↓
Config.FishTypes = {
    "o_anchovy",
    "o_codfish",
    "o_giant_seabass",
    "o_grouper",
    "o_kingcrab",
    "o_lobster",
    "o_mackerel",
    "o_mahi_mahi",
    "o_pacific_halibut",
    "o_pacific_sardine",
    "o_rainbow_trout",
    "o_red_snapper",
    "o_redfish",
    "o_spot_prawn",
    "o_stingray",
    "o_white_seabass",
    "o_yellowfin_tuna",
    "r_black_crappie",
    "r_brown_trout",
    "r_catfish",
    "r_chinook_salmon",
    "r_coho_salmon",
    "r_common_carp",
    "r_cutthroat_trout",
    "r_largemouth_bass",
    "r_perch",
    "r_striped_bass",
    "r_tilapia",
    "r_white_sturgeon"
}

-- ↓ This is all the FishPrices you can change or add more ↓
Config.FishPrices = {
    o_anchovy = 100,
    o_codfish = 100,
    o_giant_seabass = 100,
    o_grouper = 100,
    o_kingcrab = 100,
    o_lobster = 100,
    o_mackerel = 100,
    o_mahi_mahi = 100,
    o_pacific_halibut = 100,
    o_pacific_sardine = 100,
    o_rainbow_trout = 100,
    o_red_snapper = 100,
    o_redfish = 100,
    o_spot_prawn = 100,
    o_stingray = 100,
    o_white_seabass = 100,
    o_yellowfin_tuna = 100,
    r_black_crappie = 100,
    r_brown_trout = 100,
    r_catfish = 100,
    r_chinook_salmon = 100,
    r_coho_salmon = 100,
    r_common_carp = 100,
    r_cutthroat_trout = 100,
    r_largemouth_bass = 100,
    r_perch = 100,
    r_striped_bass = 100,
    r_tilapia = 100,
    r_white_sturgeon = 100
}
