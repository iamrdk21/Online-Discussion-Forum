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
                String vote=request.getParameter("vote");
                String user=request.getParameter("user");
                String id=request.getParameter("id");
                int numID = Integer.parseInt(id);
                String path="answer_page.jsp?id="+numID;
                Class.forName("com.mysql.jdbc.Driver");
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/test?zeroDateTimeBehavior=convertToNull","root","1234");
                PreparedStatement ps;
                ps=con.prepareStatement("Select * from voted where qid=? and user=?");
                ps.setInt(1,numID);
                ps.setString(2,user);
                ResultSet rs=ps.executeQuery();
                if(rs.next())
                {
                    path=path+"&status=voted";
                    response.sendRedirect(path);
                }
                else
                {
                    out.println("not voted");
                    ps=con.prepareStatement("Insert into voted(qid,user) values(?,?)");
                    ps.setInt(1,numID);
                    ps.setString(2,user);
                    int i=ps.executeUpdate();
                    ps=con.prepareStatement("Select votes from questions where id=?");
                    ps.setInt(1,numID);
                    rs=ps.executeQuery();
                    rs.next();
                    int count=rs.getInt("votes");
                    if(vote.equals("add"))
                    {
                        ps=con.prepareStatement("Update questions set votes=? where id=?");
                        ps.setInt(1,count+1);
                        ps.setInt(2,numID);
                        i=ps.executeUpdate();               
                    }
                    else if(vote.equals("sub"))
                    {
                        ps=con.prepareStatement("Update questions set votes=? where id=?");
                        ps.setInt(1,count-1);
                        ps.setInt(2,numID);
                        i=ps.executeUpdate();
                    }
                    response.sendRedirect(path);
                }
                
            }
            catch(SQLException e)
            {
                out.println(e);
            }
        %>
    </body>
</html>
