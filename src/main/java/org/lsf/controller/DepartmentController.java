package org.lsf.controller;

import org.lsf.pojo.Department;
import org.lsf.pojo.Msg;
import org.lsf.service.DepartmentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.List;

@Controller(value = "departmentController")
@RequestMapping(value = "/DEPTController")
public class DepartmentController {

    @Autowired
    @Qualifier("departmentService")
    DepartmentService departmentService;

    @RequestMapping("/查询部门信息")
    @ResponseBody
    public Msg getAllDeptWithJson(){
        List<Department> depts = new ArrayList<>();
        depts = departmentService.getAllDepts();
        return Msg.success().add("depts",depts);
    }
}
