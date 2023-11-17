// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

/// https://codewithandrea.com/tips/socket-exception-connection-failed-macos/
void main() async {
  final wsUrl = Uri.parse('ws://192.168.0.207:81');
  const connectTimeout = Duration(milliseconds: 500);
  print('Connecting to $wsUrl');
  // final channel = WebSocketChannel.connect(wsUrl);
  final channel = WebSocketChannel.connect(wsUrl, connectTimeout: connectTimeout);
  print('Connected to $wsUrl');

  await channel.ready;

  print('Channel ready');

  channel.stream.listen(
    (data) async {
      print('Received data: $data');
    },
    onDone: () {
      print('Channel closed');
    },
    onError: (error) {
      print('Channel error: $error');
    },
  );

  print('Sending message');
  channel.sink.add('hello!');
}
