<%-- 
    Document   : confirm_cancel
    Created on : 8 Jun 2025, 14:48:38
    Author     : kchip
--%>

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String appointmentId = request.getParameter("appointmentId");
    String userChoice = request.getParameter("confirm");

    if (appointmentId == null || userChoice == null) {
        out.println("<p>Missing appointment ID or confirmation choice.</p>");
        return;
    }

    if ("No".equals(userChoice)) {
        response.sendRedirect("student/view_appointments.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    try {
        String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

        String sql = "UPDATE appointments SET status = 'cancelled' WHERE id = ?";
        ps = conn.prepareStatement(sql);
        ps.setInt(1, Integer.parseInt(appointmentId));

        int rowsAffected = ps.executeUpdate();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Appointment Cancelled</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 40px; }
    </style>
</head>
<body>
<%
        if (rowsAffected > 0) {
            out.println("<h2>Your appointment has been cancelled successfully.</h2>");
        } else {
            out.println("<h2>Unable to cancel. Appointment not found.</h2>");
        }
%>
    <br><a href="view_appointments.jsp">Back to Appointments</a>
</body>
</html>
<%
    } catch (Exception e) {
%>
    <p>Error: <%= e.getMessage() %></p>
<%
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception ignore) {}
        if (conn != null) try { conn.close(); } catch (Exception ignore) {}
    }
%>
