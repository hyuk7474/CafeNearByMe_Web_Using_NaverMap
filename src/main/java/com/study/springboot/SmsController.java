package com.study.springboot;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.study.springboot.service.SmsService;

import net.nurigo.java_sdk.exceptions.CoolsmsException;

@Controller
public class SmsController
{
	@Autowired
	SmsService smsService;
	
	@RequestMapping("/check/sms")
	public @ResponseBody String checkPhone(HttpServletRequest request) throws CoolsmsException {
		String pnum = request.getParameter("pnum");
		System.out.println(pnum);
		String sResult = smsService.PhoneNumberCheck(pnum);
		System.out.println(sResult);
		
		JSONObject obj = new JSONObject();
		
		if(sResult != null)
		{
			obj.put("code","success");
			obj.put("desc","인증 정보를 발송하였습니다. 3분 안에 입력해주세요.");			
			obj.put("nVal", sResult);
		} else {
			obj.put("code","fail");
			obj.put("desc","인증 정보를 발송하지 못 했습니다.");
		}
		System.out.println(obj.toJSONString());
		
		return obj.toJSONString();
	}
}
