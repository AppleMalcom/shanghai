# 논문 리뷰 반영 작업 — 인수인계 (새 대화창용)

> 새 대화창을 열면 이 파일 내용을 붙여넣거나 "shanghai 저장소의 HANDOFF 파일을 읽어달라"고 하면 이어서 작업 가능.

## 논문 정보
- 제목: *Geospatial Data Infrastructure for Urban AI: A PostGIS-Based Exploratory Study of Shanghai Metro Deformation and Population Exposure*
- 저자: Changhyun Lee, Kiyun Yu (SNU) / 학회: APRU SCL 2026 Urban AI 백서
- 리뷰어: Mohsen Mohammadzadeh, 판정: **Minor revisions**
- 원고 파일: `Changhyun Lee_Final APRU-SCL2026_UrbanAI.docx` (사용자가 Desktop에서 직접 수정 중)
- 리뷰 시트: `Review Malcom Lee White paper - Urban AI.docx`
- 작업 방식: Kiro가 수정안을 "어느 부분을 어떻게"로 제시 → 사용자가 Word에 직접 반영. **담백하고 간결한 논문 어조 유지(리뷰 반영 티/반복 금지).**

## 확정된 핵심 사실 (데이터)
- 494개 역 (초기 769 → 정제). CSV: `shanghai_metro_risk_final.csv`
- LOS velocity: min -15.74, max -13.63, mean -14.87, median -14.89, SD 0.28 mm/yr (매우 좁은 범위)
- 인구(100m셀): min 0, max 347, mean 109.6, median 94, SD 81.8 (right-skewed)
- 건설중 역 52개, 인구 0인 역 6개
- EWPS = |v_LOS| × log₁₀(P+1)
- Top5 |LOS|: Yu'an(-15.74,1), Dongtan(-15.72,0), North Di Shui Lake(-15.66,0), Dishui Lake(-15.63,21), Chenjia Town(-15.60,4)
- Top5 EWPS: Middle Huaihai Rd(-14.87,347,37.79), Lujiabang Rd(-14.91,331,37.58), Dapuqiao(-14.87,325,37.37), Xinzha Rd(-14.88,323,37.36), Xiaonanmen(-14.93,315,37.33)
- 민감도: EWPS(log10) Top10이 linear/sqrt/pop-only와 9/10 일치, |LOS|-only와 0/10 → 순위는 사실상 인구 지배
- 데이터 출처: OSM(2026.1), LiCSAR frame 171A_05926_131310 ascending LOS mm/yr(2026.1.29, 음수=위성에서 멀어짐=침하, 결측 없음), WorldPop 2020 중국 100m R2025A v1 top-down(2026.2.3), CRS EPSG:4326(WGS84). 최종 통합 2026.2.27
- 로그 근거: Peduzzi et al.(2009) UNDP Disaster Risk Index — 곱셈형 risk=hazard×exposure×vulnerability, 인구 등 무한대 양수 변수에 로그 직접 적용. R=Hfr·Pop·Vul. 논문은 예측용 아님(exploratory) 선례로도 활용 가능.

## 완료된 리뷰 항목
- ✅ 4번 (Case study): 기술통계표(Table 2), 결과표(Table 3,4), EWPS 공식+근거(Peduzzi 2009), 민감도 분석, 운영/건설중 분리, Figure 1·2 범례(5-class quantile+단위)
- ✅ 3번 (재현성, 대부분): provenance 문단 + Table 1(data provenance), frame ID, 부호규약, CRS, 결측없음, retrieval 날짜
- ✅ 9번 (WorldPop 2020 vs 2025 불일치): 본문 "for 2020", 참고문헌 보강, 중복 참고문헌 삭제

## ⏳ 지금 반영 대기 중인 수정 5개 (담백하게 다듬기 — 사용자가 아직 Word에 미반영)
1. **[꼭]** Section 5 provenance 문단이 내용 통째로 중복됨 → 아래 3문장으로 교체:
   "The provenance of each integrated value is documented in Table 1, covering the source dataset and version, reference period, spatial reference system and retrieval date. This allows changes in the underlying observations to be distinguished from those introduced by data processing or dataset updates. Extending these links to the cell and query level would further support reuse of the integrated records."
2. Section 4 첫 문단(769→494가 다음 재현성 문단과 중복) → 축약:
   "Of an initial 769 metro-related OpenStreetMap records, 494 station locations were retained after cleaning. Of these, 52 were labelled in the source data as planned or under construction and 6 fell in grid cells with an estimated population of zero; these records were retained for the integration but are distinguished from operational stations below, because values at planned sites do not describe an existing service." (→ "Each station was linked to a COMET-LiCSAR..." 문장 삭제)
3. Section 3 마지막 문장 → "The comparison illustrates one use of the integrated database."
4. Section 5 둘째 문단: "This is a concrete contribution at the data infrastructure stage. Its value is demonstrated here through the retrieval and comparison of integrated records;" 두 문장 삭제.
5. Section 5 첫 문단: "demonstrate the analytical value of bringing..." → "Their differing spatial patterns show how a common queryable structure can support comparison across heterogeneous observations. This comparison does not, however, establish the accuracy of either ranking as a measure of infrastructure risk."

## 남은 리뷰 항목 (다음 순서 권장)
- **2번** 문제 정의(누가/어떤 유지관리·계획 결정에/결과는) 명확화 + LOS≠수직침하 명시·절대값 사용 정당화
- **5번** hazard/exposure/vulnerability/risk 구분(일부 됨) + 침하·인프라 우선순위화 문헌과 비교 + 기관 활용(공학 판단 대체 안 함) + collection 내 차별성 한 줄
- **6번** 짧은 연구질문 추가 + 별도 Limitations 소절 분리 + Intro/Problems/Discussion/Conclusion 반복 제거("AI starting point" 4회, "exploratory" 5회 등)
- **7번** 본문 1,274→1,500단어 이상 채우기 + UK English 통일(prioritisation, analyse, standardise, visualised) + APA7 점검
- **3번 잔여** 대표 SQL 쿼리(spatial join + EWPS 계산) + 워크플로 다이어그램. 사용자가 원본 Python 코드 없음 → 같은 원리로 새로 작성해 저장소에 넣고 논문엔 대표 SQL 조각 삽입하기로 함.

## 알려진 사소한 이슈
- 원고 line 4(저자 줄)에 과거 "Name, Surnamea" 템플릿 잔재 있었음 — 최근 버전엔 없는 듯, 최종 점검 때 확인.
- EWPS 수식은 docx에 이미지가 아니라 텍스트로. Word에서 v_LOS 아래첨자, log₁₀ 아래첨자 서식만 다듬기.
