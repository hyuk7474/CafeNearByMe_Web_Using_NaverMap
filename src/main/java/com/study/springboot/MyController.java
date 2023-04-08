package com.study.springboot;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.study.springboot.navermap.service.MapService;
import com.study.springboot.oauth2.SessionUser;
import com.study.springboot.service.IMService;

@Controller
public class MyController
{
	@Autowired
	IMService ims;
//	@Autowired
//	IGoodsService goods;
	
	@Autowired
	MapService mapService;

	@Autowired
	private HttpSession httpSession;
	
	@RequestMapping("/")
	public String root() {		
		return "/root";
	}
	
	@RequestMapping("/,_=_")
	public String fbRoot() {		
		return "/root";
	}
		
	@RequestMapping("/loginform")
	public String login() {
		return "/security/login";
	}
	
	@RequestMapping("/member/mypage")
	public String userpage2(Model model) {
		return "/member/mypage";
	}
	
	// 유저 정보
	@RequestMapping("/member/userinfo")
	public String userInfo(HttpServletRequest request, Model model) {
		
		return "/member/userinfo";
	}
		
	// 세션 확인 후 sns와 홈로그인을 다르게 연결함
	@RequestMapping("/pwhome")
	public String pwCheckHome(Model model) {
		System.out.println("pw체크 옴");
		String returnUrl = "";
		
		// sns로그인시에는 obj가 존재
		SessionUser obj = (SessionUser) httpSession.getAttribute("user");
		
		if (obj != null) {
			model.addAttribute("user", obj);
			
			returnUrl = "/security/pwcheck_sns";
			System.out.println("데이터:"+obj);
		} else {
			
			
			returnUrl = "/security/pwcheck_home";
		}
		return returnUrl;
	}
	
	@RequestMapping("/pwhomecheck")
	public @ResponseBody String homePWCheck(HttpServletRequest request) {
		String mid = request.getParameter("mid");
		String mpw = request.getParameter("mpw");
		
		int nResult = 0; // ims.idpwcheck(mid, mpw);
		
		JSONObject obj = new JSONObject();
		
		if(nResult == 1) {
			obj.put("code", "success");
			obj.put("desc", "비밀번호 일치");
		} else {
			obj.put("code", "fail");
			obj.put("desc", "비밀번호 불일치");
		}
		
		return obj.toJSONString();
	}
	
	@RequestMapping("/snscheck")
	public @ResponseBody String snsACCheck(HttpServletRequest request) {
		String sName = request.getParameter("mid");
		System.out.println("유저 name : " + sName);
		
		SessionUser user = (SessionUser) httpSession.getAttribute("user");
		String sname = (String)user.getName();
		System.out.println("세션 name : " + sname);
		
		JSONObject obj = new JSONObject();
		if(sName.equals(sname)) {
			obj.put("code", "success");
			obj.put("desc", "유저 일치");
		} else {
			obj.put("code", "fail");
			obj.put("desc", "유저 불일치");
		}
		
		return obj.toJSONString();
	}
	
	// 유저 아이디 기준 위시리스트 불러오기
	@RequestMapping("/member/getWish")
	public String find_WishList (Model model) {
		
		String mid = (String)httpSession.getAttribute("mid");
		
//		ims.findWish(mid, model);
		
		
		return "/member/wishlist";
	}
	
	// DB 좌표 칼럼 업데이트
	@GetMapping("/admin/map/coorupdate")
	public @ResponseBody String updateAddrCoor() throws ParseException {		
		int nResult = mapService.getAddr_CoorUpdate();		
		return "UpdateCount : " + nResult; 
	}
	
	@GetMapping("/map/scoreupdate")
	public @ResponseBody String updateScoreRandomly(){		
		int nResult = mapService.getRandom();		
		return "AddedScoreCount : " + nResult; 
	}
	
	@GetMapping("/map/menuupdate")
	public @ResponseBody String updateMenuAtOnce(){		
		int nResult = mapService.addMenu();		
		return "AddedMenuCount : " + nResult; 
	}
	
}
