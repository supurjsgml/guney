package com.chat.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.slf4j.Slf4j;

@RestController
@RequestMapping("/")
@Slf4j
public class chatController {
	
//	@Autowired
//	chatService chatservice;
	
    public ModelAndView index() {
    	ModelAndView mv = new ModelAndView();
		mv.setViewName("index");
		return mv;
    }
	
	@GetMapping("/sample")
	public String getSample() {
		
		return "API 서비스 호출";
	}
	
}
