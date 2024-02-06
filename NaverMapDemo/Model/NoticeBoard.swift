//
//  NoticeBoard.swift
//  NaverMapDemo
//
//  Created by 김지훈 on 2024/02/05.
//

import Foundation

//게시물 등록 화면
struct NoticeBoard: Identifiable {
    //@DocumentID var id:
    var id = UUID().uuidString
    var userId: String
    var noticeBoardTitle: String
    var noticeBoardDetail: String
    var noticeImageLink: [String]
    var noticeLocation: [Double]        //index 0번은 위도, 1번은 경도
    var noticeLocationName: String // 교환 희망 장소
    var isChange: Bool
    var state: Int                      //게시물 상태) 0 = 아무것도 없음, 1 = 예약중, 2 = 교환완료
    var date: Date

    var dictionary: [String: Any] {
        return [
            "noticeBoardId": id,
            "userId": userId,
            "noticeBoardTitle": noticeBoardTitle,
            "noticeBoardDetail": noticeBoardDetail,
            "noticeImageLink": noticeImageLink,
            "noticeLocation": noticeLocation,
            "noticeLocationName": noticeLocationName,
            "isChange": isChange,
            "state": state,
            "date": date
        ]
    }
}
