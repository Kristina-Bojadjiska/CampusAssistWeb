<%-- 
    Document   : update_category
    Created on : 13 Jun 2025, 01:00:33
    Author     : kchip
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";
    Connection conn = null;
    PreparedStatement stmt = null;

    String feedbackId = request.getParameter("feedbackId");
    String category = request.getParameter("category");

    try {
        Class.forName("org.sqlite.JDBC");
        conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);

        String sql = "UPDATE feedback SET category = ? WHERE id = ?";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, category);
        stmt.setInt(2, Integer.parseInt(feedbackId));
        stmt.executeUpdate();

        response.sendRedirect("manage_feedback.jsp");

    } catch(Exception e) {
        out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

