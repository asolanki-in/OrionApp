//
//  RuleRow.swift
//  SwiftUIDemos
//
//  Created by Anil Solanki on 03/05/21.
//

import SwiftUI

struct RuleRow: View {
    let rule: Rule
    var body: some View {
        Section {
            Text(rule.title).font(.headline).padding(.vertical, 5)
            if let text = rule.markdown{
                Text(text).padding(.vertical, 5)
            }
        }
    }
}

//struct RuleRow_Previews: PreviewProvider {
//    static var previews: some View {
//        Form {
//            RuleRow()
//        }
//    }
//}
