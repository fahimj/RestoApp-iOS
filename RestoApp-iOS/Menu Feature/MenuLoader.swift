//
//  MenuLoader.swift
//  RestoApp-iOS
//
//  Created by Fahim Jatmiko on 26/03/22.
//

import Foundation
import RxSwift

protocol MenuLoader {
    func getMenu() -> Observable<[Category]>
}
