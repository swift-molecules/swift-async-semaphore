# swift-async-semaphore

Use this package to bound how many tasks run a section of async work at once: a counting semaphore whose waiters suspend instead of blocking a thread, and which can time out, be cancelled, or be shut down. Start from `Async.Semaphore`; `withPermit` is the scoped form of `wait()` followed by `signal()`. To make a fixed number of tasks wait for each other instead of limiting concurrency, use Async.Barrier from swift-async-barrier.

## Laws

- `Async.Semaphore(capacity:)` traps when `capacity` is below 1.
- Suspended waiters are served first in, first out. A `signal()` while waiters are queued hands its permit straight to the oldest eligible waiter instead of returning it to the pool, so a later `wait()` cannot take it first.
- A waiter that has been cancelled or has timed out is never handed a permit; `signal()` skips it and gives the permit to the next waiter.
- When a permit is free, `wait()` and `wait(timeout:)` take it without suspending. Cancellation and the timeout only apply while suspended: an already-cancelled task still acquires a free permit, and a timeout never fires on the fast path.
- A suspended waiter that is resolved by more than one cause fails with the first of shutdown, cancellation, timeout.
- `shutdown()` is idempotent and permanent. It fails every queued waiter with the shutdown error, and every later `wait()` fails the same way. Permits already held are not revoked, and `signal()` is still accepted after shutdown.
- `withPermit` releases the permit exactly once, whether the body returns or throws, and releases nothing when acquisition failed.
- In `Async.Semaphore.Metrics`, `acquisitions` counts permits granted and `releases` counts `signal()` calls. `cancellations` and `timeouts` count waiters resolved by that cause; waiters failed by shutdown count in neither. `peakOutstanding` is a high-water mark that is never reset.
