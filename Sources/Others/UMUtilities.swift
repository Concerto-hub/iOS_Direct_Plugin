//
//  UMUtilities.swift

//

import Foundation
import UIKit
//import SwiftPublicIP


public struct ZDLUtility {
    public static func getBundle() -> Bundle? {
        var bundle: Bundle?
        if let urlString = Bundle.main.path(forResource:"Payments", ofType: "framework", inDirectory: "Frameworks")
        {
            bundle = (Bundle(url: URL(fileURLWithPath: urlString)))
        }
        return bundle
    }
}

func getController(_ storyBoardName: String, _ identifier: String) -> UIViewController {
    
    let bundle = Bundle(for: PaymentViewController.self)
    
    return UIStoryboard(name: storyBoardName, bundle: bundle).instantiateViewController(withIdentifier: identifier)
}

internal class Common: NSObject {

    internal struct Globle
    {
            static var terminalId = "TER6856791" // termilan provided by URWAY
            static var password = "TER23082202410687570250" // password provided by URWAY
            static var merchantKey = "654f277e1a955b867406adc2405b56a38dba0fcb173f3b994653d582c533edc5"
            static var url = "http://10.10.11.208:8076/CORE_2.2.2/transaction/jsonProcess/JSONrequest"
            static var merchantIdentifier="merchant.testios.com"
    }
}


internal struct Validator {
    func checkMandatoryFields(for model: UWInitializer) -> paymentResult{
        print("In Validation")
        print(model.actionCode)
        print(model.cardOperation)
        if !isValidAmount(enteredAmount: model.amount)
        {
           return .mandatory(.amount)
        }
        
        if !isValidEmail(enteredEmail: model.email) {
            return .mandatory(.email)
        }
        
        if !isValidcountry(enteredcountry: model.country) {
           return .mandatory(.country)
        }
        if !isValidcurrency(enteredcurrency: model.currency) {
           return .mandatory(.currency)
        }
//        if !isValidtrack(enteredtrack: model.trackIdCode) {
//           return .mandatory(.trackId)
//        }
        if  (model.actionCode == "12" && (model.cardOperation == ""  || model.cardOperation == nil))
        {
            return .mandatory(.cardOperation)
        }
    
        
//        if ((model.createTokenIsEnabled ?? true) && model.actionCode != "12") {
//            return .mandatory(.action_code)
//        }
        
        if model.trackIdCode.isEmpty {
            return .mandatory(.trackId)
        }
        
        if ((model.actionCode == "") || model.actionCode.isEmpty || model.actionCode == "")
        {
            return .mandatory(.action_code)
        }
        if (model.actionCode == "0")
        {
            return .mandatory(.action_code)
        }
        
        return .sucess
    }
    
    
    
    func checkActionCode(code: String , tokenEnabled: Bool) -> Bool{
        
       
        if (!tokenEnabled && code == "12" && (Int(code) ?? .zero) > 0 && (Int(code) ?? .zero) < 99){
            return false
        }
        return true
    }
    
    func isValidAmount(enteredAmount:String) -> Bool {
        let amountFormat = Float(enteredAmount)
        return amountFormat != nil
    }
    
    
    
    func isValidEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    
    
    func isValidcountry(enteredcountry:String) -> Bool {
        let countryFormat = "[A-Za-z]{2}"
        let countryPredicate = NSPredicate(format:"SELF MATCHES %@", countryFormat)
        return countryPredicate.evaluate(with: enteredcountry)
    }
    
    
    
    func isValidcurrency(enteredcurrency:String) -> Bool {
        let currencyFormat = "[A-Za-z]{3}"
        let currncyPredicate = NSPredicate(format:"SELF MATCHES %@", currencyFormat)
        return currncyPredicate.evaluate(with: enteredcurrency)
    }
    
    
    
    func isValidActioncode(enteredaction:String) -> Bool {
        let actionFormat = "[1-99]"
        let actionPredicate = NSPredicate(format:"SELF MATCHES %@", actionFormat)
        return actionPredicate.evaluate(with: enteredaction)
    }
    
    
    
    
    
    func isValidZipcode(enteredzipcode:String) -> Bool {
        let zipcodeFormat = "[0-9]{6}"
        let zipcodePredicate = NSPredicate(format:"SELF MATCHES %@", zipcodeFormat)
        return zipcodePredicate.evaluate(with: enteredzipcode)
    }

    func isValidtrack(enteredtrack:String) -> Bool {
        let trackFormat = "[A-Za-z0-9]"
        let trackPredicate = NSPredicate(format:"SELF MATCHES %@", trackFormat)
        return trackPredicate.evaluate(with: enteredtrack)
    }
    
    
  
//    func getWiFiAddress() -> String {
//        var address : String?
//
//        // Get list of all interfaces on the local machine:
//        var ifaddr : UnsafeMutablePointer<ifaddrs>?
//        guard getifaddrs(&ifaddr) == 0 else { return "" }
//        guard let firstAddr = ifaddr else { return "" }
//
//        // For each interface ...
//        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
//            let interface = ifptr.pointee
//
//            // Check for IPv4 or IPv6 interface:
//            let addrFamily = interface.ifa_addr.pointee.sa_family
//            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
//
//                // Check interface name:
//                let name = String(cString: interface.ifa_name)
//                print(name)
//                if  name == "en0" {
//
//                    // Convert interface address to a human readable string:
//                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
//                                &hostname, socklen_t(hostname.count),
//                                nil, socklen_t(0), NI_NUMERICHOST)
//                    address = String(cString: hostname)
//                } else if name == "en1" {
//                    // Convert interface address to a human readable string:
//                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
//                                &hostname, socklen_t(hostname.count),
//                                nil, socklen_t(1), NI_NUMERICHOST)
//                    address = String(cString: hostname)
//                }
//                else if  name == "en2" || name == "en3" || name == "en4"  {
//                                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//                                    getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(2), NI_NUMERICHOST)
//                                    address = String(cString: hostname)
//                                }
//            }
//        }
//        freeifaddrs(ifaddr)
//print("IP MEthod " ,address)
//        return address ?? ""
//    }
    func getWiFiAddress() -> String {
        var address : String?
//        SwiftPublicIP.getPublicIP(url: PublicIPAPIURLs.ipv4.icanhazip.rawValue) { (string, error) in
//            if let error = error {
//                print(error.localizedDescription)
//            } else if let string = string {
//                print("PUBLIC IP ",string) // Your IP address
//                address = string
//            }
//}
//        5123451203580008
        address = try? String(contentsOf: URL(string: "https://api.ipify.org")!, encoding: .utf8)
        print(address as Any)
        return address ?? ""
    }
}
