<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>

<meta charset="UTF-8">
    <title>Chating</title>
    <style>
        *{
            margin:0;
            padding:0;
        }
        .container{
            width: 500px;
            margin: 0 auto;
            padding: 25px
        }
        .container h1{
            text-align: left;
            padding: 5px 5px 5px 15px;
            color: #FFBB00;
            border-left: 3px solid #FFBB00;
            margin-bottom: 20px;
        }
        .chating{
            background-color: #000;
            width: 500px;
            height: 200px;
            overflow: auto;
        }
        .chating p{
            color: #fff;
            text-align: left;
        }
        input{
            width: 330px;
            height: 25px;
        }
        #yourMsg{
            display: none;
        }
    </style>
</head>

<script type="text/javascript">
    var ws;
    var uN;

    function wsOpen(){
        ws = new WebSocket("ws://" + location.host + "/chating");
        wsEvt();
    }
        
    function wsEvt() {
        ws.onopen = function(data){
            //소켓이 열리면 초기화 세팅하기
        }
        
        ws.onmessage = function(data) {
            var content = data.data;
            
            if(content != null && content.trim() != ""){
                $("#chating").append("<p>" + content + "</p>");
                $("#chating").scrollTop($("#chating")[0].scrollHeight);     //스크롤 맨 아래로 고정
            }
            
           	/* var color = "#" + Math.round(Math.random() * 0xffffff).toString(16);
            uN = $("#userName").val();
               
            $("#accessId").append("<p style='color:" + color + "'>" + uN + '&nbsp;' + "</p>"); */
            
        }

        document.addEventListener("keypress", function(e){
            if(e.keyCode == 13){ //enter press
                send();
            }
        });
        
        ws.onclose = function(e) {
            console.log('Socket is closed. Reconnect will be attempted in 1 second.', e.reason);
           	$("#accessId").empty();
           	
            setTimeout(function() {
            	ws = null;
            	wsOpen();
            }, 1000);
        };
    }

    function chatName(){
        var userName = $("#userName").val();
        if(userName == null || userName.trim() == ""){
            alert("사용자 이름을 입력해주세요.");
            $("#userName").focus();
        }else{
            wsOpen();
            $("#yourName").hide();
            $("#yourMsg").show();
        }
    }

    function send() {
        uN = $("#userName").val();
        var msg = $("#chatting").val();
        
        if (1 == ws.readyState && "" != msg && null != msg) {
	        ws.send(uN+" : "+msg);
	        $('#chatting').val("");
        }
    }
</script>
<body>
    <div id="container" class="container">
                접속 USER : 
	    <div id="accessId">
	    </div>
    
        <!-- <h1>채팅</h1> -->
        <div id="chating" class="chating">
        </div>
        
        <div id="yourName">
            <table class="inputTable">
                <tr>
                    <th>사용자명</th>
                    <th><input type="text" name="userName" id="userName"></th>
                    <th><button onclick="chatName()" id="startBtn">이름 등록</button></th>
                </tr>
            </table>
        </div>
        <div id="yourMsg">
            <table class="inputTable">
                <tr>
                    <th>메시지</th>
                    <th><input id="chatting" placeholder="보내실 메시지를 입력하세요."></th>
                    <th><button onclick="send()" id="sendBtn">보내기</button></th>
                </tr>
            </table>
        </div>
    </div>
</body>
</html>