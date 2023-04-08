package com.study.springboot.navermap;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

import com.study.springboot.navermap.dto.AddressReq;
import com.study.springboot.navermap.dto.AddressRes.SearchAddrItem;
import com.study.springboot.navermap.dto.SearchImageReq;
import com.study.springboot.navermap.dto.SearchImageRes;
import com.study.springboot.navermap.dto.SearchLocalReq;
import com.study.springboot.navermap.dto.SearchLocalRes;

@Component
public class NaverClient {

    // yaml 파일 사용하는데 @Value 어노테이션을 사용하며
    // 내부에 "${}"형태로 yaml에 설정한 대로 기입
    @Value("${naver.client.id}")
    private String naverClientId;

    @Value("${naver.client.secret}")
    private String naverSecret;
    
    @Value("${naver.client.addrId}")
    private String naverAddrClientId;

    @Value("${naver.client.addrSecret}")
    private String naverAddrSecret;

    @Value("${naver.url.search.local}")
    private String naverLocalSearchUrl;

    @Value("${naver.url.search.image}")
    private String naverImageSearchUrl;
    
    @Value("${naver.url.search.address}")
    private String naverAddrSearchUrl;

    public SearchLocalRes searchLocal(SearchLocalReq searchLocalReq) {
        var uri = UriComponentsBuilder
                .fromUriString(naverLocalSearchUrl)
                .queryParams(searchLocalReq.toMultiValueMap())
                .build()
                .encode()
                .toUri();
        
        System.out.println("uri : " + uri);

        var headers = new HttpHeaders();
        headers.set("X-Naver-Client-Id", naverClientId);
        headers.set("X-Naver-Client-Secret", naverSecret);
        headers.setContentType(MediaType.APPLICATION_JSON);
        
        System.out.println(headers);

        var httpEntity = new HttpEntity<>(headers);
        var responseType = new ParameterizedTypeReference<SearchLocalRes>(){};


        var responseEntity = new RestTemplate()
                                    .exchange(
                                            uri,
                                            HttpMethod.GET,
                                            httpEntity,
                                            responseType
                                    );
        
        System.out.println(responseEntity);

        return responseEntity.getBody();
    }
    
    
    public String searchAddr(AddressReq addrReq) {
        var uri = UriComponentsBuilder
                .fromUriString(naverAddrSearchUrl)
                .queryParams(addrReq.toMultiValueMap())
                .build()
                .encode()
                .toUri();
                
        var headers = new HttpHeaders();
        headers.set("X-NCP-APIGW-API-KEY-ID", naverAddrClientId);
        headers.set("X-NCP-APIGW-API-KEY", naverAddrSecret);
        headers.setContentType(MediaType.APPLICATION_JSON);
        
        var httpEntity = new HttpEntity<>(headers);
        var responseType = new ParameterizedTypeReference<String>(){};
        
        

        try
		{
            var responseEntity = new RestTemplate()
                    .exchange(
                            uri,
                            HttpMethod.GET,
                            httpEntity,
                            responseType
                    );
            System.out.println(responseEntity);
		} catch (Exception e)
		{
			e.printStackTrace();
		}
        var responseEntity = new RestTemplate()
                .exchange(
                        uri,
                        HttpMethod.GET,
                        httpEntity,
                        responseType
                );
        System.out.println(responseEntity);

        return responseEntity.getBody();
    }

    public SearchImageRes searchImage(SearchImageReq searchImageReq) {
        var uri = UriComponentsBuilder
                .fromUriString(naverImageSearchUrl)
                .queryParams(searchImageReq.toMultiValueMap())
                .build()
                .encode()
                .toUri();

        var headers = new HttpHeaders();
        headers.set("X-Naver-Client-Id", naverClientId);
        headers.set("X-Naver-Client-Secret", naverSecret);
        headers.setContentType(MediaType.APPLICATION_JSON);

        var httpEntity = new HttpEntity<>(headers);
        var responseType = new ParameterizedTypeReference<SearchImageRes>(){};


        var responseEntity = new RestTemplate()
                .exchange(
                        uri,
                        HttpMethod.GET,
                        httpEntity,
                        responseType
                );

        return responseEntity.getBody();
    }
}