import 'package:material_ui/material_ui.dart';

import '../../common/extension/object_extension.dart';
import '../../common/models/thunder_network_log.dart';
import '../../common/utils/date_time_extension.dart';
import '../../common/utils/helpers.dart';
import 'list_row_item.dart';

/// A widget that displays the request of a network log.
class const LogRequestWidget({
  /// The network log to display
  required final ThunderNetworkLog log,
  super.key,
}) extends StatelessWidget {
  /// Constructor for the [LogRequestWidget] class.
  this;

  @override
  Widget build(BuildContext context) => ListView(
    children: [
      ListRowItem(
        name: 'Started',
        value: (log.sendTime ?? DateTime.now()).formatDDMMYYYYHHmmssSSS,
      ),
      ListRowItem(
        name: 'Bytes sent',
        value: Helpers.formatBytes(log.sendBytes),
      ),
      ListRowItem(
        name: 'Headers',
        value: log.request.headers.prettyJson,
        showCopyButton: true,
        isJson: true,
      ),
      ListRowItem(
        name: 'Body',
        value: log.request.body.prettyJsonEncodedBody,
        showCopyButton: true,
        isJson: true,
      ),
      ListRowItem(
        name: 'Query Parameters',
        value: log.request.url.queryParameters.prettyJson,
        showCopyButton: true,
        showDivider: false,
        isJson: true,
      ),
    ],
  );
}
