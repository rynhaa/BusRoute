<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setAttribute("activeMenu", "notice");

	String adminName = (String) session.getAttribute("adminName");
	String adminRole = (String) session.getAttribute("role");

	if (adminName == null || adminRole == null || !adminRole.equals("ADMIN")) {
%>
	<script>
		alert("권한이 없습니다.");
		location.href = "${pageContext.request.contextPath}/admin/login";
	</script>
<%
		return;
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/resources/css/admin.css" rel="stylesheet">
<style>


  .write-container {
    width: 90%;
    margin: 0 auto 20px auto;
    background-color: #fff;
    padding: 30px;
    padding-bottom: 60px;
    border-radius: 12px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  } 

  .write-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
  }

  .writer-info {
    display: flex;
    align-items: center;
    gap: 10px;
    font-weight: bold;
    color: #444;
  }

  .writer-info img {
    width: 32px;
    height: 32px;
    border-radius: 50%;
  }

  .write-actions {
    display: flex;
    margin-top:10px;
    float: right;
    gap: 10px;
  }

  .write-actions .btn {
    padding: 8px 20px;
    border-radius: 8px;
    border: none;
    font-weight: bold;
    cursor: pointer;
    transition: 0.3s;
  }

  .btn-cancel {
    background-color: #ccc !important;
    color: #333 !important;
  }

  .btn-cancel:hover {
    background-color: #999 !important;
    color: white !important;
  }

  .btn-submit {
    background-color: #3b577a !important;
    color: white !important;
  }

  .btn-submit:hover {
    background-color: #6d87b8 !important;
  }

  .write-form label {
    display: block;
    margin: 20px 0 8px;
    font-weight: bold;
    color: #333;
  }

  .write-form input[type="text"],
  .write-form textarea {
    width: 98%;
    padding: 14px 18px;
    border: 1px solid #ccc;
    border-radius: 10px;
    font-size: 16px;
  }

  .write-form textarea {
    height: 300px;
    resize: vertical;
  }
  h3 {
  	width: 90%;
  	margin: 0 auto 20px;
  	margin-bottom: 10px;
  }
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/admin/include/nav.jsp" %>


<div class="d-flex">
	<main class="flex-grow-1 p-4">
	<!-- 30분 카운트다운 -->
	<div id="session-timer">
	    <div class="session-box">
	        <strong>자동 로그아웃까지 남은 시간 : <span id="countdown">30:00</span></strong>
	    </div>
	</div>
	
	<h3>수정 하기</h3>
	<div class="write-container">
		<div class="write-header">
	    	<div class="writer-info">
	      	${loginUser.userId}
	  		</div>
		</div>
	
		<form id="writeForm" class="write-form" action="/board/admin/modify" method="post">
			<input type="hidden" name="board_id" value="${board.board_id}" />
		  	<input type="hidden" name="writer_id" value="${loginUser.userId}" />
		
		    <label for="title">제목</label>
		    <input type="text" id="title" value="${board.title}" name="title" required>
		
			<label for="content">내용</label>
			<textarea id="content" name="content" required>${board.content}</textarea>
		</form>
		  
		<div class="write-actions">
		  	<button type="submit" form="writeForm" class="btn btn-submit">작성</button>
		  	<button type="button" onclick="location.href='/board/admin/list'" class="btn btn-cancel">취소</button>
		</div>
	</div>
	</main>
	</div>
</body>
</html>