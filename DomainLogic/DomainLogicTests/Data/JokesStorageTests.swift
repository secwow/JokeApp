import XCTest
import DomainLogic

class JokesStorageTests: XCTestCase {
    func test_retrieve_deliversEmptyOnEmptyStore() {
        let sut = makeSUT()
    
        expect(sut, toRetrive: .success([]))
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyStore() {
        let sut = makeSUT()
        
        expect(sut, toRetriveTwice: .success([]))
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyStore() {
        let sut = makeSUT()
        let item = makeUniqueJoke()
        insert(item, to: sut)
        expect(sut, toRetrive: .success([item]))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyStore() {
        let sut = makeSUT()
        let item = makeUniqueJoke()
        
        insert(item, to: sut)
        
        expect(sut, toRetriveTwice: .success([item]))
    }
    
    func test_insert_deliversNoErrorOnEmptyStore() {
        let sut = makeSUT()
        
        XCTAssertNil(insert(makeUniqueJoke(), to: sut), "Expected no error on insertion")
    }
    
    func test_insert_deliversNoErrorOnNonEmptyStore() {
        let sut = makeSUT()
        
        insert(makeUniqueJoke(), to: sut)
        
        XCTAssertNil(insert(makeUniqueJoke(), to: sut), "Expected no error on insertion")
    }
    
    func test_insert_appendsDataToStore() {
        let sut = makeSUT()
        let firstJoke = makeUniqueJoke()
        let secondJoke = makeUniqueJoke()
        
        insert(firstJoke, to: sut)
        insert(secondJoke, to: sut)
         
        expect(sut, toRetrive: .success([firstJoke, secondJoke]))
    }
    
    func test_insert_deliversErrorOnUpdatingNonExistentJoke() {
        let sut = makeSUT()
        let joke = makeUniqueJoke()
        
        XCTAssertNotNil(update(joke, in: sut))
    }
    
    func test_update_changePreviouslyInsertedValue() {
        let sut = makeSUT()
        let oldJoke = LocalJoke(with: 1, joke: "Some joke")
        let newJoke =  LocalJoke(with: 1, joke: "Joke with new text")
        
        insert(oldJoke, to: sut)
        update(newJoke, in: sut)
        
        expect(sut, toRetrive: .success([newJoke]))
    }
    
    func test_delete_deliversNoErrorOnDeletionNonExistentJoke() {
        let sut = makeSUT()
        let item = makeUniqueJoke()
        
        XCTAssertNil(delete(item: item, from: sut))
    }
    
    func test_delete_hasNoSideOnDeletionNonExistentJoke() {
        let sut = makeSUT()
        let item = makeUniqueJoke()
        
        XCTAssertNil(delete(item: item, from: sut))
        XCTAssertNil(delete(item: item, from: sut))
    }
    
    func test_delete_emptiesSpecificItem() {
        let sut = makeSUT()
        let item = makeUniqueJoke()
        
        insert(item, to: sut)
        delete(item: item, from: sut)
        
        expect(sut, toRetrive: .success([]))
    }
    
    // - MARK: Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> JokesStore {
        let sut = InMemoryJokesStore()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

    @discardableResult
    func insert(_ item: LocalJoke, to sut: JokesStore) -> Error? {
        let exp = expectation(description: "Wait for store insertion")
        var insertionError: Error?
        sut.insert(item) { result in
            if case let Result.failure(error) = result { insertionError = error }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }
    
    @discardableResult
    func update(_ item: LocalJoke, in sut: JokesStore) -> Error? {
        let exp = expectation(description: "Wait for store insertion")
        var insertionError: Error?
        sut.update(item) { result in
            if case let Result.failure(error) = result { insertionError = error }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
        return insertionError
    }

    @discardableResult
    func delete(item: LocalJoke, from sut: JokesStore) -> Error? {
        let exp = expectation(description: "Wait for joke deletion")
        var deletionError: Error?
        
        sut.delete(item) { result in
            if case let Result.failure(error) = result { deletionError = error }
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1.0)
        return deletionError
    }
    
    func expect(_ sut: JokesStore,
                   toRetriveTwice expectedResult: JokesStore.RetriveJokesResult,
                   file: StaticString = #file,
                   line: UInt = #line) {
        expect(sut, toRetrive: expectedResult)
        expect(sut, toRetrive: expectedResult)
    }
    
    func expect(_ sut: JokesStore,
                toRetrive expectedResult: JokesStore.RetriveJokesResult,
                file: StaticString = #file,
                line: UInt = #line) {
        let exp = expectation(description: "Wait for retrive data from store")
        sut.getAll { retrievedResult in
                switch (expectedResult, retrievedResult) {
                case (.failure, .failure):
                    break

                case let (.success(expected), .success(retrieved)):
                    XCTAssertEqual(retrieved, expected, file: file, line: line)
                default:
                    XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
                }

                exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
}

