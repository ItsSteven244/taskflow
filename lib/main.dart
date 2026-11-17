import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'task.dart'; // Importar el modelo desde el nuevo archivo

void main() {
  runApp(const TaskFlowApp());
}

// 1. Tareas personalizadas con userId
const demoTasks = <Task>[
  Task(
    id: 1,
    title: 'Actualizar portal web',
    description: 'Revisar componentes en React y Tailwind',
    priority: 'Alta',
    isCompleted: false,
    userId: 1,
  ),
  Task(
    id: 2,
    title: 'Finalizar interfaz TaskFlow',
    description: 'Implementar ListView.builder y TaskCard',
    priority: 'Alta',
    isCompleted: false,
    userId: 1,
  ),
  Task(
    id: 3,
    title: 'Preparar clase de matemáticas',
    description: 'Revisar fracciones y operaciones combinadas',
    priority: 'Media',
    isCompleted: false,
    userId: 1,
  ),
  Task(
    id: 4,
    title: 'Mantenimiento de entorno',
    description: 'Respaldar contenedores Docker en WSL2',
    priority: 'Media',
    isCompleted: true,
    userId: 1,
  ),
  Task(
    id: 5,
    title: 'Revisar periféricos',
    description: 'Comparar especificaciones de mouse gaming',
    priority: 'Baja',
    isCompleted: true,
    userId: 1,
  ),
];

// Función para buscar una tarea por ID
Task? findTask(int? id) {
  for (final task in demoTasks) {
    if (task.id == id) return task;
  }
  return null;
}

// 2. Configuración de Rutas
final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const TaskListScreen()),
    GoRoute(
      path: '/task/:id',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '');
        return TaskDetailScreen(task: findTask(id));
      },
    ),
  ],
);

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true, // Mantener diseño actualizado
      ),
      routerConfig: appRouter,
    );
  }
}

// 3. Pantalla de Listado
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis tareas')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: demoTasks.length,
        itemBuilder: (context, index) {
          final task = demoTasks[index];
          return Card(
            child: ListTile(
              leading: Icon(
                task.isCompleted
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: task.isCompleted
                    ? Colors.green
                    : null, // Mantenemos el color
              ),
              title: Text(task.title),
              subtitle: Text('Prioridad: ${task.priority}'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push('/task/${task.id}'),
            ),
          );
        },
      ),
    );
  }
}

// 4. Pantalla de Detalle
class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.task});

  final Task? task;

  @override
  Widget build(BuildContext context) {
    final selected = task;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de tarea')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: selected == null
            ? const Text('No se encontró esta tarea.')
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selected.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    selected.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  Chip(
                    label: Text('Prioridad: ${selected.priority}'),
                    avatar: const Icon(Icons.flag, size: 18),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        selected.isCompleted
                            ? Icons.check_circle
                            : Icons.pending_actions,
                        color: selected.isCompleted
                            ? Colors.green
                            : Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        selected.isCompleted
                            ? 'Estado: Completada'
                            : 'Estado: Pendiente',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Usuario asignado (ID): ${selected.userId}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.tonalIcon(
                      onPressed: () => context.pop(),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Volver al listado'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
