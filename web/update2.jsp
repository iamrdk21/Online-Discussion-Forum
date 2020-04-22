<%@page import="java.sql.Statement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            try
            {
                String id=request.getParameter("id");
                int numID = Integer.parseInt(id);
                Class.forName("com.mysql.jdbc.Driver");
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/test?zeroDateTimeBehavior=convertToNull","root","1234");
                String comment=request.getParameter("comment1");
                String a=request.getParameter("str"); 
                //String b=request.getParameter("str1");
                String user=request.getParameter("user");
               // String date=request.getParameter("Date");
                
                String sql="Update response set comment=? where qid=? and user=? and comment=?";
                PreparedStatement ps=con.prepareStatement(sql);
                
                ps.setString(1, comment);
                ps.setInt(2, numID);
                ps.setString(3, user);
                ps.setString(4, a);
                ps.executeUpdate();
                
                    String path="answer_page.jsp?id="+numID;
                    response.sendRedirect(path);
            }
            catch(SQLException e)
            {
                out.println(e);
            }
        %>
    </body>
</html>
