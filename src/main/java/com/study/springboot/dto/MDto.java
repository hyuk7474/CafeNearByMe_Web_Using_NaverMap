package com.study.springboot.dto;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Pattern;

import lombok.Data;

@Data
public class MDto
{
	@NotEmpty(message="아이디는 필수입력 사항입니다.")
	@Pattern(regexp="^[a-zA-Z0-9]{4,10}$",
			 message = "아이디는 영어나 숫자 4~10자리로 입력해주세요.")
	// 영문 숫자
	String mid;
	@NotEmpty(message="비밀번호는 필수입력 사항입니다.")
	@Pattern(regexp="^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{4,10}$",
			 message = "영어, 숫자, 특수문자를 포함한 4~10자리로 입력해주세요.")
	// 영문 숫자 특문
	String mpw;	
	String mname;
	String memail;
	String mpnum;
	String mblack;
	String authority;
	String enabled;
}
