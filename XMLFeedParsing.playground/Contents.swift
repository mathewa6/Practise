
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

class XFPReview {
    var title: String?
    var author: String?
    var contect: String?
}

protocol CHFParserDelegate: class {
    var feed: String { get set }
    func parsingDidEnd()
}

class CHFParser: NSObject, XMLParserDelegate {
    
    private var currentContent: String = String()
    
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
        currentContent = ""
        print("Begin: ", elementName, Array(attributeDict.keys))
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentContent += string
//        print("Content: \(currentContent)")
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        print("End: ", elementName)

        // If the current XML elements name is 'description' and it contains HTML content
        // (There's got to be a better way to detect HTML right?...)
        if currentContent.contains("<") && elementName == "content" {
        
            // Convert the entire HTML doc to an AttributedString and then back again to string to strip away all HTML.
            currentContent = currentContent.unescape() + "\n"
            delegate?.feed += currentContent

//        }
        } else if elementName == "title" {
            delegate?.feed += currentContent + "\n"
        } else if elementName == "name" {
            delegate?.feed += "NAME : " + currentContent + "\n"
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
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
