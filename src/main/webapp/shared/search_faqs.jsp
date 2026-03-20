<%-- 
    Document   : search_faqs
    Created on : 12 Jun 2025, 10:36:04
    Author     : kchip
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String keyword = request.getParameter("keyword");
    String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
%>
<html>
<head>
    <title>Search FAQs</title>
    <style>
        body { font-family: Arial, sans-serif; }
        .container { max-width: 900px; margin: 40px auto; text-align: center; }
        .header { background-color: #4B0082; color: white; padding: 15px; font-size: 22px; text-align: left; }
        table { width: 100%; margin-top: 20px; border-collapse: collapse; }
        th, td { padding: 10px; border: 1px solid #ccc; text-align: left; }
        th { background-color: #eee; }
        input[type="text"] { width: 70%; padding: 10px; }
        input[type="submit"] { padding: 10px 20px; margin-left: 10px; background-color: #4B0082; color: white; border: none; cursor: pointer; }
        .logout { float: right; color: white; text-decoration: none; font-size: 14px; }
        .back-link { margin-top: 20px; display: block; text-align: left; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        FAQ Search
        <a href="<%= request.getContextPath() %>/LogoutServlet" class="logout">Logout</a>
    </div>

    <form method="get">
        <input type="text" name="keyword" placeholder="Search FAQs by keyword..." value="<%= keyword != null ? keyword : "" %>" required />
        <input type="submit" value="Search" />
    </form>

<%
    if (keyword != null && !keyword.trim().isEmpty()) {
        try {
            Class.forName("org.sqlite.JDBC");
            conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
            stmt = conn.prepareStatement("SELECT question, answer FROM faqs WHERE question LIKE ? OR answer LIKE ?");
            stmt.setString(1, "%" + keyword + "%");
            stmt.setString(2, "%" + keyword + "%");
            rs = stmt.executeQuery();
%>
    <table>
        <tr><th>Question</th><th>Answer</th></tr>
<%
        boolean found = false;
        while (rs.next()) {
            found = true;
%>
        <tr>
            <td><%= rs.getString("question") %></td>
            <td><%= rs.getString("answer") %></td>
        </tr>
<%
        }
        if (!found) {
%>
        <tr><td colspan="2">No FAQs found for "<%= keyword %>"</td></tr>
<%
        }
        rs.close(); stmt.close(); conn.close();
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        }
    }
%>
    <a class="back-link" href="../<%= role %>/index.jsp">&larr; Back to Dashboard</a>
</div>
</body>
</html>

