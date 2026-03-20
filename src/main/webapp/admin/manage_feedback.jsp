<%-- 
    Document   : manage_feedback
    Created on : 11 Jun 2025
    Author     : kchip
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.*" %>

<%
    String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    Map<String, Integer> categoryTrends = new HashMap<>();
%>

<html>
<head>
    <title>Admin: Feedback Management</title>
    <style>
        body { font-family: Arial; background: #fff; margin: 0; padding: 0; }
        .header { background: #4B0082; color: white; padding: 16px 20px; font-size: 22px; display: flex; justify-content: space-between; }
        .container { max-width: 1000px; margin: 40px auto; padding: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; border: 1px solid #ccc; text-align: left; vertical-align: top; }
        th { background-color: #f2f2f2; }
        form { margin: 0; }
        textarea, select, input[type="submit"], button {
            padding: 6px;
            font-size: 14px;
            margin-top: 6px;
        }
        .summary { margin-top: 30px; }
        .back-link { margin-top: 30px; display: inline-block; }
        .logout { color: white; text-decoration: none; }
        td form {
            text-align: center;
        }
        td form select,
        td form button {
            display: inline-block;
            margin: 5px auto;
        }
    </style>
</head>
<body>
<div class="header">
    Admin: Feedback Management
    <a href="<%= request.getContextPath() %>/LogoutServlet" class="logout">Logout</a>
</div>
<div class="container">
    <h2>All Student Feedback</h2>

<%
    try {
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

        stmt = conn.prepareStatement(
            "SELECT f.id, f.message, f.date, f.category, f.adminResponse, f.responseDate, f.studentUsername " +
            "FROM feedback f " +
            "ORDER BY f.id DESC"
        );
        rs = stmt.executeQuery();
%>

    <table>
        <tr>
            <th>Student</th>
            <th>Category</th>
            <th>Message</th>
            <th>Submitted On</th>
            <th>Admin Response</th>
            <th>Responded On</th>
            <th>Actions</th>
        </tr>

<%
        while (rs.next()) {
            int id = rs.getInt("id");
            String student = rs.getString("studentUsername");
            String message = rs.getString("message");
            String submittedDate = rs.getString("date");
            String category = rs.getString("category");
            String adminReply = rs.getString("adminResponse");
            String responseDate = rs.getString("responseDate");

            if (category != null && !category.trim().isEmpty()) {
                categoryTrends.put(category, categoryTrends.getOrDefault(category, 0) + 1);
            }

            if (message == null || message.trim().isEmpty()) message = "-";
            if (category == null || category.trim().isEmpty()) category = "uncategorised";
            if (adminReply == null || adminReply.trim().isEmpty()) adminReply = "Awaiting reply";
            if (submittedDate == null || submittedDate.trim().isEmpty()) submittedDate = "-";
            if (responseDate == null || responseDate.trim().isEmpty()) responseDate = "-";
%>
        <tr>
            <td><%= student %></td>
            <td><%= category %></td>
            <td><%= message %></td>
            <td><%= submittedDate %></td>
            <td><%= adminReply %></td>
            <td><%= responseDate %></td>
            <td>
                <form action="update_category.jsp" method="post">
                    <input type="hidden" name="feedbackId" value="<%= id %>" />
                    <select name="category">
                        <option value="">-- Categorise --</option>
                        <option value="academic" <%= "academic".equals(category) ? "selected" : "" %>>Academic</option>
                        <option value="financial" <%= "financial".equals(category) ? "selected" : "" %>>Financial</option>
                        <option value="mental health" <%= "mental health".equals(category) ? "selected" : "" %>>Mental Health</option>
                    </select><br>
                    <button type="submit">Save</button>
                </form>

                <form action="update_feedback.jsp" method="get" style="margin-top: 5px;">
                    <input type="hidden" name="feedbackId" value="<%= id %>" />
                    <button type="submit">Respond</button>
                </form>
            </td>
        </tr>
<%
        }
%>
    </table>

    <div class="summary">
        <h3>📊 Feedback Trends</h3>
        <ul>
            <% for (Map.Entry<String, Integer> entry : categoryTrends.entrySet()) { %>
                <li><%= entry.getKey() %>: <%= entry.getValue() %> feedback(s)</li>
            <% } %>
        </ul>
    </div>

    <a class="back-link" href="index.jsp">← Back to Dashboard</a>

<%
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

</div>
</body>
</html>