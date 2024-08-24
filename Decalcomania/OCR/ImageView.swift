//
//  ImageView.swift
//  Decalcomania
//
//  Created by 장은석 on 8/24/24.
//
import SwiftUI
import Vision

struct ImageView: View {
    
    @State private var imageScale: CGFloat = 1.0
    @State private var lastScaleValue: CGFloat = 1.0
    @State private var recognizedText: String = ""
//    @State private var imageName: String = "jujutsuKaisen"
    @State private var imageName: String = "castle"
    
    var body: some View {
        NavigationView {
            GeometryReader { geometry in
                HStack {
                    // 왼쪽: 이미지 뷰
                    ScrollView([.horizontal, .vertical]) {
                        VStack {
                            Image(imageName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(imageScale)
                                .gesture(MagnificationGesture()
                                            .onChanged { value in
                                                let delta = value / lastScaleValue
                                                lastScaleValue = value
                                                imageScale *= delta
                                            }
                                            .onEnded { _ in
                                                lastScaleValue = 1.0
                                            }
                                )
                                .frame(width: geometry.size.width * 0.6 * imageScale, height: geometry.size.height * imageScale) // 이미지 스케일을 반영하여 프레임 크기 조정
                                .background(Color.clear)
                                .clipped()
                        }
                        .frame(width: geometry.size.width * 0.6 * imageScale, height: geometry.size.height * imageScale) // 스크롤 가능한 영역 크기
                    }
                    
                    Divider() // 왼쪽과 오른쪽 사이에 구분선 추가
                    
                    // 오른쪽: OCR 결과 텍스트 뷰
                    ScrollView {
                        TextEditor(text: $recognizedText) // OCR 결과를 TextEditor에 바인딩
                            .padding()
                            .frame(width: geometry.size.width * 0.4, height: geometry.size.height) // 화면의 40% 차지
                    }
                }
            }
            .frame(minWidth: 600, minHeight: 400) // 윈도우 크기
            .padding()
            .navigationTitle("Image OCR") // 네비게이션 타이틀 설정
            .toolbar {
                ToolbarItem(placement: .confirmationAction) { // 상단 툴바에 버튼 추가
                    Button(action: {
                        performOCR(on: imageName, lang: "ko")
                    }) {
                        Text("Perform OCR")
                    }
                }
            }
        }
    }

    // OCR 기능
    func performOCR(on imageName: String, lang: String = "ja") {
        guard let image = NSImage(named: imageName),
              let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            recognizedText = "이미지를 불러오는데 실패했습니다."
            return
        }
        
        let request = VNRecognizeTextRequest { (request, error) in
            if let error = error {
                recognizedText = "OCR 실패: \(error.localizedDescription)"
                return
            }

            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                recognizedText = "텍스트를 인식하지 못했습니다."
                return
            }

            // 인식된 텍스트를 순회하며 출력
            for observation in observations {
                if let topCandidate = observation.topCandidates(1).first {
                    print("인식된 텍스트: \(topCandidate.string)")
                    print("텍스트의 신뢰도: \(topCandidate.confidence)")
                    print("텍스트의 범위: \(observation.boundingBox)\n")
                }
            }

            let text = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
            recognizedText = text // OCR 결과를 recognizedText에 저장
        }

        // OCR 성능 개선을 위해 언어와 정확도 설정 추가
        request.recognitionLevel = .accurate
        request.recognitionLanguages = [lang] // 일본어 설정
        request.usesLanguageCorrection = true

        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try requestHandler.perform([request])
        } catch {
            recognizedText = "OCR 처리 중 오류 발생: \(error.localizedDescription)"
        }
    }
}

struct ImageView_Previews: PreviewProvider {
    static var previews: some View {
        ImageView()
    }
}
