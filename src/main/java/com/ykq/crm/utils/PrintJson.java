package com.ykq.crm.utils;

import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class PrintJson {

	//将boolean值解析为json串
	public static String printJsonFlag(boolean flag){

		Map<String,Boolean> map = new HashMap<String,Boolean>();
		map.put("success",flag);

		ObjectMapper om = new ObjectMapper();
		try {
			//{"success":true}
			return om.writeValueAsString(map);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	//将对象解析为json串
	public static String printJsonObj(Object obj){

		/*
		 *
		 * Person p
		 * 	id name age
		 * {"id":"?","name":"?","age":?}
		 *
		 * List<Person> pList
		 * [{"id":"?","name":"?","age":?},{"id":"?","name":"?","age":?},{"id":"?","name":"?","age":?}...]
		 *
		 * Map
		 * 	key value
		 * {key:value}
		 *
		 *
		 */

		ObjectMapper om = new ObjectMapper();
		try {
			return  om.writeValueAsString(obj);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
}























