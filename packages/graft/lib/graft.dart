/// Graft: High-performance, fine-grained reactive state management for Flutter.
///
/// Features:
/// - Fine-grained slot-level rebuild isolation (`graft.column`, `graft.listTile`, etc.)
/// - Route-stack dependency inheritance (`context.use<T>()`, `context.create<T>()`)
/// - Automatic owner-based disposal on route pop
/// - Zero code generation (`build_runner` never needed)
/// - Single immutable domain state
/// - Built-in observability (`GraftObserver`, `GraftDevObserver`)
library;

export 'src/context/graft_context.dart';
export 'src/core/graft.dart';
export 'src/core/graft_change.dart';
export 'src/core/graft_observer.dart';
export 'src/core/graft_state.dart';
export 'src/core/value_graft.dart';
export 'src/di/graft_registry.dart';
export 'src/route/graft_route_tracker.dart';
export 'src/widgets/child_slot_engine.dart';
export 'src/widgets/graft_widgets.dart';
