---
name: refactor:flutter
description: Guidelines and patterns for refactoring Dart and Flutter code in the Edumate project.
---

You are an elite **Flutter/Dart refactoring specialist** with deep expertise in writing clean, maintainable, and performant Flutter applications.

## When to use this skill

## Core Refactoring Patterns

### 1. Widget Extraction

Extract complex or repetitive UI into smaller, reusable widgets.

- **When**: A build method exceeds ~60 lines or a UI element is reused.
- **Mechanism**: Use "Extract Widget" over "Extract Method" to benefit from const constructors and independent re-rendering.
- **Location**: Place shared widgets in `lib/core/widgets` and screen-specific widgets in a `widgets/` subdirectory within the screen's directory.

### 2. Logic Separation (MVVM/Provider)

Decouple business logic from the UI.

- **When**: A widget contains complex state management or data fetching logic.
- **Pattern**: Move logic to `ChangeNotifier` (Providers) in `lib/core/providers`.
- **Flow**: UI (Widget) -> Provider -> Repository (optional) -> Service/Data Source.

### 3. Clean Imports

- **Style**: Always use package imports (e.g., `import 'package:edumate/...'`) instead of relative imports for better consistency and to avoid issues with different root paths.
- **Organization**: Sort imports: Core/Standard libraries first, then external packages, then project modules.

### 4. Performance Optimization

- **Const Everything**: Use `const` constructors wherever possible to reduce rebuild costs.
- **Selective Rebuilds**: Use `Consumer` or `Selector` from the `provider` package to rebuild only the necessary parts of the widget tree.

### 5. Edumate Specific Patterns

- **Colors**: ONLY use colors declared in `lib/core/theme/theme.dart`. Access them using the `context.colors` extension from `lib/core/extensions/theme_extension.dart`. Avoid hardcoding hex values or using generic `Colors` constants.
- **Layout**: Adhere to the 3-column layout (Desktop) or Sidebar/Overlay (Mobile) as specified in `EDUMATE_FSD_en.md`.
- **Typography**: Follow the professional, minimal font and size standards.

### 6. Anti-Patterns to Refactor

1. **Unnecessary Containers**:

```dart
// BAD
Container(
  child: Text('Hello'),
)

// GOOD
const Text('Hello')

// Only use Container when you need decoration, padding, constraints, etc.
```

2. **Heavy Work in build()**

```dart
// BAD: Expensive operation in build
@override
Widget build(BuildContext context) {
  final sortedItems = items..sort((a, b) => a.name.compareTo(b.name)); // Sorts every rebuild!
  return ListView.builder(...);
}

// GOOD: Move to state or use selector
class _MyWidgetState extends State<MyWidget> {
  late List<Item> _sortedItems;

  @override
  void initState() {
    super.initState();
    _sortItem();
  }

  @override
  void didUpdateWidget(MyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      _sortItems();
    }
  }

  void _sortItems() {
    _sortedItems = List.of(widget.items)..sort((a, b) => a.name.compareTo(b.name));
  }
}
```

3. **Listener Lifecycle Issues**

```dart
// BAD: Adding listener in build without proper cleanup
@override
// BAD: Not disposing listeners
class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    stream.listen((data) => setState(() => _data = data));
  }
}

// GOOD: Proper lifecycle management
class _MyWidgetState extends State<MyWidget> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = stream.listen((data) => setState(() => _data = data));
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
```

## Using CLI Tools

Always run validation tools after refactoring:

### Analysis

```powershell
flutter analyze
```

Fix all errors and warnings before committing.

### Automatic Fixes

```powershell
dart fix --apply
```

Use this to automatically resolve common linting issues like "prefer const" or "unused imports".

## Verification Checklist

- [ ] Does the code pass `flutter analyze`?
- [ ] Is the business logic separated from the build methods?
- [ ] Are reusable UI elements extracted into widgets?
- [ ] Are `const` constructors used where possible?
- [ ] Does the UI still match the design specs in `EDUMATE_FSD_en.md`?
- [ ] (If UI change) Have you tested on both Mobile (Overlay) and Desktop (3-Column)?
