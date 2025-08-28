import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum DriveAuthState { disconnected, connected }

class DriveClient {
  static const String _kAutoSignInKey = 'drive.autoSignInEnabled';

  final ValueNotifier<DriveAuthState> authState;

  bool _initialized;
  bool _autoSignInEnabled = false;
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
        scopeHint: <String>[drive.DriveApi.driveFileScope],
      );
      final Map<String, String>? headers = await account.authorizationClient.authorizationHeaders(
        <String>[drive.DriveApi.driveFileScope],
        promptIfNecessary: true,
      );
      if (headers == null) {
        return false;
      }

      _account = account;
      _headers = headers;
      authState.value = DriveAuthState.connected;
      _autoSignInEnabled = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kAutoSignInKey, true);

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
    _autoSignInEnabled = false;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_kAutoSignInKey, false);
  }

  Future<void> loadState() async {
    await _ensureInit();
    if (!_autoSignInEnabled) {
      authState.value = DriveAuthState.disconnected;
      return;
    }

    _account = await GoogleSignIn.instance.attemptLightweightAuthentication();
    if (_account != null) {
      _headers = await _account!.authorizationClient.authorizationHeaders(
        <String>[drive.DriveApi.driveFileScope],
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
      final SharedPreferences preferences = await SharedPreferences.getInstance();
      _autoSignInEnabled = preferences.getBool(_kAutoSignInKey) ?? false;
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
