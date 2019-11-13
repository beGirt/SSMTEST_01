package org.test;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.lsf.dao.DepartmentMapper;
import org.lsf.dao.EmployeeMapper;
import org.lsf.pojo.Department;
import org.lsf.pojo.Employee;
import org.lsf.pojo.EmployeeExample;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.UUID;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml","classpath:spring/applicationContext-*.xml"})
public class MapperTest {
    @Autowired
    @Qualifier("departmentMapper")
    DepartmentMapper departmentMapper;

    @Autowired
    @Qualifier("employeeMapper")
    EmployeeMapper employeeMapper;

    @Autowired
    @Qualifier("sqlSession")
    SqlSession sqlSession;


    @Test
    public void DeptMapperTest() {
    /*    System.out.println(employeeMapper);
        Employee employee = new Employee();
        employee.setEmpName("林盛锋");
        employee.setGender("M");
        employee.setEmail("1134187280@qq.com");
        employee.setdId(1);

        employeeMapper.insertSelective(employee);
    */
        Department department = new Department();
        department.setDeptName("开发部");
        departmentMapper.insertSelective(department);
    }

    @Test
    public void EmployeeMapperTest() {
//        Employee employee = employeeMapper.selectByPrimaryKeyWithDept(2);
/*
        System.out.println(employee.getEmpName()+" "+employee.getdId());
        System.out.println(employee.getDepartment().getDeptName());
*/
        /*Employee employee1 = new Employee();
        employee1.setEmpId(1);
        employee1.setEmail("xuhailin@qq.com");
        employee1.setGender("M");
        employee1.setEmpName("徐海林");
        employee1.setdId(2);*/
/*
        employeeMapper.insertSelective(employee1);
*//*
        employeeMapper.deleteByPrimaryKey(3);
        employeeMapper.insertSelective(employee1);*/
       // init();
//        delete();
        queryByid();
    }

    public void delete(){
        EmployeeExample employeeExample = new EmployeeExample();
        EmployeeExample.Criteria criteria = employeeExample.createCriteria();
        /*List<String> list = new ArrayList<>();
        list.add("@lsf.com");
        criteria.andEmailIn(list);
        */criteria.andEmpIdBetween(1004,1023);
        employeeMapper.deleteByExample(employeeExample);
    }
    public void queryByid(){
        Employee employee = employeeMapper.selectByPrimaryKeyWithDept(1);
        System.out.println(employee.getEmpId() +" " + employee.getEmpName());
    }
    public void init(){
        EmployeeMapper BATCH_mapper = sqlSession.getMapper(EmployeeMapper.class);
        for (int i = 0; i < 3; i++) {
            String name = UUID.randomUUID().toString().substring(0,5) + i;
            int random = new Random().nextInt( 2 ) + 1;
            BATCH_mapper.insertSelective(new Employee(null, name,"M",name+"@lsf.com", random));
            BATCH_mapper.insertSelective(new Employee(null, name,"G",name+"@lsf.com", random));
        }
    }
}