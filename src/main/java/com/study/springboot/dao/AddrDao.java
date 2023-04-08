package com.study.springboot.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.study.springboot.dto.AddrDto;
import com.study.springboot.dto.AddrTempDto;
import com.study.springboot.dto.MenuDto;

@Mapper
public interface AddrDao
{
	// DB 업데이트 용
	public List<AddrTempDto> getAddr();
	public int updateLocDataDong(String x, String y, String Addr);
	public int updateLocDataStreet(String x, String y, String Addr);


	public int deleteClosedDong(String addr);
	public int deleteClosedStreet(String addr);
	
	public List<String> getName();
	public int addRandomScore(String score, String name);
	public int updateMenu(int cno, String menu, int price, String kind);
		
	public List<AddrDto> getAroundCafe(String swLat, String neLat, String swLon, String neLon);
	public List<MenuDto> getMenu(String cno);
}
