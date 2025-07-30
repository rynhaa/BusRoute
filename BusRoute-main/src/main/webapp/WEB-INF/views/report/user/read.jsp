<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>상세 보기</title>
  <link href="/resources/css/header.css" rel="stylesheet">
  <link href="/resources/css/main.css" rel="stylesheet">
  <style>
    .write-container {
      width: 90%;
      margin: 0 auto 20px auto;
      background-color: #fff;
      padding: 30px 40px 60px;
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
    .write-image {
      margin-top: 20px;
    }
    .write-image img {
      max-width: 300px;
      height: auto;
      border-radius: 10px;
      box-shadow: 0 0 8px rgba(0,0,0,0.15);
      margin-bottom: 10px;
      margin-right: 10px;
    }
    .write-actions {
      display: flex;
      margin-top: 30px;
      justify-content: flex-end;
      gap: 10px;
    }
    .btn {
      padding: 10px 22px;
      border-radius: 8px;
      border: none;
      font-weight: bold;
      cursor: pointer;
      font-size: 16px;
      transition: 0.3s;
      text-decoration: none;
      display: inline-block;
    }
    .btn-cancel {
      background-color: #ccc;
      color: #333;
    }
    .btn-cancel:hover {
      background-color: #999;
      color: white;
    }
    .btn-edit {
      background-color: #3b577a;
      color: white;
    }
    .btn-edit:hover {
      background-color: #6d87b8;
    }
    .btn-delete {
      background-color: #d9534f;
      color: white;
    }
    .btn-delete:hover {
      background-color: #c9302c;
    }

    .admin-reply-section {
      margin-top: 40px;
      width: 90%;
      margin-left: auto;
      margin-right: auto;
    }
    .admin-reply-box {
      border-top: 1px solid #ddd;
      padding-top: 20px;
      margin-bottom: 30px;
    }
    .admin-reply-content {
      padding: 14px 18px;
      border: 1px solid #ccc;
      border-radius: 10px;
      background-color: #f9f9f9;
      font-size: 16px;
      color: #222;
      white-space: pre-wrap;
      line-height: 1.6;
    }
    .admin-reply-date {
      margin-top: 10px;
      font-size: 0.85em;
      color: #777;
    }
    .admin-reply-empty {
      color: #888;
      margin-top: 10px;
    }
  </style>
</head>
<body>
<%@ include file="/WEB-INF/views/include/header.jsp" %>

<div id="wrapper">
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
            <img src="/display?fileName=${path}" alt="첨부 이미지" style="max-width:300px; margin-bottom:10px;" />
          </c:forEach>
        </div>
      </c:if>
    </div>

    <div class="write-actions">
      <a class="btn btn-edit" href="/report/user/modify?report_id=${report.report_id}">수정</a>
      <a class="btn btn-delete" href="/report/user/remove?report_id=${report.report_id}" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
      <a class="btn btn-cancel" href="/report/user/list">목록</a>
    </div>

    <!-- 관리자 답변 -->
    <div class="admin-reply-section">
      <h4>관리자 답변</h4>

      <c:choose>
        <c:when test="${not empty report.admin_reply}">
          <div class="admin-reply-box">
            <div class="admin-reply-content">${report.admin_reply}</div>
            <div class="admin-reply-date">
              작성일: <fmt:formatDate value="${report.replied_at}" pattern="yyyy년 MM월 dd일 a hh:mm" />
            </div>
          </div>
        </c:when>
        <c:otherwise>
          <p class="admin-reply-empty">아직 관리자 답변이 등록되지 않았습니다.</p>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</div>
</body>
</html>
