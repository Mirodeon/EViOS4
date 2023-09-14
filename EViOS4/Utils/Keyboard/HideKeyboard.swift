//
//  HideKeyboard.swift
//  EViOS4
//
//  Created by Student07 on 14/09/2023.
//

import Foundation
import UIKit

func hideKeyboardOnTap(view: UIView){
    let tapOnView = UITapGestureRecognizer(
        target: view,
        action: #selector(UIView.endEditing)
    )
    view.addGestureRecognizer(tapOnView)
}
