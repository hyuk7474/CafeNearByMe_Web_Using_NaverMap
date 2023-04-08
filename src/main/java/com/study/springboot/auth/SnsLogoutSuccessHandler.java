package com.study.springboot.auth;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.context.annotation.Configuration;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.logout.LogoutSuccessHandler;

@Configuration
public class SnsLogoutSuccessHandler implements LogoutSuccessHandler
{
	@Override
	public void onLogoutSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication)
			throws IOException, ServletException
	{		
		
		System.out.println("LogoutSuccessHandeler");
		System.out.println(authentication.getName());
		
		String mId = authentication.getName();
		// sns 별 분류는 했으나.. 로그아웃 기능이 구현 안됨..
		if(mId.indexOf("(k)")>-1) {
			
		} else if(mId.indexOf("(n)")>-1) {
			
		} else if(mId.indexOf("(gg)")>-1) {
			
		} else if(mId.indexOf("(fb)")>-1) {
			
		}	
	
		response.sendRedirect("/map");
	}

		
}
