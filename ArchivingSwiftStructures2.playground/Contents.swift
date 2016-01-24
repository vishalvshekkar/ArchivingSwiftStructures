//: Playground - noun: a place where people can play

import UIKit

// MARK: - The class that aids the structure that is to be archived.

struct Movie {
    let name: String
    let director: String
    let releaseYear: Int
    
    func archive() {
        let movieClassObject = MovieClass(movie: self)
        NSKeyedArchiver.archiveRootObject(movieClassObject, toFile: MovieClass.path())
    }
    
    static func unarchive() -> Movie? {
        let movieClassObject = NSKeyedUnarchiver.unarchiveObjectWithFile(MovieClass.path()) as? MovieClass
        return movieClassObject?.movie
    }
}

//Extension containing the class that undergoes archiving and unarchiving by reading from and writing into the struct Movie

extension Movie {
    class MovieClass: NSObject, NSCoding {
        
        var movie: Movie?
        
        init(movie: Movie) {
            self.movie = movie
            super.init()
        }
        
        static func path() -> String {
            let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
            let path = documentsPath?.stringByAppendingString("/Movie")
            return path!
        }
        
        required init?(coder aDecoder: NSCoder) {
            guard let name = aDecoder.decodeObjectForKey("name") as? String else { movie = nil; super.init(); return nil }
            guard let director = aDecoder.decodeObjectForKey("director") as? String else { movie = nil; super.init(); return nil }
            guard let releaseYear = aDecoder.decodeObjectForKey("releaseYear") as? Int else { movie = nil; super.init(); return nil }
            
            movie = Movie(name: name, director: director, releaseYear: releaseYear)
            super.init()
        }
        
        func encodeWithCoder(aCoder: NSCoder) {
            if let movie = movie
            {
                aCoder.encodeObject(movie.name, forKey: "name")
                aCoder.encodeObject(movie.director, forKey: "director")
                aCoder.encodeObject(movie.releaseYear, forKey: "releaseYear")
            }
        }
    }
}

// MARK: - Test

let avatar = Movie(name: "Avatar", director: "James Cameron", releaseYear: 2009)
avatar.archive()

Movie.unarchive()?.director