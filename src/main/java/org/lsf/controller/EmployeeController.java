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
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.validation.Valid;
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
    public Msg addEmpWithJson(@Valid Employee employee, BindingResult bindingResult){
        if (bindingResult.hasErrors()){
            List<FieldError> fieldErrors = bindingResult.getFieldErrors();
            for (FieldError fieldError : fieldErrors){
                System.out.println("错误的字段名:"+fieldError.getField());
                System.out.println("错误的信息:"+fieldError.getDefaultMessage());
            }
            return Msg.fail();
        } else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }


    //用于校验用户名是否可用
    @RequestMapping(value = "/checkEmpName",method = RequestMethod.GET)
    @ResponseBody
    public Msg checkEmpName(@RequestParam("empName") String empName){

        //第一步判断用户名是否合法
        String regx = "(^[a-zA-Z0-9_-]{3,16}$)|(^[\\u2E80-\\u9FFF]{2,5}$)";
        if (!empName.matches(regx)){
            return Msg.fail().add("va_msg","姓名格式不合法");
        }


        //第二步判断用户名是否重复
        boolean b = employeeService.checkEmpName(empName);
        if (b){
            return Msg.success();
        } else {
            return Msg.fail().add("va_msg","该姓名不可用(重复)");
        }

    }


    /*用于简单测试*/
    @RequestMapping(value = "/test")
    public String test01(){
        System.out.println("你好");
        return "test";
    }
}
