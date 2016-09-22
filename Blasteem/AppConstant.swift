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
let ApplicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
let APP_TOKEN = "app_token"
let IS_LOGIN = "is_login"
let Current_User = "currentUser"
let Current_User_ID = "currentUserId"
struct AppCredential {
    static let API_UNAME = "apiuser"
    static let API_PWD = "NcQDu)!vXzZ8(%RWxv8fr%v&"
    
    static let CLIENT_ID = "uzwqqW6Gdmx1jYggXK8OJ9kzvWc4J1"
    static let CLIENT_SECRET = "MeAjF1fLHt7furdLHbwQZgZjPvg1A0"
    static let NOTIFICATION_TOKEN = "APA91bG-399h-qD_OFTwxjbzWaKYeWMSTjNrH_qnjxGZqpaPbJpFB8sKV27BsSSza6KoIUm3JDERMSmrmcK73sCmJ5XvenVxczQrV72AtMORE8WMtLbTUHY"
    
}

struct ApiUrl {
    
    static let BASEURL = "https://www.blasteem.com/"
    
    static let NEWS = "news/"
    static let MEET = "meet/"
    static let FACTORY = "e-la-factory/"
    static let ABOUTUS = "about-us/"
    static let FAQ = "faq/"
    
    static let LOGIN = "login"
    static let CREATETOKEN = "oauth/token"
    static let REGISTER = "wp-json/wp/v2/users/register"
    static let UPDATE_PROFILE = "wp-json/wp/v2/users/update_user_profile"
    static let GET_USER_PROFILE = "wp-json/wp/v2/users/get_user_profile"
    
    static let REGISTER_FB = "wp-json/wp/v2/users/facebook-register"
    static let REGISTER_GOOGLE = "wp-json/wp/v2/users/google-register"
    static let VALIDATE_FB = "wp-json/wp/v2/users/validate-facebook-user"
    static let VALIDATE_GOOGLE = "wp-json/wp/v2/users/validate-google-user"
    static let VALIDATE_USER = "wp-json/wp/v2/users/validate-wpuser-credentials"
    static let GET_ME = "wp-json/wp/v2/users/"
    static let RESET_PASSWORD = "wp-json/wp/v2/users/resetpassword"
    static let GET_VIDEO_LIST = "wp-json/wp/v2/videos/get-video-list/"
    static let GET_NEWS_LIST = "wp-json/wp/v2/videos/get_news/"
    static let GET_MEETS_LIST = "wp-json/wp/v2/videos/get_meets/"
    static let GET_SINGLE_VIDEO_INFO = "wp-json/wp/v2/videos/get-blasteem-video-info/"
    static let GET_CATEGORIES = "wp-json/wp/v2/videos/get_categories"
    static let GET_CREATORS = "wp-json/wp/v2/videos/get_creators"
    static let GET_CREATOR_INFO = "wp-json/wp/v2/creator/get_creator_info"
    static let VALIDATE_FOLLOW_CREATOR = "wp-json/wp/v2/videos/validate_creator_follow"
    static let FOLLOW_AUTHOR = "wp-json/wp/v2/videos/follow-author"
    static let GET_SUBSCRIPTIONS = "wp-json/wp/v2/videos/get_subscriptions"
    
    static let GET_COMMENTS = "wp-json/wp/v2/videos/get_comments"
    
    static let ADD_COMMENTS = "wp-json/wp/v2/videos/add_comment"
    
    static let BLAST_VIDEO = "wp-json/wp/v2/videos/blast-it"
    static let LIKE_VIDEO = "wp-json/wp/v2/videos/like-it"
    static let GET_NOTIFICATIONS = "pnfw/posts/"
    static let GET_TERMS = "wp-json/wp/v2/users/get_terms_and_conditions"
    
}

struct AppFont {
    static let OpenSans_10 = UIFont(name: "OpenSans", size: 10)
    static let OpenSans_12 = UIFont(name: "OpenSans", size: 12)
    static let OpenSans_13 = UIFont(name: "OpenSans", size: 13)
    static let OpenSans_14 = UIFont(name: "OpenSans", size: 14)
    static let OpenSans_15 = UIFont(name: "OpenSans", size: 15)
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