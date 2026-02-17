import Foundation

/// A dating profile for the Tender swipe experience.
struct Profile: Identifiable, Codable {
    let id: String
    var name: String
    var age: Int
    var bio: String
    var occupation: String
    var location: String
    var distance: Int
    var photos: [String]  // Asset catalog names
    var interests: [String]
    var education: String
    var verified: Bool
    var recentActivity: String

    init(
        id: String,
        name: String,
        age: Int,
        bio: String,
        occupation: String,
        location: String = "",
        distance: Int = 0,
        photos: [String],
        interests: [String],
        education: String = "",
        verified: Bool = false,
        recentActivity: String = ""
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.bio = bio
        self.occupation = occupation
        self.location = location
        self.distance = distance
        self.photos = photos
        self.interests = interests
        self.education = education
        self.verified = verified
        self.recentActivity = recentActivity
    }
}

// MARK: - Sample Profiles
extension Profile {
    /// Hardcoded profiles ported from the React Tender app.
    static let sampleProfiles: [Profile] = [
        Profile(
            id: "sam-1",
            name: "Sam Z.",
            age: 28,
            bio: "Adventure seeker. Coffee enthusiast. Always up for trying new restaurants. Let's explore the city together!",
            occupation: "Software Engineer",
            location: "Brooklyn, NY",
            distance: 2,
            photos: ["profile1_1", "profile1_2", "profile1_3", "profile1_4", "profile1_5", "profile1_6"],
            interests: ["Hiking", "Coffee", "Photography", "Travel"],
            education: "Columbia University",
            verified: true,
            recentActivity: "Active 2 hours ago"
        ),
        Profile(
            id: "sam-2",
            name: "Samuel",
            age: 29,
            bio: "Fitness enthusiast. Dog lover. Weekend warrior. Looking for someone who can keep up with my energy!",
            occupation: "Product Manager",
            location: "Manhattan, NY",
            distance: 5,
            photos: ["profile2_1", "profile2_2", "profile2_3", "profile2_4", "profile2_5", "profile2_6"],
            interests: ["Fitness", "Dogs", "Running", "Cooking"],
            education: "NYU Stern",
            verified: true,
            recentActivity: "Active 1 day ago"
        ),
        Profile(
            id: "sam-3",
            name: "Sammy",
            age: 27,
            bio: "Artist at heart. Music lover. Deep conversations over good wine. Seeking genuine connections.",
            occupation: "Creative Director",
            location: "Williamsburg, NY",
            distance: 3,
            photos: ["profile3_1"],
            interests: ["Art", "Music", "Wine", "Philosophy"],
            education: "Parsons School of Design",
            verified: false,
            recentActivity: "Active 3 hours ago"
        ),
        Profile(
            id: "sam-4",
            name: "S. Zoloth",
            age: 30,
            bio: "Entrepreneur. World traveler. Foodie with a passport full of stories. What's your favorite cuisine?",
            occupation: "Startup Founder",
            location: "SoHo, NY",
            distance: 4,
            photos: ["profile4_1", "profile4_2", "profile4_3", "profile4_4", "profile4_5", "profile4_6", "profile4_7", "profile4_8"],
            interests: ["Entrepreneurship", "Travel", "Food", "Startups"],
            education: "Harvard Business School",
            verified: true,
            recentActivity: "Active now"
        )
    ]
}
