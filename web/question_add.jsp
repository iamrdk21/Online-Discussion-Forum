<%@page import="java.sql.ResultSet"%>
<%@page import="javax.naming.spi.DirStateFactory.Result"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.Statement"%>
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
            String qtitle=request.getParameter("qtitle");
            String qcontent=request.getParameter("qcontent");
           // String keyword1=request.getParameter("keyword1");
            //String id=request.getParameter("id");
            //int numID= Integer.parseInt(id);
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/"+"test","root","1234");
                Statement stmt=con.createStatement();
                
               // PreparedStatement ps;
                String sql="INSERT INTO questions (Title,Content) VALUES ('"+qtitle+"','"+qcontent+"')";
                
                //ps=con.prepareStatement("Insert into keyword(keyword1,qid) values(?,?)");
                //ps.setInt(1,numID);
                //ps.setString(2,keyword1);
                stmt.executeUpdate(sql);
                //int i=ps.executeUpdate();
                //stmt1.executeUpdate(sql1);
                response.sendRedirect("discussion_answers.jsp");             
            }
            catch(SQLException e)
            { 
                out.println(e);
            }
            %>
    </body>
</html>
