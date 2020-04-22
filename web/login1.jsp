<%@page import="com.mysql.jdbc.Statement"%>
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
        <title>Authentication</title>
    </head>
    <body>
        <%
            try{
                String userid=request.getParameter("userid"); 
                session.putValue("userid",userid); 
                String pwd=request.getParameter("pwd"); 
                Class.forName("com.mysql.jdbc.Driver"); 
                java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/test","root","1234"); 
                java.sql.Statement st= con.createStatement();    
                ResultSet rs=st.executeQuery("select * from mytable1 where userid='"+userid+"'"); 
                if(rs.next()) 
                { 
                    if(rs.getString(2).equals(pwd)) 
                    { 
                        response.sendRedirect("home.jsp");
                    } 
                    else 
                    { 
                        response.sendRedirect("index.jsp?status=incorrect");
                    }
                } 
                else
                {
                    response.sendRedirect("index.jsp?status=incorrect");
                }
            }
            catch(SQLException e)
            { }
            %>
              
    </body>
</html>
