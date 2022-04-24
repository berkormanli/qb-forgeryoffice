# qb-forgeryoffice

# License

    QBCore Framework
    Copyright (C) 2021 Joshua Eger

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>

## Dependencies
- [qb-core](https://github.com/qbcore-framework/qb-core)
- [PolyZone](https://github.com/mkafrin/PolyZone)
- [qb-inventory](https://github.com/qbcore-framework/qb-inventory) - Inventory system for the QBCore Framework
- [qb-menu](https://github.com/qbcore-framework/qb-menu) - Menu System for the QBCore Framework
- [qb-target](https://github.com/BerkieBb/qb-target) - Targeting solution for the QBCore Framework
- [qb-input](https://github.com/qbcore-framework/qb-input) - NUI input system for the QBCore Framework

## Demo
https://streamable.com/ss5bw8

## Features
- Forge default document types
    1. ID Card
    2. Driver License
    3. Weapon License
    4. Lawyer Pass
- Supports both qb-target or PolyZone

## Installation
### Manual
- Download the script and put it in the `[qb]` directory.
- Add the following code to your qb-inventory/server/main.lua:102
```
exports('GetStashItems', GetStashItems)
```

## Configuration
```
Config = Config or {}

Config.UseTarget = GetConvar('UseTarget', 'false') == 'true'

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
            debug = true,
            length = 1,
            width = 1,
            distance = 2.0,
            created = false
        },
        ["forgerydetails"] = {
            heading = 180,
            debug = true,
            length = 1,
            width = 1,
            distance = 2.0,
            created = false
        },
        ["forgerydetailsZone"] = {
            heading = 180,
            debug = true,
            length = 1,
            width = 1,
            distance = 2.0,
            created = false
        },
        ["printdocument"] = {
            heading = 180,
            debug = true,
            length = 1,
            width = 1,
            distance = 2.0,
            created = false
        },
        ["printdocumentZone"] = {
            heading = 180,
            debug = true,
            length = 1,
            width = 1,
            distance = 2.0,
            created = false
        },
        ["exit"] = {
            heading = 180,
            debug = true,
            length = 1,
            width = 1,
            distance = 2.0,
            created = false
        }
    },
}
```
