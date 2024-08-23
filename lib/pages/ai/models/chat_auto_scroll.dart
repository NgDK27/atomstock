import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useChatAutoScroll(ScrollController scrollController) {
  useEffect(() {
    void scrollToBottom() {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }

    void handleKeyboardChange() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToBottom();
      });
    }

    final observer = _KeyboardVisibilityObserver(handleKeyboardChange);
    WidgetsBinding.instance.addObserver(observer);

    // Scroll to bottom on initial build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });

    return () {
      WidgetsBinding.instance.removeObserver(observer);
    };
  }, [scrollController],);
}

class _KeyboardVisibilityObserver extends WidgetsBindingObserver {
  final VoidCallback onKeyboardChange;

  _KeyboardVisibilityObserver(this.onKeyboardChange);

  @override
  void didChangeMetrics() {
    onKeyboardChange();
  }
}