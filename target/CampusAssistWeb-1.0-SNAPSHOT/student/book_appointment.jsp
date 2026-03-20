<%-- 
    Document   : book_appointment
    Created on : 7 Jun 2025, 22:34:05
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

    String category = request.getParameter("service");
    String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";
%>
<html>
<head>
    <title>Book Appointment</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
        .header {
            background-color: #4B0082;
            color: white;
            padding: 16px 20px;
            font-size: 22px;
            font-weight: bold;
            text-align: left;
        }
        .logout {
            float: right;
            color: white;
        }
        .logout:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="header">
    Book Appointment – <%= category %>
    <a href="<%= request.getContextPath() %>/LogoutServlet" class="logout">Logout</a>
</div>

<form method="post" action="confirm_booking.jsp">
    <input type="hidden" name="studentUsername" value="<%= username %>" />
    <input type="hidden" name="category" value="<%= category %>" />
    <label>Select a Time Slot:</label><br>
    <select name="appointmentId" required>
<%
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    boolean hasSlots = false;
    try {
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

        stmt = conn.prepareStatement(
            "SELECT id, datetime FROM appointments " +
            "WHERE category = ? " +
            "AND (status IS NULL OR TRIM(status) = '') " +
            "AND (studentUsername IS NULL OR TRIM(studentUsername) = '') " +
            "AND julianday(REPLACE(datetime, 'T', ' ')) > julianday('now', 'localtime') " +
            "ORDER BY julianday(REPLACE(datetime, 'T', ' '))"
        );
        stmt.setString(1, category);
        rs = stmt.executeQuery();

        while (rs.next()) {
            hasSlots = true;
            int id = rs.getInt("id");
            String datetime = rs.getString("datetime").replace("T", " ");
%>
        <option value="<%= id %>"><%= datetime %></option>
<%
        }
    } catch (Exception e) {
        out.println("<option disabled>Error loading slots: " + e.getMessage() + "</option>");
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
    </select><br><br>
<%
    if (hasSlots) {
%>
    <input type="submit" value="Confirm Booking" />
<%
    } else {
%>
    <p>No available slots at the moment for this service.</p>
<%
    }
%>
</form>
<a href="index.jsp">← Back to Dashboard</a>
</body>
</html>
