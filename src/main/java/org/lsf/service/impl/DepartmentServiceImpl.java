package org.lsf.service.impl;

import org.lsf.dao.DepartmentMapper;
import org.lsf.pojo.Department;
import org.lsf.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.util.List;

@Service(value = "departmentService")
public class DepartmentServiceImpl implements DepartmentService {
    @Autowired
    @Qualifier("departmentMapper")
    DepartmentMapper departmentMapper;

    @Override
    public List<Department> getAllDepts() {
        return departmentMapper.selectByExample(null);
    }
}
