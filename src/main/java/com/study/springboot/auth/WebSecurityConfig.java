package com.study.springboot.auth;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.study.springboot.oauth2.CustomOAuth2UserService;

@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter
{
	@Autowired
	public AuthenticationFailureHandler authenticationFailureHandler;
	@Autowired
	public AuthenticationSuccessHandler authenticationSuccessHandler;
	@Autowired
	public SnsLogoutSuccessHandler snsLogoutHandler;
		
	@Autowired
	public CustomOAuth2UserService customOAuth2UserService;

	@Override
	protected void configure(HttpSecurity http) throws Exception {
		http.authorizeRequests()
			.antMatchers("/").permitAll()
			.antMatchers("/loginform").permitAll()
			.antMatchers("/check/**").permitAll()
			.antMatchers("/guest/**").permitAll()
			.antMatchers("/map/**").permitAll()			
			.antMatchers("/style/**", "/css/**").permitAll()			
			.antMatchers("/assets/**", "/upload/**", "/naver-editor/**").permitAll()
			.antMatchers("/notice/**").permitAll()
			.antMatchers("/map_info").permitAll()
			.antMatchers("/join/**").permitAll()
//			.antMatchers("/css/**", "/js/**", "/img/**").permitAll()
			.antMatchers("/member/**").hasAnyRole("USER", "ADMIN")
			.antMatchers("/admin/**").hasRole("ADMIN")
//			.anyRequest().permitAll();
			
			// 내브바 확인용
			.antMatchers("/nav").permitAll()
			
			.anyRequest().authenticated();
		
		http.formLogin()
			.loginPage("/loginform")
			.loginProcessingUrl("/j_spring_security_check")
			.successHandler(authenticationSuccessHandler)
			.failureHandler(authenticationFailureHandler)
//			.defaultSuccessUrl("/")
			.usernameParameter("mid")
			.passwordParameter("mpw")		
			.permitAll();
		
		http.logout()
			.logoutUrl("/logout")	// default
			.logoutSuccessUrl("/")
			.logoutSuccessHandler(snsLogoutHandler)
			.deleteCookies("JSESSIONID")
			.invalidateHttpSession(true)
			.permitAll();

		http.csrf().disable()
			.headers().frameOptions().disable()
			.and()
			.oauth2Login()
			.successHandler(authenticationSuccessHandler)
				.userInfoEndpoint()
					.userService(customOAuth2UserService);
	}
	

	@Autowired
	private DataSource dataSource;
	
	@Override
	protected void configure(AuthenticationManagerBuilder auth) throws Exception {
		
		auth.jdbcAuthentication()
			.dataSource(dataSource)
			.usersByUsernameQuery("select mid as userName, mpw as password, enabled"
								 +" from ordermember where mid = ?")	 
			.authoritiesByUsernameQuery("select mid as userName, authority "
								 +" from ordermember where mid = ?")
			.passwordEncoder(passwordEncoder());		
		
	}
	
	// passwordEncoder() 추가
	public PasswordEncoder passwordEncoder() {
		return PasswordEncoderFactories.createDelegatingPasswordEncoder();
	}
}
