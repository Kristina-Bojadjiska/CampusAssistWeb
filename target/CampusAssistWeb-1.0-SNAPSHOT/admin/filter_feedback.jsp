<%-- 
    Document   : filter_feedback
    Created on : 12 Jun 2025
    Author     : kchip
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page session="true" %>

<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || !"admin".equals(role)) {
        response.sendRedirect("../shared/login.jsp");
        return;
    }

    String categoryFilter = request.getParameter("category");
    String fromDate = request.getParameter("from");
    String toDate = request.getParameter("to");
%>

<html>
<head>
    <title>Filter Feedback</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 30px; }
        .header { background-color: #4B0082; color: white; padding: 16px; font-size: 22px; font-weight: bold; }
        .form-row { margin-bottom: 20px; }
        table { width: 100%; margin-top: 20px; border-collapse: collapse; }
        th, td { padding: 10px; border: 1px solid #ccc; }
        th { background-color: #f2f2f2; }
        select, input[type="date"], input[type="submit"] { padding: 8px; margin-right: 10px; }
        .back-link { margin-top: 30px; display: inline-block; }
    </style>
</head>
<body>
    <div class="header">
        Admin: Feedback Filtering
        <a href="<%= request.getContextPath() %>/LogoutServlet" style="color:white; float:right; text-decoration:none;">Logout</a>
    </div>

    <form method="get">
        <div class="form-row">
            <label>Category:</label>
            <select name="category">
                <option value="">All</option>
                <option value="academic" <%= "academic".equals(categoryFilter) ? "selected" : "" %>>Academic</option>
                <option value="financial" <%= "financial".equals(categoryFilter) ? "selected" : "" %>>Financial</option>
                <option value="mental health" <%= "mental health".equals(categoryFilter) ? "selected" : "" %>>Mental Health</option>
                <option value="uncategorised" <%= "uncategorised".equals(categoryFilter) ? "selected" : "" %>>Uncategorised</option>
            </select>

            <label>From:</label>
            <input type="date" name="from" value="<%= fromDate != null ? fromDate : "" %>" />

            <label>To:</label>
            <input type="date" name="to" value="<%= toDate != null ? toDate : "" %>" />

            <input type="submit" value="Apply Filters" />
        </div>
    </form>

<%
    if (categoryFilter != null || fromDate != null || toDate != null) {
        String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            Class.forName("org.sqlite.JDBC");
            conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

            StringBuilder sql = new StringBuilder(
                "SELECT f.studentUsername, f.message, f.date, f.category, f.adminResponse, f.responseDate " +
                "FROM feedback f WHERE 1=1"
            );

            List<String> params = new ArrayList<String>();

            if (categoryFilter != null && !categoryFilter.trim().isEmpty()) {
                if ("uncategorised".equals(categoryFilter)) {
                    sql.append(" AND (f.category IS NULL OR TRIM(f.category) = '')");
                } else {
                    sql.append(" AND f.category = ?");
                    params.add(categoryFilter);
                }
            }

            if (fromDate != null && !fromDate.trim().isEmpty()) {
                sql.append(" AND f.date >= ?");
                params.add(fromDate);
            }

            if (toDate != null && !toDate.trim().isEmpty()) {
                sql.append(" AND f.date <= ?");
                params.add(toDate);
            }

            sql.append(" ORDER BY f.id DESC");

            stmt = conn.prepareStatement(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                stmt.setString(i + 1, params.get(i));
            }

            rs = stmt.executeQuery();
%>

    <table>
        <tr>
            <th>Student</th>
            <th>Category</th>
            <th>Message</th>
            <th>Admin Response</th>
            <th>Date</th>
        </tr>

<%
            while (rs.next()) {
                String uname = rs.getString("studentUsername");
                String message = rs.getString("message");
                String category = rs.getString("category");
                String adminReply = rs.getString("adminResponse");
                String submittedDate = rs.getString("date");

                if (category == null || category.trim().isEmpty()) category = "uncategorised";
                if (message == null || message.trim().isEmpty()) message = "-";
                if (adminReply == null || adminReply.trim().isEmpty()) adminReply = "-";
                if (submittedDate == null || submittedDate.trim().isEmpty()) submittedDate = "-";
%>
        <tr>
            <td><%= uname %></td>
            <td><%= category %></td>
            <td><%= message %></td>
            <td><%= adminReply %></td>
            <td><%= submittedDate %></td>
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

    <a class="back-link" href="index.jsp">&larr; Back to Dashboard</a>
</body>
</html>