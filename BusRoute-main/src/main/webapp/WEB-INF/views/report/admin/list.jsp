<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
<title>게시판 목록</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/resources/css/admin.css" rel="stylesheet">
<style>

  table {
    width: 90%;
    margin: 0 auto;
    border-collapse: collapse;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    border-radius: 10px;
    overflow: hidden;
  }
  
  table a{
  	text-decoration: none;
  	color: rgb(59, 80, 122);
  } 

  th, td {
    padding: 14px 18px;
    text-align: center !important;
    border-bottom: 1px solid #eee;
    
  }

  tr:hover td {
    background-color: rgb(232, 248, 255);
  }

  th {
    background-color: rgb(59, 80, 122);
    color: white;
  }

  td {
    background-color: white;
    font-weight: bold;
    cursor: pointer;
    
  }
  

  .write-btn {
    float: right;
    margin: 20px 5% 0 0;
    padding: 10px 18px;
    background-color: rgb(59, 80, 122);
    color: white;
    border-radius: 10px;
    text-decoration: none;
    font-weight: bold;
    transition: background-color 0.3s;
  }

  .write-btn:hover {
    background-color: rgb(127, 152, 202);
  }

  form {
    width: 90%;
    margin: 0 auto 20px;
    text-align: left;
  }

  select, input[type="text"] {
    padding: 14px 18px;
    border: 1px solid #ccc;
    border-radius: 10px;
    margin-right: 4px;
  }

  input[type="text"] {
    width: 400px;
  }

  input[type="submit"] {
    padding: 14px 18px;
    width: 100px;
    border: none;
    background-color: rgb(59, 80, 122);
    color: white;
    border-radius: 10px;
    cursor: pointer;
  }

  input[type="submit"]:hover {
    background-color: rgb(127, 152, 202);
  }

  .pagination {
    text-align: center ;
    width: 90%;
    margin-top: 30px;
    flex-flow: column-reverse;
  }

  .pagination li {
    display: inline-block;
    margin: 0 2px;
  }

  .pagination a {
    padding: 8px 12px;
    background-color: rgb(59, 80, 122);
    color: white;
    border-radius: 8px;
    text-decoration: none;
  }

  .pagination a:hover {
    background-color: rgb(127, 152, 202);
    color: white;
  }
  
  .pagination a.active {
  background-color: rgb(127, 152, 202);
  color: white;
  font-weight: bold;
}

  .btn {
    padding: 6px 12px;
    border-radius: 6px;
    text-decoration: none;
    font-weight: bold;
    font-size: 14px;
    color: white;
  }

  .btn-edit {
    background-color: #4caf50;
  }

  .btn-delete {
    background-color: #e74c3c;
  }

  .btn:hover {
    opacity: 0.85;
  }
  
    h3 {
  	width: 90%;
  	margin: 0 auto 20px;
  	margin-bottom: 10px;
  }
  
	/* 상태별 버튼 색상 */
	.status-btn {
	  border: none !important;
	  box-shadow: none !important;
	  color: white !important;
	  font-weight: bold;
	}
	
	.status-received {
	  background-color: #0d6efd !important; /* 접수: 파랑 */
	}
	
	.status-processing {
	  background-color: #dc3545 !important; /* 처리중: 빨강 */
	}
	
	.status-completed {
	  background-color: #000000 !important; /* 완료: 검정 */
	}
	
	/* hover 시 색상 고정 (색상 변화 없음) */
	.status-btn:hover {
	  opacity: 0.85;           /* 약간 어두워지는 효과만 */
	  color: white !important;
	}
  
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/admin/include/nav.jsp" %>


<div class="d-flex">
	<main class="flex-grow-1 p-4">



  <h3>접수 상황</h3>

  <form action="/report/admin/list" method="get">
    <input type="hidden" name="pageNum" value="1">
    <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
	<select name="type">
	  <option value="T" <c:if test='${pageMaker.cri.type == "T"}'>selected</c:if>>제목</option>
	  <option value="C" <c:if test='${pageMaker.cri.type == "C"}'>selected</c:if>>내용</option>
	  <option value="W" <c:if test='${pageMaker.cri.type == "W"}'>selected</c:if>>작성자</option>
	  <option value="G" <c:if test='${pageMaker.cri.type == "G"}'>selected</c:if>>유형</option>
	</select>
	<select name="statusFilter">
		<option value="">전체</option>
		<option value="접수" <c:if test='${pageMaker.cri.statusFilter == "접수"}'>selected</c:if>>접수</option>
		<option value="처리중" <c:if test='${pageMaker.cri.statusFilter == "처리중"}'>selected</c:if>>처리중</option>
		<option value="완료" <c:if test='${pageMaker.cri.statusFilter == "완료"}'>selected</c:if>>완료</option>
	</select>
    <input type="text" name="keyword" value="${pageMaker.cri.keyword}">
    <input type="submit" value="검색">
  </form>

  <table>
    <tr>
      <th width="10%">번호</th>
      <th width="20%">유형</th>
      <th width="30%">제목</th>
      <th width="15%">작성자</th>
      <th width="15%">작성일자</th>
      <th width="10%">상태</th>
    </tr>

    <c:if test="${empty list}">
      <tr>
        <td colspan="6" style="text-align: center; padding: 20px; color: #777;">게시글이 없습니다.</td>
      </tr>
    </c:if>
    <c:forEach items="${list}" var="report">
      <tr>
        <td width="10%"><a href="/report/admin/read?report_id=${report.report_id}">${report.displayNo}</a></td>
        <td width="20%"><a href="/report/admin/read?report_id=${report.report_id}">${report.category}</a></td>
        <td width="30%"><a href="/report/admin/read?report_id=${report.report_id}">${report.title}</a></td>
        <td width="15%"><a href="/report/admin/read?report_id=${report.report_id}">${report.username}</a></td>
        <td width="15%"><a href="/report/admin/read?report_id=${report.report_id}"><fmt:formatDate pattern="yyyy-MM-dd" value="${report.created_at}" /></a></td>
		<td width="10%">
		  <c:choose>
		    <c:when test="${report.status eq '완료'}">
		      <button type="button" class="btn btn-sm btn-dark" disabled>
		        완료
		      </button>
		    </c:when>
		    <c:when test="${report.status eq '처리중'}">
			<button type="button" class="btn btn-sm btn-danger status-btn"
			        data-report-id="${report.report_id}"
			        data-title="${fn:escapeXml(report.title)}"
			        data-content="${fn:escapeXml(report.content)}"
			        data-status="${report.status}"
			        data-admin-reply="${fn:escapeXml(report.admin_reply) != null ? fn:escapeXml(report.admin_reply) : ''}">
			  처리중
			</button>
		    </c:when>
		    <c:otherwise>
			<button type="button" class="btn btn-sm btn-primary status-btn"
			        data-report-id="${report.report_id}"
			        data-title="${fn:escapeXml(report.title)}"
			        data-content="${fn:escapeXml(report.content)}"
			        data-status="${report.status}"
			        data-admin-reply="${fn:escapeXml(report.admin_reply) != null ? fn:escapeXml(report.admin_reply) : ''}">
			  접수
			</button>
		    </c:otherwise>
		  </c:choose>
		</td>
      </tr>
    </c:forEach>
  </table>



  <div class="pagination">
    <ul class="pull-right">
      <c:if test="${pageMaker.prev}">
        <li><a href="/report/admin/list?pageNum=${pageMaker.startPage - 1}&amount=${pageMaker.cri.amount}&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}">◁ Pre</a></li>
      </c:if>
		<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
		  <li>
		    <a href="/report/admin/list?pageNum=${num}&amount=${pageMaker.cri.amount}&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}"
		       class="<c:if test='${num == pageMaker.cri.pageNum}'>active</c:if>">
		      ${num}
		    </a>
		  </li>
		</c:forEach>
      <c:if test="${pageMaker.next}">
        <li><a href="/report/admin/list?pageNum=${pageMaker.endPage + 1}&amount=${pageMaker.cri.amount}&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}">Next ▷</a></li>
      </c:if>
    </ul>
  </div>
</main>
</div>

<!-- 상태 + 관리자 댓글 모달 -->
<div class="modal fade" id="statusModal" tabindex="-1" aria-labelledby="statusModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <form id="statusForm">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="statusModalLabel">상태/댓글 수정</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
          </div>
          <div class="modal-body">
            <input type="hidden" id="modalReportId" name="report_id" />
            <div class="mb-3">
              <label class="form-label">제목</label>
              <input type="text" id="modalTitle" class="form-control" readonly />
            </div>
            <div class="mb-3">
              <label class="form-label">내용</label>
              <textarea id="modalContent" class="form-control" rows="3" readonly></textarea>
            </div>
            <div class="mb-3">
              <label class="form-label">상태</label>
              <select id="modalStatus" name="status" class="form-select">
                <option value="접수">접수</option>
                <option value="처리중">처리중</option>
                <option value="완료">완료</option>
              </select>
            </div>
            <div class="mb-3">
              <label class="form-label">관리자 댓글</label>
              <textarea id="modalReply" name="admin_reply" class="form-control" rows="3"></textarea>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
            <button type="submit" class="btn btn-primary">저장</button>
          </div>
        </div>
      </form>
    </div>
  </div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
  $(function () {
    const statusModal = new bootstrap.Modal(document.getElementById('statusModal'));

    $('.status-btn').on('click', function () {
      const btn = $(this);

      $('#modalReportId').val(btn.data('report-id'));
      $('#modalTitle').val(btn.data('title'));
      $('#modalContent').val(btn.data('content'));
      $('#modalStatus').val(btn.data('status'));
      $('#modalReply').val(btn.data('admin-reply') || '');

      statusModal.show();
    });

    $('#statusForm').on('submit', function (e) {
      e.preventDefault();

      const reportId = $('#modalReportId').val();
      const newStatus = $('#modalStatus').val();
      const adminReply = $('#modalReply').val();

      $.ajax({
        url: '/report/admin/statusUpdate',
        method: 'POST',
        contentType: 'application/json',
        data: JSON.stringify({
          report_id: reportId,
          status: newStatus,
          admin_reply: adminReply
        }),
        success: function () {
          alert('상태 및 댓글이 저장되었습니다.');
          statusModal.hide();
          location.reload();
        },
        error: function (xhr) {
          alert('저장에 실패했습니다.');
          console.error(xhr.responseText);
        }
      });
    });
  });
</script>





<%@ include file="/WEB-INF/views/admin/include/footer.jsp" %>

</body>
</html>
