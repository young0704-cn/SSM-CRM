package com.ykq.crm.interceptor;

import com.ykq.crm.settings.pojo.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.*;
import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebListener
public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        //登录页放行
        if ("/settings/login.action".equals(request.getServletPath())){
            return true;
        }
        //session中有admin对象放行
        if (request.getSession().getAttribute("user")!=null){
            return true;
        }

        //请求转发到登录页
        response.sendRedirect(request.getContextPath()+"/login.jsp");
        return false;
    }
}
