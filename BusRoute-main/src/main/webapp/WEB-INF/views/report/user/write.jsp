<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<c:if test="${not empty error or not empty sessionScope['error']}">
  <script>
    alert("${error != null ? error : sessionScope['error']}");
  </script>
</c:if>
<meta charset="UTF-8">
<title>공지사항 작성</title>
<link href="/resources/css/header.css" rel="stylesheet">
<link href="/resources/css/main.css" rel="stylesheet">
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
  	text-decoration: none;
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
		<c:if test="${not empty error}">
			<div style="margin: 10px auto; width: 90%; color: red; font-weight: bold; text-align: center;">
			${error}
			</div>
		</c:if>
		<h3>글 쓰기</h3>
		<div class="write-container">
			<div class="write-header">
	        <div class="writer-info">
	          <div class="write-value">${report.username}</div>
	        </div>
			</div>
		
		<form id="writeForm" class="write-form" action="/report/user/write" method="post" enctype="multipart/form-data">
		<input type="hidden" name="user_id" value="${user_id}">
		
		<label for="category">유형</label>
		<select id="category" name="category" required style="width: 100%; padding: 14px 18px; border-radius: 10px; border: 1px solid #ccc; font-size: 16px;">
		  <option value="">-- 유형을 선택하세요 --</option>
		  <option value="노선 문제">노선 문제</option>
		  <option value="운행 시간 문제">운행 시간 문제</option>
		  <option value="정류장 문제">정류장 문제</option>
		  <option value="정보 문제">정보 문제</option>
		  <option value="서비스 문제">서비스 문제</option>
		  <option value="요금 문제">요금 문제</option>
		  <option value="기타">기타</option>
		</select>
		
		<label for="title">제목</label>
		<input type="text" id="title" name="title" placeholder="제목을 입력하세요" required>
		
		<label for="content">내용</label>
		<textarea id="content" name="content" placeholder="내용을 입력하세요" required>
① 불편을 겪은 날짜



② 불편을 겪은 정류소명



③ 노선번호



④ 불편을 겪으신 상황 및 내용



		</textarea>
		
		<label>이미지 추가 업로드</label>
		<input type="file" id="uploadFiles" name="uploadFiles" multiple accept="image/*">
		
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
		  const uploadInput = document.getElementById("uploadFiles");
		  const preview = document.getElementById("preview");
		  const deleteContainer = document.getElementById("delete-files-container");
		
		  // 현재 선택된 파일 리스트 저장 (삭제 관리용)
		  let selectedFiles = [];
		
		  uploadInput.addEventListener("change", function (e) {
		    // 새로 선택한 파일들을 배열로 가져옴
		    const files = Array.from(e.target.files);
		
		    // 새 파일들을 selectedFiles에 추가
		    selectedFiles = selectedFiles.concat(files);
		
		    // 미리보기 렌더링
		    renderPreviews();
		
		    // input의 file 리스트를 selectedFiles로 갱신
		    updateFileInput();
		  });
		
		  // 미리보기와 삭제 버튼 렌더링 함수
		  function renderPreviews() {
		    preview.innerHTML = "";
		    selectedFiles.forEach((file, index) => {
		      if (!file.type.startsWith("image/")) return;
		
		      const reader = new FileReader();
		      reader.onload = function (e) {
		        const imgBox = document.createElement("div");
		        imgBox.className = "img-box";
		        imgBox.style.position = "relative";
		        imgBox.style.display = "inline-block";
		
		        const img = document.createElement("img");
		        img.src = e.target.result;
		        img.style.width = "150px";
		        img.style.border = "1px solid #ccc";
		        img.style.borderRadius = "8px";
		        img.style.marginRight = "10px";
		        img.style.marginBottom = "10px";
		
		        const delBtn = document.createElement("button");
		        delBtn.type = "button";
		        delBtn.textContent = "×";
		        delBtn.style.position = "absolute";
		        delBtn.style.top = "-10px";
		        delBtn.style.right = "-10px";
		        delBtn.style.background = "red";
		        delBtn.style.color = "white";
		        delBtn.style.border = "none";
		        delBtn.style.borderRadius = "50%";
		        delBtn.style.width = "20px";
		        delBtn.style.height = "20px";
		        delBtn.style.cursor = "pointer";
		
		        delBtn.addEventListener("click", function () {
		          // 삭제할 파일 인덱스 제거
		          selectedFiles.splice(index, 1);
		          renderPreviews();
		          updateFileInput();
		        });
		
		        imgBox.appendChild(img);
		        imgBox.appendChild(delBtn);
		        preview.appendChild(imgBox);
		      };
		      reader.readAsDataURL(file); 
		    });
		  }
		
		  // input[type=file]의 files 갱신 (DataTransfer API 활용)
		  function updateFileInput() {
		    const dataTransfer = new DataTransfer();
		    selectedFiles.forEach(file => dataTransfer.items.add(file));
		    uploadInput.files = dataTransfer.files;
		  }
		});
		</script>

</body>
</html>
