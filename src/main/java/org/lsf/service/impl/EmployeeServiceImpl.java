package org.lsf.service.impl;

import org.lsf.dao.EmployeeMapper;
import org.lsf.pojo.Department;
import org.lsf.pojo.Employee;
import org.lsf.pojo.EmployeeExample;
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

    public Employee isExit(Employee employee){
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andEmpNameEqualTo(employee.getEmpName());
        criteria.andEmailEqualTo(employee.getEmpName());
        criteria.andGenderEqualTo(employee.getGender());
        criteria.andDIdEqualTo(employee.getdId());
        return (Employee)employeeMapper.selectByExample(employeeExample);
    }
    @Override
    public void saveEmp(Employee employee){
        employeeMapper.insertSelective(employee);
    }

    @Override
    public boolean checkEmpName(String empName) {
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        criteria.andEmpNameEqualTo(empName);
        long count = employeeMapper.countByExample(employeeExample);
        return count == 0;
    }
}
