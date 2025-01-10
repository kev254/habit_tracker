import 'package:flutter_test/flutter_test.dart';
import 'package:habit_tracker/database/sync_manager.dart';
import 'package:workmanager/src/workmanager.dart';
import 'package:workmanager/workmanager.dart';

class MockWorkManager implements Workmanager {
  @override
  Future<void> cancelAll() async {
    // Mock cancelAll
  }

  @override
  Future<void> cancelByTag(String tag) async {
    // Mock cancelByTag
  }

  @override
  Future<void> cancelByUniqueName(String uniqueName) async {
    // Mock cancelByUniqueName
  }

 

  @override
  Future<void> initialize(Function callbackDispatcher, {bool isInDebugMode = false}) async {
    // Mock initialization
  }

  @override
  Future<void> registerOneOffTask(String uniqueName, String taskName, {String? tag, ExistingWorkPolicy? existingWorkPolicy, Duration initialDelay = Duration.zero, Constraints? constraints, BackoffPolicy? backoffPolicy, Duration backoffPolicyDelay = Duration.zero, OutOfQuotaPolicy? outOfQuotaPolicy, Map<String, dynamic>? inputData}) async {

  }

  @override
  Future<void> registerPeriodicTask(String uniqueName, String taskName, {Duration? frequency, String? tag, ExistingWorkPolicy? existingWorkPolicy, Duration initialDelay = Duration.zero, Constraints? constraints, BackoffPolicy? backoffPolicy, Duration backoffPolicyDelay = Duration.zero, OutOfQuotaPolicy? outOfQuotaPolicy, Map<String, dynamic>? inputData}) async {

  }

  @override
  void executeTask(BackgroundTaskHandler backgroundTask) {
    // TODO: implement executeTask
  }
}

void main() {
  group('HabitSyncManager Tests', () {
    late MockWorkManager mockWorkManager;

    setUp(() {
      mockWorkManager = MockWorkManager();
    });

    test('syncHabitPeriodically should register a periodic task', () async {

      HabitSyncManager syncManager = HabitSyncManager();


        var res=await syncManager.syncHabitPeriodically();
        print (res);


      expect(mockWorkManager.registerPeriodicTask, isNotNull);

    });
  });
}
