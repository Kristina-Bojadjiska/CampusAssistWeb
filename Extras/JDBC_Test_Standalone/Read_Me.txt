README – Standalone JDBC Test Folder

This folder contains the standalone JDBC testing setup created to verify that the SQLite connection works independently before integrating the database into the CampusAssist web application.

🔹 Files Included:

1. SQLiteConnector.java  
   A simple Java class that attempts to connect to campusassist.db using the SQLite JDBC driver. This was run outside of NetBeans to confirm that the database file and driver were configured correctly.

2. sqlite-jdbc-3.46.1.2.jar  
   The JDBC driver used to perform the connection test. It was included on the classpath during compilation and execution of the standalone Java file.

🔹 Notes:

- This folder and its contents are NOT used by the deployed Maven web application.
- It exists only to demonstrate development workflow and testing methodology.
- The actual database file in use by the web app is now located at:
    src/main/webapp/WEB-INF/database/campusassist.db

- All integration logic (servlet-based login, session routing, etc.) connects to the web application's copy of the database using a relative path.

🔹 How to Run (if needed again):
If needed, compile and run this Java file from command line:

  javac -cp ".;sqlite-jdbc-3.46.1.2.jar" SQLiteConnector.java
  java -cp ".;sqlite-jdbc-3.46.1.2.jar" SQLiteConnector

(This assumes the JDBC `.jar` and `.java` file are in the same folder.)

---

A SQL script (create_users_table.sql) is included to create and populate the users table used for login authentication.

---

This folder demonstrates the initial validation step before building the 
full-scale web application and is included here for transparency and evidence of careful testing practice.

