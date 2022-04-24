Config = Config or {}

-- **** IMPORTANT ****
-- UseTarget should only be set to true when using qb-target
--Config.UseTarget = GetConvar('UseTarget', 'false') == 'true'
Config.UseTarget = false

Config.ForgeryOffice = {
    coords = {
        ["enter"] = vector4(-618.6, 301.94, 82.25, 84.51),
        ["forgerydetails"] = vector3(1159.71, -3199.26, -39.25),
        ["forgerydetailsZone"] = vector3(1161.38, -3198.4, -39.01),
        ["printdocument"] = vector3(1163.6, -3195.35, -39.25),
        ["printdocumentZone"] = vector3(1163.64, -3194.69, -39.01),
        ["exit"] = vector4(1173.61, -3196.67, -39.01, 94.11),
    },
    polyzoneBoxData = {
        ["enter"] = {
            heading = -5,
            debug = false,
            length = 1,
            width = 1,
            distance = 2.0,
            created = false
        },
        ["forgerydetails"] = {
            heading = 180,
            debug = false,
            length = 1,
            width = 1,
            distance = 2.0,
            created = false
        },
        ["forgerydetailsZone"] = {
            heading = 180,
            debug = false,
            length = 1,
            width = 1,
            distance = 2.0,
            created = false
        },
        ["printdocument"] = {
            heading = 180,
            debug = false,
            length = 1,
            width = 1,
            distance = 2.0,
            created = false
        },
        ["printdocumentZone"] = {
            heading = 180,
            debug = false,
            length = 1,
            width = 1,
            distance = 2.0,
            created = false
        },
        ["exit"] = {
            heading = 180,
            debug = false,
            length = 1,
            width = 1,
            distance = 2.0,
            created = false
        }
    },
}