<%-- 
    Document   : login
    Created on : 6 Jun 2025, 11:18:42
    Author     : kchip
--%>

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>View Services</title>
</head>
<body>
    <h2>Available Support Services</h2>

    <table border="1">
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Description</th>
        </tr>

        <%
            String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";
            out.println("<p><b>Using DB path:</b> " + dbPath + "</p>");
        %>

        <%
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;

            try {
                Class.forName("org.sqlite.JDBC");
                conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
                stmt = conn.createStatement();
                rs = stmt.executeQuery("SELECT * FROM services");

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("description") %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                out.println("Error: " + e.getMessage());
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
    </table>
</body>
</html>
