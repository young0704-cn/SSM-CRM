package com.ykq.crm.settings.mapper;

import com.ykq.crm.settings.pojo.DicValue;

import java.util.List;

public interface DicValueDao {
    List<DicValue> getValue(String code);
}
