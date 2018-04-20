//
//  Savings.swift
//  Saving worth calculator
//
//  Created by Shubh Chopra on 8/16/17.
//  Copyright © 2017 Shubh Chopra. All rights reserved.
//

import Foundation

class Savings: NSObject, NSCoding {
    
    struct Keys {
        static let memo = "Memo"
        static let principle = "Principle"
        static let intrest = "Intrest"
        static let date = "Date"
        static let currency = "Currency"
        
    }
    private var memo = "";
    private var principle:Float = 0.0
    private var intrest:Float = 0.0
    private var date:NSDate!;
    private var currency = "";
    
    init(Memo: String,Principle: Float,Intrest: Float,Date:NSDate,Currency:String) {
        self .memo = Memo
        self .principle = Principle
        self .intrest = Intrest
        self .date = Date
        self .currency = Currency
    }
    required init(coder decoder: NSCoder ) {
        if let memoObj = decoder.decodeObject(forKey: Keys.memo) as? String{
            memo = memoObj
        }
            principle = decoder.decodeFloat(forKey: Keys.principle)
            intrest = decoder.decodeFloat(forKey: Keys.intrest)
        if let dateObj = decoder.decodeObject(forKey: Keys.date) as? NSDate{
            date = dateObj
        }
        if let currencyObj = decoder.decodeObject(forKey: Keys.currency) as? String{
            currency = currencyObj
        }
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(memo, forKey: Keys.memo)
        coder.encode(principle, forKey: Keys.principle)
        coder.encode(date, forKey: Keys.date)
        coder.encode(currency, forKey: Keys.currency)
        coder.encode(intrest, forKey: Keys.intrest)
    }
    var Memo: String{
        get{
            return memo;
        }
        set{
            memo = newValue;
        }
    }
    var Principle: Float{
        get{
            return principle;
        }
        set{
            principle = newValue;
        }
    }
    var Intrest: Float{
        get{
            return intrest;
        }
        set{
            intrest = newValue;
        }
    }
    var Date: NSDate{
        get{
            return date;
        }
        set{
            date = newValue;
        }
    }
    var Currency: String{
        get{
            return currency;
        }
        set{
            currency = newValue;
        }
    }
}
