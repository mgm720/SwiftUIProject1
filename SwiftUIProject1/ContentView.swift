//
//  ContentView.swift
//  SwiftUIProject1
//
//  Created by Michael Miles on 7/8/19.
//  Copyright © 2019 Michael Miles. All rights reserved.
//

import SwiftUI
import Combine

class DataSource: BindableObject {
    let didChange = PassthroughSubject<Void, Never>()
    var pictures = [String]()
    
    init() {
        let fm = FileManager.default
        
        if let path = Bundle.main.resourcePath, let items = try? fm.contentsOfDirectory(atPath: path) {
            for item in items {
                if item.hasPrefix("nssl") {
                    pictures.append(item)
                }
            }
        }
        didChange.send(())
    }
}

struct DetailView: View {
    //State stores the data for local variables
    @State var hidesNavBar = false
    var selectedImage: String
    
    var body: some View {
        let img = UIImage(named: selectedImage)!
        return Image(uiImage: img)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .navigationBarTitle(Text(selectedImage), displayMode: .inline)
            .navigationBarHidden(hidesNavBar)
            .tapAction {
                self.hidesNavBar.toggle()
        }
    }
}

struct ContentView : View {
    //ObjectBinding stores the data, since SwiftUI is structs
    @ObjectBinding var dataSource = DataSource()
    
    var body: some View {
        NavigationView {
            List(dataSource.pictures.identified(by: \.self)) { picture in
                NavigationLink(
                    destination: DetailView(selectedImage: picture),
                    isDetail: true) {
                        Text(picture)
                }
            }.navigationBarTitle("Storm Viewer")
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
