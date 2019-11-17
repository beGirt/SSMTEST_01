<%@ page import="jdk.nashorn.internal.ir.RuntimeNode" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"  prefix="c"%>
<!DOCTYPE html>
<html>
<head>

    <%--
     <meta charset="utf-8">
     <meta http-equiv="X-UA-Compatible" content="IE=edge">
     <meta name="viewport" content="width=device-width, initial-scale=1">
    --%>

    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <!-- web路径
        不以/开始的相对路径,找资源,以当前资源的路径为基准
        以/开始的相对路径,找资源,以服务器的路径为基准(http://localhost:3306)
     -->
    <%  pageContext.setAttribute("APP_PATH",request.getContextPath()); %>

    <!-- Bootstrap -->
    <!-- 引入css样式 -->
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- jQuery (Bootstrap 的所有 JavaScript 插件都依赖 jQuery，所以必须放在前边) -->
    <script src="${APP_PATH}/static/js/jquery.min.js"></script>
    <!-- 加载 Bootstrap 的所有 JavaScript 插件。你也可以根据需要只加载单个插件。 -->
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>

    <title>员工列表</title>
</head>
<body>
    <%--模态框,即弹出的页面:新增按钮--%>
    <!-- Modal -->
    <div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="myModalLabel">Modal title</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" id="save_emp_form">
                        <div class="form-group">
                            <label for="empName_add" class="col-sm-2 control-label">empName</label>
                            <div class="col-sm-10">
                                <input type="text" class="form-control" id="empName_add" name="empName" placeholder="林盛锋" aria-describedby="helpBlock1">
                                <span id="helpBlock1" class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="email_add" class="col-sm-2 control-label">email</label>
                            <div class="col-sm-10">
                                <input type="text" class="form-control" id="email_add" name = "email" placeholder="emil@emai.com" aria-describedby="helpBlock2">
                                <span id="helpBlock2" class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">gender</label>
                            <div class="col-sm-10">
                                <%--同组单选按钮:name要一致--%>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender_add_1" value="M" checked="checked"> 男
                                </label>
                                <label class="radio-inline">
                                    <input type="radio" name="gender" id="gender_add_2" value="G"> 女
                                </label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-2 control-label">部门</label>
                            <div class="col-sm-4" id="dId_form">
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="save_emp_btn">新增</button>
                </div>
            </div>
        </div>
    </div>
    <!-- 搭建显示页面 -->
    <div class="container">
        <!--标题  -->
        <div class="row">
            <div class="col-md-12">
                <h1>SSM-CRUD</h1>
            </div>
        </div>
        <!-- 按钮 -->
        <div class="row">
            <div class="col-md-4 col-md-offset-8">
                <button class="btn btn-info" id="emp_Add_Modal_btn">新增</button>
                <button class="btn btn-danger">删除</button>
            </div>
        </div>
        <!-- 显示表格数据-->
        <div class="row">
            <div class="col-lg-12">
                <table class="table table-hover" id="emps_table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>empName</th>
                            <th>gender</th>
                            <th>email</th>
                            <th>deptName</th>
                            <th>Option</th>
                        </tr>
                    </thead>

                    <tbody>

                    </tbody>

                </table>
            </div>
        </div>
        <!-- 显示分页信息 -->
        <div class="row">
            <%--分页文字信息--%>
            <div class="col-md-6" id="page_Info_area">

            </div>

            <%--分页条信息--%>
            <div class="col-md-6" id="page_nav_area">
                <nav aria-label="Page navigation">
                    <ul class="pagination" >

                    </ul>
                </nav>
            </div>
        </div>
    </div>
    <script type="text/javascript">
        //1.页面加载完成后发送ajax请求,要到分页信息
        $(function(){
            //去首页
            to_page(1);
        });

        function to_page(pageNumber) {
            $.ajax({
                url:"${APP_PATH}/EMPController/emps",
                data:"pageNumber=" + pageNumber,
                type:"get",
                success:function (result) {
                    // console.log(result);
                    //1.解析并显示员工信息
                    build_emps_table(result);
                    //2.解析并显示分页信息
                    build_page_info(result);
                    //3.解析并显示分页条信息
                    build_page_nav(result);
                }
            });
        }
        //构建表格信息
        function build_emps_table(result) {
            //构建之前先清空数据
            $("#emps_table tbody").empty();

            var emps = result.extend.pageInfo.list;
            $.each(emps,function (index,item) {
                //创建表格
                var empIdTd = $("<td></td>").append(item.empId);
                var empNameTd = $("<td></td>").append(item.empName);
                var genderTd = $("<td></td>").append(item.gender);
                var emailTd = $("<td></td>").append(item.email);
                var departmentTd = $("<td></td>").append(item.department.deptName);
                var editBtn = $("<button></button>").addClass("btn btn-info btn-sm")
                    .append($("<span></span>"))
                    .addClass("glyphicon glyphicon-pencil").append("编辑");
                var deleteBtn = $("<button></button>").addClass("btn btn-danger btn-sm")
                    .append($("<span></span>"))
                    .addClass("glyphicon glyphicon-trash").append("删除");

                var btnTd = $("<td></td>").append(editBtn).append(" ")
                    .append(deleteBtn);

                $("<tr></tr>").append(empIdTd)
                    .append(empNameTd)
                    .append(genderTd)
                    .append(emailTd)
                    .append(departmentTd)
                    .append(btnTd)
                    .appendTo("#emps_table tbody");
            });
        }
        //构建分页信息
        function build_page_info(result) {
            //构建前先清空数据
            $("#page_Info_area").empty();

            var pageInfo = result.extend.pageInfo;
            $("#page_Info_area").append("当前为"+ pageInfo.pageNum +"页 "+"总共"+pageInfo.pages +"页 "+"总共"+pageInfo.total+"条记录");
        }
        //构建分页条信息 点击后跳转
        function build_page_nav(result) {
            //构建之前先清空
            $("#page_nav_area").empty();

            var pageInfo = result.extend.pageInfo;

            var ul = $("<ul></ul>").addClass("pagination");

            //page_nav_area
            var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
            var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
            var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;").attr("href","#"));
            var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;").attr("href","#"));
            if (!pageInfo.hasPreviousPage){
                firstPageLi.addClass("disabled");
                prePageLi.addClass("disabled");
            }else {
                firstPageLi.click(function () {
                    to_page(1);
                });
                prePageLi.click(function () {
                    to_page(pageInfo.pageNum - 1);
                });
            }

            if (!pageInfo.hasNextPage){
                lastPageLi.addClass("disabled");
                nextPageLi.addClass("disabled");
            } else {
                lastPageLi.click(function () {
                    to_page(pageInfo.pages);
                });
                nextPageLi.click(function () {
                    to_page(pageInfo.pageNum + 1);
                });

            }
            ul.append(firstPageLi).append(prePageLi);

            /*
            * 构建 ( 首页 \ 末页 \ 前一页 \ 后一页 ) 的单击事件
            * */
            /*firstPageLi.click(function () {
                to_page(1);
            });
            lastPageLi.click(function () {
                to_page(pageInfo.pages);
            });
            prePageLi.click(function () {
                to_page(pageInfo.pageNum - 1);
            });
            nextPageLi.click(function () {
                to_page(pageInfo.pageNum + 1);
            });*/
            /*
            * 构建完成
            * */
            $.each(pageInfo.navigatepageNums,function (index,item) {
                var pageNumber = $("<li></li>").append($("<a></a>").append(item).attr("href","#"));
                ul.append(pageNumber);
                if(item == pageInfo.pageNum) {
                    pageNumber.addClass("active");
                }

                pageNumber.click(function () {
                    to_page(item);
                });
            });

            ul.append(nextPageLi).append(lastPageLi);

            var nav = $("<nav></nav>").append(ul);
            nav.appendTo("#page_nav_area");
        }

        function build_modal_body(result){
            $("#dId_form").empty();
            var depts_tmp = result.extend.depts;
            var select_tmp = $("<select></select>").addClass("form-control").attr("name","dId");
            $.each(depts_tmp,function (index,item) {
                var tmp = $("<option></option>").append(item.deptName);
                tmp.attr("value",item.deptId);
                select_tmp.append(tmp);
            });
            select_tmp.appendTo($("#dId_form"));
        }

        /*Jquery使用 val()方法取值,不是value()*/
        /*正则表达式要注意空格*/
        function checkout_Emp_Form(){
            var emp_Name = $("#empName_add").val();
            // console.log(emp_Name);
            /* | (^[\u2E80-\u9FFF]{2,5}$) */
            var check_emp_Name = /(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,5}$)/;
            var emp_email = $("#email_add").val();
            var check_email = 	/^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/ ;


            //检查前先清空状态


            if (check_emp_Name.test(emp_Name) == false){
                // alert("姓名格式错误");
                /*修改提示信息的显示*/
                /*
                $("#empName_add").parent().addClass("has-error");
                $("#empName_add").next("span").text("姓名格式错误");
                */
                show_validate_msg($("#empName_add"),"error","姓名格式不合法");
                return false;
            } else {
                show_validate_msg($("#empName_add"),"success","");
                /*
                $("#empName_add").parent().addClass("has-success");
                $("#empName_add").next("span").text("");
                */
            }
            if (check_email.test(emp_email) == false){
                show_validate_msg($("#email_add"),"error","邮箱格式错误");
                // alert("邮箱格式错误");
                /*$("#email_add").parent().addClass("has-error");
                $("#email_add").next("span").text("邮箱格式错误");*/
                return false;
            } else {
                show_validate_msg($("#email_add"),"success","");
                /*$("#email_add").parent().addClass("has-success");
                $("#email_add").next("span").text("");*/
            }
            return true;
        }

        /*完整重置表单*/
        function reset_form(ele){
            $(ele)[0].reset();
            $(ele).find("*").removeClass("has-success has-error");
            $(ele).find(".help-block").text("");
        }

        //显示span信息
        function show_validate_msg(ele,status,msg){
            /*显示样式前先清空样式*/
            $(ele).parent().removeClass("has-success has-error");
            $(ele).next("span").text("");

            if (status == "success"){
                $(ele).parent().addClass("has-success");
                $(ele).next("span").text(msg);
            } else if (status == "error"){
                $(ele).parent().addClass("has-error");
                $(ele).next("span").text(msg);
            }
        }

        /*点击 新增(页面) 按钮 弹出模态框*/
        $("#emp_Add_Modal_btn").click(function () {
            /*重置表单数据*/
            reset_form($("#empAddModal form"));
            var totalRecord;
            /*发出ajax请求 显示部门信息*/
            $.ajax({
                url:"${APP_PATH}/DEPTController/查询部门信息",
                type:"get",
                success:function (result) {
                    // console.log(result);
                    build_modal_body(result);
                }
            });
            //弹出对话框
            $("#empAddModal").modal();
        });

        /*校验用户名是否可用(是否重复)*/
        $("#empName_add").change(function () {
            //发送ajax请求 校验用户名是否可用
            var empName = this.value;
            $.ajax({
                url:"${APP_PATH}/EMPController/checkEmpName",
                type:"get",
                data:"empName="+empName,
                success:function (result) {
                    if (result.code == 100){
                        show_validate_msg($("#empName_add"),"success","");
                        $("#save_emp_btn").attr("empName_check_val","success");
                    } else if (result.code == 200) {
                        show_validate_msg($("#empName_add"),"error",result.extend.va_msg);
                        /*用于传输错误消息给新增按钮单击事件*/
                        $("#save_emp_btn").attr("empName_check_val","error");
                    }
                }
            });
        });


        /* (模态框中的新增按钮) 的单击事件*/
        $("#save_emp_btn").click(function () {
            // alert($("#save_emp_form").serialize());
            if (this.attr("empName_check_val") == "error"){/*新增按钮的单击事件:(姓名不合法 阻止进行ajax请求添加) */
                alert("姓名错误");
                return false;
            }
            if (checkout_Emp_Form() == false){/*新增按钮的单击事件:(数据出现不合法信息 阻止进行ajax请求添加)*/
                return false;
            }
            $.ajax({
                url:"${APP_PATH}/EMPController/emps",
                type:"post",
                data:$("#save_emp_form").serialize(),
                success:function () {
                    alert("添加成功");
                    //保存成功
                    /*
                    关闭模态框
                     */
                    $("#empAddModal").modal("hide");
                    /*
                    跳转到最后一页
                    给定一个非常大的页数
                    分页插件会跳到最后一页
                     */
                    to_page(9999);
                }
            });
        });

    </script>
</body>
</html>