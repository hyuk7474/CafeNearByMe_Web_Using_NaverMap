package com.study.springboot.auth;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.DefaultRedirectStrategy;
import org.springframework.security.web.RedirectStrategy;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.RequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;

import com.study.springboot.MemberController;

@Configuration
public class CustomAuthenticationSuccessHandler implements AuthenticationSuccessHandler
{
	@Autowired
	private HttpSession httpSession;
	
	@Autowired
	MemberController memberController;
	
	private RequestCache requestCache = new HttpSessionRequestCache();
	private RedirectStrategy redirectStrategy = new DefaultRedirectStrategy();
	
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request,
										HttpServletResponse response,
										Authentication authentication) 
	throws IOException, ServletException
	{
		try
		{			
			String mid = (String)httpSession.getAttribute("mid");
			if(mid == null) {
				mid = request.getParameter("mid");
				httpSession.setAttribute("mid", mid);
			}
						
			SavedRequest savedRequest = requestCache.getRequest(request, response);
			if(savedRequest != null) {
				// 인증 받기 전 url로 이동
				String targetUrl = savedRequest.getRedirectUrl();
				System.out.println("저장된 캐시 : " + targetUrl);
				if(targetUrl.equals("http://localhost:8081/js/scripts.js")) {
					targetUrl = "/";	// 임시..
				}
				redirectStrategy.sendRedirect(request, response, targetUrl);
			} else {			
				redirectStrategy.sendRedirect(request, response, "/map");
			}
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		// 
	}

}
