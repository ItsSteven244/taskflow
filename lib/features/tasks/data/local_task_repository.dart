import '../domain/task.dart';
import 'task_repository.dart';

class LocalTaskRepository implements TaskRepository {
  final List<Task> _tasks = [
    const Task(
      id: 1,
      title: 'Actualizar portal web',
      description: 'Revisar componentes en React y Tailwind',
      priority: 'Alta',
      isCompleted: false,
      userId: 1,
    ),
    const Task(
      id: 2,
      title: 'Finalizar interfaz TaskFlow',
      description: 'Implementar ListView.builder y TaskCard',
      priority: 'Alta',
      isCompleted: false,
      userId: 1,
    ),
    const Task(
      id: 3,
      title: 'Preparar clase de matemáticas',
      description: 'Revisar fracciones y operaciones combinadas',
      priority: 'Media',
      isCompleted: false,
      userId: 1,
    ),
    const Task(
      id: 4,
      title: 'Mantenimiento de entorno',
      description: 'Respaldar contenedores Docker en WSL2',
      priority: 'Media',
      isCompleted: true,
      userId: 1,
    ),
    const Task(
      id: 5,
      title: 'Revisar periféricos',
      description: 'Comparar especificaciones de mouse gaming',
      priority: 'Baja',
      isCompleted: true,
      userId: 1,
    ),
  ];

  @override
  List<Task> getTasks() => List.unmodifiable(_tasks);

  @override
  void save(Task task) {
    final index = _tasks.indexWhere((item) => item.id == task.id);
    if (index == -1) return;
    _tasks[index] = task;
  }
}
