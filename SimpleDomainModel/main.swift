//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

public func testMe() -> String {
    return "I have been tested"
}

public class TestMe {
    public func Please() -> String {
        return "I have been tested"
    }
}

////////////////////////////////////
// Money
//

// maps currency types relative to USD
let currMap = ["USD" : 1, "GBP" : 0.5, "EUR" : 1.5, "CAN" : 1.25]

public struct Money {
    public var amount : Int
    public var currency : String
    
    public func convert(to: String) -> Money {
        if currMap.keys.contains(to) {
            return Money(amount: Int((Double(self.amount) / currMap[self.currency]!) * currMap[to]!), currency: to)
        } else {
            print("cannot convert to currency type", to)
            exit(1)
        }
    }
    
    public func add(to: Money) -> Money {
        return Money(amount: self.convert(to.currency).amount + to.amount, currency: to.currency)
    }
    public func subtract(from: Money) -> Money {
        return Money(amount: from.amount - self.convert(from.currency).amount, currency: from.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    var title : String
    var salary : JobType
    
    public init(title : String, type : JobType) {
        self.title = title
        self.salary = type
    }
    
    public func calculateIncome(hours: Int) -> Int {
        return Int(self.salary * hours)
    }

    public func raise(amt : Double) {
    }
}

////////////////////////////////////
// Person
//
public class Person {
    public var firstName : String = ""
    public var lastName : String = ""
    public var age : Int = 0
    
    public var job : Job? {
        get { return self.job }
        set(value) {
            if age >= 16 {
                self.job = value
            }
        }
    }
    
    public var spouse : Person? {
        get { return self.spouse }
        set(value) {
            if age >= 18 {
                self.spouse = value
            }
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    public func toString() -> String {
        var string = "Person: {" + "\n\tfirstName: " + self.firstName
        string += "\n\tlastName: " + self.lastName + "\n\tage: " + String(self.age)
        if self.job != nil {
            string += "\n\tjob: " + (self.job?.title)!
        }
        if self.spouse != nil {
            let other = self.spouse!
            string += "\n\tspouse: " + other.firstName + " " + other.lastName
        }
        return string + "\n}"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    private var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
        }
        self.members.append(spouse1)
        self.members.append(spouse2)
    }
    
    public func haveChild(child: Person) -> Bool {
        if child.age == 0 {
            self.members.append(child)
            return true
        }
        return false
    }
    
    public func householdIncome() -> Int {
        var totalIncome = 0
        self.members.forEach({ (member : Person) -> () in
            totalIncome += member.job?.salary
        })
        return totalIncome
    }
}





