package com.study.springboot.oauth2;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserService;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import com.study.springboot.service.IMService;

@Service
public class CustomOAuth2UserService implements OAuth2UserService<OAuth2UserRequest, OAuth2User> {
	@Autowired
	private HttpSession httpSession;
	@Autowired
	IMService ims;

	@Override
	public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
		OAuth2UserService delegate = new DefaultOAuth2UserService();
		OAuth2User oAuth2User = delegate.loadUser(userRequest);

		String registrationId = userRequest.getClientRegistration().getRegistrationId();
		String userNameAttributeName = userRequest.getClientRegistration()
				                                  .getProviderDetails()
				                                  .getUserInfoEndpoint()
				                                  .getUserNameAttributeName();

		OAuthAttributes attributes = OAuthAttributes.of(registrationId,
				                                        userNameAttributeName,
				                                        oAuth2User.getAttributes());

		SessionUser user = new SessionUser(registrationId,
										   attributes.getId(),
										   attributes.getName(),
				                           attributes.getEmail(),
				                           attributes.getPicture());
//		System.out.println("Picture:"+attributes.getPicture());
		httpSession.setAttribute("user", user);
		
		//sns 로그인 유저 db 추가
		String mId = attributes.getId();		
				
		// 세션에 아이디 저장
		httpSession.setAttribute("mid", mId);
		// db에 없을시 추가
		int userCheck = ims.idcheck(mId);
		 if(userCheck == 0) {
			int nResult = ims.join(mId, "(snsuer)", attributes.getName(), attributes.getEmail(), "");
			System.out.println("db 저장결과 : "+nResult);
		 }
		 
		Map<String, Object> mapId = new HashMap<String, Object>();
		mapId.put("id", mId);
			
		System.out.println("저장된 아이디 : "+mId);
		System.out.println(attributes.getAttributes());
		System.out.println(attributes.getNameAttributeKey());
		System.out.println("--------------------------------------------------------");
        
		return new DefaultOAuth2User(Collections.singleton(new SimpleGrantedAuthority("ROLE_USER")),
                					 mapId,
                					 "id");
		
//		return new DefaultOAuth2User(Collections.singleton(new SimpleGrantedAuthority("ROLE_USER")),
//				                     attributes.getAttributes(),
//				                     attributes.getNameAttributeKey());
	}
}