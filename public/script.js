const taskForm = document.getElementById('taskForm');
const taskTitle = document.getElementById('taskTitle');
const taskDescription = document.getElementById('taskDescription');
const taskDueDate = document.getElementById('taskDueDate');
const tasksList = document.getElementById('tasksList');
const filterButtons = document.querySelectorAll('.filter-btn');

let currentFilter = 'all';
let allTasks = [];

async function loadTasks() {
  try {
    const response = await fetch('/api/tasks');
    allTasks = await response.json();
    renderTasks();
  } catch (error) {
    console.error('Error loading tasks:', error);
  }
}

function renderTasks() {
  const filteredTasks = filterTasks(allTasks, currentFilter);

  if (filteredTasks.length === 0) {
    tasksList.innerHTML = '<p class="empty-message">No tasks to show</p>';
    return;
  }

  tasksList.innerHTML = filteredTasks.map(task => `
    <div class="task-item ${task.completed ? 'completed' : ''}">
      <input type="checkbox" class="task-checkbox" ${task.completed ? 'checked' : ''}
        onchange="toggleTask(${task.id})">
      <div class="task-content">
        <div class="task-title">${escapeHtml(task.title)}</div>
        ${task.description ? `<div class="task-description">${escapeHtml(task.description)}</div>` : ''}
        ${task.dueDate ? `<div class="task-due-date">Due: ${task.dueDate}</div>` : ''}
      </div>
      <div class="task-actions">
        <button class="delete-btn" onclick="deleteTask(${task.id})">Delete</button>
      </div>
    </div>
  `).join('');
}

function filterTasks(tasks, filter) {
  switch(filter) {
    case 'active':
      return tasks.filter(t => !t.completed);
    case 'completed':
      return tasks.filter(t => t.completed);
    default:
      return tasks;
  }
}

async function addTask(e) {
  e.preventDefault();

  if (!taskTitle.value.trim()) {
    alert('Please enter a task title');
    return;
  }

  try {
    const response = await fetch('/api/tasks', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        title: taskTitle.value,
        description: taskDescription.value,
        dueDate: taskDueDate.value
      })
    });

    if (response.ok) {
      taskForm.reset();
      loadTasks();
    }
  } catch (error) {
    console.error('Error adding task:', error);
  }
}

async function toggleTask(id) {
  const task = allTasks.find(t => t.id === id);
  if (!task) return;

  try {
    await fetch(`/api/tasks/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ completed: !task.completed })
    });
    loadTasks();
  } catch (error) {
    console.error('Error updating task:', error);
  }
}

async function deleteTask(id) {
  if (!confirm('Are you sure you want to delete this task?')) return;

  try {
    await fetch(`/api/tasks/${id}`, { method: 'DELETE' });
    loadTasks();
  } catch (error) {
    console.error('Error deleting task:', error);
  }
}

function escapeHtml(text) {
  const div = document.createElement('div');
  div.textContent = text;
  return div.innerHTML;
}

taskForm.addEventListener('submit', addTask);

filterButtons.forEach(btn => {
  btn.addEventListener('click', () => {
    filterButtons.forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    currentFilter = btn.dataset.filter;
    renderTasks();
  });
});

loadTasks();
