//: # DP257Easy
//: ## https://redd.it/49aatn
//: ---

import XCPlayground
import Foundation


//let path = XCPlaygroundSharedDataDirectoryURL.URLByAppendingPathComponent("Presidents.csv")
let fileURL = NSBundle.mainBundle().URLForResource("Presidents", withExtension: "csv")
let input = try String(contentsOfURL: fileURL!, encoding: NSUTF8StringEncoding)
let csv = CSwiftV(String: input)

var birthDates:[Int] = []
var deathDates: [Int] = []
var ranges: [PresidentialRange] = []

let birthKey = csv.headers[1]
let deathKey = csv.headers[3]


for row in csv.keyedRows! {
    let birth = formatDateString(row[birthKey])
    let death = formatDateString(row[deathKey])
    birthDates.append(birth)
    deathDates.append(death)
    ranges.append(PresidentialRange(startYear: birth, endYear: death))
}

let startYear = birthDates.minElement()!
var maximums: [(Int, Int)] = []
var maxRange = 0

//Since counts are affected by deathyears, we can just do year in deathDates if we only care about the count
for year in startYear ..< 2016 {
    var rangeCount = 0
    for range in ranges {
        if range.doesContain(Year: year) {
            rangeCount += 1
        }
    }

    if rangeCount >= maxRange {
        maxRange = rangeCount
        maximums.append((year, maxRange))
    }
}


print(maxRange)
//Use maximums to find all years.
