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
                PreparedStatement ps=con.prepareStatement("Select comment from questions where id=?");
                //PreparedStatement ps=con.prepareStatement("Select * from questions where ID=?");
                //ResultSet rs=ps.executeQuery();               
                //ps=con.prepareStatement("Select * from response where QID=?");
                //ps.setInt(1,numID);
                //rs=ps.executeQuery();
                String comment=request.getParameter("comment");
                String user=request.getParameter("user");
                String date=request.getParameter("Date");
                session.setAttribute("comment",comment);
                session.setAttribute("Date",date);
                String path="answer_page.jsp?id="+numID;
                
                //String sql = "DELETE FROM response WHERE QID= ? and USER= ?";
                //String sql = "DELETE FROM response WHERE comment=?";
                //PreparedStatement ps = con.prepareStatement(sql);
                //ps.setInt(1,numID );
                //ps.setString(1,comment);
                //ps.setString(3, date);
                //ps.executeUpdate();
                Statement stmt= con.createStatement();
                //String sql="INSERT INTO temp(a) VALUES ('"+comment+"')";
                //out.println("select * FROM response WHERE comment='"+comment+"';");
                //String sql="SELECT * FROM response WHERE comment='"+comment+"';";
                //stmt.executeQuery(sql);
               // stmt.executeUpdate(sql);
                    
                    ps.setInt(1,numID);
                    ResultSet rs=ps.executeQuery();
                    rs.next();
                    //int count=rs.getInt("comment");
                    //out.println(count);
                    //ps=con.prepareStatement("Update questions set comment=? where id=?");
                    //ps.setInt(1,count-1);
                    //ps.setInt(2,numID);
                //int i=ps.executeUpdate();
                stmt.executeQuery("SELECT * FROM response WHERE comment='"+comment+"';");
                //rs=stmt.executeQuery("select a from temp where id==1");
                //stmt.executeUpdate("delete from temp");
                response.sendRedirect(path);
            }
            catch(SQLException e)
            {
                out.println(e);
            }
        %>
    </body>
</html>
