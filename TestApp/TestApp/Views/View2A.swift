//
// ©2019 SEAT, S.A. All rights reserved.
//
// This is file is part of a propietary app or framework.
// Unauthorized reproduction, copying or modification of this file is strictly prohibited.
//
// This code is proprietary and confidential.
//
// All the 3rd-party libraries included in the project are regulated by their own licenses.
//

import SwiftUI
import NavigationRouter

struct View2A: RoutableView {
    var body: some SwiftUI.View {
        VStack {
            Text("This view is from Module 2 and DOES NOT require authentication")
            Spacer()
        }.navigationBarTitle("Module 2 - No authentication")
    }
    
    var viewModel: ViewModel2A
    
    init(viewModel: ViewModel2A) {
        self.viewModel = viewModel
    }
}
