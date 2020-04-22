<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Authentication</title> 
</head>
<body>
<%@ page import ="java.sql.*" %>
<%@ page import ="javax.sql.*" %>
<%
String userid=request.getParameter("userid"); 
String pwd=request.getParameter("pwd"); 
String fname=request.getParameter("fname"); 
String lname=request.getParameter("lname"); 
String email=request.getParameter("email"); 
String designation=request.getParameter("designation");
session.setAttribute("userid",userid);
try
{
Class.forName("com.mysql.jdbc.Driver"); 
java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/test","root","1234"); 
Statement st= con.createStatement(); 
String sql="INSERT INTO mytable1(userid,password,fname,lname,email,designation) VALUES ('"+userid+"','"+pwd+"','"+fname+"','"+lname+"','"+email+"','"+designation+"')";
//int i=st.executeUpdate("insert into mytable1 values ('"+userid+"','"+pwd+"','"+fname+"','"+lname+"','"+email+"', '"+ designation+"')");
//response.sendRedirect("index.jsp?status=created");
st.executeUpdate(sql);
response.sendRedirect("index.jsp?status=created");
}
catch(SQLException e)
{
    out.println(e);
}
%>
</body>
</html>