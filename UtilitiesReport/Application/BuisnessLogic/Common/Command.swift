//
//  Command.swift
//  UtilitiesReport
//
//  Created by Vadim Albul on 2/20/19.
//  Copyright © 2019 Vadim Albul. All rights reserved.
//

import Foundation

class Command: Codable {
    private let identifier: String
    private let file: StaticString
    private let function: StaticString
    private let line: Int
    
    init(identifier: String = "unnamed",
         file: StaticString = #file,
         function: StaticString = #function,
         line: Int = #line,
         action: @escaping () -> Void) {
        self.identifier = identifier
        self.action = action
        self.function = function
        self.file = file
        self.line = line
    }
    
    private let action: () -> Void
    
    func perform() {
        action()
    }
    
    static let nop = Command { }
    
    /// Support for Xcode quick look feature.
    @objc
    func debugQuickLookObject() -> AnyObject? {
        return """
            type: \(String(describing: type(of: self)))
            id: \(identifier)
            file: \(file)
            function: \(function)
            line: \(line)
            """ as NSString
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init { }
    }
    
    func encode(to encoder: Encoder) throws {}
}

// MARK: - CommandWith
class CommandWith<T>: Codable {
    
    let action: (T) -> Void
    
    init(action: @escaping (T) -> Void) {
        self.action = action
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init { _ in }
    }
    func encode(to encoder: Encoder) throws {}
    
    func perform(with value: T) {
        action(value)
    }
    
    func dispatched(on queue: DispatchQueue) -> CommandWith {
        return CommandWith { value in
            queue.async {
                self.perform(with: value)
            }
        }
    }
    
    func then(_ another: CommandWith) -> CommandWith {
        return CommandWith { value in
            self.perform(with: value)
            another.perform(with: value)
        }
    }
    
    func bind(to value: T) -> Command {
        return Command { self.perform(with: value) }
    }
    
    static var nop: CommandWith {
        return CommandWith { _ in }
    }
}

// swiftlint:disable operator_whitespace legacy_hashing
extension CommandWith: Hashable {
    
    static func ==(lhs: CommandWith<T>, rhs: CommandWith<T>) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
    
    var hashValue: Int {
        return ObjectIdentifier(self).hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}

extension CommandWith {
    func map<U>(transform: @escaping (U) -> T) -> CommandWith<U> {
        return CommandWith<U> { unit in
            self.perform(with: transform(unit))
        }
    }
}
