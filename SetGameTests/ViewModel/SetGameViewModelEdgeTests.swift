/// Path: SetGameTests/ViewModel/SetGameViewModelEdgeTests.swift
/// Role: VM edges via public API (async-aware; no internals)

import XCTest

@testable import set_game

final class SetGameViewModelEdgeTests: XCTestCase {

    // MARK: - Async helpers

    /// Wait until at least `minCount` cards are visible on table (the VM deals them with staggered async).
    private func waitForTableCards(
        in viewModel: SetGameViewModel,
        atLeast minCount: Int,
        timeout seconds: TimeInterval,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for \(minCount) table cards")
        let deadline = Date().addingTimeInterval(seconds)

        func poll() {
            if viewModel.tableCards.count >= minCount {
                exp.fulfill()
                return
            }
            if Date() > deadline {
                XCTFail(
                    "Timed out waiting for \(minCount) cards (had \(viewModel.tableCards.count))",
                    file: file,
                    line: line
                )
                exp.fulfill()
                return
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: poll)
        }
        poll()
        wait(for: [exp], timeout: seconds + 0.2)
    }

    /// Try to find a valid set; if none on table, deal more and retry up to `attempts`.
    private func findValidSet(using viewModel: SetGameViewModel, attempts: Int = 4) -> [CardSet]? {
        for _ in 0..<attempts {
            if let s = firstValidSet(in: viewModel.tableCards) { return s }
            viewModel.dealThreeMore()
            // allow the append to render
            RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        }
        return firstValidSet(in: viewModel.tableCards)
    }

    /// Try to find a mismatch triple; if none on table, deal more and retry up to `attempts`.
    private func findMismatch(using viewModel: SetGameViewModel, attempts: Int = 4) -> [CardSet]? {
        for _ in 0..<attempts {
            if let m = firstMismatchTriple(in: viewModel.tableCards) { return m }
            viewModel.dealThreeMore()
            RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        }
        return firstMismatchTriple(in: viewModel.tableCards)
    }

    // MARK: - Pure helpers

    private func firstValidSet(in cards: [CardSet]) -> [CardSet]? {
        let n = cards.count
        guard n >= 3 else { return nil }
        for i in 0..<(n - 2) {
            for j in (i + 1)..<(n - 1) {
                for k in (j + 1)..<n {
                    let triple = [cards[i], cards[j], cards[k]]
                    if triple.isSet { return triple }
                }
            }
        }
        return nil
    }

    private func firstMismatchTriple(in cards: [CardSet]) -> [CardSet]? {
        let n = cards.count
        guard n >= 3 else { return nil }
        for i in 0..<(n - 2) {
            for j in (i + 1)..<(n - 1) {
                for k in (j + 1)..<n {
                    let triple = [cards[i], cards[j], cards[k]]
                    if !triple.isSet { return triple }
                }
            }
        }
        return nil
    }

    // MARK: - Tests

    func testDeselection_TogglesCardSelectionOff() {
        // Given: a fresh game where cards will arrive asynchronously
        let viewModel = SetGameViewModel()
        viewModel.startNewGame()
        waitForTableCards(in: viewModel, atLeast: 1, timeout: 1.0)

        guard let firstCard = viewModel.tableCards.first else {
            XCTFail("Expected at least one card on table")
            return
        }
        viewModel.select(this: firstCard)
        XCTAssertTrue(viewModel.isSelected(card: firstCard))

        // When: tapping the same card again
        viewModel.select(this: firstCard)

        // Then: selection toggles off
        XCTAssertFalse(viewModel.isSelected(card: firstCard))
    }

    func testFailState_ResetsOnNewSelection() {
        // Given: enough cards on table, then pick a triple that is not a set
        let viewModel = SetGameViewModel()
        viewModel.startNewGame()
        waitForTableCards(in: viewModel, atLeast: 12, timeout: 4.0)

        guard let mismatch = findMismatch(using: viewModel) else {
            XCTFail("Could not find a mismatch triple after several deals")
            return
        }

        // When: selecting the three non-matching cards
        mismatch.forEach { viewModel.select(this: $0) }

        // Then: status becomes fail
        XCTAssertEqual(viewModel.setEvalStatus, .fail)

        // When: a new selection begins
        let nextCard = viewModel.tableCards.first { !mismatch.contains($0) }!
        viewModel.select(this: nextCard)

        // Then: failure state clears
        XCTAssertNotEqual(viewModel.setEvalStatus, .fail)
    }

    func testFoundState_ConsumesMatchedCards() {
        // Given: enough cards on table, then pick a real set
        let viewModel = SetGameViewModel()
        viewModel.startNewGame()
        waitForTableCards(in: viewModel, atLeast: 12, timeout: 4.0)

        guard let validSet = findValidSet(using: viewModel) else {
            XCTFail("Could not find a valid set after several deals")
            return
        }
        let matchedIDs = Set(validSet.map { $0.id })

        // When: select all three
        validSet.forEach { viewModel.select(this: $0) }

        // Then: status reflects found
        XCTAssertEqual(viewModel.setEvalStatus, .found)

        // And When: deal replacement/cleanup
        viewModel.dealThreeMore()

        // Then: matched IDs are gone; state reset
        XCTAssertFalse(viewModel.tableCards.contains { matchedIDs.contains($0.id) })
        XCTAssertEqual(viewModel.setEvalStatus, .none)
    }
}
