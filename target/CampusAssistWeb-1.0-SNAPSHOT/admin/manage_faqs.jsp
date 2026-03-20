<%-- 
    Document   : manage_faqs
    Created on : 11 Jun 2025, 03:23:16
    Author     : kchip
--%>

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    if (username == null || !"admin".equals(role)) {
        response.sendRedirect("../shared/login.jsp");
        return;
    }
%>
<html>
<head>
    <title>Manage FAQs</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 0; padding: 0; }
        .header { background-color: #4B0082; color: white; padding: 16px 20px; font-size: 22px; font-weight: bold; display: flex; justify-content: space-between; }
        .container { max-width: 1000px; margin: 20px auto; padding: 20px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #eee; }
        textarea { width: 100%; height: 60px; }
        .btn { padding: 5px 10px; font-weight: bold; cursor: pointer; }
        .btn-delete { background-color: red; color: white; }
        .btn-save { background-color: green; color: white; }
        .btn-add { background-color: #4B0082; color: white; margin-top: 20px; }
        .logout { color: white; text-decoration: none; font-size: 14px; }
        .success-msg {
            background-color:#d4edda;
            color:#155724;
            padding:10px 15px;
            border-radius:5px;
            margin-bottom:20px;
            border:1px solid #c3e6cb;
        }
    </style>
</head>
<body>
<div class="header">
    Admin: FAQ Management
    <a href="<%= request.getContextPath() %>/LogoutServlet" class="logout">Logout</a>
</div>
<div class="container">

<%
    String status = request.getParameter("status");
    String actionType = request.getParameter("actionType");
    String feedbackMsg = null;

    if ("success".equals(status)) {
        if (actionType.startsWith("update_")) {
            feedbackMsg = "✅ FAQ updated successfully.";
        } else if (actionType.startsWith("delete_")) {
            feedbackMsg = "❌ FAQ deleted successfully.";
        } else if ("add".equals(actionType)) {
            feedbackMsg = "✅ New FAQ added.";
        }
    }
%>
<% if (feedbackMsg != null) { %>
    <div class="success-msg"><%= feedbackMsg %></div>
<% } %>

    <h2>All FAQs</h2>
    <form method="post" action="update_faqs.jsp">
        <table>
            <tr>
                <th>Question</th>
                <th>Answer</th>
                <th>Actions</th>
            </tr>
<%
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";
    try {
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
        stmt = conn.prepareStatement("SELECT * FROM faqs ORDER BY id DESC");
        rs = stmt.executeQuery();
        while (rs.next()) {
            int id = rs.getInt("id");
            String question = rs.getString("question");
            String answer = rs.getString("answer");
%>
            <tr>
                <td><textarea name="question_<%= id %>"><%= question %></textarea></td>
                <td><textarea name="answer_<%= id %>"><%= answer %></textarea></td>
                <td>
                    <button class="btn btn-save" type="submit" name="action" value="update_<%= id %>">Save</button>
                    <button class="btn btn-delete" type="submit" name="action" value="delete_<%= id %>" onclick="return confirm('Delete this FAQ?');">Delete</button>
                </td>
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
%>
        </table>
    </form>

    <h3>Add New FAQ</h3>
    <form action="update_faqs.jsp" method="post">
        <input type="hidden" name="action" value="add" />
        <label>Question:</label><br>
        <textarea name="question" required></textarea><br><br>
        <label>Answer:</label><br>
        <textarea name="answer" required></textarea><br><br>
        <button class="btn btn-add" type="submit">Add FAQ</button>
    </form>

    <p><a href="index.jsp">&larr; Back to Dashboard</a></p>
</div>
</body>
</html>
