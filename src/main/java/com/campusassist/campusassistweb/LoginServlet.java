/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

/**
 *
 * @author kchip
 */

package com.campusassist.campusassistweb;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.File;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.sql.*;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = "";

        // ✅ Fix 1: redirect if accessed without form data
        if (username == null || password == null) {
            System.out.println(">>> Skipped due to null form fields");
            response.sendRedirect(request.getContextPath() + "/shared/login.jsp");
            return;
        }

        // ✅ Fix 2: show error if submitted empty
        if (username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Please enter both username and password.");
            request.getRequestDispatcher("/shared/login.jsp").forward(request, response);
            return;
        }

        // ✅ Connect to SQLite database
        String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";
        System.out.println("LOGIN DB PATH: " + dbPath);

        if (dbPath == null) {
            System.out.println("❌ ERROR: dbPath is null");
            request.setAttribute("error", "Database path not found.");
            request.getRequestDispatcher("/shared/login.jsp").forward(request, response);
            return;
        } else {
            File dbFile = new File(dbPath);
            System.out.println("== DB Path Check ==");
            System.out.println("Path: " + dbPath);
            System.out.println("Exists: " + dbFile.exists());
            System.out.println("Readable: " + dbFile.canRead());
        }

        String url = "jdbc:sqlite:" + dbPath;
try {
    Class.forName("org.sqlite.JDBC"); // <-- force-load the driver
} catch (ClassNotFoundException e) {
    System.out.println("❌ SQLite JDBC driver not found.");
    e.printStackTrace();
    request.setAttribute("error", "JDBC driver missing.");
    request.getRequestDispatcher("/shared/login.jsp").forward(request, response);
    return;
}

        try (
            Connection conn = DriverManager.getConnection(url);
            PreparedStatement stmt = conn.prepareStatement(
                "SELECT role FROM users WHERE username = ? AND password = ?")
        ) {
            stmt.setString(1, username);
            stmt.setString(2, password);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    role = rs.getString("role");
                } else {
                    request.setAttribute("error", "Invalid username or password.");
                    request.getRequestDispatcher("/shared/login.jsp").forward(request, response);
                    return;
                }
            }

            // ✅ Start session and redirect
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            session.setAttribute("role", role);

            if ("admin".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/admin/");
            } else {
                response.sendRedirect(request.getContextPath() + "/student/");
            }

        } catch (Exception e) {
    // Save full stack trace for debugging
    StringWriter sw = new StringWriter();
    e.printStackTrace(new PrintWriter(sw));
    String fullTrace = sw.toString();

    System.out.println("=== LOGIN ERROR TRACE ===");
    System.out.println(fullTrace);

    request.setAttribute("error", "Something went wrong while processing your login.");
    request.getRequestDispatcher("/shared/login.jsp").forward(request, response);
}

    }
}
