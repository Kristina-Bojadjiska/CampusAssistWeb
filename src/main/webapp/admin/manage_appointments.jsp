<%-- 
    Document   : manage_appointments
    Created on : 10 Jun 2025, 10:17:19
    Author     : kchip
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.text.*" %>
<%@ page session="true" %>
<%@ page import="java.util.*" %>
<%
    String username = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("role");

    if (username == null || !"admin".equals(role)) {
        response.sendRedirect("../shared/login.jsp");
        return;
    }

    List<Map<String, String>> upcomingList = new ArrayList<>();
    List<Map<String, String>> pastList = new ArrayList<>();

    try {
        Class.forName("org.sqlite.JDBC");
        String dbPath = "D:/All_Projects/CampusAssistData/campusassist.db";
        Connection conn = DriverManager.getConnection("jdbc:sqlite:" + dbPath);
        PreparedStatement stmt = conn.prepareStatement("SELECT * FROM appointments ORDER BY datetime ASC");
        ResultSet rs = stmt.executeQuery();

        java.util.Date now = new java.util.Date();
        DateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm"); // fixed
        DateFormat displayFormat = new SimpleDateFormat("dd MMM yyyy, HH:mm");

        while (rs.next()) {
            Map<String, String> appt = new HashMap<>();
            appt.put("id", rs.getString("id"));
            appt.put("studentUsername", rs.getString("studentUsername"));
            appt.put("category", rs.getString("category"));
            appt.put("status", rs.getString("status"));

            String datetimeRaw = rs.getString("datetime");
            appt.put("datetimeRaw", datetimeRaw);
           try {
    
           // Fix format by replacing "T" with space
            String cleanDatetime = datetimeRaw.replace("T", " ");
            java.util.Date dt = inputFormat.parse(cleanDatetime);
            appt.put("datetimeFormatted", displayFormat.format(dt));

            if (dt.after(now)) {
            upcomingList.add(appt);
            } else {
    pastList.add(appt);
}

} catch (Exception pe) {
    // If parsing fails, assume past (fallback)
    appt.put("datetimeFormatted", datetimeRaw.replace("T", " "));
    pastList.add(appt);
}
        }

        rs.close();
        stmt.close();
        conn.close();
    } catch (Exception e) {
        out.println("<p style='color:red;'>Error loading appointments: " + e.getMessage() + "</p>");
    }
%>

<html>
<head>
    <title>Manage Appointments</title>
    <style>
        body { font-family: Arial; margin: 0; padding: 0; background-color: #fff; }
        .header {
            background-color: #4B0082;
            color: white;
            padding: 16px 20px;
            font-size: 22px;
            font-weight: bold;
        }
        .container { max-width: 1000px; margin: 40px auto; padding: 20px; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 40px; }
        th, td {
            padding: 10px;
            border: 1px solid #ccc;
            text-align: center;
            vertical-align: top;
        }
        th { background-color: #f2f2f2; }
        form { margin: 0; }
        .btn {
            padding: 6px 10px;
            font-size: 14px;
            margin: 2px;
            cursor: pointer;
        }
        .btn-approve { background-color: green; color: white; }
        .btn-reschedule { background-color: orange; color: white; }
        .btn-cancel { background-color: red; color: white; }
        .back-link { margin-top: 20px; display: inline-block; }
        .logout {
            float: right;
            color: white;
            text-decoration: none;
            font-size: 14px;
        }
        h2 {
            border-bottom: 2px solid #ccc;
            padding-bottom: 6px;
        }
    </style>
</head>
<body>
<div class="header">
    Admin: Manage Appointments
    <a href="<%= request.getContextPath() %>/LogoutServlet" class="logout">Logout</a>
</div>
<div class="container">

    <h2>Upcoming Appointments</h2>
    <table>
        <tr>
            <th>Student</th>
            <th>Category</th>
            <th>Date/Time</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        <%
            for (Map<String, String> appt : upcomingList) {
                String status = appt.get("status");
        %>
        <tr>
            <td><%= appt.get("studentUsername") %></td>
            <td><%= appt.get("category") %></td>
            <td><%= appt.get("datetimeFormatted") %></td>
            <td><%= status %></td>
            <td>
                <% if (!"cancelled".equalsIgnoreCase(status)) { %>
                    <form action="update_appointment.jsp" method="post" style="display:inline;">
                        <input type="hidden" name="appointmentId" value="<%= appt.get("id") %>" />
                        <button class="btn btn-approve" type="submit" name="action" value="approve">Approve</button>
                    </form>
                    <form action="reschedule_appointment.jsp" method="get" style="display:inline;">
                        <input type="hidden" name="appointmentId" value="<%= appt.get("id") %>" />
                        <button class="btn btn-reschedule" type="submit">Reschedule</button>
                    </form>
                    <form action="update_appointment.jsp" method="post" style="display:inline;">
                        <input type="hidden" name="appointmentId" value="<%= appt.get("id") %>" />
                        <button class="btn btn-cancel" type="submit" name="action" value="cancel"
                            onclick="return confirm('Cancel this appointment?');">Cancel</button>
                    </form>
                <% } else { %>
                    No further actions allowed.
                <% } %>
            </td>
        </tr>
        <% } %>
    </table>

    <h2>Past Appointments</h2>
    <table>
        <tr>
            <th>Student</th>
            <th>Category</th>
            <th>Date/Time</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        <%
            for (Map<String, String> appt : pastList) {
        %>
        <tr>
            <td><%= appt.get("studentUsername") %></td>
            <td><%= appt.get("category") %></td>
            <td><%= appt.get("datetimeFormatted") %></td>
            <td><%= appt.get("status") %></td>
            <td>Past Appointment – View Only</td>
        </tr>
        <% } %>
    </table>

    <a href="index.jsp" class="back-link">← Back to Dashboard</a>
</div>
</body>
</html>
