import XCTest
import DomainLogic

class JokesStoreTests: XCTestCase {
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieve: .success(.none))
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        expect(sut, toRetrieveTwice: .success(.none))
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = makeJokesFeed()
        insert(feed, to: sut)
        
        expect(sut, toRetrieve: .success(.some(feed)))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = makeJokesFeed()
        insert(feed, to: sut)
        expect(sut, toRetrieveTwice: .success(.some(feed)))
    }
    
    func test_insert_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        let feed = makeJokesFeed()
        
        let error = insert(feed, to: sut)
        XCTAssertNil(error, "Expected to insert cache successfully")
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = makeJokesFeed()
        insert(feed, to: sut)
        let error = insert(feed, to: sut)
        XCTAssertNil(error, "Expected to insert cache successfully")
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {
        let sut = makeSUT()
        
        let firstItem = ([makeUniqueJoke()], Date())
        let secondItem = ([makeUniqueJoke()], Date())
        
        insert(firstItem, to: sut)
        
        insert(secondItem, to: sut)
        expect(sut, toRetrieve: .success(secondItem))
    }
    
    func test_delete_deliversNoErrorOnEmptyCache() {
        let sut = makeSUT()
        let error = deleteCache(from: sut)
        XCTAssertNil(error, "Expected to retrive no error on empty cache")
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        var error = deleteCache(from: sut)
        XCTAssertNil(deleteCache(from: sut), "Expected to retrive no error on empty cache")
        error = deleteCache(from: sut)
        XCTAssertNil(error, "Expected to retrive no error on empty cache")
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() {
        let sut = makeSUT()
        let feed = makeJokesFeed()
        insert(feed, to: sut)
        XCTAssertNil(deleteCache(from: sut), "Expected to retrive no error on non empty cache")
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {
        let sut = makeSUT()
        
        let feed = makeJokesFeed()
        insert(feed, to: sut)
        deleteCache(from: sut)
        expect(sut, toRetrieve: .success(.none))
    }
    
    func test_storeSideEffects_runSerially() {
        let sut = makeSUT()
        
        var completedOperationsInOrder = [XCTestExpectation]()
        
        let op1 = expectation(description: "Operation 1")
        sut.insert([makeUniqueJoke()], timestamp: Date()) { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        }
        
        let op2 = expectation(description: "Operation 2")
        sut.deleteCachedFeed { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }
        
        let op3 = expectation(description: "Operation 3")
        sut.insert([makeUniqueJoke()], timestamp: Date()) { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        }
        
        waitForExpectations(timeout: 5.0)
        
        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run serially but operations finished in the wrong order")

    }

    // - MARK: Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> JokesCachedStore {
        let sut = InMemoryCachedJokesStore()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    @discardableResult
    func insert(_ cache: (feed: [LocalJoke], timestamp: Date), to sut: JokesCachedStore) -> Error? {
        let exp = expectation(description: "Wait for cache insertion")
        var insertionError: Error?
        sut.insert(cache.feed, timestamp: cache.timestamp) { result in
            if case let Result.failure(error) = result { insertionError = error }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }

    @discardableResult
    func deleteCache(from sut: JokesCachedStore) -> Error? {
        let exp = expectation(description: "Wait for cache deletion")
        var deletionError: Error?
        sut.deleteCachedFeed { result in
            if case let Result.failure(error) = result { deletionError = error }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return deletionError
    }

    func expect(_ sut: JokesCachedStore, toRetrieveTwice expectedResult: JokesCachedStore.RetrievalResult, file: StaticString = #file, line: UInt = #line) {
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
        expect(sut, toRetrieve: expectedResult, file: file, line: line)
    }

    func expect(_ sut: JokesCachedStore, toRetrieve expectedResult: JokesCachedStore.RetrievalResult, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for cache retrieval")

        sut.retrieve { retrievedResult in
            switch (expectedResult, retrievedResult) {
            case (.success(.none), .success(.none)),
                 (.failure, .failure):
                break

            case let (.success(.some(expected)), .success(.some(retrieved))):
                XCTAssertEqual(retrieved.feed, expected.feed, file: file, line: line)
                XCTAssertEqual(retrieved.timestamp, expected.timestamp, file: file, line: line)

            default:
                XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
    }
}
