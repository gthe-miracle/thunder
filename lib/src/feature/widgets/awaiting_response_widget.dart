import 'package:material_ui/material_ui.dart';

import '../../common/utils/colors.dart';

/// A widget that displays a circular progress indicator and a message.
class const AwaitingResponseWidget({
  super.key,

  /// The message to display
  final String message = 'Awaiting response...',
}) extends StatelessWidget {
  /// Constructor for the [AwaitingResponseWidget] class.
  this;

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            backgroundColor: ThunderColors.of(context).surface,
            color: ThunderColors.of(context).brilliantAzure,
            strokeCap: StrokeCap.round,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: ThunderColors.of(context).cBlack,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    ),
  );
}
