package com.study.springboot.navermap.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Service;
import org.springframework.ui.Model;

import com.study.springboot.dao.AddrDao;
import com.study.springboot.dto.AddrDto;
import com.study.springboot.dto.AddrTempDto;
import com.study.springboot.dto.MenuDto;
//import com.example.restaurant.wishlist.repository.WishListRepository;
import com.study.springboot.navermap.NaverClient;
import com.study.springboot.navermap.dto.AddressReq;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MapService {

    private final NaverClient naverClient;
    
    private final AddrDao addrDao;
        
    public String addrSearch(String query, Model model, HttpServletRequest request) throws ParseException{
    	System.out.println("service");

        // 지역 검색
        var addrReq = new AddressReq();
        addrReq.setQuery(query);

        var searchAddrRes = naverClient.searchAddr(addrReq);
        System.out.println(searchAddrRes);        
        
        JSONParser jsonParser = new JSONParser();

        Object obj = jsonParser.parse(searchAddrRes);

        JSONObject jsonObj = (JSONObject) obj;
        
        JSONArray jsonAddr = (JSONArray) jsonObj.get("addresses");
        
        JSONObject tempObj = (JSONObject) jsonAddr.get(0);
        
        System.out.println("x : " + tempObj.get("x"));
        System.out.println("y : " + tempObj.get("y"));
        
        model.addAttribute("x", tempObj.get("x"));
        model.addAttribute("y", tempObj.get("y"));
        
        JSONObject result = new JSONObject();
        
        result.put("x", tempObj.get("x"));
        result.put("y", tempObj.get("y"));

        return result.toJSONString();
    }
    
    public int getAddr_CoorUpdate() throws ParseException {
    	
    	int nResult = 0;
    	
    	boolean ing = true;
    	
    	List<AddrTempDto> addrList = null; 
    	boolean bStreet = true;
    	String addr = "";
    	
    	while(ing) {
    	
	    	addrList = addrDao.getAddr();
	    	if(addrList.isEmpty()) break;	    	
	    	
	    	try
			{
	    		
	    		for(int i=0; i<addrList.size(); i++) {
	    			bStreet = true;
	    			
	        		AddrTempDto addrInfo = addrList.get(i);
	        		
	        		System.out.println(addrInfo.getAddrstreet() + " (s) / (d) " + addrInfo.getAddrdong());
	        		if(!addrInfo.getAddrstreet().equals("nan")) {        			
	        			System.out.println("Street");
	        			addr=addrInfo.getAddrstreet();        			
	        		}
	        		else {
	        			System.out.println("Dong");
	        			addr = addrInfo.getAddrdong();
	        			bStreet = false;
	        		}
	        		System.out.println(addr);
	        		Map<String, String> xy = getCoor(addr);
	        		String x = xy.get("x");
	        		String y = xy.get("y");
	        		int count = 0;
	        		if(bStreet==true) count = addrDao.updateLocDataStreet(x, y, addr);
	        		else  count = addrDao.updateLocDataDong(x, y, addr);
	        		nResult += count;
	        	}
			} catch (Exception e)
			{
				int deleteCount = 0;
				e.printStackTrace();
				if(bStreet==true) deleteCount = addrDao.deleteClosedStreet(addr);
	    		else  deleteCount = addrDao.deleteClosedDong(addr);
				System.out.println("deleted : " + deleteCount);
				continue;
			}
    	}
    	
    	System.out.println("All done!");
    
    	return nResult;
    }
    
    private Map<String, String> getCoor(String addr) throws ParseException {
    	Map<String, String> xy = new HashMap<String, String>();
    	
    	var addrReq = new AddressReq();
        addrReq.setQuery(addr);

        var searchAddrRes = naverClient.searchAddr(addrReq);
        System.out.println(searchAddrRes);        
        
        JSONParser jsonParser = new JSONParser();

        Object obj = jsonParser.parse(searchAddrRes);

        JSONObject jsonObj = (JSONObject) obj;
        
        JSONArray jsonAddr = (JSONArray) jsonObj.get("addresses");
        
        JSONObject tempObj = (JSONObject) jsonAddr.get(0);
        
        System.out.println("x : " + tempObj.get("x"));
        System.out.println("y : " + tempObj.get("y"));
        
        xy.put("x", tempObj.get("x").toString());
        xy.put("y", tempObj.get("y").toString());
        
    	return xy;
    }
    
    public int getRandom() {
    	List<String> list = addrDao.getName();
    	Random random = new Random();
    	int nResult = 0;
    	for(String name : list) {
    		int num1 = random.nextInt(6);        
            int num2 = random.nextInt(10);
            String score = "";
            if(num1 == 5) score = "5.0";
            else score = String.valueOf(num1) + "." + String.valueOf(num2);
            System.out.println(name + " : " + score);            
            int count = addrDao.addRandomScore(score, name);
            nResult += count;
            System.out.println(nResult);
    	}
        
    	return nResult;
    }
    
    public List<AddrDto> getAroundCafe(String swLat, String neLat, String swLon, String neLon, boolean bBroad) {
    	
    	List<AddrDto> list = addrDao.getAroundCafe(swLat, neLat, swLon, neLon);
    	
    	if(bBroad) {
    		System.out.println(111);
    		if(list.size() > 40) {
    			System.out.println(222);    			
        		for(int i=list.size()-1; i>39; i--) {        			        			
        			list.remove(i);        			
        		}
        	}
    	}
    	
    	System.out.println("list size : " + list.size());
    	
    	return list;
    }
    
    public int addMenu() {
    	int nResult = 0;
    	String[] coffeeList = {"에스프레소", "아메리카노", "카페라떼", "카푸치노", "카페모카", "카라멜 마키아토", "바닐라 라떼", "에스프레소 샤케라또", "아포가토"};
    	int[] coffeePrice = {3000, 3500, 4000, 4000, 4500, 5000, 5000, 5500, 6000};
    	String[] adeList = {"레몬에이드", "자몽에이드", "블루베리에이드"};
    	int[] adePrice = {4500, 4500, 4500};
    	String[] juiceList = {"딸기 바나나 쥬스", "한라봉 쥬스", "오미자 쥬스"};
    	int[] juicePrice = {5000, 5000, 5000};
    	String[] teaList = {"잉글리쉬 브렉퍼스트 티", "캐모마일 티", "민트 티", "얼그레이 티", "히비스커스 티"};
    	int[] teaPrice = {4000, 4000, 4000, 4000, 4000};
    	
    	for(int i=1; i<15580+1; i++) {
    		for(int w=0; w<teaList.length; w++) addrDao.updateMenu(i, teaList[w], teaPrice[w], "tea");
    		for(int x=0; x<coffeeList.length; x++) addrDao.updateMenu(i, coffeeList[x], coffeePrice[x], "coffee");
    		for(int y=0; y<adeList.length; y++) addrDao.updateMenu(i, adeList[y], adePrice[y], "ade");
    		for(int z=0; z<juiceList.length; z++) addrDao.updateMenu(i, juiceList[z], juicePrice[z], "juice");    		
    		nResult += 1;
    		System.out.println(nResult); 
    	}    	
    	return nResult;
    }
    
    public List<MenuDto> getMenu(String cno) {    	
    	return addrDao.getMenu(cno);
    }
}