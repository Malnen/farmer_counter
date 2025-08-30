import 'package:farmer_counter/utils/drive_client.dart';
import 'package:farmer_counter/utils/drive_sync_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:mocktail/mocktail.dart';

class MockFunction extends Mock {
  void call();
}

class MockFunctionWithValue<T> extends Mock {
  void call(T value);
}

class MockDriveSyncService extends Mock implements DriveSyncService {}

class MockDriveClient extends Mock implements DriveClient {}

class MockDriveApi extends Mock implements DriveApi {}

class MockFilesResource extends Mock implements FilesResource {}

class MockGoogleSignIn extends Mock implements GoogleSignIn {}

class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}

class MockGoogleAuthHeaders extends Mock implements GoogleSignInAuthorizationClient {}
