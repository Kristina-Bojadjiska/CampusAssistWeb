<%-- 
    Document   : login
    Created on : 6 Jun 2025, 11:18:42
    Author     : kchip
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>CampusAssist Login</title>
    <style>
        body {

            font-family: Arial, sans-serif;
            background-color: #f3f3f3;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-top: 60px;
            padding-bottom: 40px;
        }
       
        .login-box {
            background-color: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            width: 300px;
        }
        .login-box h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin-top: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 8px;
        }
        input[type="submit"] {
            background-color: #0077cc;
            color: white;
            padding: 10px;
            width: 100%;
            border: none;
            border-radius: 8px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #005fa3;
        }
        .footer {
            margin-top: 15px;
            text-align: center;
            font-size: 12px;
            color: #777;
        }
    </style>
</head>
<body>

    <div style="text-align: center; margin-bottom: 30px;">
        <h1 style="color: #4b0082; font-size: 28px; margin-bottom: 10px;">Welcome to CampusAssist</h1>
        <h2 style="color: #555; font-size: 20px;">Solent University Student Support Portal</h2>
    </div>

<div class="login-box">
    <h2>CampusAssist Login</h2>

<%
    String error = (String) request.getAttribute("error");
    if (error != null) {
%>
    <div style="color: red; text-align: center; margin-bottom: 10px;">
        <%= error %>
    </div>
<%
    }
%>


<form method="post" action="<%= request.getContextPath() %>/LoginServlet">
    <input type="text" name="username" placeholder="Username" required />
    <input type="password" name="password" placeholder="Password" required />
    <input type="submit" value="Login" />
</form>


    <div class="footer">© 2025 Solent University</div>
</div>

</body>
</html>




