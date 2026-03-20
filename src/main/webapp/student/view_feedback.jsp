<%-- 
    Document   : view_feedback
    Created on : 8 Jun 2025
    Author     : kchip
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || !"student".equals(role)) {
        response.sendRedirect("../shared/login.jsp");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;
    String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";
%>

<html>
<head>
    <title>View Feedback</title>
    <style>
        body { font-family: Arial; padding: 20px; }
        .header {
            background-color: #4B0082;
            color: white;
            padding: 16px 20px;
            font-size: 22px;
            font-weight: bold;
        }
        .logout {
            float: right;
            color: white;
        }
        .logout:hover {
            text-decoration: underline;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #f0f0f0;
        }
        .back-link {
            margin-top: 30px;
            display: block;
        }
    </style>
</head>
<body>
    <div class="header">
        Feedback Overview
        <a href="<%= request.getContextPath() %>/LogoutServlet" class="logout">Logout</a>
    </div>

<%
    try {
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
         // COALESCE()checks both 'comment' and 'message' columns.Ensure feedback is shown for all students
         //This way view_feedback.jsp page is compatible with all students' feedback formats.
        String sql = "SELECT a.category AS service, COALESCE(f.comment, f.message) AS feedbackText, f.category, f.adminResponse, f.responseDate, f.date " +
        "FROM feedback f " +
                     "JOIN appointments a ON f.appointmentId = a.id " +
                     "WHERE f.studentUsername = ? " +
                     "ORDER BY f.date DESC";

        stmt = conn.prepareStatement(sql);
        stmt.setString(1, username);
        rs = stmt.executeQuery();

        if (!rs.isBeforeFirst()) {
            out.println("<p>You have not submitted any feedback yet.</p>");
        } else {
%>
        <table>
            <tr>
                <th>Service</th>
                <th>Your Feedback</th>
                <th>Submitted</th>
                <th>Category</th>
                <th>Admin Response</th>
                <th>Responded On</th>
            </tr>
<%
            while (rs.next()) {
                String feedback = rs.getString("feedbackText");
                String service = rs.getString("service");
                String submitted = rs.getString("date");
                String category = rs.getString("category");
                String adminReply = rs.getString("adminResponse");
                String respondedOn = rs.getString("responseDate");

                if (service == null || service.trim().isEmpty()) service = "-";
                if (submitted == null || submitted.trim().isEmpty()) submitted = "-";
                if (category == null || category.trim().isEmpty()) category = "-";
              if (adminReply == null || adminReply.trim().isEmpty()) adminReply = "Awaiting reply";
                if (respondedOn == null || respondedOn.trim().isEmpty()) respondedOn = "-";
%>
            <tr>
                <td><%= service %></td>
                <td><%= (feedback == null || feedback.trim().isEmpty()) ? "<i>No feedback submitted</i>" : feedback %></td>
                <td><%= submitted %></td>
                <td><%= category %></td>
                <td><%= adminReply %></td>
                <td><%= respondedOn %></td>
            </tr>
<%
            }
%>
        </table>
<%
        }
    } catch(Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

    <a href="index.jsp" class="back-link">← Back to Dashboard</a>
</body>
</html>
