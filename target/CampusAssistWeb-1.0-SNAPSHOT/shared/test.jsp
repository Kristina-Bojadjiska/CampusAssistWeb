<%-- 
    Document   : test
    Created on : 6 Jun 2025, 22:20:47
    Author     : @kchip
--%>

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Test Database Connection</title>
</head>
<body>
<h2>Users Table Contents</h2>

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Test Database Connection</title>
</head>
<body>
<h2>Users Table Contents</h2>

<%
    String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";
    String url = "jdbc:sqlite:" + dbPath;

    Class.forName("org.sqlite.JDBC");

    try (Connection conn = DriverManager.getConnection(url);
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery("SELECT * FROM users")) {

        while (rs.next()) {
            String username = rs.getString("username");
            String role = rs.getString("role");
%>
            <p>User: <strong><%= username %></strong> | Role: <%= role %></p>
<%
        }

    } catch (Exception e) {
%>
        <p style="color:red;">Error: <%= e.getMessage() %></p>
<%
    }
%>

</body>
</html>

