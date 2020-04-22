<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>
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
                PreparedStatement ps=con.prepareStatement("Select views from questions where id=?");
                ps.setInt(1,numID);
                ResultSet rs=ps.executeQuery();
                rs.next();
                int count=rs.getInt("views");
                ps=con.prepareStatement("Update questions set views=? where id=?");
                ps.setInt(1,count+1);
                ps.setInt(2,numID);
                int i=ps.executeUpdate();
                out.println("inserted");
                String path="question.jsp?id="+numID;
                response.sendRedirect(path);
            }
            catch(SQLException e)
            {
                out.println(e);
            }
        %>
    </body>
</html>

