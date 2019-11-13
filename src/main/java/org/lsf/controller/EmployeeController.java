package org.lsf.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.lsf.pojo.Employee;
import org.lsf.pojo.Msg;
import org.lsf.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;


@Controller(value = "employeeController")
@RequestMapping(value = "/EMPController")
public class EmployeeController {

    @Autowired
    @Qualifier(value = "employeeService")
    EmployeeService employeeService;

    @RequestMapping("/emps")
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

    /*@RequestMapping("/emps")
    @ResponseBody
    */public Msg getEmpWithJson(@RequestParam(value = "pageNumber",defaultValue = "1") Integer pageNumber){

        //引入分页查询,传递 页码 和 分页大小
        PageHelper.startPage(pageNumber,5);
        List<Employee> emps = employeeService.getAll();
        //用PageInfo包装查询后的结果
        PageInfo pi = new PageInfo(emps,5);

        return Msg.success().add("pageInfo",pi);
    }



    /*用于简单测试*/
    @RequestMapping(value = "/test")
    public String test01(){
        System.out.println("你好");
        return "test";
    }
}
