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
            int numID = Integer.parseInt(id);
            String comment=request.getParameter("comment");
            out.println(comment);
            if(comment!=null && !comment.isEmpty()){
                try
                {
                    Class.forName("com.mysql.jdbc.Driver");
                    Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/test?zeroDateTimeBehavior=convertToNull","root","1234");
                    PreparedStatement ps=con.prepareStatement("Insert into response(QID,User,Comment) values(?,?,?)");
                    ps.setInt(1,numID);
                    String username=(String)session.getAttribute("userid");
                    ps.setString(2,username);
                    ps.setString(3,comment);
                    int i=ps.executeUpdate();
                    ps=con.prepareStatement("Select comment from questions where id=?");
                    ps.setInt(1,numID);
                    ResultSet rs=ps.executeQuery();
                    rs.next();
                    int count=rs.getInt("comment");
                    out.println(count);
                    ps=con.prepareStatement("Update questions set comment=? where id=?");
                    ps.setInt(1,count+1);
                    ps.setInt(2,numID);
                    i=ps.executeUpdate();
                    String path="answer_page.jsp?id="+numID;
                    out.println("inserted");
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

