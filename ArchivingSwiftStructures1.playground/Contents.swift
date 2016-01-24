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
}

//External functions that trigger Archiving and Unarchiving of Movie

func archiveMovie(movie: Movie) {
    let movieClassObject = MovieClass()
    movieClassObject.movie = movie
    let data = NSKeyedArchiver.archivedDataWithRootObject(movieClassObject)
    NSUserDefaults.standardUserDefaults().setObject(data, forKey: "movieDetail")
}

func unarchiveMovie() -> Movie? {
    var movieStruct: Movie?
    if let data = NSUserDefaults.standardUserDefaults().objectForKey("movieDetail") as? NSData,
        let movieClassObject  = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? MovieClass
    {
        movieStruct = movieClassObject.movie
    }
    return movieStruct
}