<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
<title>게시판 목록</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/resources/css/admin.css" rel="stylesheet">
<style>
  table {
    width: 100%;
    margin: 0 auto;
    border-collapse: collapse;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    border-radius: 10px;
    overflow: hidden;
  } 
  
  th, td {
    padding: 14px 18px ;
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
    color: #333;
    font-weight: bold;
    cursor: pointer;
  }

  .write-btn {
    padding: 10px 18px;
    background-color: rgb(59, 80, 122);
    color: white;
    border-radius: 10px;
    text-decoration: none;
    font-weight: bold;
    transition: background-color 0.3s;
    display: inline-block;
  }

  .write-btn:hover {
    background-color: rgb(127, 152, 202);
  }

  form {
    text-align: left;
    width: 90%;
    margin: 0 auto 20px;
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
    display: flex;
    justify-content: center;
    list-style: none;
    padding: 0;
    margin: 0;
  }

  .pagination li {
    margin: 0 2px;
  }

  .pagination a {
    padding: 8px 12px;
    background-color: rgb(59, 80, 122);
    color: white;
    border-radius: 8px;
    text-decoration: none;
    display: inline-block;
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

  .detail-row td {
    padding: 0;
  }

  .detail-content {
    height: 0;
    overflow: hidden;
    display: none;
    padding: 0;
    opacity: 0; /* 시각적으로 감춤 */
    transition: height 0.4s ease, padding 0.2s ease, opacity 0.2s ease;
  }

  .detail-content.open {
    display: block;
    opacity: 1;
    padding: 30px 200px;
  }

  .detail-wrapper {
    padding-bottom: 10px;
  }

  .detail-wrapper pre {
    text-align:left;
    white-space: pre-wrap;
    margin: 0;
    font-weight: normal;
    font-size:15px;
    color: #444;
    line-height: 1.6;
  }

  .detail-buttons {
    display: flex;
    justify-content: flex-end;
    margin-top: 10px;
    gap: 8px;
  }

  .btn {
    padding: 6px 12px !important;
    border-radius: 6px !important;
    text-decoration: none !important;
    font-weight: bold !important;
    font-size: 14px !important;
    color: white !important;
    cursor: pointer;
  }

  .btn-edit {
    background-color: #4caf50 !important;
  }

  .btn-delete {
    background-color: #e74c3c !important; 
  }

  .btn:hover {
    opacity: 0.85 !important;
  }

  h3 {
    width: 90%;
    margin: 0 auto 20px;
    margin-bottom: 10px;
  }

  /* 페이징, 버튼 한 줄 배치 영역 */
  .board-controls {
    width: 100%;
    margin: 20px auto 40px;
    display: flex;
    align-items: center;
    justify-content: space-between;
  }

  .pagination-wrapper {
    flex-grow: 1;
  }

  .btn-wrapper {
    display: flex;
    gap: 10px;
  }

  /* 선택 삭제 버튼 커스텀 */
  button.btn-delete {
    background-color: #e74c3c;
    border: none;
  }
  button.btn-delete:hover {
    background-color: #c0392b;
  }
  
/* 상단 고정 게시글 배경색, 글자 색상 차별화 */
tr.board-row.pinned {
  background-color: #fff8dc !important;  /* 연한 크림색 배경 */
  font-weight: bold !important;
}

/* 고정 아이콘 모양 */
.pin-icon {
  color: #ff5722;  /* 주황색 */
  margin-right: 6px;
  font-size: 16px;
  vertical-align: middle;
}

/* 상단 고정 버튼 스타일 개선 */
button.btn-pin {
  background-color: #007bff;  /* Bootstrap 기본 파랑 */
  border: none;
  padding: 10px 18px;
  border-radius: 10px;
  color: white;
  font-weight: bold;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

button.btn-pin:hover {
  background-color: #0056b3;
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
	
    <h3>공지 사항</h3>

    <form action="/board/admin/list" method="get">
      <input type="hidden" name="pageNum" value="1">
      <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
      <select name="type">
        <option value="T" <c:if test="${pageMaker.cri.type == 'T'}">selected</c:if>>제목</option>
        <option value="C" <c:if test="${pageMaker.cri.type == 'C'}">selected</c:if>>내용</option>
      </select>
      <input type="text" name="keyword" value="${pageMaker.cri.keyword}">
      <input type="submit" value="검색">
    </form>

    <form id="deleteForm" action="/board/admin/deleteSelected" method="post">
      <table>
        <thead>
          <tr>
            <th width="10%"><input type="checkbox" id="selectAll"/></th>
            <th width="10%">번호</th>
            <th width="50%">제목</th>
            <th width="15%">작성자</th>
            <th width="15%">작성일자</th>
          </tr>
        </thead>
        <tbody>
          <c:if test="${empty list}">
            <tr>
              <td colspan="5" style="text-align: center; padding: 20px; color: #777;">게시글이 없습니다.</td>
            </tr>
          </c:if>

          <c:forEach items="${list}" var="board">
		  <tr class="board-row ${board.pinned ? 'pinned' : ''}">
		    <td><input type="checkbox" name="boardIds" value="${board.board_id}" /></td>
		    <td>${board.board_id}</td>
		    <td>
		      <c:if test="${board.pinned}">
		        <span class="pin-icon" title="상단 고정 게시글">📌</span>
		      </c:if>
		      ${board.title}
		    </td>
		    <td>${board.writer_id}</td>
		    <td><fmt:formatDate pattern="yyyy-MM-dd" value="${board.created_at}" /></td>
		  </tr>
            <tr class="detail-row">
              <td colspan="5">
                <div class="detail-content">
                  <div class="detail-wrapper">
                    <pre>${board.content}</pre>
                    <div class="detail-buttons">
                      <a class="btn btn-edit" href="/board/admin/modify?board_id=${board.board_id}">수정</a>
                      <a class="btn btn-delete" href="/board/admin/remove?board_id=${board.board_id}" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
                    </div>
                  </div>
                </div>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>

      <!-- 페이징 및 버튼 한 줄 배치 -->
      <div class="board-controls">
        <div class="pagination-wrapper">
          <ul class="pagination">
            <c:if test="${pageMaker.prev}">
              <li><a href="/board/admin/list?pageNum=${pageMaker.startPage - 1}&amount=${pageMaker.cri.amount}&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}">◁ Pre</a></li>
            </c:if>
            <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
              <li><a href="/board/admin/list?pageNum=${num}&amount=${pageMaker.cri.amount}&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}" class="${pageMaker.cri.pageNum == num ? 'active' : ''}">${num}</a></li>
            </c:forEach>
            <c:if test="${pageMaker.next}">
              <li><a href="/board/admin/list?pageNum=${pageMaker.endPage + 1}&amount=${pageMaker.cri.amount}&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}">Next ▷</a></li>
            </c:if>
          </ul>
        </div>

        <div class="btn-wrapper">
          <button type="submit" class="btn btn-delete" onclick="return confirm('선택된 게시글을 삭제하시겠습니까?');">
            선택 삭제
          </button>
            <button type="button" class="btn btn-pin" id="pinSelectedBtn">
		    	상단 고정
		  	</button>
		  	<button type="button" class="btn btn-secondary" id="unpinSelectedBtn">
			  상단 해제
			</button>
          <a class="write-btn" href="/board/admin/write">글쓰기</a>
        </div>
      </div>
    </form>
  </main>
</div>

<%@ include file="/WEB-INF/views/admin/include/footer.jsp" %>
<script>
document.addEventListener('DOMContentLoaded', function () {
  const paddingTopBottom = 60;
  const boardRows = document.querySelectorAll('.board-row');
  let currentlyOpen = null;
  let isTransitioning = false;

  // ✅ 아코디언 토글 기능
  boardRows.forEach(row => {
    row.addEventListener('click', e => {
      // 체크박스 클릭은 아코디언 제외
      if (e.target.tagName === 'INPUT' && e.target.type === 'checkbox') return;
      if (isTransitioning) return;

      const detailContent = row.nextElementSibling.querySelector('.detail-content');
      const wrapper = detailContent.querySelector('.detail-wrapper');
      const isOpen = detailContent.classList.contains('open');

      const closeContent = (element) => {
        element.style.transition = 'height 0.4s ease, padding 0.2s ease, opacity 0.2s ease';
        element.style.height = '0px';
        element.style.paddingTop = '0px';
        element.style.paddingBottom = '0px';
        element.style.opacity = '0';
        element.addEventListener('transitionend', function onClose() {
          element.style.display = 'none';
          element.classList.remove('open');
          isTransitioning = false;
        }, { once: true });
      };

      const openContent = () => {
        detailContent.classList.add('open');
        detailContent.style.display = 'block';
        detailContent.style.transition = 'height 0.4s ease, padding 0.2s ease, opacity 0.2s ease';
        detailContent.style.height = (wrapper.scrollHeight + paddingTopBottom) + 'px';
        detailContent.style.paddingTop = '30px';
        detailContent.style.paddingBottom = '30px';
        detailContent.style.opacity = '1';
        currentlyOpen = detailContent;
        detailContent.addEventListener('transitionend', () => {
          isTransitioning = false;
        }, { once: true });
      };

      isTransitioning = true;

      // 1. 열려 있는 것 닫기
      if (isOpen) {
        closeContent(detailContent);
        currentlyOpen = null;
        return;
      }

      if (currentlyOpen && currentlyOpen !== detailContent) {
        closeContent(currentlyOpen);
        // 새로 열기 약간 딜레이 주기
        setTimeout(() => openContent(), 100);
        return;
      }

      // 처음 열기
      openContent();
    });
  });

  // ✅ 전체 체크박스 기능
  const selectAllCheckbox = document.getElementById('selectAll');
  if (selectAllCheckbox) {
    selectAllCheckbox.addEventListener('change', function () {
      const checkboxes = document.querySelectorAll('input[name="boardIds"]');
      checkboxes.forEach(cb => cb.checked = this.checked);
    });
  }

  // ✅ 상단 고정 버튼 기능
  const pinSelectedBtn = document.getElementById('pinSelectedBtn');
  if (pinSelectedBtn) {
    pinSelectedBtn.addEventListener('click', () => {
      const checkedBoxes = document.querySelectorAll('input[name="boardIds"]:checked');
      if (checkedBoxes.length === 0) {
        alert('상단 고정할 게시글을 선택하세요.');
        return;
      }

      if (!confirm('선택된 게시글을 상단 고정 하시겠습니까?\n기존 고정 게시글은 모두 해제됩니다.')) return;

      const form = document.createElement('form');
      form.method = 'post';
      form.action = '/board/admin/pinSelected';

      checkedBoxes.forEach(cb => {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'boardIds';
        input.value = cb.value;
        form.appendChild(input);
      });

      document.body.appendChild(form);
      form.submit();
    });
  }
  
  const unpinSelectedBtn = document.getElementById('unpinSelectedBtn');
  if (unpinSelectedBtn) {
    unpinSelectedBtn.addEventListener('click', () => {
      const checkedBoxes = document.querySelectorAll('input[name="boardIds"]:checked');
      if (checkedBoxes.length === 0) {
        alert('상단 고정 해제할 게시글을 선택하세요.');
        return;
      }

      if (!confirm('선택된 게시글의 상단 고정을 해제하시겠습니까?')) return;

      const form = document.createElement('form');
      form.method = 'post';
      form.action = '/board/admin/unpinSelected';

      checkedBoxes.forEach(cb => {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'boardIds';
        input.value = cb.value;
        form.appendChild(input);
      });

      document.body.appendChild(form);
      form.submit();
    });
  }
  
  
});
</script>

</body>
</html>
