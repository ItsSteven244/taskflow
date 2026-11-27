import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'tasks_view_model.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final int? taskId;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<TasksViewModel>();
    final task = viewModel.findTask(taskId);

    if (task == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalle de tarea')),
        body: const Center(child: Text('Tarea no encontrada.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de tarea')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text('Descripción: ${task.description}'),
            const SizedBox(height: 8),
            Text('Prioridad: ${task.priority}'),
            const SizedBox(height: 8),
            Text('Estado: ${task.isCompleted ? 'Completada' : 'Pendiente'}'),
            const SizedBox(height: 8),
            Text('Usuario: ${task.userId}'),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton(
                  onPressed: () =>
                      context.read<TasksViewModel>().toggleCompleted(task.id),
                  child: Text(
                    task.isCompleted
                        ? 'Marcar como pendiente'
                        : 'Marcar como completada',
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final controller = TextEditingController(text: task.title);
                    final newTitle = await showDialog<String>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Editar título'),
                        content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            labelText: 'Título',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('Cancelar'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(
                              dialogContext,
                              controller.text.trim(),
                            ),
                            child: const Text('Guardar'),
                          ),
                        ],
                      ),
                    );
                    controller.dispose();
                    if (!context.mounted ||
                        newTitle == null ||
                        newTitle.length < 3) {
                      return;
                    }
                    try {
                      await context.read<TasksViewModel>().updateTask(
                        task.copyWith(title: newTitle),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tarea actualizada')),
                        );
                      }
                    } catch (_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No se pudo actualizar'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Editar título'),
                ),
                OutlinedButton(
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Eliminar tarea'),
                        content: Text('¿Eliminar ${task.title}?'),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: const Text('Cancelar'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(dialogContext, true),
                            child: const Text('Eliminar'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed != true || !context.mounted) return;
                    try {
                      await context.read<TasksViewModel>().deleteTask(task.id);
                      if (context.mounted) context.pop();
                    } catch (_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No se pudo eliminar la tarea'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Eliminar tarea'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
