/// Path:  SetGameTests/Support/TestNamaspaceShim.swif
/// Role: Centralized Namespace for various tests

import SwiftUI

// Shared namespace for tests that need a matchedGeometryEffect Namespace.ID
enum TestNamespaceShim {
    @Namespace static var id
}
