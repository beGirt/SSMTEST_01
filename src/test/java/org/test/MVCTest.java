package org.test;

import com.github.pagehelper.PageInfo;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.lsf.pojo.Employee;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

/*
 * 使用Spring单元测试
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:applicationContext.xml","classpath:springmvc.xml","classpath:spring/applicationContext-*.xml","classpath:applicationContext-test.xml"})
public class MVCTest {
    //传入SpringMVC的IoC容器
    @Autowired
    WebApplicationContext mvcContext;

    //虚拟MVC请求,获取处理结果.
    MockMvc mocMvc;

    @Before
    public void initMokcMvc() {
        mocMvc = MockMvcBuilders.webAppContextSetup(mvcContext).build();
    }

    @Test
    public void testPage() throws Exception{
        MvcResult result01 = mocMvc.perform(MockMvcRequestBuilders.get("/EMPController/emps").param("pageNumber", "1")).andReturn();
        MockHttpServletRequest request =  result01.getRequest();
        PageInfo pi = (PageInfo) request.getAttribute("pageInfo");
        //验证
        System.out.println("当前页码:"+pi.getPageNum());
        System.out.println("总页码:" + pi.getPages());
        System.out.println("总记录数:"+pi.getTotal());
        System.out.println("连续显示的页码:");
        int[] nums = pi.getNavigatepageNums();
        for (int num : nums) {
            System.out.print(" "+ num);
        }

        //获取员工数据
        for (Employee emp : (List<Employee>)pi.getList()) {
            System.out.println("Name:" + emp.getEmpName() + "==>>" + emp.getEmail());
        }
    }
}
