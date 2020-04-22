<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ask A Question</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <style type="text/css">
    .main_body{
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-image: url('back.jpg');
        background-repeat: no-repeat;
        background-attachment: fixed;
        background-size: 100%;
        opacity: 0.5;
        filter:alpha(opacity=20);
         }
         .navbar_custom {
            color: #FFFFFF;
            background-color: #450915;
            }
         .navbar-inverse .navbar-brand {color:white;}
         .ask {margin-top:100px;}
         .form-group{padding:20px 5px 10px 5px;;}
         .navbar{border-radius: 0px;}
         </style>
    </head>
    <body>
        
        <div class="main_body"></div>
        <nav class="navbar navbar-inverse navbar_custom">
            <div class="container-fluid">
                <div class="navbar-header" style="padding-left:10%;">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand nn" href="home.jsp">ONLINE DISCUSSION FORUM</a>
                </div>
                <div class="collapse navbar-collapse" id="myNavbar">
                    <ul class="nav navbar-nav navbar-right">
                        <li style="color:white;">
                            <a href="#" style="color:white;font-size:16px;"> Welcome <%=session.getAttribute("userid")%></a>                 
                        </li>
                        <li>
                            <a style="color:white;"  href="logout.jsp">LOGOUT</a>
                        </li>
                    </ul>  
                </div>
            </div>
        </nav>
         
                        <div class="container ask">
        <div class="col-md-6 col-md-offset-3">
          <div class="panel panel-default">
              <div class="panel-heading text-center brown"><strong>ASK YOUR QUESTION</strong></div>

            <div class="panel-body">
          <form action="question_add.jsp" method="post">
          <div class="form-group">
          <input type="text" class="form-control"  placeholder="Question Title" name="qtitle" required="true">
          </div>
          <div class="form-group">
              <textarea class="form-control" placeholder="Question Content"  name="qcontent" required="true"></textarea>
          </div>
          
              <div class="text-center">
                <button type="submit" class="btn btn-success">Submit</button>
              </div>
          </form>
            </div>
          </div>
            
        <div class="footer navbar-fixed-bottom text-center navbar_custom" style="background-color:#45015;color:#fff;">
        Copyright
        &copy; Built by Rohan D. Kadam
        </div>
    </body>
