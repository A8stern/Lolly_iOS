//
//  QRcodeModels.swift
//  LOLLY
//
//  Created by Nikita on 04.11.2025.
//

enum QRcodeModels {
    enum InitialData {
        struct Response { }

        struct ViewModel {
            let qrViewModel: QRViewModel
            let caption: String
        }
    }

    enum QRcode {
        struct Response { }

        struct ViewModel {
            let qrViewModel: QRViewModel
            let caption: String
        }
    }
}
