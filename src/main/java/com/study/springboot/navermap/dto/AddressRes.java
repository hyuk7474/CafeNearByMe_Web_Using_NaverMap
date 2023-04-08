package com.study.springboot.navermap.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AddressRes {

    // 지역 검색 출력 결과를 변수화

    private String lastBuildDate;
    private int total;
    private int start;
    private int display;
    private List<SearchAddrItem> items;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class SearchAddrItem{
    	private String status;
    	private String errorMessage;
    	private List<String> addresses;    	
        private Object meta;        
    }
}