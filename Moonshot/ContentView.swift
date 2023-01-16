//
//  ContentView.swift
//  Moonshot
//
//  Created by artembolotov on 11.01.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State private var currentLayout = ViewLayout.list
    
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    let missons: [Mission] = Bundle.main.decode("missions.json")
    
    var body: some View {
        NavigationView {
            Group {
                switch currentLayout {
                case .grid:
                    GridLayout(astronauts: astronauts, missons: missons)
                case .list:
                    ListLayout(astronauts: astronauts, missons: missons)
                }
            }
            .navigationTitle("Moonshot")
            .toolbar(content: {
                Button {
                    withAnimation {
                        currentLayout.toggle()
                    }
                } label: {
                    Image(systemName: currentLayout == .grid ? "list.triangle" : "square.grid.2x2")
                }
            })
            .background(.darkBackground)
            .preferredColorScheme(.dark)
        }
    }
}

struct GridLayout: View {
    let astronauts: [String: Astronaut]
    let missons: [Mission]
    
    let colums = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: colums) {
                ForEach(missons) { misson in
                    NavigationLink {
                        MissionView(mission: misson, astronauts: astronauts)
                    } label: {
                        VStack {
                            Image(misson.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding()
                            VStack {
                                Text(misson.displayName)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Text(misson.formattedLaunchDate)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.5))
                            }
                            .padding(.vertical)
                            .frame(maxWidth: .infinity)
                            .background(.lightBackground)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.lightBackground)
                        }
                    }
                }
            }
            .padding([.horizontal, .bottom])
        }
    }
}

struct ListLayout: View {
    let astronauts: [String: Astronaut]
    let missons: [Mission]
    
    var body: some View {
        List(missons) {mission in
            NavigationLink {
                MissionView(mission: mission, astronauts: astronauts)
            } label: {
                MissonCell(mission: mission)
            }
            .listRowBackground(Color.darkBackground)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

struct MissonCell: View {
    let mission: Mission
    
    var body: some View {
        HStack (spacing: 0) {
            Image(mission.image)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .padding()
            HStack {
                VStack(alignment: .leading) {
                    Text(mission.displayName)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(mission.formattedLaunchDate)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.leading)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.lightBackground)
        }
        .padding([.leading, .top, .bottom], 1)
        .padding(.trailing, 0)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(.lightBackground)
                .padding(.trailing, -10)
                .clipShape(Rectangle())
        }
    }
}

extension ContentView {
    enum ViewLayout {
        case grid, list
        
        mutating func toggle() {
            self = self == .grid ? .list : .grid
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
