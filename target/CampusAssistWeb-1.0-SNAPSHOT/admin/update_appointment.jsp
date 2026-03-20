<%-- 
    Document   : update_appointment
    Created on : 10 Jun 2025, 10:17:57
    Author     : kchip
--%>

<%@ page import="java.sql.*, java.text.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>


<%
String appointmentId = request.getParameter("appointmentId");
String action = request.getParameter("action");

Connection conn = null;
PreparedStatement stmt = null;

try {
    Class.forName("org.sqlite.JDBC");
    String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";
    conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

    // Optional: log or validate appointment exists
    PreparedStatement findUserStmt = conn.prepareStatement("SELECT studentUsername, datetime FROM appointments WHERE id = ?");
    findUserStmt.setInt(1, Integer.parseInt(appointmentId));
    ResultSet userRs = findUserStmt.executeQuery();

    if (userRs.next()) {
        String studentUsername = userRs.getString("studentUsername");
        String datetime = userRs.getString("datetime");
    }
    userRs.close();
    findUserStmt.close();

    // Update appointment status
    if ("approve".equals(action)) {
    // 1. Update status to confirmed
    stmt = conn.prepareStatement("UPDATE appointments SET status = 'confirmed' WHERE id = ?");
    stmt.setInt(1, Integer.parseInt(appointmentId));
    stmt.executeUpdate();
    stmt.close();

    // 2. Retrieve student and datetime again (already done above)
    PreparedStatement fetchStmt = conn.prepareStatement("SELECT studentUsername, datetime FROM appointments WHERE id = ?");
    fetchStmt.setInt(1, Integer.parseInt(appointmentId));
    ResultSet rs = fetchStmt.executeQuery();

    if (rs.next()) {
        String studentUsername = rs.getString("studentUsername");
        String datetime = rs.getString("datetime").replace("T", " ");

        // 3. Insert alert
        PreparedStatement alertStmt = conn.prepareStatement(
            "INSERT INTO alerts (username, message, date, status) VALUES (?, ?, datetime('now'), 'unread')"
        );
        String message = "Your appointment on " + datetime + " has been approved.";
        alertStmt.setString(1, studentUsername);
        alertStmt.setString(2, message);
        alertStmt.executeUpdate();
        alertStmt.close();
    }
    rs.close();
    fetchStmt.close();
}

    else if ("cancel".equals(action)) {
    // 1. Update status to cancelled
    stmt = conn.prepareStatement("UPDATE appointments SET status = 'cancelled' WHERE id = ?");
    stmt.setInt(1, Integer.parseInt(appointmentId));
    stmt.executeUpdate();
    stmt.close();

    // 2. Fetch student and datetime to create alert
    PreparedStatement fetchStmt = conn.prepareStatement("SELECT studentUsername, datetime FROM appointments WHERE id = ?");
    fetchStmt.setInt(1, Integer.parseInt(appointmentId));
    ResultSet rs = fetchStmt.executeQuery();

    if (rs.next()) {
        String studentUsername = rs.getString("studentUsername");
        String datetime = rs.getString("datetime").replace("T", " ");

        PreparedStatement alertStmt = conn.prepareStatement(
            "INSERT INTO alerts (username, message, date, status) VALUES (?, ?, datetime('now'), 'unread')"
        );
        String message = "Your appointment on " + datetime + " has been cancelled.";
        alertStmt.setString(1, studentUsername);
        alertStmt.setString(2, message);
        alertStmt.executeUpdate();
        alertStmt.close();
    }
    rs.close();
    fetchStmt.close();
}
    if (stmt != null) {
    stmt.close();
}

    conn.close();

    // Redirect back to admin dashboard
    response.sendRedirect("manage_appointments.jsp");
    return;

} catch (Exception e) {
    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
}
%>


