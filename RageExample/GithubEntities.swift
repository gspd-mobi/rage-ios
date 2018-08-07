import Foundation

struct GithubOrganization: Codable {
    var id: Int64?
    var name: String?
    var location: String?
    var blog: String?
}

struct GithubRepository: Codable {
    var id: Int64?
    var name: String?
    var fullName: String?
    var url: String?
    var stars: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case url
        case stars = "stargazers_count"
    }
}

struct GithubUser: Codable {
    var id: Int64?
    var login: String?
    var avatarUrl: String?
    var htmlUrl: String?
    var name: String?
    var email: String?
    var location: String?

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
        case name
        case email
        case location
    }
}

struct GithubError: Codable {
    var message: String?
}
