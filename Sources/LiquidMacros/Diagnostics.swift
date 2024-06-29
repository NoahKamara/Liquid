import Foundation
public import SwiftDiagnostics
import SwiftSyntax

let diagnosticDomain = "Liquid"


public struct ArgParseFixit: FixItMessage {
    public let message: String
    private let messageID: String

    /// This should only be called within a static var on FixItMessage, such
    /// as the examples below. This allows us to pick up the messageID from the
    /// var name.
    init(_ message: String, messageID: String = #function) {
        self.message = message
        self.messageID = messageID
    }

    public var fixItID: MessageID {
        MessageID(domain: diagnosticDomain, id: "\(type(of: self)).\(messageID)")
    }
}




/// A simple diagnostic with a message, id, and severity.
struct SimpleDiagnosticMessage: DiagnosticMessage, Error {
    /// The human-readable message.
    let message: String
    /// The unique diagnostic id (should be the same for all diagnostics produced by the same codepath).
    let diagnosticID: MessageID
    /// The diagnostic's severity.
    let severity: DiagnosticSeverity

    /// Creates a new diagnostic message.
    init(message: String, diagnosticID: MessageID, severity: DiagnosticSeverity) {
        self.message = message
        self.diagnosticID = diagnosticID
        self.severity = severity
    }
}

extension SimpleDiagnosticMessage: FixItMessage {
    /// The unique fix-it id (should be the same for all fix-its produced by the same codepath).
    var fixItID: MessageID { diagnosticID }
}

/// A generic macro error. If you are making a widely used macro I'd encourage you
/// to instead provide more detailed diagnostics through the diagnostics API that
/// macros have access to.
struct MacroError: LocalizedError {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    var errorDescription: String? {
        message
    }
}


/// A way to create rich diagnostics with no unnecessary boilerplate code. Only provide the
/// important details and the rest will be given sensible defaults.
struct DiagnosticBuilder<Node: SyntaxProtocol>: ~Copyable {
    /// The node that the diagnostic will be attached to.
    fileprivate var node: Node
    /// The message that the diagnostic will show.
    fileprivate var message: String?
    /// The diagnostic id (should be the same for all diagnostics produced by the same codepath).
    fileprivate var messageID = MessageID(domain: "UnknownDomain", id: "UnknownError")
    /// The fix-its that will be associated with the diagnostics.
    fileprivate var fixIts: [FixIt] = []
    /// The additional syntax nodes that will be highlighted by the diagnostic.
    fileprivate var highlights: [Syntax] = []

    /// Defaults to ``DiagnosticSeverity/error``.
    fileprivate var severity: DiagnosticSeverity = .error

    /// Creates a new builder for a diagnostics related to the given `node`.
    init(for node: Node) {
        self.node = node
    }

    /// Set the message.
    consuming func message(_ message: String) -> Self {
        self.message = message
        return self
    }

    /// Set the severity.
    consuming func severity(_ severity: DiagnosticSeverity) -> Self {
        self.severity = severity
        return self
    }

    /// Set the message id.
    private consuming func messageID(_ messageID: MessageID) -> Self {
        self.messageID = messageID
        return self
    }

    /// Add a fix-it suggestion.
    consuming func fixIt(_ fixIt: FixIt) -> Self {
        self.fixIts.append(fixIt)
        return self
    }

    consuming func fixIt(_ message: any FixItMessage, changes: [FixIt.Change]) -> Self {
        self.fixIt(.init(message: message, changes: changes))
    }

    /// Highlight a syntax node related to the diagnostic.
    consuming func highlight(_ node: some SyntaxProtocol) -> Self {
        self.highlights.append(Syntax(node))
        return self
    }

    /// Adds a replacement fix-it to the diagnostic. If `messageID` is `nil`, the fix-it will
    /// inherit the current `messageID` set via ``DiagnosticBuilder/messageID(_:)`` (or the default
    /// messageID of `"UnknownDomain", "UnknownError"`).
    consuming func suggestReplacement(
        _ message: String? = nil,
        messageID: MessageID? = nil,
        severity: DiagnosticSeverity = .error,
        new: some SyntaxProtocol
    ) -> Self {
        fixIt(
            FixIt(
                message: SimpleDiagnosticMessage(
                    message: message ?? "suggested replacement",
                    diagnosticID: messageID ?? self.messageID,
                    severity: .error
                ),
                changes: [
                    FixIt.Change.replace(
                        oldNode: Syntax(node),
                        newNode: Syntax(new)
                    )
                ]
            ))
    }

    consuming func suggestReplacement(
        _ message: String? = nil,
        messageID: MessageID? = nil,
        severity: DiagnosticSeverity = .error,
        makeNew: (Node) -> some SyntaxProtocol
    ) -> Self {
        fixIt(
            FixIt(
                message: SimpleDiagnosticMessage(
                    message: message ?? "suggested replacement",
                    diagnosticID: messageID ?? self.messageID,
                    severity: .error
                ),
                changes: [
                    FixIt.Change.replace(
                        oldNode: Syntax(node),
                        newNode: Syntax(makeNew(node))
                    )
                ]
            ))
    }

    /// Set the message id (shorthand for ``messageID(_:)``).
    consuming func messageID(domain: String, id: String) -> Self {
        messageID(MessageID(domain: domain, id: id))
    }

    /// Build the final diagnostic to be emitted. Defaults will be used for any
    /// unset configuration values.
    func build() -> Diagnostic {
        let messageID = messageID
        return Diagnostic(
            node: node,
            message: SimpleDiagnosticMessage(
                message: message ?? "unspecified error",
                diagnosticID: messageID,
                severity: severity
            ),
            highlights: highlights,
            fixIts: fixIts
        )
    }
}

import SwiftSyntaxMacros

// emit directly
extension DiagnosticBuilder {
    @discardableResult
    func emit(_ context: any MacroExpansionContext) -> Diagnostic {
        let diagnostic = build()
        context.diagnose(diagnostic)
        return diagnostic
    }

    func error() -> DiagnosticError {
        let diagnostic = build()
        return DiagnosticError(diagnostic: diagnostic)
    }
}

struct DiagnosticError: Error {
    let diagnostic: Diagnostic
}
