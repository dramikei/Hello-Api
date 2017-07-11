//
//  Controller.swift
//  hello-api
//
//  Created by Raghav Vashisht on 08/07/17.
//
//

import Foundation
import SwiftyJSON
import LoggerAPI
import CloudFoundryEnv
import Configuration
import Kitura
#if os(Linux)
    import Glibc
#else
    import Darwin
#endif


public class Controller  {
    let router:Router
    let appEnv:ConfigurationManager
    
    var url:String {
        get {return appEnv.url}
    }
    
    var port: Int {
        get {return appEnv.port}
    }
    
    var vehicleArray:[Dictionary<String, Any>] = [
        
        ["Make":"Nissan", "Model":"Murano", "Year":2017],
        ["Make":"Dodge", "Model":"Ram", "Year":2012],
        ["Make":"Nissan", "Model":"Rogue", "Year":2016]
        
    ]
    init() throws {
        appEnv = ConfigurationManager()
        router = Router()
        router.get("/", handler: getMain)
        router.get("/vehicles", handler: getAllVehicles)
        router.get("/vehicles/random", handler: getRandomVehicle)
    }
    func getMain(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        Log.debug("GET - / router handler...")
        
        var json = JSON([:])
        json["course"].stringValue = "Beginner API development with Swift,Kitura"
        json["myName"].stringValue = "Raghav Vashisht"
        json["company"].stringValue = "VashishtApps"
        try response.status(.OK).send(json: json).end()
    }
    func getAllVehicles(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        let json = JSON(vehicleArray)
        try response.status(.OK).send(json: json).end()
    }
    func getRandomVehicle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        #if os(Linux)
            srandom(UInt32(Date().timeIntervalSince1970))
            let index = random() % vehicleArray.count
        #else
            let index = Int(arc4random_uniform(UInt32(vehicleArray.count)))
        #endif
        let json = JSON(vehicleArray[index])
        try response.status(.OK).send(json: json).end()
    }
}
