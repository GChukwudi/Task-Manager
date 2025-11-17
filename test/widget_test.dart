import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager/models/task.dart';

void main() {
  group('Task Model Tests', () {
    test('Task creation with default values', () {
      final task = Task(title: 'Test Task');

      expect(task.title, 'Test Task');
      expect(task.description, '');
      expect(task.isCompleted, false);
      expect(task.timeSpentMinutes, null);
      expect(task.id.isNotEmpty, true);
    });

    test('Task toJson and fromJson', () {
      final task = Task(
        title: 'Test Task',
        description: 'Test Description',
        isCompleted: true,
        timeSpentMinutes: 60,
      );

      final json = task.toJson();
      final deserializedTask = Task.fromJson(json);

      expect(deserializedTask.title, task.title);
      expect(deserializedTask.description, task.description);
      expect(deserializedTask.isCompleted, task.isCompleted);
      expect(deserializedTask.timeSpentMinutes, task.timeSpentMinutes);
    });

    test('Task copyWith', () {
      final task = Task(title: 'Original');
      final updated = task.copyWith(title: 'Updated', isCompleted: true);

      expect(updated.title, 'Updated');
      expect(updated.isCompleted, true);
      expect(updated.id, task.id);
    });
  });
}
