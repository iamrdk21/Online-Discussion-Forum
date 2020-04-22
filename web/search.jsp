<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sdl.delivery.ugc.client.comment.Ugcapi" %>
<%@ page import="com.sdl.delivery.ugc.client.comment.impl.DefaultUgcapi" %>
<%@ page import="com.sdl.delivery.ugc.client.odata.edm.Comment" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.net.URI" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="static com.tridion.ambientdata.AmbientDataContext.getCurrentClaimStore" %>
<%@ page import="static java.util.Arrays.asList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<!-- This sample JSP page demonstrates the following UGC functionality:
  -Displaying comments
  -Controls to add a new comment
  -Controls to edit or remove a comment submitted by the person accessing the Web page.

  Notes:
    -Internet Explorer is not supported
    -Code is based on Bootstrap, JQuery, and ES6
-->
  <head>
    <title>Sample UGC demo page</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1'>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <!-- Specify your own personal CSS stylesheet for comments -->
    <link rel="stylesheet" href="comments-example.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jqeury.min.js"></script> 
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script> 
    <!-- Specify your own personal JavaScript form for submitting comments -->
    <script src="comments-form.js"></script>
  </head>

  <body>
    <%
      String cmuri = "tcm:1-1-64";
      getCurrentClaimStore().clearReadOnly();

      URI userURI = URI.create("taf:claim:contentdelivery:webservice:user");
      String currentUserId = (String) getCurrentClaimStore().get(userURI);

      UgcCommentApi api = new DefaultUgcCommentApi();      

      // Submitting a new or modified comment
      if (request.getParameter("submitComment") != null) {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String comment = request.getParameter("comment");

        // If this is a modified existing comment, get the ID of the comment being modified.
        int editCommentId = 0;
        if (request.getParameter("edit-comment-id") != null) {
          editCommentId = Integer.ParseInt(request.getParameter("edit-comment-id"));
        }

        // If this is a (new) reply to another comment, get the ID of the comment being replied to.
        int replyCommentId = 0;
        if (request.getParameter("reply-comment-id") != null) {
          replyCommentId = Integer.ParseInt(request.getParameter("reply-comment-id"));
        }

        // Retrieve any metadata key-value pairs included in the request.
        String metaKeys = request.getParameterValues("MetaKey[]");
        String metaValues = request.getParameterValues("MetaValue[]");
        Map<String, String> metaMap = createMetaMap(metaKeys, metaValues);

        // Get the URI of the item being commented on.
        cmuri = request.getParameter("cmuri");

        if (replyCommentId != 0) {
          // Post a new reply to a comment.
          api.postComment(cmuri, username, email, comment, replyCommentId, metaMap);
        } else if (editCommentId != 0) {
          // Modify an existing comment.
          api.editComment(editCommentId, comment, null, metaMap);
        } else {
          // Post a new comment on the item itself (top level).
          api.postComment(cmuri, 	username, email, comment, 0, metaMap);
        }
      // Removing a comment
      } else if (request.getParameter("removeComment") != null) {
        String commentId = request.getParameter("commentId");
        api.removeComment(Long.parseLong(commentId));
      }

      // Loading the comments

      // This call retrieves all comment threads for an item in one go, 
      // to full thread depth, sorted in ascending order, with metadata fetched.
      List<Comment> comments = api.retrieveThreadedComments(cmuri, false, -1, -1, -1, true);    
    %>

    <%!

      private Map<String, String> createMetaMap(String[] metaKeys, String[] metaValues) {
        Map<String, String> metaMap = new HashMap<>();
        Iterator<String> keys = asList(metaKeys).iterator();
        Iterator<String> values = asList(metaValues).iterator();
        while (keys.hasNext() && values.hasNext()) {
          String key = keys.next();
          String value = values.next();
          if (key != null && !key.isEmpty() && value != null && !value.isEmpty()) {
            metaMap.put(key, value);
          }
        }
        return metaMap;
      }      

      private void buildRootComment(List<Comment> comments, String currentUserId, JspWriter out) throws IOException {
        out.print("<ul class=\"media-list\">");
        for (Comment comment : comments) {
          out.print("<li class=\"media\">");
          buildComment(comment, currentUserId, out);
          out.print("</li>");
        }
        out.print("</ul>");
      }

      private void buildNestedComments(List<Comment> comments, String currentUserId, JspWriter out) throws IOException {
        out.print("<ul class=\"media-list\">");
        for (Comment comment : comments) {
          out.print("<li class=\"media media-replied\">");
          buildComment(comment, currentUserId, out);
          out.print("</li>");
        }
        out.print("</ul>");
      }

      private void buildComment(Comment comment, String currentUserId, JspWriter out) throws IOException {
        writeComment(comment, currentUserId, out);
        List<Comment> children = comment.getChildren();
        if (!children.isEmpty()) {
          buildNestedComments(children, currentUserId, out);
        }
      }

      private void writeComment(Comment comment, String currentUserId, JspWriter out) throws IOException {
        
        // Check if the comment being displayed was submitted by the user who is currently logged in. 
        boolean sameUser = comment.getUser().getId().equals(currentUserId);

        out.print("<div class=\"media-body\">");
        out.print("<div class=\"well well-lg\">");
        
        // Show the name of the commenter.
        out.print("<h4 class=\"media-heading text-uppercase reviews username\">");
        if (comment.getParent() != null) {
          out.print("<span class=\"glyphicon glyphicon-share-alt\"></span>");
        }
        out.print(comment.getUser().getName());
        out.print("</h4>");

         // Get, but hide, the email address of the commenter and the ID of the comment.
        out.print("<input type=\"hidden\" class=\"form-control\" name=\"email\" value=\"");
        out.print(comment.getUser().getEmailAddress());
        out.print("\"/>");
        out.print("<input type=\"hidden\" class=\"form-control\" name=\"comment-id\" value=\"");
        out.print(comment.getId());
        out.print("\"/>");

        // Show the comment itself.
        out.print("<p class=\"media-comment\">");
        out.print(comment.getContent());
        out.print("</p>");

        // Get, but hide, the metadata key-value pairs
        for (Map.Entry<String, String> meta : comment.getMetadata().entrySet()) {
          out.print("<input type=\"hidden\" class=\"form-control\" name=\"MetaKey[]\" value=\"");
          out.print(meta.getKey());
          out.print("\"/>");
          out.print("<input type=\"hidden\" class=\"form-control\" name=\"MetaValue[]\" value=\"");
          out.print(meta.getValue());
          out.print("\"/>");          
        }

        // Show a Reply button.
        out.print("<a class=\"btn btn-default btn-md reply-btn\" href=\"#add-comment\">");
        out.print("<span class=\"glyphicon glyphicon-share-alt\"></span>Reply</a>");

        // Show an Edit button (disabled if the currently logged-in user is not the commenter).
        out.print("<a class=\"btn btn-default btn-md edit-btn\" href=\"#edit-comment\">" +
                  (sameUser ? ">" : " disabled=\"disabled\" >"));
        out.print("<span class=\"glyphicon glyphicon-edit\"></span>Edit</a>");

        // Show a Meta button.
        out.print("<a class=\"btn btn-default btn-md meta-btn\" href=\"#meta-comment\">");
        out.print("<span class=\"glyphicon glyphicon-info-sign\"></span>Meta</a>");

        // Show a Remove button (disabled if the currently logged-in user is not the commenter).
        out.print("<a class=\"btn btn-default btn-md remove-btn\" href=\"#remove-comment\">" +
                  (sameUser ? ">" : " disabled=\"disabled\" >"));
        out.print("<span class=\"glyphicon glyphicon-remove\"></span>Remove</a>");

        out.print("</div>");
        out.print("</div>");
      }

    %>

    <div class="container">
      <div class="row">
        <div class="col-sm-10 col-sm-offset-1" id="logout">
           <div class="page-header">
             <h3 class="reviews">Leave your comment</h3>
           </div>
           <div class="comment-tabs">
             <ul class="nav nav-tabs" role="tablist">
               <li class="active">
                 <a href="#comments-logout" role="tab" data-toggle="tab" class="logout-comments-btn">
                   <h4 class="reviews text-capitalize">Comments</h4>
                 </a>
               </li>
               <li>
                 <a href="#add-comment" role="tab" data-toggle="tab" class="add-comment-btn">
                   <h4 class="reviews text-capitalize">Post comment</h4>
                 </a>
               </li>
             </ul>
             <div class="tab-content">
               <div class="tab-pane active" id="comments-logout">
                 <% buildRootComments(comments, currentUserId, out); %>
               </div>
               <div class="tab-pane" id="add-comment" />
             </div>
           </div>
        </div>
      </div>
    </div>

    <div id="show-meta-modal" class="modal" role="dialog">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal">&times;</button>
            <h4 class="modal-title">Metadata</h4>
          </div>
          <div class="show-meta modal-body">
            <table class="table">
              <thead>
                <tr>
                  <th>Meta Key</th>
                  <th>Meta Value</th>
                </tr>
              </thead>
              <tbody/>
            </table>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
          </div>
        </div>

      </div>
    </div>

    <script>
      $(function () {
        
        $('.add-comment-btn').click(function () {
          COMMENT_FORM.init({
            'edit-comment-id': 0,
            'reply-comment-id': 0
          });
          COMMENT_FORM.loadCommentsForm();
          $('.nav-tabs a[href="#add-comment"]').tab('show')
        });

        $('.reply-btn').click(function () {
          var comment = getComment($(this));
          COMMENT_FORM.init({
            'edit-comment-id': 0,
            'reply-comment-id': comment['comment-id'],
            'username': comment['username'],
            'email': comment['email']
          });
          COMMENT_FORM.loadCommentsForm();
          $('.nav-tabs a[href="#add-comment"]').tab('show')
        });

        $('.edit-btn').click(function (e) {
          e.preventDefault();
          if (!$(this).is("[disabled]")) {
            COMMENT_FORM.init(getComment($(this)));
            COMMENT_FORM.loadCommentsForm();
            $('.nav-tabs a[href="#add-comment"]').tab('show')
          }
        });

        $('.remove-btn').click(function (e) {
          e.preventDefault();
          if (!$(this).is("[disabled]")) {
            return false;
          }
          $.post('comments-example.jsp',
            {removeComment: '', commentId: getComment($(this))['comment-id']})
            .done(function (msg) {
              windows.location.replace('comments-example-jsp');
            })
            .fail(function (xhr, status, error) {
              document.open();
              document.write(xhr.responseText);
              document.close();
            });
          return true;
        });

        $('.meta-btn').click(function () {
          $('#show-meta-model tbody').remove();
          var tbody = $('#show-meta modal tabl').append('<tbody>');
          $.each(getMeta($(this)), function(key, value) {
            var trow = $('<tr>');
            tbody.append(trow);
            trow.append($('<td>').html(key));
            trow.append($('<td>').html(value));
          });

          $('#show-meta-modal').modal();
        });

        var getComment = function (sibling) {
          var result = {};
          
          result['reply-comment-id'] = 0;
          result['comment-id'] = sibling.siblings('input[name="comment-id"]').first().val();
          result['edit-comment-id'] = sibling.siblings('input[name="comment-id"]').first().val();
          result['username'] = sibling.siblings('h4.username').first().text();
          result['email'] = sibling.siblings('input[name="email"]').first().val();
          result['comment'] = sibling.siblings('p.media-comment').first().text();
          result['metadata'] = getMeta(sibling);

          return result;
        }

        var getMeta = function (sibling) {
          var keyArr = [];
          sibling.siblings('input[name^="MetaKey"]').each(function () {
            keyArr.push($(this).val());
          });

          var valueArr = [];
          sibling.siblings('input[name^="MetaValue"]').each(function () {
            valueArr.push($(this).val());
          });

          return ((keys, values) => keys.reduce((result, key, value) => {
            result[key] = values[value];
            return result;
          }, {}))(keyArr, valueArr);
      
        }

      });
    </script>
  </body>
</html>