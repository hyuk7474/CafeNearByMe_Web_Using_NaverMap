package com.study.springboot.service;

import java.util.HashMap;
import java.util.Random;

import org.json.simple.JSONObject;
import org.springframework.stereotype.Service;

import net.nurigo.java_sdk.api.Message;
import net.nurigo.java_sdk.exceptions.CoolsmsException;

@Service
public class SmsService
{
	public String PhoneNumberCheck(String to) throws CoolsmsException {
		
		String api_key = "NCSHKUKJR5WMMRB6";
		String api_secret = "98ET9ZFAUWJJQMUWKMXMORXYXCL5K2O8";
		Message coolsms = new Message(api_key, api_secret);
		
		Random rand  = new Random();
	    String numStr = "";
	    for(int i=0; i<6; i++) {
	       String ran = Integer.toString(rand.nextInt(10));
	       numStr+=ran;
	    }          
	
	    HashMap<String, String> params = new HashMap<String, String>();
	    params.put("to", to);
	    params.put("from", "01097477474");
	    params.put("type", "sms"); 
	    params.put("text", "인증번호는 [" + numStr + "] 입니다.");
		    
//	    JSONObject result = coolsms.send(params); // 보내기&전송결과받기
//	    System.out.println(result);
	        
	    return numStr;
	
	}
}
