package com.study.springboot.navermap.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AddressReq {
    
    private String query = "";

    private String coordinate = "127.1052133, 37.3595316";

//    private String  filter = "";
//
//    private int page = 1;
//
//    private int count = 10;

    public MultiValueMap<String, String> toMultiValueMap() {
        var map = new LinkedMultiValueMap<String, String>();

        map.add("query", query);
        map.add("coordinate", coordinate);
		/*
		 * map.add("filter", filter); map.add("page", String.valueOf(page));
		 * map.add("count", String.valueOf(count));
		 */

        return map;

    }
}