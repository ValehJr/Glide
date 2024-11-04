//
//  ContentView.swift
//  TransitHackathon
//
//  Created by Valeh Ismayilov on 01.11.24.
//

import MapKit
import SwiftUI

struct MainView: View {
    @State private var vm = MainViewModel()
    
    var body: some View {
        ZStack {
            Map(position: $vm.locationManager.cameraPosition)
            {
                ForEach(0..<(vm.coordinatesC.count > 1 ? vm.coordinatesC.count - 1 : 0), id: \.self) { index in
                    let point = vm.coordinatesC[index]
                    let nextPoint = vm.coordinatesC[index + 1]
                    
                    MapPolyline(coordinates: [point.coordinate, nextPoint.coordinate])
                        .stroke(vm.colorForPolyline(from: point, to: nextPoint), lineWidth: 5)
                }
                
                ForEach(vm.obstacles, id: \.id) { obstacle in
                    Annotation("",coordinate: obstacle.coordinate) {
                        Image(obstacle.type.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width:36)
                    }
                }//ForEach
                
                if let startPointAnnotation = vm.startPointAnnotation {
                    Annotation("Start", coordinate: startPointAnnotation.coordinate) {
                        AnnotationView(imageName: "startPointPin")
                    }
                    
                    MapPolygon(coordinates: [startPointAnnotation.coordinate])
                }
                
                if let destinationPointAnnotation = vm.destinationPointAnnotation {
                    Annotation("Destination", coordinate: destinationPointAnnotation.coordinate) {
                        AnnotationView(imageName: "destinationPointPin")
                    }
                }
                
            }//Map
            .onAppear {
                DispatchQueue.global().async {
                    self.vm.locationManager.checkIfLocationServicesIsEnabled()
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
            }
            VStack {
                CustomTextField(text: $vm.fromSearchQuery, placeholder: "Search for start point",isEditingChanged: {isEditing in
                    vm.isEditingFromField = isEditing
                },
                                onCommit: {
                    vm.performSearch(isFromSearch: true)
                })
                .padding(.top, 4)
                
                
                if !vm.fromSearchQuery.isEmpty || vm.isEditingFromField {
                    CustomTextField(text: $vm.toSearchQuery, placeholder: "Search for destination point", isEditingChanged : {               isEditing in
                        vm.isEditingToField = isEditing
                    },
                                    onCommit: {
                        vm.performSearch(isFromSearch: false)
                    })
                }
                Spacer()
                if vm.beginCoordinate != nil && vm.destCoordinate != nil {
                    Button(action: {
                        vm.isShowingDestination = true
                        vm.sendRouteRequest()
                    }) {
                        Text("Get Route")
                            .fontWeight(.medium)
                            .frame(width: 100, height: 40)
                            .background(Color.customGray.opacity(0.85))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                HStack {
                    if !vm.isEditingFromField && !vm.isEditingToField && !vm.fromSearchQuery.isEmpty && !vm.toSearchQuery.isEmpty {
                        Button(action:{
                            vm.isShowingAlert = true
                        }, label: {
                            ZStack {
                                BottomButtonView(imageName: "bell.fill")
                            }
                            
                        })//Button
                        .padding(.leading,8)
                        .alert("The bus driver has been notified.", isPresented: $vm.isShowingAlert) {
                            Button("OK", role: .cancel) { }
                        }
                    } else {
                        ZStack {
                            BottomButtonView(imageName: "bell.fill")
                            Circle()
                                .fill(Color.black.opacity(0.6))
                                .frame(width: 45, height: 45)
                        }
                        .padding(.leading,8)
                    }
                    Spacer()
                    Button(action: {
                        vm.isShowingAlarm.toggle()
                    }, label: {
                        BottomButtonView(imageName: "exclamationmark.triangle.fill")
                    })
                    .padding(.trailing,8)
                    .sheet(isPresented: $vm.isShowingAlarm) {
                        ObstaclesGridView(obstacleSelected: { selectedObstacle in
                            if let userLocation = vm.locationManager.userLocation {
                                let newObstacle = Obstacle(type: selectedObstacle, coordinate: userLocation)
                                vm.obstacles.append(newObstacle)
                                print(newObstacle)
                                vm.isShowingAlarm.toggle()
                                
                            }
                        })
                        .presentationDetents([.height(460)])
                    }
                }//H
                .frame(width: 120,height: 60)
                .background(
                    Capsule()
                        .fill(Color.customGray)
                )
                
            }//V
            .padding(.horizontal,15)
            .padding(.bottom,20)
        }//Z
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
}

#Preview {
    MainView()
}
