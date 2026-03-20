import Foundation

enum APIConfigError: LocalizedError {
    case missingBaseURL

    var errorDescription: String? {
        switch self {
        case .missingBaseURL:
            return "APIBaseURL is missing. Configure the API_BASE_URL build setting."
        }
    }
}

enum APIConfig {
    static var baseURLString: String {
        let configured = Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String
        return configured?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }

    static func url(path: String) throws -> URL {
        guard !baseURLString.isEmpty else {
            throw APIConfigError.missingBaseURL
        }

        let normalizedBase = baseURLString.hasSuffix("/")
            ? String(baseURLString.dropLast())
            : baseURLString
        let normalizedPath = path.hasPrefix("/") ? path : "/" + path

        guard let url = URL(string: normalizedBase + normalizedPath) else {
            throw URLError(.badURL)
        }

        return url
    }
}
