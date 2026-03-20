<%-- 
    Document   : view_alerts
    Created on : 11 Jun 2025, 01:24:55
    Author     : kchip
--%>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
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
    <title>Student Alerts</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .header {
            background-color: #4B0082;
            color: white;
            padding: 16px;
            font-size: 20px;
            font-weight: bold;
        }
        .container {
            max-width: 800px;
            margin: 40px auto;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .unread {
            color: darkred;
            font-weight: bold;
        }
        .read {
            color: gray;
        }
        .back-link {
            margin-top: 30px;
            display: inline-block;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        Student Alerts
        <a href="<%= request.getContextPath() %>/LogoutServlet" style="color:white; float:right; text-decoration:none;">Logout</a>
    </div>

<%
try {
    Class.forName("org.sqlite.JDBC");
    conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

    stmt = conn.prepareStatement("SELECT id, message, date, status FROM alerts WHERE username = ? ORDER BY date DESC");
    stmt.setString(1, username);
    rs = stmt.executeQuery();
%>
    <table>
        <tr>
            <th>Message</th>
            <th>Date</th>
            <th>Status</th>
        </tr>
<%
    List<Integer> toMarkRead = new ArrayList<>();

    while (rs.next()) {
        int alertId = rs.getInt("id");
        String msg = rs.getString("message");
        String date = rs.getString("date");
        String status = rs.getString("status");

        String cssClass = "read".equals(status) ? "read" : "unread";

        if ("unread".equals(status)) {
            toMarkRead.add(alertId);
        }
%>
        <tr>
            <td><%= msg %></td>
            <td><%= date %></td>
            <td class="<%= cssClass %>"><%= status %></td>
        </tr>
<%
    }

    rs.close();
    stmt.close();

    if (!toMarkRead.isEmpty()) {
        stmt = conn.prepareStatement("UPDATE alerts SET status = 'read' WHERE id = ?");
        for (int id : toMarkRead) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
        stmt.close();
    }

} catch (Exception e) {
    out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
} finally {
    if (rs != null) rs.close();
    if (stmt != null) stmt.close();
    if (conn != null) conn.close();
}
%>
    <a class="back-link" href="index.jsp">&larr; Back to Dashboard</a>
</div>
</body>
</html>
