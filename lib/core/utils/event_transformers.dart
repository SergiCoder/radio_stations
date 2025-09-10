import 'dart:async';

import 'package:bloc/bloc.dart';

/// A collection of reusable BLoC `EventTransformer`s.
///
/// These transformers help control how frequently events are processed
/// by a BLoC, preventing rapid, repeated invocations that can lead to
/// wasted work or jittery UX.
/// Provides reusable BLoC `EventTransformer`s.
///
/// Use DI to inject this where needed instead of calling static helpers.
class EventTransformers {
  /// Creates a new instance of [EventTransformers].
  const EventTransformers();

  /// Creates an `EventTransformer` that drops incoming events while the
  /// previous event is still being processed by the handler.
  ///
  /// This mirrors an "exhaust"/"droppable" strategy: it prevents piling up
  /// of concurrent actions and is well-suited for play/pause toggles.
  ///
  /// After each handled event completes, a cooldown period is applied where
  /// new events are also dropped. The default cooldown is 500ms.
  EventTransformer<E> droppable<E>({Duration cooldown = const Duration(milliseconds: 500)}) {
    return (events, mapper) {
      late StreamController<E> controller;
      StreamSubscription<E>? subscription;
      var isRunning = false;
      var inCooldown = false;
      Timer? cooldownTimer;

      controller = StreamController<E>(
        onListen: () {
          subscription = events.listen(
            (event) {
              if (isRunning || inCooldown) return;
              isRunning = true;
              controller
                  .addStream(mapper(event))
                  .whenComplete(() {
                    isRunning = false;
                    if (cooldown > Duration.zero) {
                      inCooldown = true;
                      cooldownTimer?.cancel();
                      cooldownTimer = Timer(cooldown, () {
                        inCooldown = false;
                      });
                    }
                  });
            },
            onError: controller.addError,
            onDone: () {
              cooldownTimer?.cancel();
              controller.close();
            },
            cancelOnError: false,
          );
        },
        onPause: () => subscription?.pause(),
        onResume: () => subscription?.resume(),
        onCancel: () {
          cooldownTimer?.cancel();
          return subscription?.cancel();
        },
      );

      return controller.stream;
    };
  }
}
