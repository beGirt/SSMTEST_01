package org.lsf.service.impl;

import org.lsf.dao.EmployeeMapper;
import org.lsf.pojo.Employee;
import org.lsf.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("employeeService")
public class EmployeeServiceImpl implements EmployeeService {

    @Autowired
    @Qualifier("employeeMapper")
    EmployeeMapper employeeMapper;

    /*
     * 查询所有员工
     */
    @Override
    public List<Employee> getAll(){
        return employeeMapper.selectByExampleWithDept(null);
    }

    @Override
    public Employee querybyID(Integer id) {
        return employeeMapper.selectByPrimaryKeyWithDept(id);
    }
}
