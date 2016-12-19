//
//  Forecast.swift
//  Twilight
//
//  Created by Mark on 12/19/16.
//  Copyright © 2016 Mark Feldman. All rights reserved.
//

import UIKit
import SwiftyJSON

class Forecast: NSObject {
    
    var forecastDays = [ForecastDay]()
    
    init(withDict json: JSON) throws {
        
        guard let txtForecastDays = json["txt_forecast"]["forecastday"].array else {
            throw SerializationError.invalid
        }
        
        guard let simpleForecastDays = json["simpleforecast"]["forecastday"].array else {
            throw SerializationError.invalid
        }
        
        for i in 0..<simpleForecastDays.count {
            let forecastDay = ForecastDay(txtForecast: txtForecastDays[i], simpleForecast: simpleForecastDays[i])
            forecastDays.append(forecastDay)
            
        }
    }
    
}

struct ForecastDay {
    var forecastText: String
    var title: String
    var pop: String
    var date: Date
    var highF: String
    var highC: String
    var lowF: String
    var lowC: String
    var conditions: String
    
    init(txtForecast: JSON, simpleForecast: JSON) {
        forecastText = txtForecast["fcttext"].stringValue
        pop = txtForecast["pop"].stringValue
        title = txtForecast["title"].stringValue
        
        date = Date(json: simpleForecast["date"])
        highF = simpleForecast["high"]["fahrenheit"].stringValue
        highC = simpleForecast["high"]["celsius"].stringValue
        lowF = simpleForecast["low"]["fahrenheit"].stringValue
        lowC = simpleForecast["low"]["celsius"].stringValue
        conditions = simpleForecast["conditions"].stringValue
    }
    
}

struct Date {
    var epoch: String
    var pretty: String
    var day: Int
    var month: Int
    var year: Int
    var monthName: String
    var monthNameShort: String
    var weekdayShort: String
    var weekday: String
    var ampm: String
    var tzShort: String
    var tzLong: String
    
    init(json: JSON) {
        epoch = json["epoch"].stringValue
        pretty = json["pretty"].stringValue
        day = json["day"].intValue
        month = json["month"].intValue
        year = json["year"].intValue
        monthName = json["monthName"].stringValue
        monthNameShort = json["monthNameShort"].stringValue
        weekday = json["weekday"].stringValue
        weekdayShort = json["weekdayShort"].stringValue
        ampm = json["ampm"].stringValue
        tzShort = json["tz_short"].stringValue
        tzLong = json["tz_long"].stringValue
    }
}
