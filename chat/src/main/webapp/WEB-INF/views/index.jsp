<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script src="/static/js/notify.js" ></script>

<meta charset="UTF-8">
    <title>http://devnote.com</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@700&family=Do+Hyeon&family=Noto+Sans+KR:wght@500&display=swap');

          @font-face {
            font-family: 'IBMPlexSansKR-Regular';
            src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_20-07@1.0/IBMPlexSansKR-Regular.woff') format('woff');
            font-weight: normal;
            font-style: normal;
        }

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
            color: #000;
            border-left: 3px solid #E0E6F8;
            margin-bottom: 20px;
        }
        .chating{
            padding:15px;
            background-color:#E4F7BA;
            width: 500px;
            height: 200px;
            overflow: auto;
        }
        .chating p{
            padding-bottom: 3px;
            font-family: 'IBMPlexSansKR-Regular', sans-serif;
            font-size: small;
            color: #000;
            text-align: left;
        }
        .google-font {
            font-family: 'Nanum Gothic', sans-serif;
        }
        .myButton {
            box-shadow:inset 0px 1px 0px 0px #97c4fe;
            background:linear-gradient(to bottom, #3d94f6 5%, #1e62d0 100%);
            background-color:#3d94f6;
            border-radius:6px;
            border:1px solid #337fed;
            display:inline-block;
            cursor:pointer;
            color:#ffffff;
            font-family:Arial;
            font-size:15px;
            font-weight:bold;
            padding:6px 24px;
            text-decoration:none;
            text-shadow:0px 1px 0px #1570cd;
        }
        .myButton:hover {
            background:linear-gradient(to bottom, #1e62d0 5%, #3d94f6 100%);
            background-color:#1e62d0;
        }
        .myButton:active {
            position:relative;
            top:1px;
        }
        .speech-bubble {
            display:inline-block;
            padding: 4px;
            position: relative;
            background: #fdfcfc;
            border-radius: .4em;
        }

        .speech-bubble:after {
            content: '';
            position: absolute;
            left: 0;
            top: 50%;
            width: 0;
            height: 0;
            border: 2px solid transparent;
            border-right-color: #fdfcfc;
            border-left: 0;
            border-bottom: 0;
            margin-top: -1px;
            margin-left: -2px;
        }ㄴㅇㄹㄴㅇㄹㅇㄴㄹㄴㅇㄹㅇㄴㄹ
        
        input{
            margin: 10px;
            width: 330px;
            height: 25px;
        }
        
        #yourMsg{
            display: none;
        }
        
        .emoticon_size{
            font-size: 140%;            
        }
    </style>
</head>

<script type="text/javascript">
    var ws;
    var uN;
    var old_name;

    $(function () {
        //알람기능 권한 요청
        //getNotificationPermission();
    })
    
    function heartBreaker() {
    	const heartList = ['❤', '💝', '🧡', '💛'];
    	const imoticonString = "😀 😃 😄 😁 😆 😅 😂 🤣 😊 😇 🙂 🙃 😉 😌 😍 🥰 😘 😗 😙 😚 😋 😛 😝 😜 🤪 🤨 🧐 🤓 😎 🤩 🥳 😏 😒 😞 😔 😟 😕 🙁 ☹️ 😣 😖 😫 😩 🥺 😢 😭 😤 😠 😡 🤬 🤯 😳 🥵 🥶 😱 😨 😰 😥 😓 🤗 🤔 🤭 🤫 🤥 😶 😐 😑 😬 🙄 😯 😦 😧 😮 😲 🥱 😴 🤤 😪 😵 🤐 🥴 🤢 🤮 🤧 😷 🤒 🤕 🤑 🤠 😈 👿 👹 👺 🤡 💩 👻 💀 ☠️ 👽 👾 🤖 🎃 😺 😸 😹 😻 😼 😽 🙀 😿 😾";
    	const imoticonList = [];
    	
    	heartList.forEach((el, idx) =>
    	   $("#heart").append("<button><span class='emoticon_size' id='heart_" + idx + "' onclick='heartBt(" + idx + ", " + '"#heart"' + ")'>" + el + "</span></button>")
    	);
    	
    	imoticonString.split(" ").forEach((el, idx) =>
    	   $("#emoticon").append("<button><span class='emoticon_size' id='emoticon_" + idx + "' onclick='heartBt(" + idx + ", " + '"#emoticon"' + ")'>" + el + "</span></button>")
    	);
    	
    }

    function wsOpen(){
        ws = new WebSocket("ws://" + location.host + "/chating");
        wsEvt();
    }

    function wsEvt() {
        ws.onopen = function(data){
            //소켓이 열리면 초기화 세팅하기
            old_name = $("#userName").val();
        }

        ws.onmessage = function(data) {


            var content = data.data;
            var date = new Date();
            var currentTime = date.getMinutes() > 9 ? date.getHours() + ":" + date.getMinutes() : date.getHours() + ":0" + date.getMinutes();

            var name = content.substring(0, content.indexOf(":") -1 );
            var p_tag = "<div style='padding:4px'><p class='speech-bubble'>";


            if(old_name == name){
              p_tag="<div style='padding:4px;text-align:right'><p class='speech-bubble'>";
            }


            if(content != null && content.trim() != ""){
                $("#chating").append(p_tag + content.split(":")[1] + "</p></div>");
                $("#chating").scrollTop($("#chating")[0].scrollHeight);     //스크롤 맨 아래로 고정

                //new Notification("New", {body:'message'});
                //newExcitingAlerts();
            }

            var color = "#" + Math.round(Math.random() * 0xffffff).toString(16);

            $("#accessId").html("<p style='color:" + color + "'>" + name + '&nbsp;' + currentTime + "</p>");
            //$("#accessId").append("<p style='color:" + color + "'>" + name + '&nbsp;' + "</p>");

        }

        document.addEventListener("keypress", function(e){
            if(e.keyCode == 13){ //enter press
                send();
            }
        });

        ws.onclose = function(e) {
            console.log('Socket is closed. Reconnect will be attempted in 1 second.', e.reason);
            //$("#accessId").empty();

            setTimeout(function() {
                ws = null;
                wsOpen();
            }, 1000);
        };

/*         newExcitingAlerts = (function () {
            var oldTitle = document.title;
            var msg = "New!";
            var timeoutId;
            var blink = function() { document.title = document.title == msg ? ' ' : msg; };
            var clear = function() {
                clearInterval(timeoutId);
                document.title = oldTitle;
                window.onmousemove = null;
                timeoutId = null;
            };
            return function () {
                if (!timeoutId) {
                    timeoutId = setInterval(blink, 1000);
                    window.onmousemove = clear;
                }
            };
        }()); */
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
            
            //하트버튼 SET
            heartBreaker();
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


    //알림 권한 요청
    function getNotificationPermission() {
        // 브라우저 지원 여부 체크
        if (!("Notification" in window)) {
            $.notify("알림을 차단하셨습니다.\n브라우저의 사이트 설정에서 변경하실 수 있습니다.", "warn");
        } else {
            Notification.requestPermission();
        }

        // 데스크탑 알림 권한 요청
        Notification.requestPermission(function (result) {
            // 권한 거절
            if(result == 'denied') {
                $.notify("알림을 차단하셨습니다.\n브라우저의 사이트 설정에서 변경하실 수 있습니다.", "warn");
            }
        });
    }
    
    function heartBt(i, c) {
    	$("#chatting").val($("#chatting").val() + $(c).children()[i].innerText);
    	$("#chatting").focus();
	}

</script>
<body>
    <div id="container" class="container">
        <div>
           <table class="inputTable">
                <tr>
                    <th class="google-font">접속 USER : </th>
                    <th class="google-font" id="accessId"></th>
                </tr>
            </table>
        </div>

        <h1 class="google-font">건뎐하게❤</h1>
        <div id="chating" class="chating">
        </div>

        <div id="yourName">
            <table class="inputTable">
                <tr>
                    <th class="google-font">이름</th>
                    <th><input type="text" name="userName" id="userName"></th>
                    <th><a href="#" onclick="chatName()" class="myButton">click</a></th>

                </tr>
            </table>
        </div>
        <div id="yourMsg">
            <table class="inputTable">
                <tr>
                    <th class="google-font">메시지</th>
                    <th><input id="chatting" placeholder="보내실 메시지를 입력하세요."></th>
                    <th><a href="#" onclick="send()" class="myButton">click</a></th>
                </tr>
            </table>
        </div>
        
        <div id="heart">
        </div>
        
        <br>
        
        <div id="emoticon">
        </div>
    </div>
</body>
</html>