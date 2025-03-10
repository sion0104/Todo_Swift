## 개요

**SwiftUI**와 **Swift Data**를 활용하여 제작된 **할 일 관리 애플리케이션**
사용자가 할 일을 효율적으로 관리할 수 있도록 설계되었으며, 작업 추가, 편집, 삭제, 우선순위 지정, 기한별 정렬 등 다양한 기능을 제공.

---

## 주요 기능

1. **작업 관리**

   - 작업 제목, 우선순위, 기한을 입력하여 새 작업 추가 가능.
   - 작업 제목, 우선순위, 기한 수정 가능.
   - 작업 완료/미완료 상태 전환.
   - 작업 목록에서 작업 삭제.

2. **검색 및 필터링**

   - 작업 제목으로 검색 가능.

3. **정렬 기능**

   - **새로운 정렬 옵션 추가**:
     - 기한 오름차순 정렬 (가장 빠른 작업이 상단에 표시됨).
     - 기한 내림차순 정렬 (가장 늦은 작업이 상단에 표시됨).
     - 우선순위별 정렬 (높음 > 중간 > 낮음 순서).
     - 작업 제목 알파벳순 정렬.

4. **로컬 데이터 저장**

   - **Swift Data**를 활용하여 작업 데이터를 로컬에 저장, 앱을 다시 열어도 데이터 유지.

5. **테마 모드 설정**

   - **시스템, 라이트, 다크 모드**를 지원합니다. `@AppStorage`를 사용해 테마 설정이 기기에 저장되며 앱 재실행 시에도 유지됩니다.

6. **사용자 친화적 인터페이스**
   - **SwiftUI** 컴포넌트(`NavigationStack`, `TextField`, `Picker`, `DatePicker`, `List` 등)를 사용한 직관적이고 깔끔한 UI.
   - 작업 상태에 따라 시각적 피드백 제공(예: 완료된 작업은 `strikethrough` 효과와 회색 배경 표시).

---

## 파일 구성

### **1. ContentView.swift**

앱의 메인 화면으로, 작업 목록을 표시합니다. 주요 구성 요소는 다음과 같습니다:

- **검색바**: 검색 기능을 켜고 끌 수 있는 버튼.
- **작업 목록**: 작업을 표시하며, 완료 처리, 세부 정보 보기, 삭제 등의 기능 제공.
- **정렬 및 필터링 옵션**: 툴바 버튼과 메뉴를 통해 접근 가능.
- **툴바 버튼**:
  - 새 작업 추가 (`isAddingTodo` 상태).
  - 검색 기능 토글 (`isSearching` 상태).
  - 정렬 옵션 선택 (`sortOption` 상태).

### **2. AddTodoView.swift**

새 작업을 추가할 때 사용하는 모달 화면입니다. 주요 구성 요소는 다음과 같습니다:

- **Form 레이아웃**: 작업 제목, 우선순위(`Picker`), 기한(`DatePicker`)을 입력할 수 있는 폼.
- **유효성 검사**: 제목이 비어 있지 않은지, 기한이 현재 시점보다 이후인지 확인.
- **Swift Data 통합**: 새로운 작업을 로컬 데이터 저장소에 저장.

### **3. TodoDetailView.swift**

기존 작업을 편집할 수 있는 세부 정보 화면입니다. 주요 기능은 다음과 같습니다:

- **작업 편집**: 제목, 우선순위, 기한 수정 가능.
- **유효성 검사**: 유효하지 않은 입력값 저장 방지.

### **4. TodoItem.swift**

**Swift Data**를 사용하여 정의된 `TodoItem` 모델입니다. 주요 속성:

- `id`: 작업 고유 식별자.
- `title`: 작업 제목.
- `isCompleted`: 작업 완료 여부를 나타내는 불리언 값.
- `priority`: 작업 우선순위(낮음, 중간, 높음).
- `dueDate`: 작업의 기한.

---

## 의존성

- **SwiftUI**: 사용자 인터페이스 디자인.
- **Swift Data**: 작업 데이터 로컬 저장.

---

## 실행 방법

1. 이 저장소를 로컬에 클론합니다.
2. Xcode에서 프로젝트를 엽니다.
3. iOS 17 이상 버전이 실행되는 시뮬레이터 또는 실제 기기에서 앱을 실행합니다.

---

## 향후 개선 사항

- 작업 기한이 다가올 때 알림을 제공하는 기능 추가.
- 작업 카테고리 기능을 도입하여 정리 방식 개선.
- 클라우드 스토리지를 통합하여 여러 기기에서 작업을 동기화.

