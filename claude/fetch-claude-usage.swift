#!/usr/bin/env swift

import Foundation
func readSessionKey() -> String? {
    let sessionKeyPath = FileManager.default.homeDirectoryForCurrentUser
        .appendingPathComponent(".claude-session-key")

    guard FileManager.default.fileExists(atPath: sessionKeyPath.path) else {
        return nil
    }

    guard let key = try? String(contentsOf: sessionKeyPath, encoding: .utf8) else {
        return nil
    }

    let trimmedKey = key.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmedKey.isEmpty ? nil : trimmedKey
}
func fetchOrganizationId(sessionKey: String) async throws -> String {
    let url = URL(string: "https://claude.ai/api/organizations")!
    var request = URLRequest(url: url)
    request.setValue("sessionKey=\(sessionKey)", forHTTPHeaderField: "Cookie")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.httpMethod = "GET"

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
        throw NSError(domain: "ClaudeAPI", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch org ID"])
    }

    struct Organization: Codable {
        let uuid: String
    }

    let organizations = try JSONDecoder().decode([Organization].self, from: data)
    guard let firstOrg = organizations.first else {
        throw NSError(domain: "ClaudeAPI", code: 2, userInfo: [NSLocalizedDescriptionKey: "No organizations found"])
    }

    return firstOrg.uuid
}
struct UsageData {
    let fiveHourUtilization: Int
    let fiveHourResetsAt: String?
    let sevenDayUtilization: Int?
    let sevenDayResetsAt: String?
}

func fetchUsageData(sessionKey: String, orgId: String) async throws -> UsageData {
    let url = URL(string: "https://claude.ai/api/organizations/\(orgId)/usage")!
    var request = URLRequest(url: url)
    request.setValue("sessionKey=\(sessionKey)", forHTTPHeaderField: "Cookie")
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.httpMethod = "GET"

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
        throw NSError(domain: "ClaudeAPI", code: 3, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch usage"])
    }

    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
       let fiveHour = json["five_hour"] as? [String: Any],
       let fiveHourUtil = fiveHour["utilization"] as? Double {
        let fiveHourResetsAt = fiveHour["resets_at"] as? String

        var sevenDayUtilization: Int? = nil
        var sevenDayResetsAt: String? = nil

        if let sevenDay = json["seven_day"] as? [String: Any],
           let sevenDayUtil = sevenDay["utilization"] as? Double {
            sevenDayUtilization = Int(sevenDayUtil)
            sevenDayResetsAt = sevenDay["resets_at"] as? String
        }

        return UsageData(
            fiveHourUtilization: Int(fiveHourUtil),
            fiveHourResetsAt: fiveHourResetsAt,
            sevenDayUtilization: sevenDayUtilization,
            sevenDayResetsAt: sevenDayResetsAt
        )
    }

    throw NSError(domain: "ClaudeAPI", code: 4, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])
}

// Main execution
// Use Task to run async code, RunLoop keeps script alive until exit() is called
Task {
    guard let sessionKey = readSessionKey() else {
        print("ERROR:NO_SESSION_KEY")
        exit(1)
    }

    do {
        let orgId = try await fetchOrganizationId(sessionKey: sessionKey)
        let usage = try await fetchUsageData(sessionKey: sessionKey, orgId: orgId)

        // Output format: FIVE_HOUR_UTIL|FIVE_HOUR_RESETS|SEVEN_DAY_UTIL|SEVEN_DAY_RESETS
        let fiveHourResets = usage.fiveHourResetsAt ?? ""
        let sevenDayUtil = usage.sevenDayUtilization.map { String($0) } ?? ""
        let sevenDayResets = usage.sevenDayResetsAt ?? ""

        print("\(usage.fiveHourUtilization)|\(fiveHourResets)|\(sevenDayUtil)|\(sevenDayResets)")
        exit(0)
    } catch {
        print("ERROR:\(error.localizedDescription)")
        exit(1)
    }
}

// Keep script alive while async Task executes
RunLoop.main.run()