package org.lsf.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.lsf.pojo.Department;
import org.lsf.pojo.Employee;
import org.lsf.pojo.Msg;
import org.lsf.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.util.ArrayList;
import java.util.List;


@Controller(value = "employeeController")
@RequestMapping(value = "/EMPController")
public class EmployeeController {

    @Autowired
    @Qualifier(value = "employeeService")
    EmployeeService employeeService;

    //@RequestMapping("/emps")
    public ModelAndView getEmps(@RequestParam(value = "pageNumber",defaultValue = "1") Integer pageNumber) {
        ModelAndView mav = new ModelAndView("list");

        //引入分页查询,传递 页码 和 分页大小
        PageHelper.startPage(pageNumber,5);
        List<Employee> emps = employeeService.getAll();
        //用PageInfo包装查询后的结果
        PageInfo pi = new PageInfo(emps,5);
        //传递page对象
        mav.addObject("pageInfo", pi);


        return mav;
    }


    /*查询 ajax*/

    @RequestMapping(value = "/emps",method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmpWithJson(@RequestParam(value = "pageNumber",defaultValue = "1") Integer pageNumber){

        //引入分页查询,传递 页码 和 分页大小
        PageHelper.startPage(pageNumber,5);
        List<Employee> emps = employeeService.getAll();
        //用PageInfo包装查询后的结果
        PageInfo pi = new PageInfo(emps,5);

        return Msg.success().add("pageInfo",pi);
    }



    @RequestMapping(value = "/emps",method = RequestMethod.POST)
    @ResponseBody
    public Msg addEmpWithJson(Employee employee){
        employeeService.saveEmp(employee);
        return Msg.success();
    }


    //用于校验用户名是否可用
    @RequestMapping(value = "/checkEmpName",method = RequestMethod.GET)
    @ResponseBody
    public Msg checkEmpName(@RequestParam("empName") String empName){
        boolean b = employeeService.checkEmpName(empName);
        if (b){
            return Msg.success();
        } else {
            return Msg.fail();
        }
    }


    /*用于简单测试*/
    @RequestMapping(value = "/test")
    public String test01(){
        System.out.println("你好");
        return "test";
    }
}
