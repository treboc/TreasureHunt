//  Created by Dominik Hauser on 08.09.22.
//  
//

import SwiftUI

struct ContentView: View {

  @State var showInput = false {
    didSet {
      print("showInput: \(showInput)")
    }
  }
  let stationsStore = StationsStore()
  @EnvironmentObject private var locationProvider: LocationProvider

  var body: some View {
    NavigationView {
      VStack {
        Text("Name of the station")
        DirectionDistance(angle: 30, error: nil, distance: 30)
      }
      .navigationBarItems(trailing:
                            Button(action: {
        showInput.toggle()
      }) {
        Image(systemName: "plus")
      })
      .sheet(isPresented: $showInput) {
        if let location = locationProvider.location {
          InputView(location: location)
        } else {
          EmptyView()
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
