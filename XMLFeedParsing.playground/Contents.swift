
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
    var rating: Int?
    var version: String?
    
    var description: String {
        return "REVIEW,\n \(title),\n \(content),\n \(author),\n \(rating)"
    }
}

protocol CHFParserDelegate: class {
    var feed: String { get set }
    func parsingDidEnd()
}

class CHFParser: NSObject, XMLParserDelegate {
    
    private var currentContent: String = String()
    
    private var currentReview: XFPReview?
    
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
            print(self.currentReview ?? "NO REVIEW")
            self.currentReview = XFPReview()
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

        // If the current XML elements name is 'description' and it contains HTML content
        // (There's got to be a better way to detect HTML right?...)
        if self.currentContent.contains("<") && elementName == "content" {
        
            // Convert the entire HTML doc to an AttributedString and then back again to string to strip away all HTML.
            self.currentContent = self.currentContent.unescape() + "\n"
            delegate?.feed += self.currentContent

//        }
        } else if elementName == "title" {
            delegate?.feed += self.currentContent + "\n"
            self.currentReview?.title = self.currentContent
        } else if elementName == "name" {
            delegate?.feed += "NAME : " + self.currentContent + "\n"
            self.currentReview?.author = self.currentContent
        } else if elementName == "im:version" {
            self.currentReview?.version = self.currentContent
        } else if elementName == "im:rating" {
            self.currentReview?.rating = Int(self.currentContent)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        print(self.currentReview ?? "NO REVIEW")
        self.delegate?.parsingDidEnd()
    }
    
}

class ParserTest: CHFParserDelegate {
    
    internal func parsingDidEnd() {
//        print(self.feed)
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
