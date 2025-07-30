<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    request.setAttribute("activeMenu", "reportList");

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
<title>상세 보기</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
<link href="${pageContext.request.contextPath}/resources/css/admin.css" rel="stylesheet"/>
<style>
  /* 기존 스타일 유지 */
  .write-container {
    width: 90%;
    margin: 0 auto 20px auto;
    background-color: #fff;
    padding: 30px 40px;
    padding-bottom: 60px;
    border-radius: 12px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
  }

  .write-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 30px;
  }

  .writer-info {
    display: flex;
    align-items: center;
    gap: 10px;
    font-weight: bold;
    color: #444;
  }
  
  .writer-info .write-value {
  font-size: 14px;
  padding: 6px 6px;
  background-color: #f0f0f0;
  border-radius: 8px;
  font-weight: 600;
  color: #555;
  min-width: 80px;
  text-align: center;
  }

  .write-label {
    margin: 20px 0 8px;
    font-weight: bold;
    color: #333;
    font-size: 18px;
  }

  .write-value {
    padding: 14px 18px;
    border: 1px solid #ccc;
    border-radius: 10px;
    background-color: #f9f9f9;
    font-size: 17px;
    color: #222;
  }

  .write-content {
    white-space: pre-wrap;
    line-height: 1.6;
    min-height: 200px;
  }
  
  /* 댓글(관리자 답변) 영역 스타일: 최대 높이 제한 + 스크롤 */
  .write-content2 {
    white-space: pre-wrap;
    line-height: 1.6;
    max-height: 200px;       /* 최대 높이 */
    overflow-y: auto;        /* 넘칠 경우 세로 스크롤 */
    padding: 14px 18px;
    border: 1px solid #ccc;
    border-radius: 10px;
    background-color: #f9f9f9;
    font-size: 16px;
    color: #222;
  }

  .write-image {
    margin-top: 20px;
  }

  .write-image img {
    max-width: 100%;
    height: auto;
    border-radius: 10px;
    box-shadow: 0 0 8px rgba(0,0,0,0.15);
  }

  .write-actions {
    display: flex;
    margin-top: 30px;
    justify-content: flex-end;
    gap: 10px;
  }

  .btn {
    padding: 8px 16px;
    border-radius: 8px;
    border: none;
    font-weight: bold;
    cursor: pointer;
    font-size: 14px;
    transition: 0.3s;
    text-decoration: none;
    display: inline-block;
  }

  .btn-cancel {
    background-color: #ccc !important;
    color: #333 !important;
  }

  .btn-cancel:hover {
    background-color: #999 !important;
    color: white !important;
  }

  .btn-edit {
    background-color: #3b577a !important;
    color: white !important;
  }

  .btn-edit:hover {
    background-color: #6d87b8 !important;
  }

  .btn-delete {
    background-color: #d9534f !important;
    color: white !important;
  }

  .btn-delete:hover {
    background-color: #c9302c !important;
  }
  h3 {
    width: 90%;
    margin: 0 auto 20px;
    margin-bottom: 10px;
  }

  /* 관리자 답변 작성 textarea 스타일 개선 */
  #adminReply {
    width: 100%;
    padding: 12px;
    border-radius: 8px;
    border: 1px solid #ccc;
    resize: vertical;  /* 세로 방향만 크기 조절 가능 */
    font-size: 16px;
    line-height: 1.5;
    min-height: 80px;  /* 최소 높이 줄임 */
    max-height: 150px; /* 최대 높이 지정 */
  }

  #adminReply:focus {
    outline: none;
    border-color: #3b577a;
    box-shadow: 0 0 5px rgba(59, 87, 122, 0.7);
  }

  /* 답변 저장 버튼 스타일(버튼 태그 안에 인라인 스타일 제거하고 클래스화 가능) */
  .btn-save-reply {
    background-color: #3b577a;
    color: #fff;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    transition: background-color 0.3s ease;
  }

  .btn-save-reply:hover {
    background-color: #6d87b8;
  }
  
  .btn-delete {
  background-color: #d9534f !important;
  color: white !important;
  border: none;
  cursor: pointer;
  transition: background-color 0.3s;
}

.btn-delete:hover {
  background-color: #c9302c !important;
}
</style>
</head>
<body>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/views/admin/include/nav.jsp" %>

<div class="d-flex">
  <main class="flex-grow-1 p-4">
    <h3>상세 내용 보기</h3>

    <div class="write-container">
      <div class="write-header">
        <div class="writer-info">
          <div class="write-value">${report.username}</div>
        </div>
      </div>

      <div>
        <div class="write-label">유형</div>
        <div class="write-value">${report.category}</div>

        <div class="write-label">제목</div>
        <div class="write-value">${report.title}</div>

        <div class="write-label">내용</div>
        <div class="write-value write-content">${report.content}</div>

		<c:if test="${not empty report.attachmentPath}">
		  <div class="write-label">첨부 이미지</div>
		  <div class="write-image">
		    <c:forEach var="path" items="${fn:split(report.attachmentPath, ',')}">
		      <!-- path는 '/upload/uuid_파일명' 형식으로 저장됨 -->
			<img src="/display?fileName=${path}" alt="첨부 이미지" style="max-width:300px; margin-bottom:10px;" />
		    </c:forEach>
		  </div>
		</c:if>
      </div>

      <div class="write-actions">
        <a class="btn btn-edit" href="/report/admin/modify?report_id=${report.report_id}">수정</a>
        <a class="btn btn-delete" href="/report/admin/remove?report_id=${report.report_id}" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
        <a class="btn btn-cancel" href="/report/admin/list">목록</a>
      </div>



		<c:if test="${sessionScope.role == 'ADMIN'}">
		  <div id="adminReplySection" style="margin-top:30px;">
		    <c:choose>
		      <c:when test="${empty report.admin_reply}">
		        <!-- 답변 없음: 바로 작성 textarea와 저장 버튼 -->
		        <form id="adminReplyForm" action="/report/admin/adminReply" method="post">
		          <input type="hidden" name="report_id" value="${report.report_id}" />
		          <label for="adminReply" class="write-label">답변 작성</label>
		          <textarea id="adminReply" name="adminReply" rows="4" placeholder="답변을 입력하세요"
		                    style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid #ccc; resize: none;" required></textarea>
		          <button type="submit" class="btn btn-edit" style="margin-top: 15px;">답변 저장</button>
		        </form>
		      </c:when>
		
		      <c:otherwise>
		        <!-- 답변 있음: 답변 내용 표시 -->
		        <div id="replyView" style="border: 1px solid #ccc; padding: 15px; border-radius: 8px; background:#f9f9f9;">
		          <pre style="white-space: pre-wrap; margin:0;">${report.admin_reply}</pre>
		          <div style="margin-top: 10px; font-size: 0.85em; color: #777;">
		            작성일: <fmt:formatDate value="${report.replied_at}" pattern="yyyy년 MM월 dd일 a hh:mm" />
		          </div>
		        </div>
		
				<!-- 수정/삭제 버튼 (위쪽에 있는 것들) -->
				<div id="editButtonGroup" style="margin-top:10px;">
				  <button id="btnEditReply" class="btn btn-edit" type="button">수정</button>
				  <form action="/report/admin/adminReplyDelete" method="post" 
				        onsubmit="return confirm('답변을 삭제하시겠습니까?');" 
				        style="display:inline-block; margin-left:10px;">
				    <input type="hidden" name="report_id" value="${report.report_id}" />
				    <button type="submit" class="btn btn-delete">삭제</button>
				  </form>
				</div>
		
		        
				<!-- 수정 폼 (숨김 상태) -->
				<form id="editReplyForm" action="/report/admin/adminReply" method="post" style="margin-top:15px; display:none;">
				  <input type="hidden" name="report_id" value="${report.report_id}" />
				  <textarea name="adminReply" id="editReplyTextarea" rows="4"
				            style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid #ccc; resize: none;" required></textarea>
				
				  <div class="edit-actions" style="margin-top: 10px; display: flex; justify-content: left; gap: 10px; align-items: ;">
				    <button type="submit" class="btn btn-edit">저장</button>
				
				    <!-- 삭제 버튼 (JS로 form 제출) -->
				    <button type="button" class="btn btn-delete" onclick="submitDeleteForm()">삭제</button>
				
				    <button type="button" id="btnCancelEdit" class="btn btn-cancel">취소</button>
				  </div>
				</form>
				
				<!-- 실제 삭제용 폼 (보이지 않음) -->
				<form id="deleteReplyForm" action="/report/admin/adminReplyDelete" method="post" style="display:none;">
				  <input type="hidden" name="report_id" value="${report.report_id}" />
				</form>
		      </c:otherwise>
		    </c:choose>
		  </div>
		</c:if>
    </div>
  </main>
</div>
<%@ include file="/WEB-INF/views/admin/include/footer.jsp" %>


<script>
document.addEventListener('DOMContentLoaded', function () {
  const btnEdit = document.getElementById('btnEditReply');
  const replyView = document.getElementById('replyView');
  const editForm = document.getElementById('editReplyForm');
  const editTextarea = document.getElementById('editReplyTextarea');
  const btnCancel = document.getElementById('btnCancelEdit');
  const editButtonGroup = document.getElementById('editButtonGroup'); // 위쪽 버튼 묶음
  const deleteForm = document.getElementById('deleteReplyForm'); // 삭제용 숨김 폼

  // [수정] 버튼 클릭 시
  if (btnEdit) {
    btnEdit.addEventListener('click', () => {
      // 기존 답변을 textarea에 복사
      editTextarea.value = replyView.querySelector('pre').innerText.trim();

      // 기존 보기 및 버튼 숨기고 수정 폼 표시
      replyView.style.display = 'none';
      editButtonGroup.style.display = 'none';
      editForm.style.display = 'block';
    });
  }

  // [취소] 버튼 클릭 시
  if (btnCancel) {
    btnCancel.addEventListener('click', () => {
      editForm.style.display = 'none';
      replyView.style.display = 'block';
      editButtonGroup.style.display = 'block';
    });
  }

  // [삭제] 버튼 클릭 시 (수정 폼 내)
  window.submitDeleteForm = function () {
    if (confirm("답변을 삭제하시겠습니까?")) {
      deleteForm.submit();
    }
  };
});

</script>
</body>
</html>
