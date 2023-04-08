package com.study.springboot;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.study.springboot.dto.MDto;
import com.study.springboot.service.IMService;

@Controller
@RequestMapping("/join")
public class JoinController
{
	@Autowired
	IMService ims;
	
	@GetMapping("")
	public String viewTerms() {
		return "/join/terms";
	}
	
	@PostMapping("/allAgreed")
	public @ResponseBody String allAgreed(HttpServletRequest request,Model model) {		
		JSONObject obj = new JSONObject();
		
		HttpSession session = request.getSession();
		
		
		int nResult = 0;
		
		if(request.getParameter("allAgreed").equals("checked")) {			
			nResult = 1;
			model.addAttribute("allAgreed", "checked");			
			session.setAttribute("allAgreed", "checked");
		}		
		
		if(nResult == 1) {
			obj.put("code", "success");
			obj.put("desc", "모든 항목에 동의하였습니다.");
		} else {
			obj.put("code", "fail");
			obj.put("desc", "모든 항목에 동의하지 않았습니다.");
		}		
		return obj.toJSONString();
	}
	
	@GetMapping("/input")
	public String homejoin() {		
		return "/join/input";
	}	
		
	@PostMapping("/idcheck")
	public @ResponseBody String doIdcheck(HttpServletRequest request) {		
		JSONObject obj = new JSONObject();
		
		String mid = request.getParameter("mid");
		System.out.println("check id : " + mid);
		int nResult = ims.idcheck(mid);
		
		if(nResult == 0) {
			obj.put("code", "success");
			obj.put("desc", "사용가능한 아이디입니다.");
		} else {
			obj.put("code", "fail");
			obj.put("desc", "사용할수 없는 아이디입니다.");
		}		
		return obj.toJSONString();
	}
	
	@PostMapping("/process")
	public @ResponseBody String memberjoin(@ModelAttribute("dto") @Valid MDto MDto,
			  								BindingResult result,
			  								HttpServletRequest request,
			  								Model model)
	{
		System.out.println("join process");
		JSONObject obj = new JSONObject();
		System.out.println(result.hasErrors());
		System.out.println(result.toString());

		if(result.hasErrors()) {
			if(result.getFieldError("mid") != null) {
				String massage = result.getFieldError("mid").getDefaultMessage();
				System.out.println("1 : " + massage);
				obj.put("code", "fail");
				obj.put("desc", massage);
				obj.put("type", "mid");
			} else if(result.getFieldError("mpw") != null) {
				String massage = result.getFieldError("mpw").getDefaultMessage();
				System.out.println("2 : " + massage);
				obj.put("code", "fail");
				obj.put("desc", massage);
				obj.put("type", "mpw");
			}
			return obj.toJSONString();
		
		} else {
			// 검증 후 정보 등록
			System.out.println("---------------------");
			System.out.println(request.getParameter("mpnum"));
			
			int nResult = ims.join(request.getParameter("mid"),
								   request.getParameter("mpw"),
								   request.getParameter("mname"),
								   request.getParameter("memail"),
								   request.getParameter("mpnum"));
			
			if(nResult == 1) {
				obj.put("code", "success");
				obj.put("desc", "회원가입 성공");
			} else {
				obj.put("code", "fail");
				obj.put("desc", "회원가입 실패");
			}
			
			return obj.toJSONString();			
		}		
	}	
	
	@GetMapping("/success")
	public String joinsuccess() {
		return "/join/success";
	}
	
}
