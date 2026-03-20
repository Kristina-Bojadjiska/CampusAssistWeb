<%-- 
    Document   : confirm_booking
    Created on : 7 Jun 2025, 22:57:31
    Author     : kchip
--%>

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>

<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || !"student".equals(role)) {
        response.sendRedirect("../shared/login.jsp");
        return;
    }

    String appointmentIdStr = request.getParameter("appointmentId");
    String studentUsername = request.getParameter("studentUsername");
    String category = request.getParameter("category");

    Connection conn = null;
    PreparedStatement stmt = null;
    String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";

    try {
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

        stmt = conn.prepareStatement("UPDATE appointments SET studentUsername = ?, category = ?, status = 'pending' WHERE id = ?");
        stmt.setString(1, studentUsername);
        stmt.setString(2, category);
        stmt.setInt(3, Integer.parseInt(appointmentIdStr));
        int rows = stmt.executeUpdate();

        if (rows > 0) {
%>
            <html>
            <head>
                <title>Booking Confirmed</title>
                <style>
                    body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
                </style>
            </head>
            <body>
                <h2>Your appointment has been successfully booked!</h2>
                <a href="index.jsp">← Back to Dashboard</a>
            </body>
            </html>
<%
        } else {
            out.println("<p style='color:red;'>Failed to update appointment. Please try again.</p>");
        }

        stmt.close();
        conn.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    }
%>
