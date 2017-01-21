
import UIKit

extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func split(by separator: String) -> [String] {
        return self.components(separatedBy: separator)
    }
    
    func unescape() -> String {
        let data = try! NSAttributedString(data: self.data(using: String.Encoding.unicode)!,
                                           options: [NSDocumentTypeDocumentAttribute:
                                            NSHTMLTextDocumentType],
                                           documentAttributes: nil)
        return data.string
        
    }
}

class XFPReview: CustomStringConvertible {
    var title: String?
    var author: String?
    var content: String?
    var rating: Int = 0
    var version: String?
    
    var description: String {
        return "\n \(title),\n \(content),\n \(author),\n \(rating)/5"
    }
}

protocol CHFParserDelegate: class {
    var allReviews: [XFPReview] { get set }
    func parsingDidEnd()
}

class CHFParser: NSObject, XMLParserDelegate {
    
    private var currentContent: String = String()
    
    private var currentReview: XFPReview?
    
    private var isParsingContent: Bool = false
    
    weak var delegate: CHFParserDelegate?
    
    // MARK: - XMLParser methods
    
    func parseURL(url: String) {
        guard let xmlURL = URL(string: url) else {
            print("URL string invalid!")
            return
        }
        guard let parser = XMLParser(contentsOf: xmlURL) else {
            print("URL cannot be reached!")
            return
        }
        
        parser.delegate = self
        if !parser.parse() {
            print("Data Error!")
            let error = parser.parserError!
            print("Error description: \(error.localizedDescription)")
            print("Line: \(parser.lineNumber)")
        }
    }
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        self.currentContent = ""
//        print("Begin: ", elementName, Array(attributeDict.keys))
        if elementName == "entry" {
//            print(self.currentReview ?? "NO REVIEW")
            if self.currentReview != nil {
                self.delegate?.allReviews.append(self.currentReview!)
            }
            self.currentReview = XFPReview()
        } else if elementName == "content" && attributeDict["type"] == "text" {
            self.isParsingContent = true
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.currentContent += string
//        print("Content: \(currentContent)")
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
//        print("End: ", elementName)

        if elementName == "title" {
            self.currentReview?.title = self.currentContent
        } else if elementName == "name" {
            self.currentReview?.author = self.currentContent
        } else if elementName == "im:version" {
            self.currentReview?.version = self.currentContent
        } else if elementName == "im:rating" {
            self.currentReview?.rating = Int(self.currentContent) ?? 0
        } else if self.isParsingContent {
            self.currentReview?.content = self.currentContent
            self.isParsingContent = false
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
//        print(self.currentReview ?? "NO REVIEW")
        self.delegate?.allReviews.append(self.currentReview ?? XFPReview())
        self.delegate?.parsingDidEnd()
    }
    
}

class ParserTest: CHFParserDelegate {
    
    var allReviews: [XFPReview] = []
    
    internal func parsingDidEnd() {
        print(self.allReviews.dropFirst()) // [1 ..< self.allReviews.count]
    }

    internal var feed: String = ""

    private let parser = CHFParser()
    
    init() {
        parser.delegate = self
    }
    
    func process(url: String) {
        self.parser.parseURL(url: url)
    }
}

let test = ParserTest()

test.process(url: "https://itunes.apple.com/us/rss/customerreviews/id=920189534/sortBy=mostRecent/xml") // 888422857
