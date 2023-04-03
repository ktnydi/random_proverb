struct Proverb {
    let character: String
    let message: String
    let movie: String
    let year: Int
    
    init(json: [String: Any]) {
        character =  json["character"] as! String;
        message = json["message"] as! String;
        movie = json["movie"] as! String;
        year = json["year"] as! Int;
    }
}
