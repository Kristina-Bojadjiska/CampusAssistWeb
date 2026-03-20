<%-- 
    Document   : view_faqs
    Created on : 8 Jun 2025, 03:21:39
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

    String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
%>
<html>
<head>
    <title>FAQs</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #fff;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 1000px;
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
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
        }
        th, td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .back-link {
    display: block;
    margin-top: 25px;
    font-size: 16px;
    text-align: left;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        Frequently Asked Questions
        <a href="<%= request.getContextPath() %>/LogoutServlet" style="color:white; float:right; text-decoration:none;">Logout</a>

    </div>

    <table>
        <tr>
            <th>Question</th>
            <th>Answer</th>
        </tr>
        <%
            try {
                Class.forName("org.sqlite.JDBC");
                conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
                stmt = conn.createStatement();
                rs = stmt.executeQuery("SELECT question, answer FROM faqs");

                while (rs.next()) {
                    String question = rs.getString("question");
                    String answer = rs.getString("answer");
        %>
        <tr>
            <td><%= question %></td>
            <td><%= answer %></td>
        </tr>
        <%
                }
            } catch (Exception e) {
                out.println("<tr><td colspan='2'>Error: " + e.getMessage() + "</td></tr>");
            } finally {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }
        %>
    </table>

    <br>
    <a class="back-link" href="index.jsp">← Back to Dashboard</a>
</div>
</body>
</html>

