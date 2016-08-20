//
//  AppConstant.swift
//  Blasteem
//
//  Created by k on 8/18/16.
//  Copyright © 2016 beneta. All rights reserved.
//

import Foundation

let mainColor = UIColor(red:0.05, green:0.94, blue:0.85, alpha:1.0)

//User Defaults Constants
let APP_TOKEN = "app_token"
let Current_User = "currentUser"
struct AppCredential {
    static let API_UNAME = "apiuser"
    static let API_PWD = "SJmPgYR!2LFkrB%dx65cYT8C"
    
    static let CLIENT_ID = "5CXEOvasCDNRyeDHJmfmw3Y4YXGad4"
    static let CLIENT_SECRET = "7iG4WvA7XcLL3jZG1J3h5zk4Ej1ktf"
    
    
}

struct ApiUrl {
    
    static let BASEURL = "https://blasteem.stringsoftware.space/"
    static let LOGIN = "login"
    static let CREATETOKEN = "oauth/token"
    static let REGISTER = "wp-json/wp/v2/users/register"
    static let REGISTER_FB = "wp-json/wp/v2/users/facebook-register"
    static let REGISTER_GOOGLE = "wp-json/wp/v2/users/google-register"
    static let VALIDATE_FB = "wp-json/wp/v2/users/validate-facebook-user"
    static let VALIDATE_GOOGLE = "wp-json/wp/v2/users/validate-google-user"
    static let VALIDATE_USER = "wp-json/wp/v2/users/validate-wpuser-credentials"
}

struct AppFont {
    static let OpenSans_10 = UIFont(name: "OpenSans", size: 10)
    static let OpenSans_12 = UIFont(name: "OpenSans", size: 12)
    static let OpenSans_13 = UIFont(name: "OpenSans", size: 13)
    static let OpenSans_14 = UIFont(name: "OpenSans", size: 14)
    static let OpenSans_16 = UIFont(name: "OpenSans", size: 16)
    static let OpenSans_18 = UIFont(name: "OpenSans", size: 18)
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.mainScreen().bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.mainScreen().bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
    static let IS_IPHONE_4_OR_LESS  = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPAD              = UIDevice.currentDevice().userInterfaceIdiom == .Pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}
let province_arr = ["Agrigento",
                    "Alessandria",
                    "Ancona",
                    "Aosta",
                    "Arezzo",
                    "Ascoli Piceno",
                    "Asti",
                    "Avellino",
                    "Bari",
                    "Barletta-Andria-Trani",
                    "Belluno",
                    "Benevento",
                    "Bergamo",
                    "Biella",
                    "Bologna",
                    "Bolzano",
                    "Brescia",
                    "Brindisi",
                    "Cagliari",
                    "Caltanissetta",
                    "Campobasso",
                    "Carbonia-Iglesias",
                    "Caserta",
                    "Catania",
                    "Catanzaro",
                    "Chieti",
                    "Como",
                    "Cosenza",
                    "Cremona",
                    "Crotone",
                    "Cuneo",
                    "Enna",
                    "Fermo",
                    "Ferrara",
                    "Firenze",
                    "Foggia",
                    "Forlì-Cesena",
                    "Frosinone",
                    "Genova",
                    "Gorizia",
                    "Grosseto",
                    "Imperia",
                    "Isernia",
                    "La Spezia",
                    "L\'Aquila",
                    "Latina",
                    "Lecce",
                    "Lecco",
                    "Livorno",
                    "Lodi",
                    "Lucca",
                    "Macerata",
                    "Mantova",
                    "Massa-Carrara",
                    "Matera",
                    "Messina",
                    "Milano",
                    "Modena",
                    "Monza e della Brianza",
                    "Napoli",
                    "Novara",
                    "Nuoro",
                    "Olbia-Tempio",
                    "Oristano",
                    "Padova",
                    "Palermo",
                    "Parma",
                    "Pavia",
                    "Perugia",
                    "Pesaro e Urbino",
                    "Pescara",
                    "Piacenza",
                    "Pisa",
                    "Pistoia",
                    "Pordenone",
                    "Potenza",
                    "Prato",
                    "Ragusa",
                    "Ravenna",
                    "Reggio Calabria",
                    "Reggio Emilia",
                    "Rieti",
                    "Rimini",
                    "Roma",
                    "Rovigo",
                    "Salerno",
                    "Medio Campidano",
                    "Sassari",
                    "Savona",
                    "Siena",
                    "Siracusa",
                    "Sondrio",
                    "Taranto",
                    "Teramo",
                    "Terni",
                    "Torino",
                    "Ogliastra",
                    "Trapani",
                    "Trento",
                    "Treviso",
                    "Trieste",
                    "Udine",
                    "Varese",
                    "Venezia",
                    "Verbano-Cusio-Ossola",
                    "Vercelli",
                    "Verona",
                    "Vibo Valentia",
                    "Vicenza",
                    "Viterbo"]

let sex_arr = ["Maschio","Femmina"]

let USER_DEFAULTS:NSUserDefaults = NSUserDefaults.standardUserDefaults()