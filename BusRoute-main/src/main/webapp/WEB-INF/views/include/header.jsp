<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<header>
  <nav style="display: flex; align-items: center; justify-content: space-between; padding: 12px 40px; max-width: 1400px; margin: 0 auto;">
    <div style="flex-shrink: 0; display: flex; align-items: center;">
  	<a href="${pageContext.request.contextPath}/" style="display: flex; align-items: center;">
    	<img src="/resources/image/bus4.png" alt="로고" height="50" style="display: block;" />
  	</a>
	</div>

    <div style="display: flex; align-items: center; gap: 24px;">
      <a href="${pageContext.request.contextPath}/route/bus/view" class="nav-link-custom">버스 노선</a>
      <a href="${pageContext.request.contextPath}/route/station/view" class="nav-link-custom">버스 정류장</a>
      <a href="${pageContext.request.contextPath}/report/user/list" class="nav-link-custom">불편 접수</a>
      <a href="${pageContext.request.contextPath}/board/list" class="nav-link-custom">공지사항</a>
      
      <c:if test="${empty sessionScope.userid}">
        <a href="${pageContext.request.contextPath}/login" class="btn-header">로그인</a>
      </c:if>
      <c:if test="${not empty sessionScope.userid}">
        <a href="${pageContext.request.contextPath}/mypage" class="btn-header">마이 페이지</a>
      </c:if>
      
    	<%-- <c:if test="${empty sessionScope.userid}">
	    <a href="${pageContext.request.contextPath}/login" class="btn1" id="login">로그인</a>
	    </c:if>
	    <c:if test="${not empty sessionScope.userid}">
	    <a href="${pageContext.request.contextPath}/mypage" class="btn1" id="mypage">마이 페이지</a>
	    </c:if> --%>
	    </div>	
  </nav>
</header>
<style>
  .nav-link-custom {
    text-decoration: none;
    color: #002744;
    font-weight: 600;
    font-size: 17px;
    transition: color 0.2s ease;
  }

  .nav-link-custom:hover {
    color: #4e54c8;
  }

  .btn-header {
    padding: 6px 16px;
    font-size: 15px;
    font-weight: 600;
    border: 2px solid #4e54c8;
    border-radius: 8px;
    background-color: white;
    color: #4e54c8;
    text-decoration: none;
    transition: all 0.2s ease;
  }

  .btn-header:hover {
    background-color: #4e54c8;
    color: white;
  }
</style>