<%-- 
    Document   : update_faqs
    Created on : 11 Jun 2025, 03:57:54
    Author     : kchip
--%>

<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String action = request.getParameter("action");
    String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";
    Connection conn = null;
    PreparedStatement stmt = null;
    String errorMsg = null;

    try {
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

        if (action != null && action.startsWith("update_")) {
            int id = Integer.parseInt(action.substring(7));
            String updatedQuestion = request.getParameter("question_" + id);
            String updatedAnswer = request.getParameter("answer_" + id);

            stmt = conn.prepareStatement("UPDATE faqs SET question = ?, answer = ? WHERE id = ?");
            stmt.setString(1, updatedQuestion);
            stmt.setString(2, updatedAnswer);
            stmt.setInt(3, id);
            stmt.executeUpdate();

        } else if (action != null && action.startsWith("delete_")) {
            int id = Integer.parseInt(action.substring(7));
            stmt = conn.prepareStatement("DELETE FROM faqs WHERE id = ?");
            stmt.setInt(1, id);
            stmt.executeUpdate();

        } else if ("add".equals(action)) {
            String question = request.getParameter("question");
            String answer = request.getParameter("answer");

            stmt = conn.prepareStatement("INSERT INTO faqs (question, answer) VALUES (?, ?)");
            stmt.setString(1, question);
            stmt.setString(2, answer);
            stmt.executeUpdate();
        }

        response.sendRedirect("manage_faqs.jsp?status=success&actionType=" + action);

    } catch (Exception e) {
        errorMsg = e.getMessage();
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

<% if (errorMsg != null) { %>
<html>
<head>
    <title>FAQ Error</title>
    <style>
        body { font-family: Arial; background: #fff; margin: 0; padding: 0; }
        .header {
            background-color: #4B0082;
            color: white;
            padding: 16px 20px;
            font-size: 22px;
            display: flex;
            justify-content: space-between;
        }
        .container { max-width: 800px; margin: 40px auto; padding: 20px; }
        .logout { color: white; text-decoration: none; }
        .logout:hover { text-decoration: underline; }
        .error {
            color: red;
            font-weight: bold;
            margin-top: 20px;
        }
        .back-link {
            margin-top: 30px;
            display: block;
        }
    </style>
</head>
<body>
<div class="header">
    FAQ Error
    <a href="<%= request.getContextPath() %>/LogoutServlet" class="logout">Logout</a>
</div>
<div class="container">
    <p class="error">Error: <%= errorMsg %></p>
    <a href="manage_faqs.jsp" class="back-link">← Back to FAQ Management</a>
</div>
</body>
</html>
<% } %>
