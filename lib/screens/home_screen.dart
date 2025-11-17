import 'package:flutter/material.dart';
import '../models/task.dart';
import '../utils/storage_service.dart';
import '../widgets/task_card.dart';
import '../widgets/task_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();
  List<Task> _tasks = [];
  bool _isLoading = true;
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);
    try {
      final tasks = await _storageService.loadTasks();
      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) _showErrorSnackBar('Failed to load tasks');
    }
  }

  Future<void> _saveTasks() async {
    final success = await _storageService.saveTasks(_tasks);
    if (!success && mounted) _showErrorSnackBar('Failed to save tasks');
  }

  void _addTask(Task task) {
    setState(() => _tasks.insert(0, task));
    _saveTasks();
    _showSuccessSnackBar('Task created');
  }

  void _updateTask(Task updatedTask) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
      if (index != -1) _tasks[index] = updatedTask;
    });
    _saveTasks();
    _showSuccessSnackBar('Task updated');
  }

  void _deleteTask(String taskId) {
    setState(() => _tasks.removeWhere((t) => t.id == taskId));
    _saveTasks();
    _showSuccessSnackBar('Task deleted');
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => TaskDialog(onSave: _addTask),
    );
  }

  void _showEditTaskDialog(Task task) {
    showDialog(
      context: context,
      builder: (context) => TaskDialog(task: task, onSave: _updateTask),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  List<Task> get _filteredTasks {
    switch (_filter) {
      case 'active':
        return _tasks.where((t) => !t.isCompleted).toList();
      case 'completed':
        return _tasks.where((t) => t.isCompleted).toList();
      default:
        return _tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _filteredTasks;
    final activeCount = _tasks.where((t) => !t.isCompleted).length;
    final completedCount = _tasks.where((t) => t.isCompleted).length;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Tasks',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All (${_tasks.length})',
                  isSelected: _filter == 'all',
                  onTap: () => setState(() => _filter = 'all'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Active ($activeCount)',
                  isSelected: _filter == 'active',
                  onTap: () => setState(() => _filter = 'active'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Done ($completedCount)',
                  isSelected: _filter == 'completed',
                  onTap: () => setState(() => _filter = 'completed'),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : filteredTasks.isEmpty
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: _loadTasks,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return TaskCard(
                    task: task,
                    onToggle: _updateTask,
                    onEdit: () => _showEditTaskDialog(task),
                    onDelete: () => _deleteTask(task.id),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        icon: const Icon(Icons.add),
        label: const Text('New Task'),
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;

    switch (_filter) {
      case 'active':
        message = 'No active tasks';
        icon = Icons.check_circle_outline;
        break;
      case 'completed':
        message = 'No completed tasks yet';
        icon = Icons.assignment_outlined;
        break;
      default:
        message = 'No tasks yet';
        icon = Icons.add_task;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (_filter == 'all') ...[
            const SizedBox(height: 8),
            Text(
              'Tap + to create your first task',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF6366F1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF6366F1) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
