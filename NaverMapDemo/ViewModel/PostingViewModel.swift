//
//  PostingViewModel.swift
//  NaverMapDemo
//
//  Created by 김지훈 on 2024/02/05.
//

import Foundation


class PostingViewModel: ObservableObject {
    @Published var noticeBoard: NoticeBoard
    
    init() {
        noticeBoard = NoticeBoard(userId: "", noticeBoardTitle: "", noticeBoardDetail: "", noticeImageLink: [], noticeLocation: [],noticeLocationName: [], isChange: false, state: 0, date: Date())
    }

    // 위도,경도 값을 noticeLocation에 저장 or 업데이트
    func updateLocation(with coord: (Double, Double)) {
        // noticeLocation 배열이 비어있거나, 기존 값이 있을 때는 값을 업데이트
        if noticeBoard.noticeLocation.isEmpty {
            // 새로운 좌표 추가
            noticeBoard.noticeLocation.append(contentsOf: [coord.1, coord.0]) // 위도, 경도 순서
        } else {
            // 기존 좌표 업데이트
            noticeBoard.noticeLocation[0] = coord.1 // 위도
            noticeBoard.noticeLocation[1] = coord.0 // 경도
        }
    }
    
    // coord 값을 updateLocationName에 저장 or 업데이트
    func updateLocationName(with rocation: String) {
        // noticeLocationName 배열이 비어있거나, 기존 값이 있을 때는 값을 업데이트
        if noticeBoard.noticeLocationName.isEmpty {
            // 새로운 도로명 추가
            noticeBoard.noticeLocationName.append(rocation) // 도로명
        } else {
            // 기존 도로명 업데이트
            noticeBoard.noticeLocationName[0] = rocation
        }
    }
    

}
