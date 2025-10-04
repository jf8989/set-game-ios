/// Path: SetGameTests/ViewModel/SetGameViewModelEdgeTests.swift
/// Role: VM edges via public API (async-aware; no internals)

import XCTest

@testable import set_game

final class SetGameViewModelEdgeTests: XCTestCase {

    // MARK: - Async helpers

    /// Waits until `tableCards.count >= minCount` or times out.
    /// Polls every 50ms on the main queue to match the VM’s staggered deal cadence.
    /// Adds a small timeout cushion to account for scheduler jitter; fails with the
    /// observed count for debuggability.
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

    /// Tries to locate a valid set among the current `tableCards`.
    /// If none is found, deals three more cards and retries up to `attempts` times,
    /// allowing a short render window between attempts. Returns the first triple found.
    private func findValidSet(using viewModel: SetGameViewModel, attempts: Int = 4) -> [CardSet]? {
        for _ in 0..<attempts {
            if let s = firstValidSet(in: viewModel.tableCards) { return s }
            viewModel.dealThreeMore()
            // allow the append to render
            RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        }
        return firstValidSet(in: viewModel.tableCards)
    }

    /// Tries to locate a non-set triple among `tableCards`.
    /// If none is found, deals three more cards and retries up to `attempts` times,
    /// allowing a short render window between attempts. Returns the first triple found.
    private func findMismatch(using viewModel: SetGameViewModel, attempts: Int = 4) -> [CardSet]? {
        for _ in 0..<attempts {
            if let m = firstMismatchTriple(in: viewModel.tableCards) { return m }
            viewModel.dealThreeMore()
            RunLoop.main.run(until: Date().addingTimeInterval(0.05))
        }
        return firstMismatchTriple(in: viewModel.tableCards)
    }

    // MARK: - Pure helpers

    /// Exhaustive O(n³) search for the first valid set within `cards`.
    /// Returns the first triple that satisfies `isSet`, or `nil` if none exists.
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

    /// Exhaustive O(n³) search for the first triple that is *not* a set.
    /// Returns the first non-matching triple, or `nil` if all triples form sets.
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
        // Given: a fresh game started; we wait for at least one visible card (async deal).
        let viewModel = SetGameViewModel()
        viewModel.startNewGame()
        waitForTableCards(in: viewModel, atLeast: 1, timeout: 1.0)

        guard let firstCard = viewModel.tableCards.first else {
            XCTFail("Expected at least one card on table")
            return
        }
        viewModel.select(this: firstCard)
        XCTAssertTrue(viewModel.isSelected(card: firstCard))

        // When: tapping the same card again.
        viewModel.select(this: firstCard)

        // Then: the second tap toggles selection off for that exact card.
        XCTAssertFalse(viewModel.isSelected(card: firstCard))
    }

    func testFailState_ResetsOnNewSelection() {
        // Given: twelve cards are visible; we find a triple that is not a set.
        let viewModel = SetGameViewModel()
        viewModel.startNewGame()
        waitForTableCards(in: viewModel, atLeast: 12, timeout: 4.0)

        guard let mismatch = findMismatch(using: viewModel) else {
            XCTFail("Could not find a mismatch triple after several deals")
            return
        }

        // When: selecting all three non-matching cards.
        mismatch.forEach { viewModel.select(this: $0) }

        // Then: evaluation state becomes `.fail`.
        XCTAssertEqual(viewModel.setEvalStatus, .fail)

        // When: starting a new selection with a different card.
        let nextCard = viewModel.tableCards.first { !mismatch.contains($0) }!
        viewModel.select(this: nextCard)

        // Then: the failure state clears (state no longer `.fail`).
        XCTAssertNotEqual(viewModel.setEvalStatus, .fail)
    }

    func testFoundState_ConsumesMatchedCards() {
        // Given: twelve cards are visible; we find a valid set and capture its identifiers.
        let viewModel = SetGameViewModel()
        viewModel.startNewGame()
        waitForTableCards(in: viewModel, atLeast: 12, timeout: 4.0)

        guard let validSet = findValidSet(using: viewModel) else {
            XCTFail("Could not find a valid set after several deals")
            return
        }
        let matchedIDs = Set(validSet.map { $0.id })

        // When: selecting all three cards that form the set.
        validSet.forEach { viewModel.select(this: $0) }

        // Then: evaluation state becomes `.found`.
        XCTAssertEqual(viewModel.setEvalStatus, .found)

        // And When: requesting cleanup/deal to advance the game.
        viewModel.dealThreeMore()

        // Then: none of the matched identifiers remain on the table and state resets to `.none`.
        XCTAssertFalse(viewModel.tableCards.contains { matchedIDs.contains($0.id) })
        XCTAssertEqual(viewModel.setEvalStatus, .none)
    }
}
