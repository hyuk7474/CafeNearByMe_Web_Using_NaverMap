package com.study.springboot.oauth2;

import java.util.Map;

import lombok.Builder;
import lombok.Getter;

@Getter
public class OAuthAttributes {
	private Map<String, Object> attributes;
	private String nameAttributeKey;
	private String id;
	private String name;
	private String email;
	private String picture;

	@Builder
	public OAuthAttributes(Map<String, Object> attributes, String nameAttributeKey, String id,
			               String name, String email, String picture) 
	{
		this.attributes = attributes;
		this.nameAttributeKey = nameAttributeKey;
		this.id = id;
		this.name = name;
		this.email = email;
		this.picture = picture;
	}

	public static OAuthAttributes of(String registrationId, String userNameAttributeName,
			                         Map<String, Object> attributes) 
	{
		System.out.println(registrationId);
		System.out.println("userNameAttributeName :" +userNameAttributeName);
		if (registrationId.equals("google")) {
			return ofGoogle(userNameAttributeName, attributes);
		} else if  (registrationId.equals("facebook")) {
			return ofFacebook(userNameAttributeName, attributes);
		} else if  (registrationId.equals("kakao")) {			
			return ofKakao(userNameAttributeName, attributes);
		} else if  (registrationId.equals("naver")) {
			return ofNaver(userNameAttributeName, attributes);
		}
		return ofGoogle(userNameAttributeName, attributes);
	}

	private static OAuthAttributes ofGoogle(String userNameAttributeName, Map<String, Object> attributes) 
	{
		System.out.println(attributes);

		String sId = (String)attributes.get("sub");
		System.out.println("google sId : " + sId);
		
		return OAuthAttributes.builder()
				.id("(gg)"+sId)
				.name((String) attributes.get("name"))
				.email((String) attributes.get("email"))
				.picture((String) attributes.get("picture"))
				.attributes(attributes)
				.nameAttributeKey(userNameAttributeName)
				.build();
	}
	
	private static OAuthAttributes ofFacebook(String userNameAttributeName, Map<String, Object> attributes) 
	{
		System.out.println(attributes);		
		
		String sId = (String) attributes.get("id");					
		String sName = (String) attributes.get("name");
		String sEmail = (String) attributes.get("email");
		Map<String, Object> pic1 = (Map<String, Object>) attributes.get("picture");
		Map<String, Object> pic2 = (Map<String, Object>) pic1.get("data");
		String pic3 = (String) pic2.get("url");
		
		return OAuthAttributes.builder()
				.id("(fb)"+sId)
				.name(sName)
				.email(sEmail)
				.picture(pic3)
				.attributes(attributes)
				.nameAttributeKey(userNameAttributeName)
				.build();
	}

	private static OAuthAttributes ofKakao(String userNameAttributeName, Map<String, Object> attributes) 
	{
		System.out.println(attributes);

		Map<String, Object> obj1 = (Map<String, Object>) attributes.get("kakao_account");
		Map<String, Object> obj2 = (Map<String, Object>) obj1.get("profile");
		String sId = Long.toString((Long)attributes.get("id"));
		System.out.println("sId : " + sId);			
		String sName = (String) obj2.get("nickname");
		String sPic = (String) obj2.get("thumbnail_image_url");
		String sEmail = (String) obj1.get("email");
		
		return OAuthAttributes.builder()
				.id("(k)"+sId)
				.name(sName)
				.email(sEmail)
				.picture(sPic)
				.attributes(attributes)
				.nameAttributeKey(userNameAttributeName)
				.build();		
	}

	private static OAuthAttributes ofNaver(String userNameAttributeName, Map<String, Object> attributes) 
	{
//		System.out.println(attributes);				
		
		Map<String, Object> obj1 = (Map<String, Object>) attributes.get("response");
		String sName = (String) obj1.get("name");		
		String sEmail = (String) obj1.get("email");
		
		String sId = (String) obj1.get("id");		
		System.out.println("naver sId : " + sId);

		return OAuthAttributes.builder()
				.id("(n)"+sId)
				.name(sName)
				.email(sEmail)				
				.attributes(attributes)
				.nameAttributeKey(userNameAttributeName)
				.build();	
		
	}

}