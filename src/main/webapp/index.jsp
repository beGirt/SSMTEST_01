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
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label for="empName_add" class="col-sm-2 control-label">empName</label>
                            <div class="col-sm-10">
                                <input type="text" class="form-control" id="empName_add" name="empName" placeholder="林盛锋">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="email_add" class="col-sm-2 control-label">email</label>
                            <div class="col-sm-10">
                                <input type="text" class="form-control" id="email_add" name = "email" placeholder="emil@emai.com">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="email_add" class="col-sm-2 control-label">gender</label>
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
                            <label for="email_add" class="col-sm-2 control-label">部门</label>
                            <div class="col-sm-4">
                                <select class="form-control"  id="dId_form">

                                </select>
                            </div>
                        </div>


                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary">Save changes</button>
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

            $.each(depts_tmp,function (index,item) {
                var base_option = $("<option></option>").append(item.deptName).appendTo($("#dId_form"));
            });
        }

        $("#emp_Add_Modal_btn").click(function () {

            //发出ajax请求
            $.ajax({
                url:"${APP_PATH}/departmentController/查询部门信息",
                type:"get",
                success:function (result) {
                    // console.log(result);
                    build_modal_body(result);
                }
            });

            //弹出对话框
            $("#empAddModal").modal();
        });

    </script>
</body>
</html>