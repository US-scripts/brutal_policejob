Config = {
    Core = 'QBCORE',  -- 'ESX' / 'QBCORE' | Other core setting on the 'core' folder.
    Billing = 'false', -- 'okokBilling' / 'esx_billing' / 'jaksam_billing'
    TextUI = 'okokTextUI', -- 'ox_lib' / 'okokTextUI' / 'ESXTextUI' / 'QBDrawText' // Custom can be add in the cl_utils.lua!!!
    ProgressBar = '', -- 'progressBars' / 'pogressBar' / 'mythic_progbar' // Custom can be add in the cl_utils.lua!!!
    Inventory = 'qb_inventory', -- 'ox_inventory' / 'qb_inventory' / 'quasar_inventory' / 'chezza_inventory' // Custom can be add in the cl_utils.lua!!!
    Metric = 'kmh', -- 'kmh' / 'mph'
    BrutalNotify = true, -- Buy here: (4€+VAT) https://store.brutalscripts.com | Or set up your own notify >> cl_utils.lua
    SteamName = false, -- true = Steam name | false = character name
    DateFormat = '%d/%m/%Y', -- Date format
    CustomOutfitMenu = false, -- If it's true, it will open a custom outfit menu, what you can edit in the cl_utils.lua line 103.

    PoliceStations = {
        
        ['Police Department'] = {
            Job = 'police', -- Job name
            MenuColors = {'rgb(15, 100, 210)', 'rgb(9, 43, 88)'}, -- Job panel color

            Blip = {color = 38, sprite = 60, size = 1.0}, -- Job blip
            Marker = {use = true, marker = 20, rgb = {15, 100, 210}, bobUpAndDown = true, rotate = false},
            
            Duty = vector3(436.76, -985.2, 31.03), -- Duty ON / OFF coords
            DutyBlips = true, -- With this the cops can see the other cops in the map.

            Cloakrooms = {
                vector3(714.11, 649.76, 128.91),
               --  You can add more...
            },

            Armorys = {
                vector3(438.29, -977.43, 31.03),
                -- You can add more...
            },

            BossMenu = {
                grades = {22},
                coords = {
                    vector3(466.91, -1000.47, 31.03),
                    -- You can add more...
                }
            },

            Garages = {
                {
                    Label = 'Garage I.', -- Gargae Label
                    menu = vector3(448.62, -1014.21, 28.96), -- Garage menu open coords
                    spawn = vector4(448.62, -1014.21, 28.96, 183.88), -- Vehicle spawn coords
                    deposit = vector3(448.62, -1014.21, 28.96), -- Vehicle deposit place

                    vehicles = {
                        ['25rnbrt'] = {
                            Label = 'moto',
                            minRank = 0
                        },

                        ['909_track'] = {
                            Label = 'Police Vehicle',
                            minRank = 0
                        },
        
                        ['909_heatcharger'] = {
                            Label = 'Police2 Vehicle',
                            minRank = 0
                        },
                    }
                },

                {
                    Label = 'Helicopter Garage',
                    menu = vector3(439.91, -989.63, 44.95),
                    spawn = vector4(439.91, -989.63, 44.95, 88.34),
                    deposit = vector3(439.91, -989.63, 44.95),

                    vehicles = {
                        ['polmav'] = {
                            Label = 'Police Helicopter',
                            minRank = 3
                        },
                    }
                },

                -- You can add more...
            },

            Shop = {
                -- minGrade = The minimum grade to access to buy the item.
                {item = 'radio', label = 'Radio', price = 0, minGrade = 0},
                --{item = 'heavyarmor', label = 'heavyarmor', price = 0, minGrade = 0},
                {item = 'weapon_flashlight', label = 'Flash Light', price = 0, minGrade = 0},
                {item = 'weapon_nightstick', label = 'Nightstick', price = 0, minGrade = 0},
                {item = 'weapon_stungun', label = 'Tazer', price = 0, minGrade = 0},
                {item = 'policetablet', label = 'policetablet', price = 0, minGrade = 0},
                {item = 'specialbadge', label = 'specialbadge', price = 0, minGrade = 0},
                {item = 'ifak', label = 'ifak', price = 0, minGrade = 0},

                -- ESX Basic Items --
                --{item = '-9', label = 'Ammo-9', price = 10, minGrade = 1},
                --{item = '-shotgun', label = 'Ammo-Shotgun', price = 20, minGrade = 3},
                --{item = '-rifle', label = 'Ammo-Rifle', price = 20, minGrade = 2},

                -- QB Basic Items --
                --{item = 'pistol_ammo', label = 'Pistol Ammo', price = 10, minGrade = 1},
                --{item = 'smg_ammo', label = 'SMG Ammo', price = 15, minGrade = 2},
                --{item = 'rifle_ammo', label = 'Rifle Ammo', price = 20, minGrade = 2},
                --{item = 'shotgun_ammo', label = 'Shotgun Ammo', price = 20, minGrade = 3},
            },
        },

        -----------------------------------------------------------
        -------------------| Sheriff Department |------------------
        -----------------------------------------------------------

        ['Sheriff Department'] = {
            Job = 'sheriff', -- Job name
            MenuColors = {'rgb(235, 164, 52)', 'rgb(181, 116, 13)'}, -- Job panel color

            Blip = {color = 22, sprite = 60, size = 1.0}, -- Job blip
            Marker = {use = true, marker = 20, rgb = {15, 100, 210}, bobUpAndDown = true, rotate = false},
            
            Duty = vector3(1829.29, 3681.42, 34.34), -- Duty ON / OFF coords
            DutyBlips = true, -- With this the cops can see the other cops in the map.

            Cloakrooms = {
                vector3(-440.2871, 6010.4814, 36.9957),
                -- You can add more...
            },

            Armorys = {
                vector3(-449.4388, 6015.1021, 36.9956),
                -- You can add more...
            },

            BossMenu = {
                grades = {3},
                coords = {
                    vector3(-432.8335, 6005.9185, 36.9957),
                    -- You can add more...
                }
            },

            Garages = {
                {
                    Label = 'Garage I.', -- Gargae Label
                    menu = vector3(-464.5174, 6025.8784, 31.3404), -- Garage menu open coords
                    spawn = vector4(-472.4534, 6035.4565, 31.3404, 228.1378), -- Vehicle spawn coords
                    deposit = vector3(-472.4534, 6035.4565, 31.3404), -- Vehicle deposit place

                    vehicles = {
                        --['MODEL'] = {
                        --    Label = 'VEHICLE-LABEL',
                        --    minRank = MINIMUM-GRADE
                        --},

                        ['sheriff'] = {
                            Label = 'Sheriff Vehicle',
                            minRank = 1
                        },
        
                        ['sheriff2'] = {
                            Label = 'Sheriff2 Vehicle',
                            minRank = 2
                        },
                    }
                },

                {
                    Label = 'Helicopter Garage',
                    menu = vector3(-467.3760, 5997.3281, 31.2556),
                    spawn = vector4(-475.5866, 5988.2788, 31.3365, 315.5201),
                    deposit = vector3(-475.5866, 5988.2788, 31.3365),

                    vehicles = {
                        ['polmav'] = {
                            Label = 'Sheriff Helicopter',
                            minRank = 3
                        },
                    }
                },

                -- You can add more...
            },

            Shop = {
                -- minGrade = The minimum grade to access to buy the item.
                {item = 'radio', label = 'Radio', price = 500, minGrade = 0},
                {item = 'sheriff_bulletproof', label = 'Bullet Proof', price = 500, minGrade = 0},
                {item = 'weapon_flashlight', label = 'Flash Light', price = 10, minGrade = 0},
                {item = 'weapon_nightstick', label = 'Nightstick', price = 10, minGrade = 0},
                {item = 'weapon_stungun', label = 'Tazer', price = 500, minGrade = 0},
                {item = 'weapon_pistol', label = 'Pistol', price = 500, minGrade = 1},
                {item = 'weapon_smg', label = 'SMG', price = 500, minGrade = 2},
                {item = 'weapon_carbinerifle', label = 'Carbinerifle', price = 500, minGrade = 2},
                {item = 'weapon_pumpshotgun', label = 'Pumpshotgun', price = 500, minGrade = 3},
                {item = 'weapon_pumpshotgun', label = 'Pumpshotgun', price = 500, minGrade = 3},

                -- ESX Basic Items --
                {item = 'ammo-9', label = 'Ammo-9', price = 10, minGrade = 1},
                {item = 'ammo-shotgun', label = 'Ammo-Shotgun', price = 20, minGrade = 3},
                {item = 'ammo-rifle', label = 'Ammo-Rifle', price = 20, minGrade = 2},

                -- QB Basic Items --
                --{item = 'pistol_ammo', label = 'Pistol Ammo', price = 10, minGrade = 1},
                --{item = 'smg_ammo', label = 'SMG Ammo', price = 15, minGrade = 2},
                --{item = 'rifle_ammo', label = 'Rifle Ammo', price = 20, minGrade = 2},
                --{item = 'shotgun_ammo', label = 'Shotgun Ammo', price = 20, minGrade = 3},
            },
        },
    },

    Commands = {
   
        JobMenu = {
            Command = 'jobmenu', 
            Control = 'F12',  -- Controls list:  https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
            Suggestion = 'Open Job Menu'
        },

        MDT = {
            Command = 'mdt', 
            Suggestion = 'Open MDT Menu'
        },

        VehiclePanel = {
            Command = 'vehiclepanel',
            Suggestion = 'Vehicle Panel Position edit'
        },

        PlateReader = {
            WhitelistedVehicles = {'police', 'police2', 'police3', 'police4', 'r1250', 'fbi2', 'sheriff', 'sheriff2'}, -- false =  not in use
            Command = 'platereader', 
            Control = '',  -- Controls list:  https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
            Suggestion = 'Plate Reader Menu'
        },

        AreaLock = {
            Command = 'arealock', 
            Suggestion = 'Area Lock Menu'
        },

        CameraRepair = {
            Command = 'camera_repair', 
            Suggestion = 'Repair the Camera'
        },

        Drag = {
            Command = 'drag', 
            Suggestion = 'Drag Animation'
        },

        RemoveObjects = {
            Command = 'removeobjects', 
            Suggestion = 'Remove Objects'
        },

        -- For Civils

        CitizenCall = {
            Command = 'citizencall', 
            Suggestion = 'Citizen Call Menu'
        },
    },

    HandCuff = {
        Freeze = false, -- Do you want to freeze the player while he is cuffed? true / false
        CuffObject = true, -- Do you want to use Cuff Object on the player's hand? true / false
        -- More controls: https://docs.fivem.net/docs/game-references/controls/
        DisableControls = {24,257,25,263,32,34,31,30,45,22,44,37,23,288,289,170,167,73,199,59,71,72,36,47,264,257,140,141,142,143,75}, -- Disabled controls while the player is cuffed.

        HandcuffKeyItem = 'handcuff_key', -- Usable item, what everyone can use to open the handcuff.
        DragBlacklistedVehicles = {'bf400', 'sanchez'}
    },

    BulletProofs = {
        Use = true, -- true = false
        Items = {
            -- Job = who can use, onlyjob = Only the job members can use? true / fase, item = ITEM
            {job = 'police', onlyjob = true, item = 'police_bulletproof'},
            {job = 'sheriff', onlyjob = true, item = 'sheriff_bulletproof'},
        }
    },

    SpeedCameras = {
        Use = true, -- true / false
        Blips = {sprite = 184, color = 82, size = 0.5}, -- Speedcameras blips
        OtherWhitelistedJobs = {'ambulance', 'sheriff', ''}, -- Other Whitelisted jobs
        Positions = {
            -- Coords, job = which job will get the money from the speedcameras, limit = speed limit, price = price (Proportional fine value), radius = radius, blip = true / false
            {coords = vector3(2076.3738, 2718.7109, 47.6280), job = 'police', limit = 50, price = 1000, radius = 5.0, blip = true},
            {coords = vector3(1320.0201, 610.4359, 80.1452), job = 'police', limit = 130, price = 3000, radius = 15.0, blip = true},
            {coords = vector3(-2686.5913, 2442.6104, 16.6781), job = 'police', limit = 130, price = 3000, radius = 15.0, blip = true},
            {coords = vector3(-1057.4922, -607.0911, 17.9110), job = 'police', limit = 110, price = 2000, radius = 25.0, blip = true},
            {coords = vector3(229.3872, -662.6493, 38.2247), job = 'police', limit = 50, price = 1000, radius = 15.0, blip = true},
            {coords = vector3(120.5341, -1378.1332, 28.8197), job = 'police', limit = 50, price = 1000, radius = 25.0, blip = true},
        }
    },

    Prison = {
        ClearInventory = false, -- true / false
        SaveFrequency = 5,
        Blip = {label = 'Prison', color = 3, sprite = 188, size = 1.25},
        Coords = vector3(1765.2253, 2560.2373, 45.5651),
        SendPlayerToJail = vector3(1840.3468, 2579.6252, 46.0143),
        FinishCoords = vector4(1847.0192, 2585.8787, 45.6726, 267.4373),

        Hospital = {
            Blip = {label = 'Prison Hospital', coords = vector3(1767.7861, 2570.3118, 45.7299), color = 2, sprite = 61, size = 0.8}, 
            ReviveTime = 15, -- in sec
            ClearInventory = true, -- true / false
            Beds = {
                {coords = vector3(1772.00, 2597.9272, 45.6585), heading = 90.0, prop = 'v_med_bed2'},
                {coords = vector3(1772.00, 2594.9656, 45.6586), heading = 90.0, prop = 'v_med_bed2'},
                {coords = vector3(1772.00, 2591.8428, 45.6586), heading = 90.0, prop = 'v_med_bed2'},
            },
        },

        Escape = {
            CanEscape = false, -- Do you want to let the players to escape from the Prison? true / false
            EscapeDistance = 500.0, -- Escape Distance

            EscapeByTunnel = {
                Use = false, -- If it's true, you have to have this required mlo: https://ed-johnsonscripts.tebex.io/package/5303552
                Price = 5000, -- Price to can use
                TimeToEscape = 30000, -- Escaping time

                Model = 's_m_y_prismuscl_01',
                Coords = vector4(1628.2682, 2584.9957, 44.5652, 1.0618),
                DoorCoords = vector4(1628.185, 2584.76, 45.5583, 1.0618),
                WalkCoords = vector4(1626.5833, 2585.4402, 45.5648, 2.9932),
                DoorObject = -904036698,
            },
        },

        Shop = {
            Blip = {label = 'Prison Shop', color = 69, sprite = 59, size = 0.8}, 
            Coords = vector3(1779.9288, 2559.0132, 45.6731),
            Items = {
                -- In ESX
                {item = 'burger', label = 'Burger', price = 1},
                {item = 'water', label = 'Water', price = 1},

                -- In QB
                --{item = 'sandwich', label = 'Sandwich', price = 1},
                --{item = 'water_bottle', label = 'Water', price = 1},
            }
        },

        Jobs = {
            Use = true,
            Blip = {label = 'Prison Job', color = 17, sprite = 66, size = 0.7},
            StartJob = vector3(1616.6893, 2576.9800, 45.8556),

            Works = {
                -- Welding
                {
                    Time = 10, -- Time in sec
                    Money = {min = 100, max = 200}, -- Mimimum, Maximum random money amount
                    Blip = {label = 'Work Possition', color = 26, sprite = 354, size = 0.8},
                    Animation = 'WORLD_HUMAN_WELDING',
                    RemoveProp = 'prop_weld_torch',
                    Positions = {
                        {Coords = vector3(1624.7623, 2575.7261, 45.5649), Heading = 270.0},
                        {Coords = vector3(1610.1010, 2568.1750, 45.5649), Heading = 45.0},
                    },
                },

                -- Hammering
                {
                    Time = 10,
                    Money = {min = 100, max = 200},
                    Blip = {label = 'Work Possition', color = 26, sprite = 402, size = 1.0},
                    Animation = 'WORLD_HUMAN_HAMMERING',
                    RemoveProp = 'prop_tool_hammer',
                    Positions = {
                        {Coords = vector3(1630.2081, 2527.3784, 45.5649), Heading = 235.0},
                        {Coords = vector3(1624.8821, 2513.2861, 45.5648), Heading = 100.0},
                    },
                },

                -- Planting
                {
                    Time = 10,
                    Money = {min = 100, max = 200},
                    Blip = {label = 'Work Possition', color = 2, sprite = 1, size = 0.75},
                    Animation = 'WORLD_HUMAN_GARDENER_PLANT',
                    RemoveProp = 'prop_cs_trowel',
                    Positions = {
                        {Coords = vector3(1771.3270, 2546.0410, 45.5871), Heading = 275.0},
                        {Coords = vector3(1757.6355, 2550.0220, 45.5651), Heading = 130.0},
                        {Coords = vector3(1700.1659, 2536.5183, 45.5595), Heading = 150.0},
                    },
                },

                -- Cleaning
                {
                    Time = 10,
                    Money = {min = 100, max = 200},
                    Blip = {label = 'Work Possition', color = 5, sprite = 1, size = 0.75},
                    Animation = 'WORLD_HUMAN_MAID_CLEAN',
                    RemoveProp = 'prop_rag_01',
                    Positions = {
                        {Coords = vector3(1781.9982, 2558.9646, 45.6732), Heading = 0.0},
                        {Coords = vector3(1784.3669, 2563.7920, 45.6731), Heading = 0.0},
                        {Coords = vector3(1784.2422, 2552.7314, 45.6731), Heading = 0.0},
                    },
                },

                -- You can add more...
            },
        },

        PrisonGuards = {
            {Model = 'mp_m_securoguard_01', Coords = vector4(1759.9581, 2413.7534, 45.3684, 28.3456), Distance = 10.0},
            {Model = 'mp_m_securoguard_01', Coords = vector4(1820.5490, 2477.2603, 45.3775, 58.4353), Distance = 10.0},
            {Model = 'mp_m_securoguard_01', Coords = vector4(1659.2534, 2398.5969, 45.4038, 1.3208), Distance = 10.0},
            {Model = 'mp_m_securoguard_01', Coords = vector4(1544.2542, 2470.9983, 45.3487, 291.0606), Distance = 10.0},
            {Model = 'mp_m_securoguard_01', Coords = vector4(1538.5869, 2585.3689, 45.3398, 276.2064), Distance = 10.0},
            {Model = 'mp_m_securoguard_01', Coords = vector4(1572.9132, 2678.1006, 45.3943, 241.9367), Distance = 10.0},
            {Model = 'mp_m_securoguard_01', Coords = vector4(1650.8765, 2754.4700, 45.4991, 204.2366), Distance = 10.0},
            {Model = 'mp_m_securoguard_01', Coords = vector4(1772.0437, 2758.9846, 45.5022, 158.1188), Distance = 10.0},
            {Model = 'mp_m_securoguard_01', Coords = vector4(1844.9613, 2699.1370, 45.5318, 91.8540), Distance = 10.0},
            {Model = 'mp_m_securoguard_01', Coords = vector4(1819.9763, 2621.6011, 45.5227, 84.6645), Distance = 10.0},
            {Model = 'mp_m_securoguard_01', Coords = vector4(1796.1647, 2620.0349, 45.5651, 357.4224), Distance = 10.0},
            {Model = 'mp_m_securoguard_01', Coords = vector4(1797.2832, 2590.6509, 45.6206, 190.7684), Distance = 10.0},
            {Model = 'mp_m_securoguard_01', Coords = vector4(1822.2632, 2608.7876, 45.5931, 92.6341), Distance = 20.0},
        },
    },

    SecurityCameras = {
        hack = {
            enable = true, -- Camera Hacking | true = false
            time = 30, -- Hacking time
            removeItem = false, -- Remove the item? | true = false
            item = 'cam_hacking', -- Camera Hacking item
            distance = 15.0 -- The player should be at this distance from camera object
        },

        cameras = {
            [1] = {label = "Prison CAM#1", coords = vector3(1768.84, 2530.96, 50.06), r = {x = -15.0, y = 0.0, z = 42.78}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123279267539730493/1.png'},
            [2] = {label = "Prison CAM#2", coords = vector3(1616.35, 2522.01, 50.12), r = {x = -15.0, y = 0.0, z = 300.78}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123279278671417486/2.png'},
            [3] = {label = "Prison CAM#3", coords = vector3(1694.99, 2529.18, 59.00), r = {x = -15.0, y = 0.0, z = 300.78}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123279288834195577/3.png'},
            [4] = {label = "Pacific Bank CAM#1", coords = vector3(235.35, 227.76, 113.83), r = {x = -35.0, y = 0.0, z = 220.05}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123279610604425327/4.png'},
            [5] = {label = "Pacific Bank CAM#2", coords = vector3(232.64, 221.82, 108.47), r = {x = -25.0, y = 0.0, z = -140.91}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123279622096818266/5.png'},
            [6] = {label = "Pacific Bank CAM#3", coords = vector3(251.83, 225.38, 104.50), r = {x = -35.0, y = 0.0, z = -74.87}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123279633509535854/6.png'},
            [7] = {label = "Jewelery CAM#1", coords = vector3(-620.28, -224.15, 40.32), r = {x = -25.0, y = 0.0, z = 165.78}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123280883814764574/7.png'},
            [8] = {label = "Jewelery CAM#2", coords = vector3(-627.47, -239.98, 40.30), r = {x = -25.0, y = 0.0, z = -10.78}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123281525883031552/8.png'},
            [9] = {label = "Paleto Bank #1", coords = vector3(-115.40, 6472.91, 33.00), r = {x = -25.0, y = 0.0, z = 200.1595}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123289550551261344/11.png'},
            [10] = {label = "Paleto Bank #2", coords = vector3(-108.02, 6462.61, 33.40), r = {x = -25.0, y = 0.0, z = 360.00}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123289558289760396/12.png'},
            [11] = {label = "Paleto Bank #3", coords = vector3(-104.62, 6479.42, 33.38), r = {x = -25.0, y = 0.0, z = 182.00}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123289568263807019/13.png'},
            [12] = {label = "Paleto Bank #4", coords = vector3(-107.89, 6468.54, 33.90), r = {x = -25.0, y = 0.0, z = 216.00}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123289575872286790/14.png'},
            [13] = {label = "Fleeca Bank #1", coords = vector3(146.52, -1038.20, 30.72), r = {x = -25.0, y = 0.0, z = 250.1595}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123283944394211389/9.png'},
            [14] = {label = "Fleeca Bank #1", coords = vector3(150.01, -1051.31, 31.10), r = {x = -25.0, y = 0.0, z = 25.1595}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123283959363682304/10.png'},
            [15] = {label = "Fleeca Bank #2", coords = vector3(1179.08, 2705.60, 39.40), r = {x = -25.0, y = 0.0, z = 90.1595}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123283944394211389/9.png'},
            [16] = {label = "Fleeca Bank #2", coords = vector3(1171.28, 2716.70, 39.82), r = {x = -25.0, y = 0.0, z = 225.1595}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123283959363682304/10.png'},
            [17] = {label = "Fleeca Bank #3", coords = vector3(-1216.80, -331.46, 39.0), r = {x = -25.0, y = 0.0, z = 290.1595}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123283944394211389/9.png'},
            [18] = {label = "Fleeca Bank #3", coords = vector3(-1204.83, -337.83, 39.51), r = {x = -25.0, y = 0.0, z = 80.1595}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123283959363682304/10.png'},
            [19] = {label = "Fleeca Bank #4", coords = vector3(-2963.95, 478.96, 17.06), r = {x = -25.0, y = 0.0, z = 350.1595}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123283944394211389/9.png'},
            [20] = {label = "Fleeca Bank #4", coords = vector3(-2952.67, 486.13, 17.47), r = {x = -25.0, y = 0.0, z = 140.1595}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123283959363682304/10.png'},
            [21] = {label = "Fleeca Bank #5", coords = vector3(310.85, -276.56, 55.47), r = {x = -25.0, y = 0.0, z = 250.1595}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123283944394211389/9.png'},
            [22] = {label = "Fleeca Bank #5", coords = vector3(314.34, -289.67, 56.23), r = {x = -25.0, y = 0.0, z = 25.1595}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123283959363682304/10.png'},
            [23] = {label = "Fleeca Bank #6", coords = vector3(-354.35, -47.43, 50.69), r = {x = -25.0, y = 0.0, z = 250.1595}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123283944394211389/9.png'},
            [24] = {label = "Fleeca Bank #6", coords = vector3(-350.62, -60.48, 50.76), r = {x = -25.0, y = 0.0, z = 25.1595}, img = 'https://cdn.discordapp.com/attachments/907358524907081798/1123283959363682304/10.png'},
        },
    },

    -----------------------------------------------------------
    -----------------------| TRANSLATE |-----------------------
    -----------------------------------------------------------

    MoneyForm = '$', -- Money form

    -- All Licences Label
    Licences = {
        ['weapon'] = 'Weapon Licence',
        ['dmv'] = 'DMV Licence',
        ['drive'] = 'Drive Licence',
        ['driver'] = 'Drive Licence',
        ['bike'] = 'Bike Licence',
        ['hunting'] = 'Hunting Licence',
        ['business'] = 'Business Licence',
    },

    Locales = {
        CameraLabel = 'Left ~INPUT_CELLPHONE_LEFT~ Right ~INPUT_CELLPHONE_RIGHT~\nUp  ~INPUT_CELLPHONE_UP~ Down ~INPUT_CELLPHONE_DOWN~\n~r~Cancel ~INPUT_CELLPHONE_CANCEL~',
        ObjectLabel = 'Rotate Object ~INPUT_CELLPHONE_LEFT~ & ~INPUT_CELLPHONE_RIGHT~\n~b~Place Object~w~ ~INPUT_FRONTEND_RDOWN~',
        Male = 'Male',
        Female = 'Female',
        SpeedCameraFine = 'Speed Camera - Speed:',
        SpeedCameraBlipLabel = 'Speed Camera',
        None = 'None',
        Jail = 'Jail',
        Reason = 'Reason',
        Time = 'Time',

        -- Job Menu Locales

        CitizenInteractions = 'Citizen Interactions',
        Search = 'Search',
        Cuff = 'Cuff',
        Uncuff = 'Uncuff',
        Drag = 'Drag',
        InOutOfVehicle = 'In/out of vehicle',

        VehicleInteractions = 'Vehicle Interactions',
        Lockpick = 'Lockpick',
        WheelClamp = 'Wheel clamp',
        Impound = 'Impound',
        VehicleSearch = 'Search',

        Objects = 'Objects',
        Cone = 'Cone',
        Barrier = 'Barrier',
        Spikestrips = 'Spikestrips',
        Tent = 'Tent',
        Light = 'Light',

        MDT = 'MDT'
    },

    Texts = {
        [1] = {'[E] - To open the dress menu', 38},
        [2] = {'[E] - To open the armory menu', 38},
        [3] = {'[E] - To open the garage menu', 38},
        [4] = {'[E] - To deposit the vehicle', 38},
        [5] = {'[E] - To Duty ON', '[E] - To Duty OFF', 38},
        [6] = {'[E] - Search Vehicle Trunk', 38},
        [7] = {'[E] - Search Vehicle Glovebox', 38},
        [8] = {'[E] - Remove Object', 38},
        [9] = {'[E] - Start Job', 38},
        [10] = {'[E] - Finish Job', 38},
        [11] = {'[E] - Start Work', 38},
        [12] = {'[E] - Escape By Tunnel', 38},
        [13] = {'[E] - Shop', 38},
        [14] = {'[E] - Send Player To Jail', 38},
        [15] = {'[E] - To open the Boss Menu', 38},
    },
    
    -- Notify function EDITABLE >> cl_utils.lua
    Notify = { 
        [1] = {"POLICE JOB", "No vehicle available for your rank.", 5000, "error"},
        [2] = {"POLICE JOB", "You can't deposit this Vehicle.", 5000, "error"},
        [3] = {"POLICE JOB", "Duty status: <b>ON", 5000, "info"},
        [4] = {"POLICE JOB", "Duty status: <b>OFF", 5000, "info"},
        [5] = {"POLICE JOB", "Something is in the way!", 5000, "error"},
        [6] = {"POLICE JOB", "There isn't free seat in the Vehicle!", 5000, "error"},
        [7] = {"POLICE JOB", "You got:", 5000, "info"},
        [8] = {"POLICE JOB", "<br>You spent:<b>", 5000, "info"},
        [9] = {"POLICE JOB", "You can't use it.", 5000, "error"},
        [10] = {"POLICE JOB", "You don't have enough money!", 5000, "error"},
        [11] = {"POLICE JOB", "<b>You have started Work!</b> Go to the Point, marked on the map! You will receive Money when you finish the Job.", 10000, "info"},
        [12] = {"POLICE JOB", "Go to the Next Point, marked on the map!", 5000, "info"},
        [13] = {"POLICE JOB", "The Prison Guard bringed you back!", 5000, "info"},
        [14] = {"POLICE JOB", "You do not have enough cash:", 5000, "error"},
        [15] = {"POLICE JOB", "The door is opening, escape!", 5000, "success"},
        [16] = {"POLICE JOB", "Please DO NOT SPAM!", 8000, "error"},
        [17] = {"POLICE JOB", "You aren't near to a Camera Object!", 5000, "error"},
        [18] = {"POLICE JOB", "Hack FAILED!", 5000, "error"},
        [19] = {"POLICE JOB", "Hack SUCCESS! The camera has been deactivated.", 5000, "success"},
        [20] = {"POLICE JOB", "You have successfully repaired the Camera!", 6000, "success"},
        [21] = {"POLICE JOB", "You have successfully submitted!", 6000, "success"},
        [22] = {"POLICE JOB", "You have successfully created a fine!", 6000, "success"},
        [23] = {"POLICE JOB", "There are no player near you!", 6000, "error"},
        [24] = {"POLICE JOB", "Jail time is over!", 6000, "success"},
        [25] = {"POLICE JOB", "You have successfully escaped!", 6000, "success"},
        [26] = {"POLICE JOB", "You can't escape!", 6000, "error"},
        [27] = {"POLICE JOB", "Citizen Call <br>Street: ", 6000, "info"},
        [28] = {"POLICE JOB", "No one nearby to drag!", 6000, "error"},
        [29] = {"POLICE JOB", "Someone is in the Vehicle!", 6000, "error"},
        [30] = {"POLICE JOB", "You have to put a Wheel Clamp to the Wheel first.", 6000, "error"},
    },

    Progressbar = {
        DutyOFF = 'Duty OFF...',
        DutyON = 'Duty ON...',
        Working = 'Working...',
        WheelClampPlacing = 'Placing Wheel Clamp...',
        Impound = 'Impound...'
    },
    
    Webhooks = {
        Use = true, -- Use webhooks? true / false
        Locale = {
            ['ItemBought'] = 'Item Bought',
            ['CitizenCallOpen'] = 'Citizen Call - Open',
            ['CitizenCallClose'] = 'Citizen Call - Close',
            ['FineCreated'] = 'Fine Created',
            ['Jail'] = 'Jail',
            ['Unjail'] = 'Unjail',

            ['PlayerName'] = 'Player Name',
            ['Identifier'] = 'Identifier',
            ['Items'] = 'Items',
            ['Text'] = 'Text',
            ['Callid'] = 'Call ID',
            ['Coords'] = 'Coords',
            ['Assistant'] = 'Assistant',
            ['CloseReason'] = 'Close Reason',
            ['Receiver'] = 'Receiver',
            ['Amount'] = 'Amount',
            ['Job'] = 'Job',
            ['Reason'] = 'Reason',

            ['Time'] = 'Time ⏲️'
        },

        -- To change a webhook color you need to set the decimal value of a color, you can use this website to do that - https://www.mathsisfun.com/hexadecimal-decimal-colors.html
        Colors = {
            ['SubAccountCreated'] = 3145631, 
            ['SubAccountDeleted'] = 16711680,
            ['PermissionTableRefreshed'] = 10155240
        }
    },

    -----------------------------------------------------------
    -----------------------| UNIFORMS |------------------------
    -----------------------------------------------------------

    CitizenWear = {label = "Citizen Wear"},

    Uniforms = {
        {
            label = 'Police Dress', -- Uniform Label
            jobs = {
                -- Job = job name, grades = grades
                {job = 'police', grades = {0,1,2,3}},
                -- More jobs
            },
            male = {
                ['t-shirt'] = {item = 58, texture = 0},
                ['torso2'] = {item = 55, texture = 0},
                ['arms'] = {item = 41, texture = 0},
                ['pants'] = {item = 25, texture = 0},
                ['shoes'] = {item = 25, texture = 0},
                ['hat'] = {item = -1, texture = 0},
                ['accessory'] = {item = 0, texture = 0},
                ['ear'] = {item = 2, texture = 0},
                ['decals'] = {item = 0, texture = 0},
                ['mask'] = {item = 0, texture = 0}
            },
            female = {
                ['t-shirt'] = {item = 35, texture = 0},
                ['torso2'] = {item = 48, texture = 0},
                ['arms'] = {item = 44, texture = 0},
                ['pants'] = {item = 34, texture = 0},
                ['shoes'] = {item = 27, texture = 0},
                ['hat'] = {item = -1, texture = 0},
                ['accessory'] = {item = 0, texture = 0},
                ['ear'] = {item = 2, texture = 0},
                ['decals'] = {item = 0, texture = 0},
                ['mask'] = {item = 0, texture = 0}
            },
        },
        {
            label = 'Visibility Vest',
            jobs = {
                {job = 'police', grades = {0,1,2,3,4}},
            },
            male = {
                ['t-shirt'] = {item = 59, texture = 1},
            },
            female = {
                ['t-shirt'] = {item = 36, texture = 1},
            }
        },
        {
            label = 'Boss Dress',
            jobs = {
                {job = 'police', grades = {4}},
            },
            male = {
                ['t-shirt'] = {item = 58, texture = 0},
                ['torso2'] = {item = 55, texture = 0},
                ['arms'] = {item = 41, texture = 0},
                ['pants'] = {item = 25, texture = 0},
                ['shoes'] = {item = 25, texture = 0},
                ['hat'] = {item = -1, texture = 0},
                ['accessory'] = {item = 0, texture = 0},
                ['ear'] = {item = 2, texture = 0},
                ['decals'] = {item = 8, texture = 3},
                ['mask'] = {item = 0, texture = 0}
            },
            female = {
                ['t-shirt'] = {item = 35, texture = 0},
                ['torso2'] = {item = 48, texture = 0},
                ['arms'] = {item = 44, texture = 0},
                ['pants'] = {item = 34, texture = 0},
                ['shoes'] = {item = 27, texture = 0},
                ['hat'] = {item = -1, texture = 0},
                ['accessory'] = {item = 0, texture = 0},
                ['ear'] = {item = 2, texture = 0},
                ['decals'] = {item = 7, texture = 3},
                ['mask'] = {item = 0, texture = 0}
            }
        },
    },

    PrisonUniform = {
        male = {
            ['t-shirt'] = {item = 15, texture = 0},
            ['torso2'] = {item = 146, texture = 0},
            ['arms'] = {item = 74, texture = 0},
            ['pants'] = {item = 3, texture = 7},
            ['shoes'] = {item = 3, texture = 12},
            ['hat'] = {item = -1, texture = 0},
            ['accessory'] = {item = 0, texture = 0},
            ['ear'] = {item = -1, texture = 0},
            ['decals'] = {item = 0, texture = 0},
            ['mask'] = {item = 0, texture = 0}
        },
        female = {
            ['t-shirt'] = {item = 3, texture = 0},
            ['torso2'] = {item = 38, texture = 3},
            ['arms'] = {item = 2, texture = 0},
            ['pants'] = {item = 3, texture = 15},
            ['shoes'] = {item = 66, texture = 5},
            ['hat'] = {item = -1, texture = 0},
            ['accessory'] = {item = 0, texture = 0},
            ['ear'] = {item = -1, texture = 0},
            ['decals'] = {item = 0, texture = 0},
            ['mask'] = {item = 0, texture = 0}
        }
    },
}