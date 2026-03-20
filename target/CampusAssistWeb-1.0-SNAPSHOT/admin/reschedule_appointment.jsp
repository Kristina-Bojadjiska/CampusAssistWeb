<%-- 
    Document   : reschedule_appointment
    Created on : 10 Jun 2025, 23:05:08
    Author     : kchip
--%>

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Reschedule Appointment</title>
    <style>
        body { font-family: Arial; margin: 40px; }
        label { display:block; margin-top: 10px; }
        input[type=datetime-local] { padding: 5px; margin-top: 5px; }
        input[type=submit] { margin-top: 15px; padding: 6px 15px; background-color: blue; color: white; border: none; }
        a { display:block; margin-top: 15px; }
    </style>
</head>
<body>
    <h2>Reschedule Appointment</h2>
    <form method="post" action="reschedule_appointment.jsp">
        <input type="hidden" name="appointmentId" value="<%= request.getParameter("appointmentId") %>"/>
        <label>New Date and Time:</label>
        <input type="datetime-local" name="newDate" required/>
        <input type="submit" name="submit" value="Save"/>
    </form>
    <a href="manage_appointments.jsp">&larr; Back to Admin Dashboard</a>
    <a href="<%= request.getContextPath() %>/LogoutServlet" style="color:white; float:right; text-decoration:none;">Logout</a>

<%
if ("POST".equalsIgnoreCase(request.getMethod())) {
    String id = request.getParameter("appointmentId");
    out.println("Appointment ID received: " + id);
    String newDate = request.getParameter("newDate");

    Connection conn = null;
    PreparedStatement stmt = null;
    String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";

    try {
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

        // 1. Update datetime and set status to 'rescheduled'
        stmt = conn.prepareStatement("UPDATE appointments SET datetime = ?, status = 'rescheduled' WHERE id = ?");
        stmt.setString(1, newDate);
        stmt.setString(2, id);
        stmt.executeUpdate();
        stmt.close();

        // 2. Fetch studentUsername for alert
        PreparedStatement fetchStmt = conn.prepareStatement("SELECT studentUsername FROM appointments WHERE id = ?");
        fetchStmt.setString(1, id);
        ResultSet rs = fetchStmt.executeQuery();

        if (rs.next()) {
            String studentUsername = rs.getString("studentUsername");
            String formattedDate = newDate.replace("T", " ");

            // 3. Insert alert into alerts table
            PreparedStatement alertStmt = conn.prepareStatement(
                "INSERT INTO alerts (username, message, date, status) VALUES (?, ?, datetime('now'), 'unread')"
            );
            String message = "Your appointment has been rescheduled to " + formattedDate + ".";
            alertStmt.setString(1, studentUsername);
            alertStmt.setString(2, message);
            alertStmt.executeUpdate();
            alertStmt.close();
        }

        rs.close();
        fetchStmt.close();

        // Redirect to admin dashboard
        response.sendRedirect("manage_appointments.jsp");

    } catch(Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
}
%>

</body>
</html>
