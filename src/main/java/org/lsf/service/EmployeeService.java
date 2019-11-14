package org.lsf.service;

import org.lsf.pojo.Department;
import org.lsf.pojo.Employee;

import java.util.List;

public interface EmployeeService {
    public List<Employee> getAll();
    public Employee querybyID(Integer id);
}
