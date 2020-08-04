import XCTest
import DomainLogic

class RemoteJokesLoaderTests: XCTestCase {
    
   func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                let json = makeItemsJSON(items: [])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .success([]), when: {
            let emptyListJSON = makeItemsJSON(items: [])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(id: 1, joke: "BestJoke")
        
        let item2 = makeItem(id: 2, joke: "BestJoke")
        
        let items = [item1.model, item2.model]
        
        expect(sut, toCompleteWith: .success(items), when: {
            let json = makeItemsJSON(items: [item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteJokesLoader? = RemoteJokesLoader(url: url, client: client)
        
        var capturedResults = [RemoteJokesLoader.Result]()
        sut?.load { capturedResults.append($0) }

        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON(items: []))
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    private func failure(_ error: RemoteJokesLoader.Error) -> RemoteJokesLoader.Result {
        return .failure(error)
    }
    
    func makeSUT(url: URL = anyURL(),
                 file: StaticString = #file,
                 line: UInt = #line) -> (JokesLoader, HTTPClientSpy) {
        let spyClient = HTTPClientSpy()
        let loader = RemoteJokesLoader(url: url, client: spyClient)
        trackForMemoryLeaks(spyClient, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        
        return (loader, spyClient)
    }
    
    func makeItem(id: Int, joke: String) -> (model: Joke, json: [String: Any]) {
        let model = Joke(with: id, joke: joke)
        let json = ["id": id,
                    "joke": joke
        ].compactMapValues({ $0 })
        
        return (model, json)
        
    }
    
    private enum JSONJokeType: String {
        case success, failure
    }
    
    private func makeItemsJSON(type: JSONJokeType = .success, items: [[String: Any]]) -> Data {
        let json = ["type": type.rawValue, "value": items] as [String : Any]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(_ sut: JokesLoader, toCompleteWith expectedResult: RemoteJokesLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as RemoteJokesLoader.Error), .failure(expectedError as RemoteJokesLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
}
