<%-- 
    Document   : view_services.jsp
    Created on : 7 Jun 2025, 22:10:27
    Author     : kchip
--%>

<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"student".equals(role)) {
        response.sendRedirect("../shared/login.jsp");
        return;
    }

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Support Services</title>
    <style>
        table {
            margin: 20px auto;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px 14px;
            border: 1px solid #999;
        }
        th {
            background-color: #f0f0f0;
        }
        .header {
            background-color: #4b0082;
            color: white;
            padding: 15px;
        }
        .header h2 {
            margin: 0;
            display: inline-block;
        }
        .header .logout {
            float: right;
            margin-top: 4px;
        }
        .header .logout a {
            color: white;
            text-decoration: none;
           

        }
    </style>
</head>
<body>

<div class="header">
    <h2>Student Support Services</h2>
    <div class="logout">
        <a href="<%= request.getContextPath() %>/LogoutServlet" style="color:white; float:right; text-decoration:none;">Logout</a>

    </div>
</div>

<%
    try {
        Class.forName("org.sqlite.JDBC");
    String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";
    conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT name, description FROM services");
%>

<table>
    <tr>
        <th>Service</th>
        <th>Description</th>
        <th>Action</th>
    </tr>
<%
        while (rs.next()) {
            String service = rs.getString("name");
            String description = rs.getString("description");
%>
    <tr>
        <td><%= service %></td>
        <td><%= description %></td>
        <td><a href="book_appointment.jsp?service=<%= service %>">Book</a></td>
    </tr>
<%
        }
    } catch (Exception e) {
%>
    <p style="color:red; text-align:center;">Error: <%= e.getMessage() %></p>
<%
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
</table>

<div class="container">
    <br>
    <a href="index.jsp">&larr; Back to Dashboard</a>
</div>
</body>
</html>
