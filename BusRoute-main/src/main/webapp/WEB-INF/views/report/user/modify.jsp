<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="/resources/css/header.css" rel="stylesheet">
<link href="/resources/css/main.css" rel="stylesheet">
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
    background-color: #ccc;
    color: #333;
  }

  .btn-cancel:hover {
    background-color: #999;
    color: white;
  }

  .btn-submit {
    background-color: #3b577a;
    color: white;
  }

  .btn-submit:hover {
    background-color: #6d87b8;
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
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/include/header.jsp" %>
  <div id="wrapper">
	<h3>수정 하기</h3>
	<div class="write-container">
		<div class="write-header">
	        <div class="writer-info">
	          <div class="write-value">${report.username}</div>
	        </div>
		</div>
		<form id="writeForm" class="write-form" action="/report/user/modify" method="post" enctype="multipart/form-data">

			<input type="hidden" name="report_id" value="${report.report_id}" />
		  	<input type="hidden" name="user_id" value="${report.user_id}" />
		  	<input type="hidden" name="status" value="${report.status}" />
		  	
			<label for="category">유형</label>
			<select id="category" name="category" required style="width: 98%; padding: 10px; border-radius: 10px; border: 1px solid #ccc; font-size: 16px;">
			  <option value="">-- 유형을 선택하세요 --</option>
			  <option value="노선 문제" <c:if test="${report.category == '노선 문제'}">selected</c:if>>노선 문제</option>
			  <option value="운행 시간 문제" <c:if test="${report.category == '운행 시간 문제'}">selected</c:if>>운행 시간 문제</option>
			  <option value="정류장 문제" <c:if test="${report.category == '정류장 문제'}">selected</c:if>>정류장 문제</option>
			  <option value="정보 문제" <c:if test="${report.category == '정보 문제'}">selected</c:if>>정보 문제</option>
			  <option value="서비스 문제" <c:if test="${report.category == '서비스 문제'}">selected</c:if>>서비스 문제</option>
			  <option value="요금 문제" <c:if test="${report.category == '요금 문제'}">selected</c:if>>요금 문제</option>
			  <option value="기타" <c:if test="${report.category == '기타'}">selected</c:if>>기타</option>
			</select>
		
		    <label for="title">제목</label>
		    <input type="text" id="title" value="${report.title}" name="title" required>
		
			<label for="content">내용</label>
			<textarea id="content" name="content" required>${report.content}</textarea>
			
			
			<c:if test="${not empty report.attachmentPath}">
			  <label>첨부된 이미지</label>
			  <div id="existing-images" style="display: flex; gap: 20px; flex-wrap: wrap;">
			    <c:forEach var="filePath" items="${fn:split(report.attachmentPath, ',')}">
			      <div class="img-box" style="position: relative; display: inline-block;">
			        <img src="/display?fileName=${report.attachmentPath}" style="width: 150px; height: auto; border: 1px solid #ccc; border-radius: 8px;">
			        <button type="button" class="delete-btn" data-filename="${fn:substringAfter(filePath, '/upload/')}"
			                style="position: absolute; top: -10px; right: -10px; background: red; color: white; border: none; border-radius: 50%; width: 20px; height: 20px; cursor: pointer;">×</button>
			      </div>
			    </c:forEach>
			  </div>
			</c:if>
			
			<label>이미지 추가 업로드</label>
			<input type="file" name="uploadFiles" id="uploadFiles" multiple accept="image/*">
			<div id="preview" style="display: flex; gap: 20px; flex-wrap: wrap; margin-top: 10px;"></div>
			<div id="delete-files-container"></div>
		</form>
		  
		<div class="write-actions">
		  	<button type="submit" form="writeForm" class="btn btn-submit">작성</button>
		  	<button type="button" onclick="location.href='/report/user/list'" class="btn btn-cancel">취소</button>
		</div>
	</div>
	</div>
	
	<script>
	document.addEventListener("DOMContentLoaded", function () {
	  // 삭제 버튼 클릭 시
	  document.querySelectorAll(".delete-btn").forEach(btn => {
	    btn.addEventListener("click", function () {
	      const filename = this.dataset.filename;
	      // 삭제 대상 숨은 input 추가
	      const hiddenInput = document.createElement("input");
	      hiddenInput.type = "hidden";
	      hiddenInput.name = "deleteFiles";
	      hiddenInput.value = filename;
	      document.getElementById("delete-files-container").appendChild(hiddenInput);
	
	      // 이미지 박스 제거
	      this.parentElement.remove();
	    });
	  });
	
	  // 파일 선택 시 미리보기
	  document.getElementById("uploadFiles").addEventListener("change", function (event) {
	    const preview = document.getElementById("preview");
	    preview.innerHTML = ""; // 기존 미리보기 초기화
	
	    Array.from(event.target.files).forEach(file => {
	      if (file.type.startsWith("image/")) {
	        const reader = new FileReader();
	        reader.onload = function (e) {
	          const img = document.createElement("img");
	          img.src = e.target.result;
	          img.style.width = "150px";
	          img.style.border = "1px solid #ccc";
	          img.style.borderRadius = "8px";
	          img.style.marginRight = "10px";
	          preview.appendChild(img);
	        };
	        reader.readAsDataURL(file);
	      }
	    });
	  });
	});
	</script>
</body>
</html>