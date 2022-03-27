//
//  DetailLoader.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 27/03/22.
//

import Foundation
import RxSwift

protocol ItemDetailLoader {
    func getItemDetail() -> Observable<MenuItem>
}
