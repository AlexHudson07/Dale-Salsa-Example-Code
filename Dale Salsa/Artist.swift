
import UIKit

class Artist: NSObject, NSCoding {
    var name: String!
    var id : Int!
    var bio : String!
    var pageURL : String!
    
    init (name: String, id: Int, bio: String, pageURL: String) {
        super.init()
        self.name = name
        self.id = id
        self.bio = bio
        self.pageURL = pageURL
    }
    
    required convenience init?(coder decoder: NSCoder) {
        guard let name = decoder.decodeObject(forKey: k.artistName) as? String,
            let id = decoder.decodeObject(forKey: k.artistId) as? Int,
            let bio = decoder.decodeObject(forKey: k.artistBio) as? String,
            let pageURL = decoder.decodeObject(forKey: k.artistPageURL) as? String
            else { return nil }
        
        self.init (name: name, id: id, bio: bio, pageURL: pageURL)
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.name, forKey: k.artistName)
        coder.encode(self.id, forKey: k.artistId)
        coder.encode(self.bio, forKey: k.artistBio)
        coder.encode(self.pageURL, forKey: k.artistPageURL)
    }
}
