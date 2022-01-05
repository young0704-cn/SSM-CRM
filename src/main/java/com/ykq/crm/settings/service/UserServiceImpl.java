package com.ykq.crm.settings.service;

import com.ykq.crm.exception.MyException;
import com.ykq.crm.settings.mapper.UserDao;
import com.ykq.crm.settings.pojo.User;
import com.ykq.crm.utils.DateTimeUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserServiceImpl implements UserService{

    @Autowired
    public UserDao mapper;

    @Override
    public User userLogin(User user) throws MyException{

        User u=mapper.login(user);
        if (u==null){
            throw new MyException("账号密码不正确");
        }

        String expireTime=u.getExpireTime();
        String currentTime= DateTimeUtil.getSysTime();
        if(currentTime.compareTo(expireTime)>0){
            throw new MyException("账号已失效");
        }

        if ("0".equals(u.getLockState())){
            throw new MyException("账号处于冻结状态");
        }

        String allowIps=u.getAllowIps();
        if(!allowIps.contains(user.getAllowIps())){
            throw new MyException("ip"+user.getAllowIps()+"无权访问");
        }

        return u;
    }
}
