package org.lsf.dao;

import java.util.List;
import org.apache.ibatis.annotations.Param;
import org.lsf.pojo.Employee;
import org.lsf.pojo.EmployeeExample;
import org.springframework.stereotype.Repository;

@Repository(value = "employeeMapper")
public interface EmployeeMapper {

    /*
     * 添加的方法
     */
    List<Employee> selectByExampleWithDept(EmployeeExample example);
    Employee selectByPrimaryKeyWithDept(Integer empId);

    long countByExample(EmployeeExample example);

    int deleteByExample(EmployeeExample example);

    int deleteByPrimaryKey(Integer empId);

    int insert(Employee record);

    int insertSelective(Employee record);

    List<Employee> selectByExample(EmployeeExample example);

    Employee selectByPrimaryKey(Integer empId);

    int updateByExampleSelective(@Param("record") Employee record, @Param("example") EmployeeExample example);

    int updateByExample(@Param("record") Employee record, @Param("example") EmployeeExample example);

    int updateByPrimaryKeySelective(Employee record);

    int updateByPrimaryKey(Employee record);
}