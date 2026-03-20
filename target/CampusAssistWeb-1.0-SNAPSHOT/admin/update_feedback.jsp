<%-- 
    Document   : manage_appointments
    Created on : 13 Jun 2025, 01:10:19
    Author     : kchip
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date" %>
<%
    String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String feedbackId = request.getParameter("feedbackId");
    String message = "";
    String adminResponse = "";
    boolean updated = false;

    try {
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            adminResponse = request.getParameter("adminResponse");

            // Save response and responseDate
            String sql = "UPDATE feedback SET adminResponse = ?, responseDate = ? WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, adminResponse);
            
            // Format timestamp as yyyy-MM-dd HH:mm:ss
            String responseDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
            stmt.setString(2, responseDate);
            stmt.setInt(3, Integer.parseInt(feedbackId));
            stmt.executeUpdate();

            updated = true;
            stmt.close();
        }

        // Load existing response (if any)
        String sql = "SELECT adminResponse FROM feedback WHERE id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setInt(1, Integer.parseInt(feedbackId));
        rs = stmt.executeQuery();
        if (rs.next()) {
            adminResponse = rs.getString("adminResponse");
        }

    } catch(Exception e) {
        message = "<p style='color:red;'>Error: " + e.getMessage() + "</p>";
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

<html>
<head>
    <title>Update Feedback</title>
    <style>
        body { font-family: Arial; padding: 30px; }
        .header { background-color: #4B0082; color: white; padding: 16px; font-size: 22px; font-weight: bold; }
        textarea { width: 100%; height: 120px; padding: 10px; font-size: 14px; margin-bottom: 20px; }
        .btn { padding: 10px 20px; background: #4B0082; color: white; border: none; cursor: pointer; font-size: 16px; }
        .success { color: green; font-weight: bold; margin-bottom: 20px; }
        .back-link { display: inline-block; margin-top: 30px; }
    </style>
</head>
<body>
    <div class="header">Update Feedback</div>

<% if (updated) { %>
    <div class="success">✅ Feedback updated successfully!</div>
<% } else { %>
    <form method="post">
        <input type="hidden" name="feedbackId" value="<%= feedbackId %>" />
        <label>Admin Response:</label><br>
        <textarea name="adminResponse"><%= adminResponse == null ? "" : adminResponse %></textarea><br>
        <button type="submit" class="btn">Save Response</button>
    </form>
<% } %>


<a class="back-link" href="manage_feedback.jsp">← Back to Feedback List</a>
<%= message %>
</body>
</html>
