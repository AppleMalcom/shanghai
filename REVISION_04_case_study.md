# 리뷰어 항목 4 (Case study / empirical example) — 개정안

리뷰어(Mohsen Mohammadzadeh)가 항목 4에서 요구한 내용:

> 노출 대리변수와 점수는 상당한 검증이 필요. 단일 100m 셀 인구 ≠ 역세권/이용객/위험 노출 인구.
> 계획·건설중 역을 운영역과 근거 없이 함께 분석 금지. **기술통계 분포**를 제시하고,
> **EWPS = |LOS velocity| × log10(population + 1)의 근거**를 설명. **대안 역세권/가중치 민감도 분석**,
> **공간 불확실성 및 독립 검증** 논의. 지도에는 **수치 구간과 단위를 포함한 범례** 필요.

아래 개정안은 저장소의 `shanghai_metro_risk_final.csv`(494개 역)에서 실제로 계산한 수치를 사용합니다.

---

## 확정된 실제 수치 (재현 가능)

| 변수 | n | Min | Max | Mean | Median | SD |
|------|---|-----|-----|------|--------|-----|
| LOS velocity (signed, mm yr⁻¹) | 494 | −15.74 | −13.63 | −14.87 | −14.89 | 0.28 |
| \|LOS velocity\| (mm yr⁻¹) | 494 | 13.63 | 15.74 | 14.87 | 14.89 | 0.28 |
| Residential population (per 100 m cell) | 494 | 0 | 347 | 109.6 | 94 | 81.8 |

- 인구가 0인 역: **6개**
- 자료상 "still in construction"으로 표기된 역: **52개**

**Table A. 물리적 변형 상위 5개 역 (|LOS velocity| 기준)**

| Rank | Station | LOS velocity (mm yr⁻¹) | Population |
|------|---------|------------------------|-----------|
| 1 | Yu'an (under construction) | −15.74 | 1 |
| 2 | Dongtan (under construction) | −15.72 | 0 |
| 3 | North Di Shui Lake (under construction) | −15.66 | 0 |
| 4 | Dishui Lake | −15.63 | 21 |
| 5 | Chenjia Town (under construction) | −15.60 | 4 |

**Table B. 노출 가중 우선순위 상위 5개 역 (EWPS 기준)**

| Rank | Station | LOS velocity (mm yr⁻¹) | Population | EWPS |
|------|---------|------------------------|-----------|------|
| 1 | Middle Huaihai Road | −14.87 | 347 | 37.79 |
| 2 | Lujiabang Road | −14.91 | 331 | 37.58 |
| 3 | Dapuqiao | −14.87 | 325 | 37.37 |
| 4 | Xinzha Road | −14.88 | 323 | 37.36 |
| 5 | Xiaonanmen | −14.93 | 315 | 37.33 |

**민감도 분석 (baseline EWPS = |LOS|·log₁₀(pop+1) 의 상위 10개와 겹치는 정도)**

| 대안 가중치 | Top-10 중복 |
|------------|-------------|
| Linear: \|LOS\|·pop | 9 / 10 |
| Square-root: \|LOS\|·√pop | 9 / 10 |
| Population only (LOS 무시) | 9 / 10 |
| \|LOS\| only (population 무시) | 0 / 10 |

→ 순위는 가중치 **형태(log/linear/sqrt)** 변화에는 견고하지만, **population-only 순위와 사실상 동일**하고
\|LOS\|-only 순위와는 전혀 겹치지 않는다. 즉 EWPS 순위는 인구가 지배한다. LOS 값의 범위가
좁기(SD 0.28) 때문이며, 이것이 본 연구를 **탐색적(exploratory)** 으로 규정하는 정량적 근거다.

---

## Section 4 개정 텍스트 (영문, UK English, 논문에 바로 붙일 수 있음)

### 4. CASE STUDY OR EMPIRICAL EXAMPLE

The Shanghai Metro network was examined as an empirical case. Previous studies have used
time-series InSAR to monitor ground deformation along the network and have combined PS-InSAR
with machine learning to assess subsidence risk (Zhang et al., 2023; Chai et al., 2024). The
present case examines the same urban context from a complementary perspective by integrating
physical deformation with station locations and residential population.

The initial OpenStreetMap dataset contained 769 metro-related records. After removing records
with missing essential information and resolving duplicated station names, 494 station
locations were retained. Each station was linked to a COMET-LiCSAR LOS deformation velocity
and to the WorldPop residential population estimate of the corresponding 100 m grid cell. Of
these 494 stations, 52 were labelled in the source data as planned or under construction and 6
fell in grid cells with an estimated population of zero. These records were retained for the
integration demonstration but are distinguished from operational stations in the interpretation
below, because deformation and population values at planned sites do not describe an existing
transport service.

Across the 494 stations, LOS deformation velocity ranged from −15.74 to −13.63 mm yr⁻¹
(mean −14.87, median −14.89, standard deviation 0.28 mm yr⁻¹), so all stations lay within a
narrow deformation band. Residential population per 100 m cell ranged from 0 to 347
(mean 109.6, median 94, standard deviation 81.8), a much wider relative spread. These
descriptive distributions are summarised in Table 1.

*Table 1. Descriptive statistics for the integrated station-level variables (n = 494).*

| Variable | Min | Max | Mean | Median | SD |
|----------|-----|-----|------|--------|----|
| LOS velocity (mm yr⁻¹) | −15.74 | −13.63 | −14.87 | −14.89 | 0.28 |
| \|LOS velocity\| (mm yr⁻¹) | 13.63 | 15.74 | 14.87 | 14.89 | 0.28 |
| Residential population (per 100 m cell) | 0 | 347 | 109.6 | 94 | 81.8 |

The physical-deformation view was produced using the absolute LOS deformation velocity at each
station. The highest absolute values appeared mainly at eastern, coastal and peripheral
stations, several of which were labelled as planned or under construction (Table 2). Four of the
five highest-deformation stations had a residential population of four or fewer.

*Table 2. Five stations with the highest absolute LOS deformation velocity.*

| Rank | Station | LOS velocity (mm yr⁻¹) | Population |
|------|---------|------------------------|-----------|
| 1 | Yu'an (under construction) | −15.74 | 1 |
| 2 | Dongtan (under construction) | −15.72 | 0 |
| 3 | North Di Shui Lake (under construction) | −15.66 | 0 |
| 4 | Dishui Lake | −15.63 | 21 |
| 5 | Chenjia Town (under construction) | −15.60 | 4 |

*Figure 1. Spatial distribution of absolute LOS deformation velocity at Shanghai Metro
stations (mm yr⁻¹). Graduated symbols follow five quantile classes spanning 13.63–15.74 mm yr⁻¹,
with darker red denoting higher absolute velocity. Map by the authors; basemap © OpenStreetMap
contributors, ODbL.*

Population exposure was then incorporated using an exposure-weighted priority score (EWPS):

> **EWPS = |v_LOS| × log₁₀(P + 1)**

where **v_LOS** is the LOS deformation velocity at the station (mm yr⁻¹), the absolute value is
used to represent the magnitude of movement irrespective of direction, and **P** is the WorldPop
residential population estimate for the 100 m grid cell containing the station. The base-10
logarithm compresses the wide population range (0–347) so that a small number of very high-density
cells does not dominate the product, and the "+1" term keeps the score defined where P = 0. This
formulation is a transparent, monotonic weighting rather than an empirically calibrated risk model;
it is used here only to illustrate how the integrated records can express a combined ranking.

Under this score the highest-priority stations concentrated in central Shanghai (Table 3),
including Middle Huaihai Road, Lujiabang Road, Dapuqiao, Xinzha Road and Xiaonanmen. All five
are operational, densely populated central stations rather than the peripheral,
low-population stations that dominated the deformation-only view.

*Table 3. Five highest-priority stations under the exposure-weighted score.*

| Rank | Station | LOS velocity (mm yr⁻¹) | Population | EWPS |
|------|---------|------------------------|-----------|------|
| 1 | Middle Huaihai Road | −14.87 | 347 | 37.79 |
| 2 | Lujiabang Road | −14.91 | 331 | 37.58 |
| 3 | Dapuqiao | −14.87 | 325 | 37.37 |
| 4 | Xinzha Road | −14.88 | 323 | 37.36 |
| 5 | Xiaonanmen | −14.93 | 315 | 37.33 |

*Figure 2. Exposure-weighted priority (EWPS) based on LOS deformation velocity and residential
population (dimensionless index). Graduated symbols follow five quantile classes, with darker red
denoting a higher score. Map by the authors; basemap © OpenStreetMap contributors, ODbL.*

To test how far this ranking depends on the chosen weighting, the top-ten EWPS stations were
compared with rankings produced by alternative formulations. Replacing the logarithm with a
linear (|v_LOS| × P) or square-root (|v_LOS| × √P) population weight changed only one of the top
ten stations (nine of ten retained in each case). A ranking based on population alone likewise
retained nine of the ten, whereas a ranking based on |v_LOS| alone shared none. The exposure-weighted
ranking is therefore robust to the shape of the population weighting but is effectively governed by
population, because the LOS values occupy a narrow band (standard deviation 0.28 mm yr⁻¹). This
dependence, together with the spatial uncertainty of the single-cell population extraction and the
absence of independent validation, is why the exposure-weighted results are presented as an
exploratory demonstration of heterogeneous data integration rather than as a validated measure of
subsidence risk.

The comparison shows that a deformation-only view and an exposure-informed view produce different
spatial patterns: the former highlights peripheral, largely non-operational stations, while the
latter highlights the dense central core. Confirming whether either pattern reflects actual
infrastructure risk would require station-catchment population rather than single-cell estimates,
conversion of LOS velocity to vertical motion, separation of operational from planned stations,
and comparison against independent subsidence observations.
```
```

---

## 이 개정안이 리뷰어 4번 요구를 충족하는 방식 (체크리스트)

| 리뷰어 요구 | 반영 위치 |
|-------------|-----------|
| 기술통계 분포(descriptive distributions) | Table 1 + 본문 통계 문장 |
| EWPS 공식 근거 설명 | 수식 직후 변수/단위 정의 + log·"+1" 근거 |
| 단일 100m 셀 ≠ 역세권/이용객 | 마지막 문단 + 민감도 문단 |
| 계획/건설중 역 분리 정당화 | 2번째 문단 (52개·인구0 6개 명시, 해석에서 구분) |
| 대안 역세권/가중치 민감도 | 민감도 문단 (linear/sqrt/pop-only/LOS-only 비교) |
| 공간 불확실성 + 독립 검증 | 민감도 문단 끝 + 마지막 문단 |
| 지도 범례(수치 구간+단위) | Figure 1·2 캡션 (5-class quantile, 단위 명시) |

> **참고:** 표 3개가 추가되면서 본문 단어 수가 늘어, 리뷰어 7번(1,500단어 미달) 문제도 부분적으로 완화됩니다.
