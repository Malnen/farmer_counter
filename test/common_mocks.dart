import 'package:farmer_counter/utils/drive_client.dart';
import 'package:farmer_counter/utils/drive_sync_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFunction extends Mock {
  void call();
}

class MockDriveSyncService extends Mock implements DriveSyncService {
}

class MockDriveClient extends Mock implements DriveClient {}
