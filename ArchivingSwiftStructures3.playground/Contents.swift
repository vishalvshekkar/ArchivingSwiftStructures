//: Playground - noun: a place where people can play

import UIKit

// MARK: - The structure that is to be archived.

struct Movie {
    let name: String
    let director: String
    let releaseYear: Int
}

// MARK: - The protocol, when implemented by a structure makes the structure archive-able
protocol Dictionariable {
    func dictionaryRepresentation() -> NSDictionary
    init?(dictionaryRepresentation: NSDictionary?)
}

// MARK: - Implementation of the Dictionariable protocol by Movie struct
extension Movie: Dictionariable {
    
    func dictionaryRepresentation() -> NSDictionary {
        let representation: [String: AnyObject] = [
            "name": name,
            "director": director,
            "releaseYear": releaseYear
        ]
        return representation
    }
    
    init?(dictionaryRepresentation: NSDictionary?) {
        guard let values = dictionaryRepresentation else {return nil}
        if let name = values["name"] as? String,
            director = values["director"] as? String,
            releaseYear = values["releaseYear"] as? Int {
                self.name = name
                self.director = director
                self.releaseYear = releaseYear
        } else {
            return nil
        }
    }
}

// MARK: - Methods aiding in archiving and unarchiving the structures

//Single Structure Instances
func extractStructureFromDictionary<T:Dictionariable>() -> T? {
    guard let encodedDict = NSKeyedUnarchiver.unarchiveObjectWithFile(path()) as? NSDictionary else {return nil}
    return T(dictionaryRepresentation: encodedDict)
}

func saveStructureToDefaults<T:Dictionariable>(structure: T) {
    let encodedValue = structure.dictionaryRepresentation()
    NSKeyedArchiver.archiveRootObject(encodedValue, toFile: path())
}

//Multiple Structure Instances
func extractStructuresFromDictionaryArray<T:Dictionariable>() -> [T] {
    guard let encodedArray = NSKeyedUnarchiver.unarchiveObjectWithFile(path()) as? [AnyObject] else {return []}
    return encodedArray.map{$0 as? NSDictionary}.flatMap{T(dictionaryRepresentation: $0)}
}

func saveStructuresToDefaults<T:Dictionariable>(structures: [T]) {
    let encodedValues = structures.map{$0.dictionaryRepresentation()}
    NSKeyedArchiver.archiveRootObject(encodedValues, toFile: path())
}

//Metjod to get path to encode stuctures to
func path() -> String {
    let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
    let path = documentsPath?.stringByAppendingString("/Movie")
    return path!
}


// MARK: - Testing Code

//Single Structure Instances

let movie = Movie(name: "Avatar", director: "James Cameron", releaseYear: 2009)
saveStructureToDefaults(movie)
let someMovie: Movie? = extractStructureFromDictionary()
someMovie?.director

//Multiple Structure Instances
let movies = [
    Movie(name: "Avatar", director: "James Cameron", releaseYear: 2009),
    Movie(name: "The Dark Knight", director: "Christopher Nolan", releaseYear: 2008)
]
saveStructuresToDefaults(movies)

let someArray: [Movie] = extractStructuresFromDictionaryArray()
someArray[0].director