//
//  String+Extensions.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 07.11.2025.
//

extension String {
    /// Строка из цифр
    public var digitsOnlyString: String {
        replacingOccurrences(of: "[^0-9]+", with: "", options: .regularExpression, range: range(of: self))
    }

    /// Отформатированная строка вида `mm:ss`
    public var timeFormatted: String {
        guard let seconds = Int(digitsOnlyString) else {
            return ""
        }
        if seconds >= 60 {
            let minutesPart = abs(seconds / 60)
            let seconds = seconds - minutesPart * 60
            let secondsPart = seconds < 10 ? "0\(seconds)" : "\(seconds)"
            return "\(minutesPart):\(secondsPart)"
        } else {
            let secondsPart = seconds < 10 ? "0\(seconds)" : "\(seconds)"
            return "0:\(secondsPart)"
        }
    }
}
