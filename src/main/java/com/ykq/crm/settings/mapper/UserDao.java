package com.ykq.crm.settings.mapper;

import com.ykq.crm.settings.pojo.User;

import java.util.List;

public interface UserDao {
    User login(User user);
    List<User> getAll();
}
