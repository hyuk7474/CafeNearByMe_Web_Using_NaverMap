package com.study.springboot;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.study.springboot.navermap.NaverClient;
import com.study.springboot.navermap.dto.SearchImageReq;
import com.study.springboot.navermap.dto.SearchLocalReq;
import com.study.springboot.navermap.dto.SearchLocalRes.SearchLocalItem;

@Controller
public class NaverMapController {

    @Autowired
    private NaverClient naverClient;
    
    

    @RequestMapping("/map/search")
    public @ResponseBody String searchLocalTest() {

        var search = new SearchLocalReq();
        search.setQuery("갈비집");

        var result = naverClient.searchLocal(search);
                
        List<SearchLocalItem> items = result.getItems();
                
        Map<String, Object> totData = new HashMap<>();
        
        for(SearchLocalItem item : items) {
        	Map<String, Object> data = new HashMap<>();
        	data.put("title", item.getTitle());
        	data.put("link", item.getLink());
        	data.put("category", item.getCategory());
        	data.put("description", item.getDescription());
        	data.put("telephone", item.getTelephone());
        	data.put("address", item.getAddress());
        	data.put("roadAddress", item.getRoadAddress());
        	data.put("mapx", item.getMapx());
        	data.put("mapy", item.getMapy());
        	totData.put(item.getTitle(), data);
        }
        
        JSONObject obj = new JSONObject();
        obj.put("code","success");
		obj.put("desc","검색 정보를 불러왔습니다.");
        obj.put("totData", totData);
        
        
        
        
        return obj.toJSONString();        
    }

    @RequestMapping("/map/image")
    public void searchImageTest() {

        var search = new SearchImageReq();
        search.setQuery("갈비집");

        var result = naverClient.searchImage(search);
        System.out.println(result);
        System.out.println(result.getClass().getName());
    }
}