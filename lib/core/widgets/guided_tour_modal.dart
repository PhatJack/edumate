import 'package:flutter/material.dart';

enum TourStepAction { back, next, close }

class GuidedTourStep {
  final String title;
  final String description;

  const GuidedTourStep({
    required this.title,
    required this.description,
  });
}

Future<TourStepAction> showGuidedTourStepModal(
  BuildContext context, {
  required GuidedTourStep step,
  required int currentStep,
  required int totalSteps,
  bool canGoBack = false,
  bool isLastStep = false,
  GlobalKey? targetKey,
  bool forceCenter = false,
}) async {
  final action = await showDialog<TourStepAction>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      final theme = Theme.of(context);
      final colorScheme = theme.colorScheme;
      final media = MediaQuery.of(context);

      Rect? targetRect;
      if (!forceCenter && targetKey?.currentContext != null) {
        final renderObject = targetKey!.currentContext!.findRenderObject();
        if (renderObject is RenderBox && renderObject.hasSize) {
          final topLeft = renderObject.localToGlobal(Offset.zero);
          targetRect = topLeft & renderObject.size;
        }
      }

      final maxCardWidth = media.size.width > 560 ? 460.0 : media.size.width - 32;

      double? top;
      double? left;
      if (targetRect != null) {
        final preferredTop = targetRect.bottom + 12;
        final clampedLeft = (targetRect.left - 12).clamp(
          16.0,
          (media.size.width - maxCardWidth - 16).clamp(16.0, double.infinity),
        );
        left = clampedLeft;
        top = preferredTop;
        if (preferredTop > media.size.height * 0.68) {
          top = (targetRect.top - 280).clamp(16.0, media.size.height - 320);
        }
      }

      Widget card() {
        return Material(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Huong dan su dung',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(TourStepAction.close),
                      icon: const Icon(Icons.close),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  step.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  step.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 18),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: totalSteps == 0 ? 0 : currentStep / totalSteps,
                    minHeight: 6,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Bước $currentStep/$totalSteps',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    if (canGoBack)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(TourStepAction.back),
                          child: const Text('Quay lại'),
                        ),
                      ),
                    if (canGoBack) const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).pop(TourStepAction.next),
                        child: Text(isLastStep ? 'Bắt đầu ngay' : 'Tiếp theo'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }

      return Stack(
        children: [
          Positioned.fill(
            child: ColoredBox(color: Colors.black.withValues(alpha: 0.45)),
          ),
          if (targetRect != null)
            Positioned(
              left: targetRect.left - 4,
              top: targetRect.top - 4,
              width: targetRect.width + 8,
              height: targetRect.height + 8,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ),
          if (top != null && left != null)
            Positioned(
              top: top,
              left: left,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxCardWidth),
                child: card(),
              ),
            )
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxCardWidth),
                  child: card(),
                ),
              ),
            ),
        ],
      );
    },
  );

  return action ?? TourStepAction.close;
}
