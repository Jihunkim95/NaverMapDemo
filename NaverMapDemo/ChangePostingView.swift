//
//  ChangePostingView.swift
//  NaverMapDemo
//
//  Created by 김지훈 on 2024/02/05.
//

import SwiftUI

struct ChangePostingView: View {
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel = PostingViewModel()
    
    @State private var selectedImages: [UIImage] = []
    @State private var showActionSheet = false
    @State private var showImagePicker = false
    @State private var sourceType = 0
    
    @ObservedObject var locationManager = LocationManager()
    @State var myCoord:(Double,Double) = (77,77)
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    
                    // 제목 입력 필드
                    Text("제목")
                        .bold()
                    TextField("제목을 입력해주세요", text: $viewModel.noticeBoard.noticeBoardTitle)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(.bottom, 20)
                    
                    // 상세 설명 입력 필드
                    VStack(alignment: .leading) {
                        Text("상세설명")
                            .bold()
                        ZStack {
                            TextEditor(text: $viewModel.noticeBoard.noticeBoardDetail)
                                .padding(.leading, 11)
                                .padding(.trailing, 11)
                                .padding(.top, 7)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            if viewModel.noticeBoard.noticeBoardDetail.isEmpty {
                                VStack {
                                    HStack {
                                        Text("상세 내용을 작성해주세요")
                                            .foregroundStyle(.tertiary)
                                        Spacer()
                                    }
                                    .padding()
                                    
                                    Spacer()
                                }
                            }
                        }
                        .frame(height: 200)
                    }
                    .padding(.bottom, 20)
                    
                    // 교환 희망 장소 선택 버튼
                    Text("교환 희망 장소")
                        .bold()
                    
                    //EmptyView에 지훈님이 만든 네이버 맵 화면
                    NavigationLink(destination: MapMarkerView(myCoord: $myCoord, viewModel: viewModel)) {
                        HStack {
                            Text("\(viewModel.noticeBoard.noticeLocationName )")
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.black)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(hex: "EAEAEA"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .cornerRadius(10)
                    }
                    .padding(.bottom, 30)
                    
                    // 확인 버튼
                    Button(action: {
                        let test = ""
//                        viewModel.uploadPost(isChange: true, images: selectedImages)
                    }) {
                        Text("게시물 등록")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(hex:"59AAE0"))
                            .cornerRadius(10)
                    }
                    .padding(.bottom, 20)
                }
                .onAppear {
                    locationManager.onAuthorizationGranted = updateMapToCurrentLocation
                }
            }
            .padding()
            .navigationTitle("바꿔요")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16))
                            .foregroundStyle(.black)
                    }
                }
            }
        }
    }
    private func updateMapToCurrentLocation() {
        if let currentLocation = locationManager.location {
            myCoord = (currentLocation.longitude, currentLocation.latitude)
        }
    }
}


