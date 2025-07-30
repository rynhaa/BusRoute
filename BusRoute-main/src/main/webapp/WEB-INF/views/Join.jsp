<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Join</title>
<link href="/resources/css/header.css" rel="stylesheet">
<link href="/resources/css/main.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<style>
  
  #join-form {
    width: 650px;
    margin: 0 auto;
    background-color: #ffffff;
    border-radius: 10px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    padding: 20px 30px;
  }

  table {
    width: 100%;
    border-collapse: collapse;
  }

  td {
    padding: 12px 10px;
    font-size: 18px;
    vertical-align: middle;
  }

  input[type="text"], input[type="password"], input[type="email"] {
    padding: 10px 15px;
    width: 70%;
    border: 1px solid #ccc;
    border-radius: 10px;
    box-sizing: border-box;
  }

  input[type="submit"]{
    padding: 12px 18px;
    width: 100px;
    border: none;
    border-radius: 10px;
    cursor: pointer;
    color: white;
    background-color: rgb(59, 80, 122);
  }


  input[type="submit"]:hover {
    background-color: rgb(127, 152, 202);
  }
  
  #idduplicateCheck, #emailduplicateCheck{
  	padding: 12px 18px;
    width: 100px;
    border: none;
    border-radius: 10px;
    cursor: pointer;
    color: white;
    background-color: rgb(59, 80, 122);
    margin-left: 30px;
  }
  
  #idduplicateCheck:hover, #emailduplicateCheck:hover{
  	background-color: rgb(127, 152, 202);
  }


  #join{
    float:right;
  }

</style>
</head>
<body>
<c:if test="${not empty message}">
    <script>
        alert('${message}');
    </script>
</c:if>


<%@ include file="/WEB-INF/views/include/header.jsp" %>
<div id="wrapper">
	<h3>회원가입</h3><br>
	<div id="join-form">
		<form action="/join" method="post" onsubmit="return Login()">
	        <table>
	            <tr>
	                <td>아이디</td>
	                <td><input type="text" name="userid" id="userid" placeholder="아이디를 입력해주세요.">
	                <input type="button" value="중복검사" id="idduplicateCheck"><br>
	                <label id="idmsg" class="msg" style="font-size:13px"></label></td>
	            </tr>
	            <tr>
	                <td>비밀번호</td>
	                <td><input type="password" name="password" id="password" placeholder="비밀번호를 입력해주세요."><br>
	                <label id="pwmsg" class="msg" style="font-size:13px"></label></td>
	            </tr>
	            <tr>
	            	<td>비밀번호 확인</td>
	            	<td><input type="password" name="passwordcheck" id="passwordcheck" placeholder="비밀번호를 다시 입력해주세요."><br>
	                <label id="pwcheckmsg" class="msg" style="font-size:13px"></label></td>
	            </tr>
	            <tr>
	                <td>성명</td>
	                <td><input type="text" name="username" id="username" placeholder="성명을 입력해주세요."><br>
	                <label id="namemsg" class="msg" style="font-size:13px"></label></td>
	            </tr>
	            <tr>
	                <td>전화번호</td>
	                <td><input type="text" name="phone" id="phone"  maxlength="13" placeholder="(-)포함 전화번호를 입력해주세요."><br>
	                <label id="phonemsg" class="msg" style="font-size:13px"></label></td>
	            </tr>
	            <tr>
	                <td>이메일</td>
	                <td><input type="email" name="email" id="email" placeholder="이메일을 입력해주세요.">
	                <input type="button" value="중복검사" id="emailduplicateCheck"><br>
	                <label id="emailmsg" class="msg" style="font-size:13px"></label></td>
	            </tr>
	            <tr>
	                <td>주소</td>
	                <td><input type="text" name="address" id="address" placeholder="주소를 입력해주세요." onclick="execDaumPostcode()" readonly><br>
	                <label id="addressmsg" class="msg" style="font-size:13px"></label></td>
	            </tr>
	            <tr>
	                <td colspan="2"><input type="submit" value="가입하기" id="join"></td>
	            </tr>
	        </table>
	    </form>
	</div>
</div>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R'){
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById("address").value = addr;
            }
        }).open();
    }
</script>
<script>
	
	let isIdAvailable = false;
	let isEmailIdAvailable = false;


	function Login(){
		// 아이디
		let userid = document.getElementById("userid");
		// 비밀번호
		let password = document.getElementById("password");
		// 비밀번호 확인
		let passwordcheck = document.getElementById("passwordcheck");
		// 성명
		let username = document.getElementById("username");
		// 전화번호
		let phone = document.getElementById("phone");
		// 이메일
		let email = document.getElementById("email");
		// 주소
		let address = document.getElementById("address");
		
		// 아이디
		let idmsg = document.getElementById("idmsg");
		// 비밀번호
		let pwmsg = document.getElementById("pwmsg");
		// 비밀번호확인
		let pwcheckmsg = document.getElementById("pwcheckmsg")
		// 성명
		let namemsg = document.getElementById("namemsg");
		// 전화번호
		let phonemsg = document.getElementById("phonemsg");
		// 이메일
		let emailmsg = document.getElementById("emailmsg");
		// 주소
		let addressmsg = document.getElementById("addressmsg");
		
		
		// 아이디 정규식 (5 ~ 16자 영어 숫자)
		let idReg = /^(?=.*[a-z])(?=.*[0-9])[a-z0-9]{5,16}$/
		// 비밀번호 정규식 (5 ~ 20자 영어 숫자)
    	let pwReg = /^(?=.*[a-z])(?=.*\d).{5,20}$/
		// 휴대폰 번호 정규식 (- 포함하여 작성)
    	let phoneReg = /^(01[016789]{1})-[0-9]{3,4}-[0-9]{4}$/
		// 이메일 정규식 (@과 . 포함하여 작성)
		let emailReg = /^[A-Za-z0-9_.\-]+@[A-Za-z0-9\-]+\.[A-Za-z]{2,}$/
		
		
		// 아이디 필수
		let idre;
		// 비밀번호 필수
		let pwre;
		// 비밀번호 확인 필수
		let pwcheckre;
		// 성명 필수
		let usernamere;
		// 전화번호 필수
		let phonere;
		// 이메일 필수
		let emailre;
		// 주소 필수
		let addressre;
		
		
		// 아이디 정규식 비교
		if (userid.value === "") {
		    idmsg.innerHTML = "아이디는 필수 정보입니다.";
		    idmsg.style.color = "red";
		    idre = false;
		} else if (!userid.value.match(idReg)) {
		    idmsg.innerHTML = "아이디는 5 ~ 16자 영어 + 숫자만 사용 가능합니다.";
		    idmsg.style.color = "red";
		    idre = false;
		} else if (!isIdAvailable) {
		    idmsg.innerHTML = "아이디 중복 확인을 해주세요.";
		    idmsg.style.color = "red";
		    idre = false;
		} else {
		    idmsg.innerHTML = "사용 가능한 아이디입니다.";
		    idmsg.style.color = "blue";
		    idre = true;
		}
		
		// 비밀번호 정규식 비교
		if (password.value === "") {
	    pwmsg.innerHTML = "비밀번호는 필수 정보입니다.";
	    pwmsg.style.color = "red";
	    pwre = false;
	    
		} else if (password.value.match(pwReg)) {
		    pwmsg.innerHTML = "사용 가능한 비밀번호입니다.";
		    pwmsg.style.color = "blue";
		    pwre = true;
		} else {
		    pwmsg.innerHTML = "비밀번호는 5 ~ 20자 영어 + 숫자만 사용 가능합니다.";
		    pwmsg.style.color = "red";
		    pwre = false;
		}
		
		// 비밀번호 일치 확인
		if(passwordcheck.value === ""){
		    pwcheckmsg.innerHTML = "비밀번호를 입력하세요.";
		    pwcheckmsg.style.color = "red";
		    pwcheckre = false;
		}else if(password.value !== passwordcheck.value){
		    pwcheckmsg.innerHTML = "비밀번호가 일치하지 않습니다.";
		    pwcheckmsg.style.color = "red";
		    pwcheckre = false;
		}else{
		    pwcheckmsg.innerHTML = "일치합니다.";
		    pwcheckmsg.style.color = "blue";
		    pwcheckre = true;
		}
		
		// 성명 
		if (username.value === ""){
			namemsg.style.display = "block";
			namemsg.innerHTML = "성명은 필수 정보입니다.";
			namemsg.style.color = "red";
			usernamere = false;
		} else {
			namemsg.style.display = "none";
			usernamere = true;
		}
		
		// 전화번호
		if (phone.value === "") {
		    phonemsg.style.display = "block";
		    phonemsg.innerHTML = "전화번호는 필수 정보입니다.";
		    phonemsg.style.color = "red";
		    phonere = false;
		} else if (!phone.value.match(phoneReg)) {
		    phonemsg.style.display = "block";
		    phonemsg.innerHTML = "전화번호가 정확한지 확인해주세요.";
		    phonemsg.style.color = "red";
		    phonere = false;
		} else {
		    phonemsg.style.display = "none";
		    phonere = true;
		}
		
		// 이메일
		if (email.value === "") {
		    emailmsg.style.display = "block";
		    emailmsg.innerHTML = "이메일은 필수 정보입니다.";
		    emailmsg.style.color = "red";
		    emailre = false;
		} else if (!email.value.match(emailReg)) {
		    emailmsg.style.display = "block";
		    emailmsg.innerHTML = "이메일 형식을 확인해주세요.";
		    emailmsg.style.color = "red";
		    emailre = false;
		} else {
		    emailmsg.style.display = "none";
		    emailre = true;
		}
		
		// 주소
		if (address.value === ""){
			addressmsg.style.display = "block";
			addressmsg.innerHTML = "주소는 필수 정보입니다.";
			addressmsg.style.color = "red";
			addressre = false;
		} else{
			addressmsg.style.display = "none";
			addressre = true;
		}
		
		
		
		if (idre == true && pwre == true && usernamere == true && phonere == true && emailre == true && addressre == true && pwcheckre == true) {
		    return true;
		} else {
		    return false;
		}
		
		
	} // Login()끝
	
	
	$(document).ready(function() {
		
		$('#phone').on('input', function() {
		    let number = $(this).val().replace(/[^0-9]/g, '');
		    let formatted = '';

		    if (number.length < 4) {
		        formatted = number;
		    } else if (number.length < 7) {
		        formatted = number.substr(0, 3) + '-' + number.substr(3);
		    } else if (number.length < 11) {
		        formatted = number.substr(0, 3) + '-' + number.substr(3, 3) + '-' + number.substr(6);
		    } else {
		        formatted = number.substr(0, 3) + '-' + number.substr(3, 4) + '-' + number.substr(7, 4);
		    }

		    $(this).val(formatted);
		});
		
		// 아이디 중복 체크
		$("#userid").on("input", function() {
		    isIdAvailable = false;
		    $("#idmsg")
	        .text("아이디 중복 확인이 필요합니다.")
	        .css({
	            "color": "red"
	        });
		});
		
		$("#idduplicateCheck").on("click", function(e) {
			let id = $("#userid").val();
			console.log("중복검사 요청 id:", id)
			if(id === "") {
				$("#idmsg")
		        .text("아이디를 입력해주세요.")
		        .css({
		            "color": "red"
		        });
                return;
        	}
			$.ajax({
		        url: "/idCheck",
		        type: "GET",
		        data: { userid: id },
		        dataType: "json",
		        success: function(result) {
		            if (result === 0) {
		                isIdAvailable = true;
		                $("#idmsg").text("사용 가능한 아이디입니다.").css({
		    	            "color": "blue",
		    	            "font-size": "15px"
		    	        });;
		            } else {
		                isIdAvailable = false;
		                $("#idmsg").text("이미 사용 중인 아이디입니다.").css({
		    	            "color": "red"
		    	        });
		            }
		        },
		        error: function(xhr, status, error) {
		            alert("중복체크오류");
		        }
		    });
		})
		
		// 이메일 중복 체크
		$("#email").on("input", function() {
			isEmailIdAvailable = false;
			$("#emailmsg")
	        .text("이메일 중복 확인이 필요합니다.")
	        .css({
	            "color": "red"
	        });
		});
		
		$("#emailduplicateCheck").on("click", function(e) {
			let email = $("#email").val();
			if(email === "") {
				$("#emailmsg")
		        .text("이메일을 입력해주세요.")
		        .css({
		            "color": "red"
		        });
                return;
        	}
			
			if (!email.includes("@")){
				$("#emailmsg").text("유효한 이메일 형식이 아닙니다.").css({
					"color" : "red"
				});
				return;
			}
			
			$.ajax({
		        url: "/emailCheck",
		        type: "GET",
		        data: { email: email },
		        dataType: "json",
		        success: function(result) {
		            if (result === 0) {
		            	isEmailIdAvailable = true;
		                $("#emailmsg").text("사용 가능한 이메일입니다.").css({
				            "color": "blue"
				        });
		            } else {
		            	isEmailIdAvailable = false;
		                $("#emailmsg").text("이미 사용 중인 이메일입니다.").css({
				            "color": "red"
				        });
		            }
		        },
		        error: function(xhr, status, error) {
		            alert("중복체크오류");
		        }
		    });
		})
	})
	
	
</script>
</body>
</html>