package com.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONObject;
import org.springframework.web.client.RestTemplate;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class restApiUtil {
	
	private static int TIME_OUT = 5000;
	
	/**
     * REST API 호출 GET
     *  
     * @param paramUrl
     * @param jsonObject void
     */
	@SuppressWarnings("unchecked")
	public static List<Map<String, Object>> getRestCall(String paramUrl,JSONObject jsonObject){
		Map<String, Object> result = null;
    	
		try {
    		
            HttpURLConnection conn = (HttpURLConnection) new URL(paramUrl).openConnection();
            conn.setConnectTimeout(TIME_OUT);
            conn.setReadTimeout(TIME_OUT);
            conn.setRequestMethod("GET");
            conn.setRequestProperty("X-Auth-Token", "API_KEY");            
            conn.setRequestProperty("X-Data-Type", "application/json");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(false);

            RestTemplate restTemplate = new RestTemplate();
            
            result = restTemplate.getForEntity(paramUrl, Map.class).getBody();
            
            if (conn.getResponseCode() != 200) {
            	throw new RuntimeException("Failed: HTTP error code : " + conn.getResponseCode());
            } else {
                log.info("API ACCESS SUCCESE DATA : " + result);
            }
            
            conn.disconnect();
            
        } catch (IOException e) {
        	log.info("getRestCall Fail : " + e.getMessage());
        }
		
		return (List<Map<String, Object>>) result.get("object");
    }
    
    /**
     * REST API 호출 POST
     *  
     * @param paramUrl
     * @param jsonObject void
     */
	@SuppressWarnings("unchecked")
	public static List<Map<String, Object>> postRestCall(String paramUrl,JSONObject jsonObject){
		Map<String, Object> result = null;
		
    	try {
    		HttpURLConnection conn = (HttpURLConnection) new URL(paramUrl).openConnection();
    		
            conn.setConnectTimeout(TIME_OUT);
            conn.setReadTimeout(TIME_OUT);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("X-Auth-Token", "API_KEY");            
            conn.setRequestProperty("X-Data-Type", "application/json");
            conn.setRequestProperty("Content-Type", "application/json");
            conn.setDoOutput(true);		//URL 연결을 출력용으로 사용, POST 파라미터 전달을 위한 설정 (쓰기모드)

//            OutputStreamWriter osw = new OutputStreamWriter(conn.getOutputStream(),"UTF-8");
//            osw.write(jsonObject.toString());
//            osw.flush();
//            osw.close();
            
            RestTemplate restTemplate = new RestTemplate();
            
            result = restTemplate.postForEntity(paramUrl, jsonObject, Map.class).getBody();
            
            if (conn.getResponseCode() != 200) {
            	throw new RuntimeException("Failed: HTTP error code : " + conn.getResponseCode());
            } else {
                log.info("API ACCESS SUCCESE DATA : " + result);
            }
            
            conn.disconnect();
            
        } catch (IOException e) {
            log.info("RestCall Fail : " + e.getMessage());
        }
    	
    	return (List<Map<String, Object>>) result.get("object");
    }
}
