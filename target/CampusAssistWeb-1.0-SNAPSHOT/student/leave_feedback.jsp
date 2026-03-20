<%-- 
    Document   : leave_feedback
    Created on : 8 Jun 2025, 03:42:29
    Author     : kchip
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");
    String appointmentId = request.getParameter("appointmentId");

    if (username == null || !"student".equals(role)) {
        response.sendRedirect("../shared/login.jsp");
        return;
    }

    String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";
    boolean alreadySubmitted = false;
    boolean submittedNow = false;

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

        stmt = conn.prepareStatement("SELECT COUNT(*) FROM feedback WHERE appointmentId = ?");
        stmt.setInt(1, Integer.parseInt(appointmentId));
        rs = stmt.executeQuery();
        if (rs.next() && rs.getInt(1) > 0) {
            alreadySubmitted = true;
        }
        rs.close();
        stmt.close();

        if (!alreadySubmitted && request.getMethod().equalsIgnoreCase("POST")) {
            String feedbackText = request.getParameter("feedback");
            if (feedbackText != null && !feedbackText.trim().isEmpty()) {
                String currentDate = new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
                stmt = conn.prepareStatement("INSERT INTO feedback (appointmentId, studentUsername, message, date) VALUES (?, ?, ?, ?)");
                stmt.setInt(1, Integer.parseInt(appointmentId));
                stmt.setString(2, username);
                stmt.setString(3, feedbackText);
                stmt.setString(4, currentDate);

                stmt.executeUpdate();
                submittedNow = true;
            }
        }
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

<html>
<head>
    <title>Leave Feedback</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #fff;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 800px;
            margin: 40px auto;
            text-align: center;
        }
        .header {
            background-color: #4B0082;
            color: white;
            padding: 16px 20px;
            font-size: 22px;
            font-weight: bold;
            border-radius: 8px 8px 0 0;
            text-align: left;
        }
        .logout {
            float: right;
            color: white;
        }
        .logout:hover {
            text-decoration: underline;
        }
        textarea {
            width: 100%;
            height: 120px;
            padding: 10px;
            margin-top: 20px;
            font-size: 16px;
        }
        input[type="submit"] {
            padding: 10px 20px;
            background-color: #4B0082;
            color: white;
            border: none;
            border-radius: 5px;
            margin-top: 15px;
            font-weight: bold;
            cursor: pointer;
        }
        .message {
            margin-top: 40px;
            font-size: 18px;
            font-weight: bold;
            color: green;
        }
        .back-link {
            display: block;
            margin-top: 40px;
            font-size: 16px;
            text-align: left;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        Leave Feedback
        <a href="<%= request.getContextPath() %>/LogoutServlet" class="logout">Logout</a>
    </div>

<%
    if (alreadySubmitted || submittedNow) {
        String feedbackText = "";
        try {
            Class.forName("org.sqlite.JDBC");
            conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
            stmt = conn.prepareStatement("SELECT message FROM feedback WHERE appointmentId = ?");
            stmt.setInt(1, Integer.parseInt(appointmentId));
            rs = stmt.executeQuery();

            if (rs.next()) {
                feedbackText = rs.getString("message");
            }

            rs.close();
            stmt.close();
            conn.close();
        } catch (Exception e) {
            out.println("<p style='color:red;'>Error loading feedback: " + e.getMessage() + "</p>");
        }
%>
    <p class="message">This is the feedback you submitted:</p>
    <div style="background-color:#f9f9f9; padding:15px; border:1px solid #ccc; margin-top:10px; text-align:left;">
        <%= feedbackText %>
    </div>
<%
    } else {
%>
    <form method="post">
        <textarea name="feedback" placeholder="Write your feedback here..." required></textarea><br>
        <input type="submit" value="Submit Feedback" />
    </form>
<%
    }
%>

    <a class="back-link" href="index.jsp">← Back to Dashboard</a>
</div>
</body>
</html>
