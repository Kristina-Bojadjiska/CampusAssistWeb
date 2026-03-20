<%-- 
    Document   : view_appointments
    Created on : 8 Jun 2025, 00:19:40
    Author     : kchip
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.time.LocalDateTime, java.time.format.DateTimeFormatter" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || !"student".equals(role)) {
        response.sendRedirect("../shared/login.jsp");
        return;
    }

    String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>
<html>
<head>
    <title>My Booked Appointments</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #fff;
            margin: 0;
            padding: 0;
        }

        .header {
            background-color: #4B0082;
            color: white;
            padding: 16px 20px;
            font-size: 20px;
            font-weight: bold;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logout {
            color: white;
            text-decoration: none;
            font-size: 14px;
        }

        .logout:hover {
            text-decoration: underline;
        }

        .container {
            max-width: 1000px;
            margin: 40px auto;
        }

        h2 {
            margin-bottom: 20px;
            text-align: left;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: center;
        }

        th {
            background-color: #f2f2f2;
        }

        .past-label {
            color: red;
            font-weight: bold;
        }

        .upcoming-label {
            color: green;
            font-weight: bold;
        }

        .action-button {
            padding: 6px 12px;
            font-size: 14px;
            font-weight: bold;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .cancel-btn {
            background-color: #f44336;
        }

        .feedback-btn {
            background-color: #4CAF50;
        }

        .back-link {
            display: inline-block;
            margin-top: 25px;
            text-decoration: none;
            font-size: 14px;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        My Booked Appointments
        <a href="<%= request.getContextPath() %>/LogoutServlet" style="color:white; float:right; text-decoration:none;">Logout</a>

    </div>

<%
    try {
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

        String sql = "SELECT id, category, datetime, status FROM appointments WHERE studentUsername = ? AND status != 'cancelled' ORDER BY datetime DESC";

        stmt = conn.prepareStatement(sql);
        stmt.setString(1, username);
        rs = stmt.executeQuery();

        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        DateTimeFormatter displayFormat = DateTimeFormatter.ofPattern("dd MMMM yyyy, HH:mm");
        boolean hasResults = false;
%>

    <table>
        <tr>
            <th>Category</th>
            <th>Date & Time</th>
            <th>When</th>
            <th>Action</th>
        </tr>
<%
        while (rs.next()) {
            hasResults = true;
            int id = rs.getInt("id");
            String category = rs.getString("category");
            String datetimeRaw = rs.getString("datetime");
            String datetimeStr = datetimeRaw.replace("T", " ");
LocalDateTime slotTime;
try {
    // Try with seconds first
    DateTimeFormatter fullFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    slotTime = LocalDateTime.parse(datetimeStr, fullFormat);
} catch (Exception ex) {
    // Fallback to format without seconds
    DateTimeFormatter shortFormat = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
    slotTime = LocalDateTime.parse(datetimeStr, shortFormat);
}


            String status = rs.getString("status");

//            LocalDateTime slotTime = LocalDateTime.parse(datetimeStr, formatter);
            boolean isPast = slotTime.isBefore(now);
%>
        <tr>
            <td><%= category %></td>
            <td><%= slotTime.format(displayFormat) %></td>
            <td>
                <% if (isPast) { %>
                    <span class="past-label">Past</span>
                <% } else { %>
                    <span class="upcoming-label">Upcoming</span>
                <% } %>
            </td>
            <td>
<% if (isPast) {
    PreparedStatement feedbackStmt = conn.prepareStatement(
        "SELECT message FROM feedback WHERE appointmentId = ?"
    );
    feedbackStmt.setInt(1, id);
    ResultSet feedbackRs = feedbackStmt.executeQuery();
    boolean hasFeedback = feedbackRs.next();
    feedbackRs.close();
    feedbackStmt.close();

    if (!hasFeedback) {
%>
    <form method="get" action="leave_feedback.jsp" style="margin: 0;">
        <input type="hidden" name="appointmentId" value="<%= id %>">
        <input class="action-button feedback-btn" type="submit" value="Leave Feedback">
    </form>
<%  } else { %>
    <form method="get" action="leave_feedback.jsp" style="margin: 0;">
        <input type="hidden" name="appointmentId" value="<%= id %>">
        <input class="action-button" style="background-color:gray;" type="submit" value="View Feedback">
    </form>
<%  }
} else { %>
    <form method="get" action="cancel_appointment.jsp" style="margin: 0;">
        <input type="hidden" name="appointmentId" value="<%= id %>">
        <input class="action-button cancel-btn" type="submit" value="Cancel">
    </form>
<% } %>
</td>

        </tr>
<%
        }
%>
    </table>

<%
        if (!hasResults) {
%>
    <p>You have no booked appointments at the moment.</p>
<%
        }

    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

    <a class="back-link" href="index.jsp">← Back to Dashboard</a>
</div>
</body>
</html>
