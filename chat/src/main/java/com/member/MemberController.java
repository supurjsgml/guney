package com.member;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.member.service.MemberService;
import com.util.restApiUtil;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/")
public class MemberController {
	
	@Autowired
	private MemberService memberService;

//	@Autowired
//	private restApiUtil restapiutil;
	
	@GetMapping("/member")
	public List<Map<String, Object>> getSample() {
		return restApiUtil.postRestCall("https://guney-chat-backend.herokuapp.com/member", null);
	}
	
}
