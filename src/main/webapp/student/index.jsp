<%-- 
    Document   : confirm_cancel
    Created on : 8 Jun 2025, 14:48:38
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

    int unreadCount = 0;
    try {
        Class.forName("org.sqlite.JDBC");
        String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";
        Connection conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
        PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM alerts WHERE username = ? AND status = 'unread'");
        ps.setString(1, username);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            unreadCount = rs.getInt(1);
        }
        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        out.println("<!-- Failed to load alerts: " + e.getMessage() + " -->");
    }
%>

<html>
<head>
    <title>Dashboard</title>
</head>
<body style="font-family:Arial, sans-serif; padding: 20px;">

<div style="background-color:#4b0082; color:white; padding:15px;">
    <h2 style="margin:0;">CampusAssist – <%= username %></h2>
    <div style="text-align:right;">
        <a href="<%= request.getContextPath() %>/LogoutServlet" style="color:white;">Logout</a>
    </div>
</div>

<h1>Welcome, <%= username %>!</h1>


<p><a href="../shared/search_services.jsp">🔍 Search Support Sessions</a></p>

<p>
    <a href="view_services.jsp">➕ Book a Support Session</a>
</p>
<p>
    <a href="view_appointments.jsp">📅 View My Appointments</a>
</p>
<p><a href="../shared/search_faqs.jsp">🔍 Search FAQs</a></p>
<p>
    <a href="view_faqs.jsp">📘 View FAQs</a>
</p>
<p>
    <a href="view_feedback.jsp">🗣 View Feedback</a>
</p>
<p>
    <a href="view_alerts.jsp">🔔 View Alerts<%= (unreadCount > 0) ? " (" + unreadCount + ")" : "" %></a>
</p>

<p>You have successfully logged in as a <strong><%= role %></strong>.</p>

</body>
</html>
