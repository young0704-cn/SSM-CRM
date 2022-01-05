package com.ykq.crm.settings.controller;

import com.ykq.crm.exception.MyException;
import com.ykq.crm.settings.pojo.User;
import com.ykq.crm.settings.service.UserService;
import com.ykq.crm.utils.MD5Util;
import com.ykq.crm.utils.PrintJson;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/settings")
public class UserController {
    @Autowired
    public UserService service;

    @RequestMapping("/login.action")
    @ResponseBody
    public String login(User user, HttpServletRequest request){
        /*
        接收登录页面传来的 user 和 请求对象
        为了安全起见用户登录密码采用MD5加密，在这需要将明文转为密文去数据库中查找
        request.getRemoteAddr()获取请求对象的ip地址，对比是否有访问权限
        */
        String loginPwd= MD5Util.getMD5(user.getLoginPwd());
        user.setAllowIps(request.getRemoteAddr());
        user.setLoginPwd(loginPwd);

        String json="";
        try {
            User userLogin=service.userLogin(user);
            request.getSession().setAttribute("user",userLogin);
            //执行到此，登录成功
            json=PrintJson.printJsonFlag(true);
        } catch (MyException e) {
            String wrong=e.getMessage();
            //执行到此，登录失败             如果抛出异常,代表Service业务层执行失败。即登录失败
            Map<String,Object> map=new HashMap<>();
            map.put("success",false);
            map.put("msg",wrong);
            json=PrintJson.printJsonObj(map);
        }
        return json;
    }
}
