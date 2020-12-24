package com.member;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.member.service.MemberService;

@RestController
@RequestMapping("/")
public class MemberController {
	
	@Autowired
	private MemberService memberService;

	@GetMapping("/member")
	public List<Map<String, Object>> getSample() {
		return memberService.getSample();
	}
}
