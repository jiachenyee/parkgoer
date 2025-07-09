//
//  Parking+RackType.swift
//  Parkgoer
//
//  Created by Jia Chen Yee on 7/8/25.
//

import Foundation

extension Parking {
    enum RackType: Codable {
        case ltaRacks
        case mrtRacks
        case hdbRacks
        case uraRacks
        case paRacks
        case neaRacks
        case mohRacks
        case busInterchangeRacks
        case nParksRacks
        case yellowBox
        case hdbYellowBox
        case ltaYellowBox
        case jtcRacks
        case nlbRacks
        case sportSGRacks
        case stbRacks
        case slaRacks
        case mccyRacks
        case iteRacks
        case hsaRacks
        case avaRacks
        case jbtcRacks
        case pubRacks
        case polyRacks(String)
        case other(String)
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            let rackString = try container.decode(String.self)
            
            switch rackString.uppercased() {
            case "LTA_RACKS": self = .ltaRacks
            case "MRT_RACKS": self = .mrtRacks
            case "HDB_RACKS", "HBD_RACKS": self = .hdbRacks
            case "URA_RACKS": self = .uraRacks
            case "PA_RACKS", "RACKS_PA": self = .paRacks
            case "NEA_RACKS": self = .neaRacks
            case "PUB_RACKS": self = .pubRacks
            case "HSA_RACKS": self = .hsaRacks
            case "MOH_RACKS": self = .mohRacks
            case "AVA_RACKS": self = .avaRacks
            case "BI_RACKS": self = .busInterchangeRacks
            case "JBTC_RACKS": self = .jbtcRacks
            case "NPARKS_RACKS": self = .nParksRacks
            case "JTC_RACKS": self = .jtcRacks
            case "NLB_RACKS": self = .nlbRacks
            case "SPORTSG_RACKS": self = .sportSGRacks
            case "MCCY_RACKS": self = .mccyRacks
            case "STB_RACKS": self = .stbRacks
            case "ITE_RACKS": self = .iteRacks
            case "SLA_RACKS": self = .slaRacks
            case "YELLOW BOX": self = .yellowBox
            case "LTA_YELLOW_BOX": self = .ltaYellowBox
            case "HDB_YELLOWBOX": self = .hdbYellowBox
            default:
                if rackString.localizedCaseInsensitiveContains("POLY_") {
                    self = .polyRacks(rackString.uppercased().replacingOccurrences(of: "POLY_RACKS", with: ""))
                    return
                }
                self = .other(rackString)
                print("WARNING: Unknown rack type: \(rackString)")
            }
        }
        
        init(from rackString: String) {
            switch rackString.uppercased() {
            case "LTA_RACKS": self = .ltaRacks
            case "MRT_RACKS": self = .mrtRacks
            case "HDB_RACKS", "HBD_RACKS": self = .hdbRacks
            case "URA_RACKS": self = .uraRacks
            case "PA_RACKS", "RACKS_PA": self = .paRacks
            case "NEA_RACKS": self = .neaRacks
            case "PUB_RACKS": self = .pubRacks
            case "HSA_RACKS": self = .hsaRacks
            case "MOH_RACKS": self = .mohRacks
            case "AVA_RACKS": self = .avaRacks
            case "BI_RACKS": self = .busInterchangeRacks
            case "JBTC_RACKS": self = .jbtcRacks
            case "NPARKS_RACKS": self = .nParksRacks
            case "JTC_RACKS": self = .jtcRacks
            case "NLB_RACKS": self = .nlbRacks
            case "SPORTSG_RACKS": self = .sportSGRacks
            case "MCCY_RACKS": self = .mccyRacks
            case "STB_RACKS": self = .stbRacks
            case "ITE_RACKS": self = .iteRacks
            case "SLA_RACKS": self = .slaRacks
            case "YELLOW BOX": self = .yellowBox
            case "LTA_YELLOW_BOX": self = .ltaYellowBox
            case "HDB_YELLOWBOX": self = .hdbYellowBox
            default:
                if rackString.localizedCaseInsensitiveContains("POLY_") {
                    self = .polyRacks(rackString.uppercased().replacingOccurrences(of: "POLY_RACKS", with: ""))
                    return
                }
                self = .other(rackString)
                print("WARNING: Unknown rack type: \(rackString)")
            }
        }
        
        var isYellowBox: Bool {
            switch self {
            case .yellowBox, .ltaYellowBox, .hdbYellowBox:
                return true
            default:
                return false
            }
        }
        
        func encode(to encoder: any Encoder) throws {
            var container = encoder.singleValueContainer()
            
            let encodedValue = switch self {
            case .ltaRacks: "LTA_RACKS"
            case .mrtRacks: "MRT_RACKS"
            case .hdbRacks: "HDB_RACKS"
            case .uraRacks: "URA_RACKS"
            case .paRacks: "PA_RACKS"
            case .neaRacks: "NEA_RACKS"
            case .pubRacks: "PUB_RACKS"
            case .hsaRacks: "HSA_RACKS"
            case .mohRacks: "MOH_RACKS"
            case .avaRacks: "AVA_RACKS"
            case .busInterchangeRacks: "BI_RACKS"
            case .jbtcRacks: "JBTC_RACKS"
            case .nParksRacks: "NPARKS_RACKS"
            case .jtcRacks: "JTC_RACKS"
            case .nlbRacks: "NLB_RACKS"
            case .sportSGRacks: "SPORTSG_RACKS"
            case .mccyRacks: "MCCY_RACKS"
            case .stbRacks: "STB_RACKS"
            case .iteRacks: "ITE_RACKS"
            case .slaRacks: "SLA_RACKS"
            case .yellowBox: "YELLOW BOX"
            case .ltaYellowBox: "LTA_YELLOW_BOX"
            case .hdbYellowBox: "HDB_YELLOWBOX"
            case .polyRacks(let poly): "\(poly)_POLY_RACKS"
            case .other(let value): value
            }
            
            try container.encode(encodedValue)
        }
        
        var symbol: String {
            switch self {
            case .ltaRacks: return "car"
            case .mrtRacks: return "tram"
            case .hdbRacks: return "building.2"
            case .uraRacks: return "building.2"
            case .paRacks: return "person.2"
            case .neaRacks: return "leaf"
            case .mohRacks: return "heart"
            case .busInterchangeRacks: return "bus"
            case .nParksRacks: return "leaf"
            case .yellowBox: return "bicycle"
            case .hdbYellowBox: return "building.2"
            case .ltaYellowBox: return "car"
            case .jtcRacks: return "building.2"
            case .nlbRacks: return "book"
            case .sportSGRacks: return "sportscourt"
            case .stbRacks: return "paperplane"
            case .slaRacks: return "leaf"
            case .mccyRacks: return "person.2"
            case .iteRacks: return "graduationcap"
            case .hsaRacks: return "magnifyingglass"
            case .avaRacks: return "dog"
            case .jbtcRacks: return "building.2"
            case .pubRacks: return "drop"
            case .polyRacks: return "graduationcap"
            case .other: return "bicycle"
            }
        }
        
        var fullName: String? {
            switch self {
            case .ltaRacks, .ltaYellowBox: "Land Transport Authority"
            case .mrtRacks: "MRT"
            case .hdbRacks, .hdbYellowBox: "Housing Development Board"
            case .uraRacks: "Urban Redevelopment Authority"
            case .paRacks: "People's Association"
            case .neaRacks: "National Environment Agency"
            case .mohRacks: "Ministry of Health"
            case .busInterchangeRacks: "Bus Interchange"
            case .nParksRacks: "NParks"
            case .yellowBox: nil
            case .jtcRacks: "JTC Corporation"
            case .nlbRacks: "National Library Board"
            case .sportSGRacks: "Sport Singapore"
            case .stbRacks: "Singapore Tourism Board"
            case .slaRacks: "Singapore Land Authority"
            case .mccyRacks: "Ministry of Culture, Community and Youth"
            case .iteRacks: "Institute of Technical Education"
            case .hsaRacks: "Health Sciences Authority"
            case .avaRacks: "Agri-Food & Veterinary Authority of Singapore"
            case .jbtcRacks: "Jalan Besar Town Council"
            case .pubRacks: "Public Utilities Board"
            case .polyRacks(let string): "\(string.capitalized) Polytechnic"
            case .other(let string): string
            }
        }
    }
}
