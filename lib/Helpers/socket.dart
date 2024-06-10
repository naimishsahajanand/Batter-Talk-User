// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_const_declarations, unnecessary_brace_in_string_interps, constant_identifier_names, library_prefixes

import 'package:batter_talk_user/Helpers/api_endpoints.dart';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Conecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Conecting;

  ServerStatus get serverStatus => _serverStatus;

  late IO.Socket socket;

  void connect(String room) async {
    final token = "";

    socket = IO.io(SocketApi.socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'forceNew': true,
      'extraHeaders': {
        'x-token': token,
        'room': room,
      }
    });

    print("++++++++__________+++++++++++${token}");
    socket.connect();

    socket.onConnect((data) => {
          print('Connected to socket server'),
          _serverStatus = ServerStatus.Online,
        });

    socket.onDisconnect((data) => {
          print('Disconnected from socket server'),
          _serverStatus = ServerStatus.Offline,
          //notifyListeners(),
        });
  }

  void soc_connect() {
    print('121222 connecting socket...');
    socket.connect();
    print('211222121 connected socket...');
  }

  void disconnect() {
    print('121222 Reconnecting socket...');
    socket.disconnect();
    print('211222121 Disconnected socket...');
  }
}
