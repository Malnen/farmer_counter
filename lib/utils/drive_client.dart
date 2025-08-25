import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;

enum DriveAuthState { disconnected, connected }

class DriveClient {
  final ValueNotifier<DriveAuthState> authState;

  bool _initialized;
  GoogleSignInAccount? _account;
  Map<String, String>? _headers;

  DriveClient()
      : authState = ValueNotifier<DriveAuthState>(DriveAuthState.disconnected),
        _initialized = false;

  bool get isConnected => authState.value == DriveAuthState.connected;

  drive.DriveApi? get api => (_headers != null) ? drive.DriveApi(_AuthHttpClient(_headers!)) : null;

  Future<bool> connect() async {
    await _ensureInit();
    try {
      final GoogleSignInAccount account = await GoogleSignIn.instance.authenticate(
        scopeHint: <String>[drive.DriveApi.driveScope],
      );
      final Map<String, String>? headers = await account.authorizationClient.authorizationHeaders(
        <String>[drive.DriveApi.driveScope],
        promptIfNecessary: true,
      );
      if (headers == null) {
        return false;
      }

      _account = account;
      _headers = headers;
      authState.value = DriveAuthState.connected;
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> disconnect() async {
    await _ensureInit();
    await GoogleSignIn.instance.signOut();
    _account = null;
    _headers = null;
    authState.value = DriveAuthState.disconnected;
  }

  Future<void> loadState() async {
    await _ensureInit();
    _account = await GoogleSignIn.instance.attemptLightweightAuthentication();
    if (_account != null) {
      _headers = await _account!.authorizationClient.authorizationHeaders(
        <String>[drive.DriveApi.driveScope],
        promptIfNecessary: false,
      );
      if (_headers != null) {
        authState.value = DriveAuthState.connected;
        return;
      }
    }

    authState.value = DriveAuthState.disconnected;
  }

  Future<void> _ensureInit() async {
    if (!_initialized) {
      await GoogleSignIn.instance.initialize(
        clientId: '156428963186-onde9hov3jkpf2sjebkoumnvm218t4v9.apps.googleusercontent.com',
        serverClientId: '156428963186-91jv4r0prmp50qu7japfos3v6mobg918.apps.googleusercontent.com',
      );
      _initialized = true;
    }
  }
}

class _AuthHttpClient extends http.BaseClient {
  _AuthHttpClient(this._headers);

  final Map<String, String> _headers;
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }
}
