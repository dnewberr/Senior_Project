//
//  User.swift
//  Iota Pi App
//
//  Created by Deborah Newberry on 11/16/16.
//  Copyright © 2016 Deborah Newberry. All rights reserved.
//

import Foundation

public class User: Equatable {
    let adminPrivileges: AdminPrivileges!
    let birthday: String!
    let educationClass: String!
    let email: String!
    let expectedGrad: String!
    let firstname: String!
    let hasWonHirly: Bool!
    let isCheckedIn: Bool!
    let lastname: String!
    let major: String!
    let nickname: String!
    let phoneNumber: String!
    let rosterNumber: Int!
    let section: String!
    let sloAddress: String!
    let status: Status!
    let userId: String!
    
    init(dict: NSDictionary, userId: String) {
        self.birthday = dict.value(forKey: "birthday") as! String
        self.educationClass = dict.value(forKey: "class") as! String
        self.expectedGrad = dict.value(forKey: "expectedGrad") as! String
        self.firstname = dict.value(forKey: "firstname") as! String
        if let hasWonHirly = dict.value(forKey: "hasWonHirly") as? Bool {
            self.hasWonHirly = true
        } else {
            self.hasWonHirly = false
        }
        if let isCheckedIn = dict.value(forKey: "isCheckedIn") as? Bool {
            self.isCheckedIn = true
        } else {
            self.isCheckedIn = false
        }
        self.lastname = dict.value(forKey: "lastname") as! String
        self.major = dict.value(forKey: "major") as! String
        if let nickname = dict.value(forKey: "nickname") as? String {
            self.nickname = nickname
        } else {
            self.nickname = "N/A"
        }
        self.phoneNumber = dict.value(forKey: "phone") as! String
        self.rosterNumber = dict.value(forKey: "roster") as! Int
        self.section = dict.value(forKey: "section") as! String
        self.sloAddress = dict.value(forKey: "sloAddress") as! String
        
        switch dict.value(forKey: "status") as! String {
            case "Active" : self.status = Status.Active
            case "Alumni" : self.status = Status.Alumni
            case "Conditional" : self.status = Status.Conditional
            case "Inactive" : self.status = Status.Inactive
            default : self.status = Status.Other
        }
        
        if let admin = dict.value(forKey: "admin") as? String {
            switch admin {
                case "President" : self.adminPrivileges = AdminPrivileges.President
                case "RecSec" : self.adminPrivileges = AdminPrivileges.RecSec
                case "Parliamentarian" : self.adminPrivileges = AdminPrivileges.Parliamentarian
                default : self.adminPrivileges = AdminPrivileges.None
            }
        } else {
            self.adminPrivileges = AdminPrivileges.None
        }
        
        self.email = self.firstname.lowercased() + "." + self.lastname.lowercased() + "@iotapi.com"
        self.userId = userId
    }
    
    func toFirebaseObject() -> Any {
        return [
            "birthday": self.birthday,
            "expectedGrad": self.expectedGrad,
            "firstname": self.firstname,
            "lastname": self.lastname,
            "class": self.educationClass,
            "hasWonHirly": self.hasWonHirly,
            "major": self.major,
            "nickname": self.nickname,
            "phone": self.phoneNumber,
            "roster": self.rosterNumber,
            "section": self.section,
            "sloAddress": self.sloAddress,
            "status": self.status.rawValue,
            "admin": self.adminPrivileges.rawValue
        ]
    }
    
    func toArrayOfEditableInfo() -> [String] {
        return [
            self.nickname,
            self.educationClass,
            self.section,
            self.birthday,
            self.sloAddress,
            self.major,
            self.expectedGrad
        ]
    }
    
    func getArrayOfDetails() -> [String] {
        return [
            "Nickname",
            "Class",
            "Section",
            "Birthday",
            "Slo Address",
            "Major",
            "Expected Graduation"
        ]
    }
}

public func ==(lhs:User, rhs:User) -> Bool {
    return lhs.userId == rhs.userId
}
