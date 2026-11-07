import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//  CONFIGURACIÓN DE RUTAS
final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const TaskListScreen()),
    GoRoute(
      path: '/task/:id',
      builder: (context, state) {
        // Extrae el ID de la URL y lo convierte a número
        final taskId = int.parse(state.pathParameters['id']!);
        return TaskDetailScreen(taskId: taskId);
      },
    ),
  ],
);

void main() {
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Se cambia MaterialApp por MaterialApp.router
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}

// MODELO Y DATOS
class Task {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
  });

  final int id;
  final String title;
  final String description;
  final String priority;
  final bool isCompleted;
}

const demoTasks = [
  Task(
    id: 1,
    title: 'Actualizar portal web',
    description: 'Revisar componentes en React y Tailwind',
    priority: 'Alta',
    isCompleted: false,
  ),
  Task(
    id: 2,
    title: 'Finalizar interfaz TaskFlow',
    description: 'Implementar ListView.builder y TaskCard',
    priority: 'Alta',
    isCompleted: false,
  ),
  Task(
    id: 3,
    title: 'Preparar clase de matemáticas',
    description: 'Revisar fracciones y operaciones combinadas',
    priority: 'Media',
    isCompleted: false,
  ),
  Task(
    id: 4,
    title: 'Mantenimiento de entorno',
    description: 'Respaldar contenedores Docker en WSL2',
    priority: 'Media',
    isCompleted: true,
  ),
  Task(
    id: 5,
    title: 'Revisar periféricos',
    description: 'Comparar especificaciones de mouse gaming',
    priority: 'Baja',
    isCompleted: true,
  ),
];

// TARJETA REUTILIZABLE
class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, this.onTap});

  final Task task;
  final VoidCallback? onTap; // Parámetro para recibir la acción de toque

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap, // Activa la interacción
        leading: Icon(
          task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: task.isCompleted ? Colors.green : null,
        ),
        title: Text(task.title),
        subtitle: Text('${task.priority} · ${task.description}'),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

// PANTALLA 1: LISTADO
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
          return TaskCard(
            task: task,
            // Al tocar, navega a la ruta dinámica de la tarea
            onTap: () => context.push('/task/${task.id}'),
          );
        },
      ),
    );
  }
}

//  PANTALLA 2: DETALLE
class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final int taskId;

  @override
  Widget build(BuildContext context) {
    // Busca la tarea específica usando el ID recibido
    final task = demoTasks.firstWhere((item) => item.id == taskId);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de tarea')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Text(
              task.description,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Chip(
              label: Text('Prioridad: ${task.priority}'),
              avatar: const Icon(Icons.flag, size: 18),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  task.isCompleted ? Icons.check_circle : Icons.pending_actions,
                  color: task.isCompleted ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                Text(
                  task.isCompleted ? 'Estado: Completada' : 'Estado: Pendiente',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: () => context.pop(), // Acción para regresar
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
