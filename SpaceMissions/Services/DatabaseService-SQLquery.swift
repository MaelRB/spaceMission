//
//  DatabaseService-SQLquery.swift
//  SpaceMissions
//
//  Created by Mael Romanin Bluteau on 28/12/2021.
//

import Foundation

extension DatabaseService {
    
    struct HighestAvgResult: Equatable {
        let name: String
        let cost: Double
    }
    
    enum SQLQuery: Equatable {
        
        // Database
        case allCompany
        case allLaunch
        case allMission
        
        // Number
        case numberCompany
        case numberMission
        case numberMissionPerCompany
        case numberMissionActive
        
        // Cost
        case totalCostForCompany(String) // Million $
        case totalCost
        case highestAverageCostCreateView
        case highestAverageCost
        
        // Other
        case rateOfSuccessCreateView
        case rateOfSuccess
        
        
        var query: String {
            switch self {
                case .allCompany:                       return  "SELECT * FROM Company"
                case .allLaunch:                        return  "SELECT * FROM Launch"
                case .allMission:                       return  "SELECT * FROM Mission"
                case .numberCompany:                    return  "SELECT COUNT(*) FROM Company"
                case .numberMission:                    return  "SELECT COUNT(*) FROM Mission"
                case .numberMissionPerCompany:          return  """
                                                                SELECT companyName, COUNT(*) as NumLaunch
                                                                FROM Launch
                                                                GROUP BY CompanyName
                                                                ORDER BY NumLaunch DESC;
                                                                """
                case .totalCostForCompany(let name):    return  """
                                                                SELECT SUM(cost)
                                                                FROM Mission
                                                                JOIN Launch ON Launch.MissionID = Mission.MissionID
                                                                WHERE Launch.CompanyName = '\(name)';
                                                                """
                case .numberMissionActive:              return  """
                                                                SELECT COUNT(*)
                                                                FROM Mission
                                                                GROUP BY StatusRocket
                                                                HAVING StatusRocket = 'StatusActive';
                                                                """
                case .totalCost:                        return  "SELECT SUM(cost) FROM Mission"
                case .rateOfSuccessCreateView:          return  """
                                                                CREATE VIEW RateSuccess as
                                                                SELECT CompanyName, COUNT(*) as NumSuccess
                                                                FROM Launch
                                                                JOIN Mission ON Mission.MissionID = Launch.MissionID
                                                                WHERE StatusMission = 'Success'
                                                                GROUP BY CompanyName;
                                                                
                                                                SELECT Launch.CompanyName, CAST(NumSuccess as REAL) / COUNT(*) as RateSuccess
                                                                FROM Mission
                                                                JOIN Launch ON Launch.MissionID = Mission.MissionID
                                                                JOIN RateSuccess ON RateSuccess.CompanyName = Launch.CompanyName
                                                                GROUP BY Launch.CompanyName;
                                                                """
                case .rateOfSuccess:                    return  """
                                                                SELECT Launch.CompanyName, CAST(NumSuccess as REAL) / COUNT(*) as RateSuccess
                                                                FROM Mission
                                                                JOIN Launch ON Launch.MissionID = Mission.MissionID
                                                                JOIN RateSuccess ON RateSuccess.CompanyName = Launch.CompanyName
                                                                GROUP BY Launch.CompanyName;
                                                                """
                case .highestAverageCostCreateView:     return  """
                                                                CREATE VIEW AverageCost as
                                                                SELECT CompanyName, AVG(Cost) as avgCost
                                                                FROM Launch
                                                                JOIN Mission ON Mission.MissionID = Launch.MissionID
                                                                GROUP BY CompanyName;

                                                                SELECT companyName, avgCost
                                                                FROM AverageCost
                                                                WHERE avgCost = (SELECT MAX(avgCost)
                                                                FROM AverageCost)
                                                                """
                case .highestAverageCost:               return  """
                                                                SELECT companyName, avgCost
                                                                FROM AverageCost
                                                                WHERE avgCost = (SELECT MAX(avgCost)
                                                                FROM AverageCost)
                                                                """
                
            }
        }
    }
}
