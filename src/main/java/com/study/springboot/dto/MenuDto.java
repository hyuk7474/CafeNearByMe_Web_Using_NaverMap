package com.study.springboot.dto;

import lombok.Data;

@Data
public class MenuDto
{
	int cno;
	String menu;
	int price;
	int soldout;
	String kind;
}
