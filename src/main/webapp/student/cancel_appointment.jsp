<%-- 
    Document   : cancel_appointment
    Created on : 8 Jun 2025, 14:47:10
    Author     : kchip
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String appointmentId = request.getParameter("appointmentId");
    if (appointmentId == null || appointmentId.isEmpty()) {
        out.println("<p>Invalid appointment ID.</p>");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Confirm Cancellation</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; padding: 40px; }
        .btn { padding: 10px 20px; margin: 10px; font-size: 16px; }
    </style>
</head>
<body>
    <h2>Are you sure you want to cancel your appointment?</h2>
    <form action="confirm_cancel.jsp" method="post">
        <input type="hidden" name="appointmentId" value="<%= appointmentId %>">
        <input type="submit" name="confirm" value="Yes" class="btn">
        <input type="submit" name="confirm" value="No" class="btn">
    </form>
        
        <a href="<%= request.getContextPath() %>/LogoutServlet" style="color:white; float:right; text-decoration:none;">Logout</a>

</body>
</html>
