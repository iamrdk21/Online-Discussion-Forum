<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.DriverManager"%>

<%@page import="java.sql.SQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            String id=request.getParameter("id");
            String username=(String)session.getAttribute("userid");
            int numID = Integer.parseInt(id);
            String comment=request.getParameter("Comment");
            String reply=request.getParameter("reply");
            out.println(reply);
            if(reply!=null && !reply.isEmpty()){
                try
                {
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/test?zeroDateTimeBehavior=convertToNull","root","1234");
                    PreparedStatement ps=con.prepareStatement("Insert into reply(User,Comment,Reply) values(?,?,?)");
                    ps.setString(1,username);
                    ps.setString(2,comment);
                    ps.setString(3,reply);
                    ps.executeUpdate();
                    String path="answer_page.jsp?id="+numID;
                    response.sendRedirect(path);
               } 
               catch(SQLException e)
               {
                   out.println(e);
               }
            }
            else
            {
                out.println("nothing");
            }
            
        %>
    </body>
</html>

