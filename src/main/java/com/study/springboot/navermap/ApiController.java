package com.study.springboot.navermap;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONObject;
import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.study.springboot.dto.AddrDto;
import com.study.springboot.dto.MenuDto;
import com.study.springboot.navermap.service.MapService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/map")
@RequiredArgsConstructor
public class ApiController {
	
	private final MapService mapService;
	
	@GetMapping("")
	public String test2(HttpServletRequest request) {
		JSONObject obj = new JSONObject();
		Map<String, String> latlng = new HashMap<String, String>();
		latlng.put("lat", "37.5621393");
		latlng.put("lon", "126.9753446");
		obj.put("data", latlng);
		
		String jsonMemberData = (String)request.getAttribute("jsonMemberData");
		System.out.println(jsonMemberData);
		
		request.setAttribute("data", obj.toJSONString());
		return "map/map";
	}
	
	@GetMapping("/addr")
    public String addrSearch(@RequestParam String query, Model model, HttpServletRequest request) throws ParseException {    	
    	System.out.println("controller");    	
    	mapService.addrSearch(query, model, request);
    	System.out.println("!!");
    	return "/map/map";
    }
	
	@PostMapping("/getAround")
	public @ResponseBody String getAroundCafe(@RequestParam String swLat, @RequestParam String swLon, @RequestParam String neLat, @RequestParam String neLon, @RequestParam boolean bBroad) {
		System.out.println("bBroad : " + bBroad);
		System.out.println(swLat + " / " + neLat + " / " + swLon + " / " + neLon);
		List<AddrDto> list = mapService.getAroundCafe(swLat, neLat, swLon, neLon, bBroad);
		Map<Integer, Map<String, String>> datas = new HashMap<>();
		System.out.println(list.size());
		int i = 0;
		for(AddrDto dto : list) {
			Map<String, String> data = new HashMap<>();
			data.put("name", dto.getName());
			data.put("addrdong", dto.getAddrdong());
			data.put("addrstreet", dto.getAddrstreet());
			data.put("lat", dto.getLat());
			data.put("lon", dto.getLon());
			data.put("score", dto.getScore());
			data.put("cno", dto.getCno());
			datas.put(i, data);
			i++;
		}		
		JSONObject obj = new JSONObject();
		if(list.size()>0) {
			obj.put("datas", datas);
			obj.put("code", "success");
			obj.put("desc", "주변 카페 정보를 불러왔습니다.");
		} else {
			obj.put("code", "non exist");
			obj.put("desc", "주변 카페 정보가 없습니다.");
		}
		
		return obj.toJSONString();				
	}
	
	@PostMapping("/getmenu")
	public @ResponseBody String getMenu(@RequestParam String cno) {
		List<MenuDto>dtos = mapService.getMenu(cno);
		Map<String, Object> datas = new HashMap<>();
		int nResult = 0;
		if(!dtos.isEmpty()) {
			for(MenuDto dto : dtos ) {
				Map<String, Object> drink = new HashMap<>();
				drink.put("cno", dto.getCno());
				drink.put("menu", dto.getMenu());
				drink.put("price", dto.getPrice());
				drink.put("soldout", dto.getSoldout());
				drink.put("kind", dto.getKind());
				datas.put(dto.getMenu(), drink);
			}
			nResult = 1;
		}		
		
		JSONObject obj = new JSONObject();
		if(nResult==1) {
			obj.put("code", "success");
			obj.put("desc", "메뉴를 불러왔습니다.");
			obj.put("datas", datas);
		} else {
			obj.put("code", "fail");
			obj.put("desc", "메뉴가 없습니다.");
		}
		
		return obj.toJSONString();
	}
}