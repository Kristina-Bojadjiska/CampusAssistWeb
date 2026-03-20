<%-- 
    Document   : search_services
    Created on : 12 Jun 2025, 10:42:57
    Author     : kchip
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<%
    String keyword = request.getParameter("keyword");
    String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>

<html>
<head>
    <title>Search Services</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .header {
            background-color: #4B0082;
            color: white;
            padding: 16px;
            font-size: 22px;
            font-weight: bold;
        }
        .container {
            max-width: 1000px;
            margin: 30px auto;
            text-align: center;
        }
        table {
            width: 100%;
            margin-top: 30px;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ccc;
            text-align: left;
        }
        th { background-color: #f2f2f2; }
        input[type="text"] {
            width: 50%;
            padding: 10px;
        }
        input[type="submit"] {
            padding: 10px 20px;
            background-color: #4B0082;
            color: white;
            border: none;
            cursor: pointer;
        }
        .back-link {
            margin-top: 20px;
            display: inline-block;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        Search Support Sessions
        <a href="<%= request.getContextPath() %>/LogoutServlet" style="color:white; float:right;">Logout</a>
    </div>

    <form method="get">
        <input type="text" name="keyword" placeholder="Search support categories..." value="<%= keyword != null ? keyword : "" %>">
        <input type="submit" value="Search">
    </form>

<%
if (keyword != null && !keyword.trim().isEmpty()) {
    try {
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

        stmt = conn.prepareStatement("SELECT name, description FROM services WHERE name LIKE ?");
        stmt.setString(1, "%" + keyword + "%");
        rs = stmt.executeQuery();
%>
    <table>
    <tr>
        <th>Session Type</th>
        <th>Description</th>
    </tr>
<%
        while (rs.next()) {
%>
        <tr>
            <td><%= rs.getString("name") %></td>
            <td><%= rs.getString("description") %></td>
        </tr>
<%
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
}
%>
    </table>
    <%
    String role = (String) session.getAttribute("role");
    String backLink = (role != null && (role.equals("student") || role.equals("admin"))) ? ("../" + role + "/index.jsp") : "login.jsp";
%>
<a class="back-link" href="<%= backLink %>">&larr; Back to Dashboard</a>

    
</div>
</body>
</html>
