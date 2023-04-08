package com.study.springboot.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.factory.PasswordEncoderFactories;
import org.springframework.stereotype.Service;

import com.study.springboot.dao.MDao;
import com.study.springboot.dto.AppMemberDto;
import com.study.springboot.dto.HistoryDto;
import com.study.springboot.dto.MDto;

@Service
public class MService implements IMService
{
	@Autowired 
	MDao mdao;
	
	int nResult = 0;
	
	@Override
	public int join(String mid, String mpw, String mname, String memail, String mpnum)
	{
		
		System.out.println("변환전 mpw : " + mpw);
		
		String encodePw = PasswordEncoderFactories.createDelegatingPasswordEncoder().encode(mpw);
		System.out.println("변환후 mpw : " + encodePw);
		
		int nResult = mdao.join(mid, encodePw, mname, memail, mpnum);
		System.out.println("Result : " + nResult);
		return nResult;
		
	}
	
	@Override
	public int idcheck(String mid) { 
		
		nResult = mdao.idcheck(mid);
		
		return nResult;
	}
	
	@Override
	public int idpwcheck(String mid, String mpw) {
		
		
		String encodePw = mdao.idpwcheck(mid);
		System.out.println("불러온 pw : " + encodePw);
		boolean chk = PasswordEncoderFactories.createDelegatingPasswordEncoder().matches(mpw, encodePw);
		
		if(chk == true) {
			nResult = 1;
			System.out.println("pw 일치함");
		} else {
			nResult = 0;
		}
		
		return nResult;
	}
	
	@Override
	public MDto userinfo(String mid) {
		return mdao.userinfo(mid);
	}
	
	@Override
	public int modifyMyInfo(String mid, String memail, String mpnum, String mname) { 
		
		nResult = mdao.modifyMyInfo(mid, memail, mpnum, mname);
		
		return nResult;
	}
	
	@Override
	public int modipw(String mid, String mpw) {
		
		System.out.println("변환전 mpw : " + mpw);
		
		String encodePw = PasswordEncoderFactories.createDelegatingPasswordEncoder().encode(mpw);
		System.out.println("변환후 mpw : " + encodePw);
		
		nResult = mdao.modipw(mid, encodePw);
		
		return nResult;
	}
	
//	@Override
//	public int snsjoin(String mid, String mname, String memail, String mpnum) {
//		
//		String encodePw = "snsuser";
//		
//		String mpw = PasswordEncoderFactories.createDelegatingPasswordEncoder().encode(encodePw);
//		System.out.println("sns 비밀번호 : " + mpw);
//		
//		nResult = mdao.snsjoin(mid, mpw, mname, memail, mpnum);
//		
//		return nResult;
//	}
	
	@Override
	public int deleteuser(String mid) {
		
		nResult = mdao.deleteuser(mid);
		
		return nResult;
	}

	@Override
	public AppMemberDto getMemberInfo(String mId)
	{		
		return mdao.getMemberInfo(mId);
	}

	@Override
	public int updateHistory(String item_Name, String price, String cupCount, String mId, String mName, String mPnum,
			String mEmail, String cno)
	{
		nResult = mdao.updateHistory(item_Name, price, cupCount, mId, mName, mPnum, mEmail, cno);
		return nResult;
	}

	@Override
	public List<HistoryDto> getHistory(String mId)
	{		
		return mdao.getHistory(mId);
	}
	

}
