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
        case addCompany(String)
        case addLaunch(Launch)
        case addMission(Mission)
        
        // Company
        case numberCompany
        case rateOfSuccessCreateView
        case rateOfSuccess(String)
        
        // Number
        case numberMission
        case numberMissionForCompany(String)
        case numberMissionActive
        
        // Cost
        case totalCostForCompany(String) // Million $
        case totalCost
        case highestAverageCostCreateView
        case highestAverageCost
        
        
        var query: String {
            switch self {
                case .allCompany:                           return  "SELECT * FROM Company"
                case .allLaunch:                            return  "SELECT * FROM Launch"
                case .allMission:                           return  "SELECT * FROM Mission"
                case .addCompany(let name):                 return  """
                                                                    INSERT INTO Company (companyName)
                                                                    VALUES ('\(name)');
                                                                    """
                case .addLaunch(let launch):                return  """
                                                                    INSERT INTO Launch (companyName, location, date, MissionID)
                                                                    VALUES ('\(launch.companyName)', '\(launch.location)',
                                                                    '\(launch.date)', '\(launch.missionID)');
                                                                    """
                case .addMission(let mission):              return  """
                                                                    INSERT INTO Mission (missionID, detail, statusRocket, cost, statusMission)
                                                                    VALUES ('\(mission.missionID)', '\(mission.detail)', '\(mission.statusRocket)', '\(mission.cost)', '\(mission.statusMission)');
                                                                    """
                case .numberCompany:                        return  "SELECT COUNT(*) FROM Company"
                case .numberMission:                        return  "SELECT COUNT(*) FROM Mission"
                case .numberMissionForCompany(let name):    return  """
                                                                    SELECT COUNT(*) as NumLaunch
                                                                    FROM Launch
                                                                    WHERE companyName = '\(name)';
                                                                    """
                case .totalCostForCompany(let name):        return  """
                                                                    SELECT SUM(cost)
                                                                    FROM Mission
                                                                    JOIN Launch ON Launch.MissionID = Mission.MissionID
                                                                    WHERE Launch.CompanyName = '\(name)';
                                                                    """
                case .numberMissionActive:                  return  """
                                                                    SELECT COUNT(*)
                                                                    FROM Mission
                                                                    GROUP BY StatusRocket
                                                                    HAVING StatusRocket = 'StatusActive';
                                                                    """
                case .totalCost:                            return  "SELECT SUM(cost) FROM Mission"
                case .rateOfSuccessCreateView:    return  """
                                                                    CREATE VIEW RateSuccess as
                                                                    SELECT CompanyName, COUNT(*) as NumSuccess
                                                                    FROM Launch
                                                                    JOIN Mission ON Mission.MissionID = Launch.MissionID
                                                                    WHERE StatusMission = 'Success'
                                                                    GROUP BY CompanyName;
                                                                    """
                case .rateOfSuccess(let name):              return  """
                                                                    SELECT CAST(NumSuccess as REAL) / COUNT(*) as RateSuccess
                                                                    FROM Mission
                                                                    JOIN Launch ON Launch.MissionID = Mission.MissionID
                                                                    JOIN RateSuccess ON RateSuccess.CompanyName = Launch.CompanyName
                                                                    WHERE Launch.companyName = '\(name)'
                                                                    GROUP BY Launch.CompanyName;
                                                                    """
                case .highestAverageCostCreateView:         return  """
                                                                    CREATE VIEW AverageCost as
                                                                    SELECT CompanyName, AVG(Cost) as avgCost
                                                                    FROM Launch
                                                                    JOIN Mission ON Mission.MissionID = Launch.MissionID
                                                                    GROUP BY CompanyName;
                                                                    """
                case .highestAverageCost:                   return  """
                                                                    SELECT companyName, avgCost
                                                                    FROM AverageCost
                                                                    WHERE avgCost = (SELECT MAX(avgCost)
                                                                    FROM AverageCost)
                                                                    """
                
            }
        }
    }
}
