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
public struct Money {
    public var amount : Int
    public var currency : String
    
    public func convert(to: String) -> Money {
        // maps currency types relative to USD
        let currMap = ["USD" : 1, "GBP" : 0.5, "EUR" : 1.5, "CAN" : 1.25]
        
        if let conv = currMap[to] {
            return Money(amount: Int((Double(self.amount) / currMap[self.currency]!) * conv), currency: to)
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
        switch self.salary {
        case .Hourly(let rate):
            return Int(Double(hours) * rate)
        case .Salary(let salary):
            return salary
        }
    }

    public func raise(amt : Double) {
        switch self.salary {
        case .Hourly(let rate):
            self.salary = JobType.Hourly(rate + amt)
        case .Salary(let salary):
            self.salary = JobType.Salary(salary + Int(amt))
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    public var firstName : String = ""
    public var lastName : String = ""
    public var age : Int = 0
    private var _job : Job?
    private var _spouse : Person?
    
    public var job : Job? {
        get { return self._job }
        set(value) {
            if self.age >= 16 {
                self._job = value!
            }
        }
    }
    
    public var spouse : Person? {
        get { return self._spouse }
        set(value) {
            if self.age >= 18 {
                self._spouse = value!
            }
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    public func toString() -> String {
        var string = "[Person:" + " firstName:" + self.firstName
        string += " lastName:" + self.lastName + " age:" + String(self.age)
        string += " job:" + (self._job == nil ? "nil" : (self._job?.title)!)
        let other = self._spouse
        string += " spouse:" + (other == nil ? "nil" : other!.firstName + " " + other!.lastName)
        return string + "]"
    }
}

////////////////////////////////////
// Family
//
public class Family {
    private var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil && (spouse1.age > 21 || spouse2.age > 21) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            self.members.append(spouse1)
            self.members.append(spouse2)
        } else {
            print("spouses cannot already be married and there must be at least one over the age of 21")
            exit(1)
        }
    }
    
    public func haveChild(child: Person) -> Bool {
        child.age = 0
        self.members.append(child)
        return true
    }
    
    public func householdIncome() -> Int {
        var totalIncome = 0
        self.members.forEach({ (member : Person) -> () in
            if let job = member.job {
                var hours : Int
                switch job.salary {
                case .Hourly(_):
                    hours = 40 * 50
                case .Salary(_):
                    hours = 0
                }
                totalIncome += job.calculateIncome(hours)
            }
        })
        return totalIncome
    }
}





