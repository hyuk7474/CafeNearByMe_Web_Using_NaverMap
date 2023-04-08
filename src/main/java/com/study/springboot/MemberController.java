package com.study.springboot;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.study.springboot.dto.AppMemberDto;
import com.study.springboot.dto.HistoryDto;
import com.study.springboot.service.IMService;

@Controller
@RequestMapping("/member")
public class MemberController
{
	@Autowired
	IMService ims;
	
	@GetMapping("/mypage")
	public String toMyPage() {
		return "/member/mypage";
	}
		
	@PostMapping("/myinfo")
	public String getInfo(HttpServletRequest request, Model model, @RequestParam String mId) {
		
		Map<String, Object> data = getMemberInfo(mId);		
		
		
		JSONObject obj = new JSONObject();
		
		if(!data.isEmpty())
		{
			if(!Objects.isNull(model)) model.addAllAttributes(data);
		} else {
			System.out.println("["+mId+"]"+"의 데이터가 없습니다.");
		}
		
//		if(Objects.isNull(model)) {			
//			request.setAttribute("jsonMemberData", obj.toJSONString());
//			String jsonMemberData = (String)request.getAttribute("jsonMemberData");
//			System.out.println(jsonMemberData);
//		}
		
		return "/member/modify_info";
	}
	
	@PostMapping("/myinfojson")
	public @ResponseBody String getInfoJson(HttpServletRequest request, Model model, @RequestParam String mId) {
		
		Map<String, Object> data = getMemberInfo(mId);		
		
		JSONObject obj = new JSONObject();
		
		if(!data.isEmpty())
		{
			obj.put("code","success");
			obj.put("desc","회원 정보를 불러왔습니다.");			
			obj.put("data", data);
		} else {
			obj.put("code","fail");
			obj.put("desc","회원 정보를 불러오지 못 했습니다.");
		}
		
		return obj.toJSONString();
	}
	
	public Map<String, Object> getMemberInfo(String mId) {
		Map<String, Object> data = new HashMap<>();
		
		AppMemberDto memberDTO = ims.getMemberInfo(mId);		
		if(!Objects.isNull(memberDTO)){		
			String mpnum1 = "";
			String mpnum2 = "";
			String mpnum3 = "";
			if(memberDTO.getMPnum()!=null) {				
				mpnum1 = memberDTO.getMPnum().substring(0,3);
				mpnum2 = memberDTO.getMPnum().substring(4,8);
				mpnum3 = memberDTO.getMPnum().substring(9);
			}
			
			data.put("mId", memberDTO.getMId());
			data.put("mPw", memberDTO.getMPw());
			data.put("mName", memberDTO.getMName());
			data.put("mPnum", memberDTO.getMPnum());
			data.put("mPnum1", mpnum1);
			data.put("mPnum2", mpnum2);
			data.put("mPnum3", mpnum3);
			data.put("mEmail", memberDTO.getMEmail());
			data.put("mBlack", memberDTO.getMBlack());
			data.put("enabled", memberDTO.getEnabled());
		}
		
		return data;
	}
	
	@PostMapping("/myinfo/modify")
	public @ResponseBody String modifyInfo(HttpServletRequest request, Model model) {
		System.out.println("myInfo");
		
		int num = 0;		
		String mId = request.getParameter("mid");
		String mname = request.getParameter("mname");
		String mpnum = request.getParameter("mpnum");
		String memail = request.getParameter("memail");
		
		int nResult = ims.modifyMyInfo(mId, memail, mpnum, mname);
		
		JSONObject obj = new JSONObject();
		
		if(nResult == 1)
		{
			obj.put("code","success");
			obj.put("desc","회원 정보를 수정하였습니다.");		
		
		} else {
			obj.put("code","fail");
			obj.put("desc","회원 정보를 수정하지 못 했습니다.");
		}
		
		return obj.toJSONString();
	}
	
	@PostMapping("/addhistory")
	public @ResponseBody String addHistory(HttpServletRequest request, Model model,
											 @RequestParam String item_Name,
											 @RequestParam String price,
											 @RequestParam String cupCount,
											 @RequestParam String mId,
											 @RequestParam String mName,
											 @RequestParam String mPnum,
											 @RequestParam String mEmail,
											 @RequestParam String cno) {
		System.out.println("addhistory");
				
		int nResult = ims.updateHistory(item_Name, price, cupCount, mId, mName, mPnum, mEmail, cno);
		
		JSONObject obj = new JSONObject();
		
		if(nResult == 1)
		{
			obj.put("code","success");
			obj.put("desc","구매내역DB에 추가되었습니다.");		
		
		} else {
			obj.put("code","fail");
			obj.put("desc","구매내역DB에 추가하지 못 하였습니다.");
		}
		
		return obj.toJSONString();
	}
	
	@PostMapping("/gethistory")
	public @ResponseBody String getHistory(HttpServletRequest request, Model model, @RequestParam String mId) {
		System.out.println("getHistory");
		try
		{
			List<HistoryDto> historyList = ims.getHistory(mId);
			
			Map<Integer, Object> datas = new HashMap<>();
			
			int i = 0;
			for(HistoryDto dto : historyList) {
				Map<String, Object> data = new HashMap<>();
				data.put("mId", dto.getMId());
				data.put("price", dto.getPrice());
				data.put("cupCount", dto.getCupCount());
				data.put("mName", dto.getMName());
				data.put("mPnum", dto.getMPnum());
				data.put("mEmail", dto.getMEmail());
				data.put("cno", dto.getCno());
				data.put("item_Name", dto.getItem_Name());
				data.put("paidDate", dto.getPaidDate());
				data.put("paidTime", dto.getPaidTime());
				
				datas.put(i, data);
				i++;
			}
			
			JSONObject obj = new JSONObject();
			
			if(!datas.isEmpty())
			{
				obj.put("code","success");
				obj.put("desc","회원 정보를 불러왔습니다.");			
				obj.put("data", datas);
			} else {
				obj.put("code","fail");
				obj.put("desc","회원 정보를 불러오지 못 했습니다.");
			}
			
			return obj.toJSONString();
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		return null;
	}
	
	
}
