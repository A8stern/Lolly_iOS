//
//  ContactsMapperInterface.swift
//  LOLLY
//
//  Created by Kirill Prokofyev on 23.11.2025.
//

public protocol ContactsMapperInterface: AnyObject {
    func map(_ response: ContactsInfoResponseModel) -> ContactsInfo
}
