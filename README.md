# Task Manager

A simple and elegant task management web application built with Node.js and Express.

## Features

- Create, read, update, and delete tasks
- Mark tasks as completed
- Filter tasks by status (All, Active, Completed)
- Add due dates to tasks
- Clean and responsive UI

## Installation

1. Clone the repository:
```bash
git clone https://github.com/ankitrohila/taskmanager.git
cd taskmanager
```

2. Install dependencies:
```bash
npm install
```

## Running the Application

### Development
```bash
npm start
```

The application will run on `http://localhost:3000`

## API Endpoints

- `GET /api/tasks` - Get all tasks
- `POST /api/tasks` - Create a new task
- `GET /api/tasks/:id` - Get a specific task
- `PUT /api/tasks/:id` - Update a task
- `DELETE /api/tasks/:id` - Delete a task

## Project Structure

```
taskmanager/
├── server.js           # Express server and API routes
├── public/
│   ├── index.html      # Main HTML file
│   ├── style.css       # Styling
│   └── script.js       # Frontend JavaScript
├── package.json        # Dependencies
└── README.md          # This file
```

## License

ISC
