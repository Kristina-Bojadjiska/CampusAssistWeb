# CampusAssistWeb

CampusAssistWeb is a Java-based web application designed to simulate a university support system where students can manage appointments and provide feedback, while administrators can monitor, categorise, and respond to user input.

The project focuses on building a functional backend-driven system with consistent data handling and real-world behaviour.

---

## 🚀 Features

### Student functionality
- Secure login/logout
- Book and cancel appointments
- Submit feedback after sessions

### Admin functionality
- View all submitted feedback
- Categorise feedback (academic / financial / mental health)
- Respond to student messages
- Filter and review feedback reports

---

## 🛠️ Tech Stack

- Java (Servlets)
- JSP
- JDBC (SQLite)
- Maven
- Apache Tomcat

---

## ⚙️ Key Implementation Details

- Implemented full CRUD-style interaction between users and the system
- Ensured consistent database access across JSPs and Servlets
- Designed feedback workflow connecting student input with admin response
- Introduced persistent database configuration to maintain data across server restarts
- Structured project using Maven for dependency and build management

---

## ▶️ Running the Project

1. Clone the repository:
   ```bash
   git clone https://github.com/Kristina-Bojadjiska/CampusAssistWeb.git

2. Open in NetBeans / IntelliJ
3. Configure Apache Tomcat
4. Build and deploy the application

⚠️ Database Configuration

The project currently uses a local SQLite database:
D:/All_Projects/CampusAssistData/campusassist.db

For a production environment, this would be replaced with a shared or cloud-hosted database (e.g., MySQL, PostgreSQL).

🔄 Future Improvements
- Replace SQLite with a scalable database solution
- Refactor JSP scriptlets into cleaner MVC structure (e.g. JSTL / Controllers)
- Implement password hashing and improved authentication
- Deploy to a cloud environment

👩‍💻 Author

Kristina Bojadjiska