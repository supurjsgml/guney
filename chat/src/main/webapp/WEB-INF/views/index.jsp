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
        }
        input{
            margin: 10px;
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
    var old_name;

    $(function () {
        //알람기능 권한 요청
        //getNotificationPermission();
        
    	heartBreaker();
    })
    
    function heartBreaker() {
    	const heartList = ['❤', '💝', '🧡', '💛'];
    	
    	heartList.forEach((el, idx) =>
    	   $("heart").append("<button><span id='heart_'>" + el + "</span></button>")
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
            <button><span>❤</span></button>
            <button><span>💝</span></button>
            <button><span>🧡</span></button>
            <button><span>💛</span></button>
            <!-- </td><td>노란색 하트</td><td><span class='copy btn btn-mini btn-default active'>복사</span></td></tr><tr><td class='td-img'><img class="lazy" src="//cdnjs.cloudflare.com/ajax/libs/blockly/1.0.0/media/1x1.gif" data-src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/12.1.5/72x72/1f49a.png' /></td><td class="td-txt">💚</td><td>녹색 하트</td><td><span class='copy btn btn-mini btn-default active'>복사</span></td></tr><tr><td class='td-img'><img class="lazy" src="//cdnjs.cloudflare.com/ajax/libs/blockly/1.0.0/media/1x1.gif" data-src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/12.1.5/72x72/1f499.png' /></td><td class="td-txt">💙</td><td>파란색 하트</td><td><span class='copy btn btn-mini btn-default active'>복사</span></td></tr><tr><td class='td-img'><img class="lazy" src="//cdnjs.cloudflare.com/ajax/libs/blockly/1.0.0/media/1x1.gif" data-src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/12.1.5/72x72/1f49c.png' /></td><td class="td-txt">💜</td><td>보라색 하트</td><td><span class='copy btn btn-mini btn-default active'>복사</span></td></tr><tr><td class='td-img'><img class="lazy" src="//cdnjs.cloudflare.com/ajax/libs/blockly/1.0.0/media/1x1.gif" data-src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/12.1.5/72x72/1f90e.png' /></td><td class="td-txt">🤎</td><td>갈색 하트</td><td><span class='copy btn btn-mini btn-default active'>복사</span></td></tr><tr><td class='td-img'><img class="lazy" src="//cdnjs.cloudflare.com/ajax/libs/blockly/1.0.0/media/1x1.gif" data-src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/12.1.5/72x72/1f5a4.png' /></td><td class="td-txt">🖤</td><td>검정색 하트</td><td><span class='copy btn btn-mini btn-default active'>복사</span></td></tr><tr><td class='td-img'><img class="lazy" src="//cdnjs.cloudflare.com/ajax/libs/blockly/1.0.0/media/1x1.gif" data-src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/12.1.5/72x72/1f90d.png' /></td><td class="td-txt">🤍</td><td>흰색 하트</td><td><span class='copy btn btn-mini btn-default active'>복사</span></td></tr><tr><td class='td-img'><img class="lazy" src="//cdnjs.cloudflare.com/ajax/libs/blockly/1.0.0/media/1x1.gif" data-src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/12.1.5/72x72/1f494.png' /></td><td class="td-txt">💔</td><td>깨진 하트</td><td><span class='copy btn btn-mini btn-default active'>복사</span></td></tr><tr><td class='td-img'><img class="lazy" src="//cdnjs.cloudflare.com/ajax/libs/blockly/1.0.0/media/1x1.gif" data-src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/12.1.5/72x72/2763.png' /></td><td class="td-txt">❣</td><td>하트 느낌표</td><td><span class='copy btn btn-mini btn-default active'>복사</span></td></tr><tr><td class='td-img'><img class="lazy" src="//cdnjs.cloudflare.com/ajax/libs/blockly/1.0.0/media/1x1.gif" data-src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/12.1.5/72x72/1f495.png' /></td><td class="td-txt">💕</td><td>두 개의 하트</td><td><span class='copy btn btn-mini btn-default active'>복사</span></td></tr><tr><td class='td-img'><img class="lazy" src="//cdnjs.cloudflare.com/ajax/libs/blockly/1.0.0/media/1x1.gif" data-src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/12.1.5/72x72/1f49e.png' /></td><td class="td-txt">💞</td><td>회전하는 하트</td><td><span class='copy btn btn-mini btn-default active'>복사</span></td></tr><tr><td class='td-img'><img class="lazy" src="//cdnjs.cloudflare.com/ajax/libs/blockly/1.0.0/media/1x1.gif" data-src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/12.1.5/72x72/1f493.png' /></td><td class="td-txt">💓</td><td>두근거리는 하트</td><td><span class='copy btn btn-mini btn-default active'>복사</span></td></tr><tr><td class='td-img'><img class="lazy" src="//cdnjs.cloudflare.com/ajax/libs/blockly/1.0.0/media/1x1.gif" data-src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/12.1.5/72x72/1f497.png' /></td><td class="td-txt">💗</td><td>점점 커지는 하트</td><td><span class='copy btn btn-mini btn-default active'>복사</span></td></tr><tr><td class='td-img'><img class="lazy" src="//cdnjs.cloudflare.com/ajax/libs/blockly/1.0.0/media/1x1.gif" data-src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/12.1.5/72x72/1f496.png' /></td><td class="td-txt">💖</td><td>반짝이는 하트</td><td><span class='copy btn btn-mini btn-default active'>복사</span></td></tr><tr><td class='td-img'><img class="lazy" src="//cdnjs.cloudflare.com/ajax/libs/blockly/1.0.0/media/1x1.gif" data-src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/12.1.5/72x72/1f498.png' /></td><td class="td-txt">💘</td><td>화살 맞은 하트</td><td><span class='copy btn btn-mini btn-default active'>복사</span></td></tr><tr><td class='td-img'><img class="lazy" src="//cdnjs.cloudflare.com/ajax/libs/blockly/1.0.0/media/1x1.gif" data-src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/12.1.5/72x72/1f49d.png' /></td><td class="td-txt">💝</td><td>리본 달린 하트</td><td><span class='copy btn btn-mini btn-default active'>복사</span></td></tr><tr><td class='td-img'><img class="lazy" src="//cdnjs.cloudflare.com/ajax/libs/blockly/1.0.0/media/1x1.gif" data-src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/12.1.5/72x72/1f49f.png' /></td><td class="td-txt">💟</td><td>하트 장식</td><td><span class='copy btn btn-mini btn-default active'>복사</span></td></tr><tr><td class='td-img'><img class="lazy" src="//cdnjs.cloudflare.com/ajax/libs/blockly/1.0.0/media/1x1.gif" data-src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/12.1.5/72x72/262e.png' /></td><td class="td-txt">☮</td><td>평화 기호</td><td><span class='copy btn btn-mini btn-default active'>복사</span></td></tr><tr><td class='td-img'><img class="lazy" src="//cdnjs.cloudflare.com/ajax/libs/blockly/1.0.0/media/1x1.gif" data-src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/12.1.5/72x72/271d.png' /></td><td class="td-txt">✝</td><td>라틴 십자가</td><td><span class='copy btn btn-mini btn-default active'>복사</span></td></tr><tr><td class='td-img'><img class="lazy" src="//cdnjs.cloudflare.com/ajax/libs/blockly/1.0.0/media/1x1.gif" data-src='https://cdnjs.cloudflare.com/ajax/libs/twemoji/12.1.5/72x72/262a.png' /></td> -->
        </div>
    </div>
</body>
</html>