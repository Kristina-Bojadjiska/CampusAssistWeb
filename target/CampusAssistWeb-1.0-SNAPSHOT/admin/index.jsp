<%-- 
    Document   : index
    Created on : 6 Jun 2025, 11:41:04
    Author     : kchip
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<html>
<head>
    <title>Dashboard</title>
</head>
<body style="font-family:Arial, sans-serif; padding: 20px;">

<div style="background-color:#4b0082; color:white; padding:15px;">
    <h2 style="margin:0;">CampusAssist – <%= session.getAttribute("username") %></h2>
    <div style="text-align:right;">
        <a href="<%= request.getContextPath() %>/LogoutServlet" style="color:white;">Logout</a>
    </div>
</div>

<h1>Welcome, <%= session.getAttribute("username") %>!</h1>

<p><a href="../shared/search_services.jsp">🔍 Search Support Sessions</a></p>
<p><a href="manage_appointments.jsp">📋 Manage Appointments</a></p>
<p><a href="filter_feedback.jsp">📊 Filter Feedback Reports</a></p>
<p><a href="manage_feedback.jsp">📝 Manage Feedback</a></p>
<p><a href="../shared/search_faqs.jsp">🔍 Search FAQs</a></p>
<p><a href="manage_faqs.jsp">📚 Manage FAQs</a></p>


<p>You have successfully logged in as a 
    <strong><%= session.getAttribute("role") %></strong>.
</p>

</body>
</html>


