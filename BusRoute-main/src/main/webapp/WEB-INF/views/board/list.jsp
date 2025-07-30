<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판 목록</title>
<link href="/resources/css/header.css" rel="stylesheet">
<link href="/resources/css/main.css" rel="stylesheet">
<style>
  

  table { 
    width: 90%;
    margin: 0 auto;
    border-collapse: collapse;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    border-radius: 10px;
    overflow: hidden;
  }

  th, td {
    padding: 14px 18px;
    text-align: center;
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
    text-align: center;
    margin-top: 30px;
    margin-bottom : 80px;
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

  .detail-row td {
    padding: 0;
  }
  
  .detail-content {
	height: 0;
	overflow: hidden;
	display: none;
	padding: 0;
	opacity: 0; /* 추가: 시각적으로 감춤 */
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
    line-height : 1.6;
  }

  .detail-buttons {
    display: flex;
    justify-content: flex-end;
    margin-top: 10px;
    gap: 8px;
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
</style>
</head>
<body>
  <%@ include file="/WEB-INF/views/include/header.jsp" %>
  <div id="wrapper">
  <h3>공지 사항</h3>

  <form action="/board/list" method="get">
    <input type="hidden" name="pageNum" value="1">
    <input type="hidden" name="amount" value="${pageMaker.cri.amount}">
    <select name="type">
      <option value="T">제목</option>
      <option value="C">내용</option>
    </select>
    <input type="text" name="keyword" value="${pageMaker.cri.keyword}">
    <input type="submit" value="검색">
  </form>

  <table>
	  	<thead>
		    <tr>
		      <th width="10%">번호</th>
		      <th width="60%">제목</th>
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
            </div>
          </div>
        </td>
      </tr>
    </c:forEach>
  </table>


  <div class="pagination">
    <ul class="pull-right">
      <c:if test="${pageMaker.prev}">
        <li><a href="/board/list?pageNum=${pageMaker.startPage - 1}&amount=${pageMaker.cri.amount}&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}">◁ Pre</a></li>
      </c:if>
      <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
        <li><a href="/board/list?pageNum=${num}&amount=${pageMaker.cri.amount}&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}" class="${pageMaker.cri.pageNum == num ? 'active' : ''}">${num}</a></li>
      </c:forEach>
      <c:if test="${pageMaker.next}">
        <li><a href="/board/list?pageNum=${pageMaker.endPage + 1}&amount=${pageMaker.cri.amount}&type=${pageMaker.cri.type}&keyword=${pageMaker.cri.keyword}">Next ▷</a></li>
      </c:if>
    </ul>
  </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function () {
  const boardRows = document.querySelectorAll('.board-row');
  const paddingTopBottom = 60;

  let currentlyOpen = null;
  let isTransitioning = false; // transition 중인지 여부

  boardRows.forEach(row => {
    row.addEventListener('click', () => {
      if (isTransitioning) return; // 애니메이션 중이면 무시

      const detailContent = row.nextElementSibling.querySelector('.detail-content');
      const wrapper = detailContent.querySelector('.detail-wrapper');
      const isOpen = detailContent.classList.contains('open');

      if (isOpen) {
        isTransitioning = true;

        detailContent.style.transition = 'height 0.4s ease, padding 0.2s ease, opacity 0.2s ease';
        detailContent.style.height = '0px';
        detailContent.style.paddingTop = '0px';
        detailContent.style.paddingBottom = '0px';
        detailContent.style.opacity = '0';

        detailContent.addEventListener('transitionend', function onClose() {
          detailContent.style.display = 'none';
          detailContent.classList.remove('open');
          currentlyOpen = null;
          isTransitioning = false;
        }, { once: true });

        return;
      }

      if (currentlyOpen && currentlyOpen !== detailContent) {
        isTransitioning = true;

        currentlyOpen.style.transition = 'height 0.4s ease, padding 0.2s ease, opacity 0.2s ease';
        currentlyOpen.style.height = '0px';
        currentlyOpen.style.paddingTop = '0px';
        currentlyOpen.style.paddingBottom = '0px';
        currentlyOpen.style.opacity = '0';

        currentlyOpen.addEventListener('transitionend', function onClose() {
          currentlyOpen.style.display = 'none';
          currentlyOpen.classList.remove('open');

          // 새 항목 열기
          detailContent.classList.add('open');
          detailContent.style.display = 'block';
          detailContent.style.opacity = '1';
          detailContent.style.transition = 'height 0.4s ease, padding 0.2s ease, opacity 0.2s ease';
          detailContent.style.height = (wrapper.scrollHeight + paddingTopBottom) + 'px';
          detailContent.style.paddingTop = '30px';
          detailContent.style.paddingBottom = '30px';

          currentlyOpen = detailContent;

          detailContent.addEventListener('transitionend', () => {
            isTransitioning = false;
          }, { once: true });

        }, { once: true });

        return;
      }

      // 처음 열기
      isTransitioning = true;

      detailContent.classList.add('open');
      detailContent.style.display = 'block';
      detailContent.style.opacity = '1';
      detailContent.style.transition = 'height 0.4s ease, padding 0.2s ease, opacity 0.2s ease';
      detailContent.style.height = (wrapper.scrollHeight + paddingTopBottom) + 'px';
      detailContent.style.paddingTop = '30px';
      detailContent.style.paddingBottom = '30px';

      currentlyOpen = detailContent;

      detailContent.addEventListener('transitionend', () => {
        isTransitioning = false;
      }, { once: true });
    });
  });
});
</script>

</body>
</html>
