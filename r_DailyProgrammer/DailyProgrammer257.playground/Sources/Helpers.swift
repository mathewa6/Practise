import Foundation

public struct PresidentialRange: CustomStringConvertible {
    public var startYear: Int
    public var endYear: Int
    
    public init(startYear: Int, endYear: Int) {
        self.startYear = startYear
        self.endYear = endYear
    }
    
    public var description: String {
        return "\(startYear) - \(endYear)"
    }
    
    public func doesContain(Year year:Int) -> Bool {
        if year <= endYear && year >= startYear {
            return true
        }
        return false
    }
    
}

public func formatDateString(date: String?) -> Int {
    let trimmedDate = date?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    if trimmedDate?.characters.count > 0 {
        let end = (trimmedDate?.endIndex)!
        let start = end.advancedBy(-4)
        let last = trimmedDate![start..<end]
        
        return Int(last) ?? 0
    }
    return 0
}
