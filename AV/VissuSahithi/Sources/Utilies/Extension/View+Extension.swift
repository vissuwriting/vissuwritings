//
//  View+Extension.swift
//  AV
//
//  Created by Medidi V V Satyanaryana Murty on 06/03/26.
//

import Foundation
import SwiftUI

//MARK: TabBarHidden

extension View {
    func tabBarHidden(_ hidden: Bool = true) -> some View {
        self.background(
            TabBarControllerAccessor(hidden: hidden)
                .frame(width: 0, height: 0)
        )
    }
}

struct TabBarControllerAccessor: UIViewControllerRepresentable {
    let hidden: Bool
    
    func makeUIViewController(context: Context) -> UIViewController {
        Controller(hidden: hidden)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    class Controller: UIViewController {
        let hidden: Bool
        init(hidden: Bool) {
            self.hidden = hidden
            super.init(nibName: nil, bundle: nil)
        }
        required init?(coder: NSCoder) { fatalError() }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            tabBarController?.tabBar.isHidden = hidden
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            if hidden {
                tabBarController?.tabBar.isHidden = false
            }
        }
    }
}
