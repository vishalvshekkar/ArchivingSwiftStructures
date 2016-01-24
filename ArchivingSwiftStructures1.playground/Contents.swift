//: Playground - noun: a place where people can play

import UIKit

// MARK: - The structure to be archived.

struct Movie {
    let name: String
    let director: String
    let releaseYear: Int
}

// MARK: - The class that aids the structure that is to be archived.

class MovieClass: NSObject, NSCoding {
    
    var movie: Movie?
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        
        if let name = aDecoder.decodeObjectForKey("name") as? String,
            director = aDecoder.decodeObjectForKey("director") as? String,
            releaseYear = aDecoder.decodeObjectForKey("releaseYear") as? Int {
                movie = Movie(name: name, director: director, releaseYear: releaseYear)
        }
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let movie = movie
        {
            aCoder.encodeObject(movie.name, forKey: "name")
            aCoder.encodeObject(movie.director, forKey: "director")
            aCoder.encodeObject(movie.releaseYear, forKey: "releaseYear")
        }
    }
    
    static func path() -> String {
        let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
        let path = documentsPath?.stringByAppendingString("/Movie")
        return path!
    }
}

//External functions that trigger Archiving and Unarchiving of Movie

func archiveMovie(movie: Movie) {
    let movieClassObject = MovieClass()
    movieClassObject.movie = movie
    NSKeyedArchiver.archiveRootObject(movieClassObject, toFile: MovieClass.path())
}

func unarchiveMovie() -> Movie? {
    let movieClassObject = NSKeyedUnarchiver.unarchiveObjectWithFile(MovieClass.path()) as? MovieClass
    return movieClassObject?.movie
}

// MARK: - Test

let avatar = Movie(name: "Avatar", director: "James Cameron", releaseYear: 2009)
archiveMovie(avatar)

unarchiveMovie()?.director