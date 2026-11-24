## Alcance de TaskFlow

Problema: necesito organizar actividades académicas (clases, proyectos de desarrollo y auditorías) y saber cuáles faltan.
Usuario objetivo: estudiante de Ingeniería en TI que planifica entregas y prácticas semanales.

### Historias de usuario y criterios de aceptación
1. Como estudiante, quiero listar mis tareas para ver qué debo hacer en mis proyectos y pasantías.
   Criterio: la lista muestra título, prioridad y estado de cada tarea.
2. Como estudiante, quiero abrir una tarea para leer su descripción técnica completa.
   Criterio: al tocar una tarjeta aparece el detalle de la tarea elegida.
3. Como estudiante, quiero crear una tarea para registrar un pendiente urgente.
   Criterio: el formulario guarda una tarea válida y la lista la muestra.
4. Como estudiante, quiero editar una tarea para corregir sus datos o estado.
   Criterio: los cambios guardados aparecen en lista y detalle.
5. Como estudiante, quiero eliminar una tarea terminada para limpiar la lista.
   Criterio: después de confirmar, la tarea desaparece de la lista.

### Modelo de datos
Task: id (entero único), title (texto), description (texto),
priority (Alta, Media o Baja), isCompleted (verdadero/falso),
userId (entero que identifica al usuario de prueba).

### Pantallas previstas
Lista: tarjetas de tareas y acción para crear.
Detalle: información completa y futuras acciones de editar o eliminar.
Formulario: campos de título, descripción y prioridad.

### Requisitos no funcionales
La navegación debe tener textos comprensibles.
Un id inexistente debe mostrar un mensaje en vez de cerrar la app abruptamente.

### Contrato de API que necesitaremos
GET /tasks        listar tareas
GET /tasks/:id    consultar detalle
POST /tasks       crear tarea
PATCH /tasks/:id  actualizar tarea
DELETE /tasks/:id eliminar tarea

## API de tareas

* **URL exacta:** `https://jsonplaceholder.typicode.com/todos?userId=2`
* **Parámetro de filtro:** `userId = 2` (configurado como constante en `TaskApiService`).
* **Campos que entrega la API:** `id` (entero), `userId` (entero), `title` (texto) y `completed` (booleano, mapeado a `isCompleted`).
* **Valores por defecto completados por TaskFlow:** Como JSONPlaceholder no devuelve descripción ni prioridad, `Task.fromJson` asigna `'Sin descripción (API)'` y `'Sin prioridad (API)'`.
* **Persistencia actual:** Marcar una tarea como completada o pendiente modifica únicamente la copia en memoria dentro de `RemoteTaskRepository`; al reiniciar la aplicación, los datos vuelven al estado original devuelto por la API.


## Estados de la lista remota (Sesión 8)

La pantalla principal (`TaskListScreen`) distingue cuatro estados gestionados desde `TasksViewModel`:

* **Carga (`isLoading`):** Se muestra un `CircularProgressIndicator` mientras la petición HTTP está en curso; se comprobó al iniciar la app y al pulsar el botón de recarga.
* **Éxito (`tasks` con elementos):** Muestra el listado de tareas del usuario `userId = 2` con soporte para actualizar desde el `AppBar` o deslizando hacia abajo (`RefreshIndicator`).
* **Vacío (`isEmpty`):** Se provocó cambiando temporalmente `userId` a `9999` en `TaskApiService`. La API responde con `[]` (HTTP 200) y la interfaz muestra el mensaje *"Todavía no hay tareas para mostrar."* junto al botón **Actualizar**.
* **Error (`errorMessage`):** Se provocó desconectando el acceso a red (modo *Offline* / sin conexión) y pulsando el botón de recarga. La interfaz muestra el mensaje de error y el botón **Reintentar**, que al restaurar la conexión vuelve a cargar la lista sin reiniciar la aplicación.