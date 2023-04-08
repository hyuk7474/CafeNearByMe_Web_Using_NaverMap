package com.study.springboot.service;

import java.util.List;

import com.study.springboot.dto.AppMemberDto;
import com.study.springboot.dto.HistoryDto;
import com.study.springboot.dto.MDto;

public interface IMService
{
	public int join(String mid, String mpw, String mname, String memail, String mpnum);
	
	public int idcheck(String mid);
	public int idpwcheck(String mid, String mpw);
	
	public AppMemberDto getMemberInfo(String mId);
	
	public MDto userinfo(String mid);
	public int modifyMyInfo(String mid, String memail, String mpnum, String mname);
	public int modipw(String mid, String mpw);
//	public int snsjoin(String mid, String mname, String memail, String mpnum);
	public int deleteuser(String mid);
	
	public int updateHistory(String item_Name, String price, String cupCount, String mId, String mName, String mPnum, String mEmail, String cno);
	public List<HistoryDto> getHistory(String mId);
	
//	public void findWish(String mid, Model model);
}
