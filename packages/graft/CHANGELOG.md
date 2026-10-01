## 0.0.1

* Initial release of **Graft**:
  - High-performance, fine-grained reactive state management for Flutter.
  - Zero code-generation (`build_runner` never needed).
  - Automatic slot-diffing engine for multi-child (`graft.column`, `graft.row`, `graft.stack`) and single-child widgets (`graft.listTile`, `graft.padding`, `graft.card`).
  - Route-stack dependency inheritance via `context.use<T>()` and `context.create<T>()`.
  - Automatic owner-based disposal on route pop.
  - Built-in global observability via `GraftObserver` and `GraftDevObserver`.
  - Declarative unit testing harness `graftTest`.
