
import UIKit

extension Artist {
    convenience init(fromDictionary source: [String:Any]) throws {
        guard
            let name = source[k.artistName] as? String,
            let id = source[k.artistId] as? Int,
            let bio = source[k.artistBio] as? String,
            let pageURL = source[k.artistPageURL] as? String
            else { throw ParseError.missingValueOrIncorrectValueType(message: String(describing: Artist.self)) }
        
        self.init (name: name, id: id, bio: bio, pageURL: pageURL)
    }
    
    enum ParseError: Error {
        case missingValueOrIncorrectValueType(message: String)
        case incorrectDataType(message: String)
        
        func getError() -> NSError {
            let errorMessage: String
            switch(self) {
            case .missingValueOrIncorrectValueType(let message):
                errorMessage = message
            case .incorrectDataType(let message):
                errorMessage = message
            }
            let domain = "Unable to parse service data: \(errorMessage)"
            return NSError(domain: domain, code: 0, userInfo: nil)
        }
    }
}
