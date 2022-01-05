package com.ykq.crm.settings.service;

import com.ykq.crm.exception.MyException;
import com.ykq.crm.settings.pojo.User;

public interface UserService {
    User userLogin(User user) throws MyException;
}
