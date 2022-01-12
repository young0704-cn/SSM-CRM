<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});

		//全选框绑定事件，触发全选操作
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked)
		})
		//$().on(触发事件,选择器,回调函数)	全选框根据复选框情况变更				$("input[name=xz]").click(function () {}语法不能监听动态生成的元素
		$("#clue-tbody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
		})

		$("#update-btn").click(function () {
			if (confirm("确定更新？")){
				$.ajax({
					url:"clue/update.action",
					dataType:"json",
					type:"post",
					data:{
						id:$.trim($("#edit-id").val()),
						fullname:$.trim($("#edit-surname").val()),
						appellation:$.trim($("#edit-call").val()),
						owner:$.trim($("#edit-clueOwner").val()),
						company:$.trim($("#edit-company").val()),
						job:$.trim($("#edit-job").val()),
						email:$.trim($("#edit-email").val()),
						phone:$.trim($("#edit-phone").val()),
						website:$.trim($("#edit-website").val()),
						mphone:$.trim($("#edit-mphone").val()),
						state:$.trim($("#edit-status").val()),
						source:$.trim($("#edit-source").val()),
						description:$.trim($("#edit-describe").val()),
						contactSummary:$.trim($("#edit-contactSummary").val()),
						nextContactTime:$.trim($("#edit-nextContactTime").val()),
						address:$.trim($("#edit-address").val())
					},
					success:function (result_data) {
						/*
                            {success:true/flase,msg}
                        */
						if (result_data.success){
							$("#editActivityModal").modal("hide");
						}else {
							alert(result_data.msg)
						}
						pageList($("#cluePage").bs_pagination('getOption', 'currentPage')
								,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
					}
				})
			}
		})

		$("#editbtn").click(function (){
			$xz=$("input[name=xz]:checked")
			if ($xz.length==1){
				$.ajax({
					url:"clue/edit.action",
					data:{
						"id":$xz.val()
					},
					dataType:"json",
					type:"get",
					success:function(result_data){
						/*
							{uList,clue}
						*/
						var html=""
						$.each(result_data.uList,function (i,n) {
							html+="<option value='"+n.id+"'>"+n.name+"</option>"
						})
						$("#edit-id").val(result_data.clue.id)
						$("#edit-company").val(result_data.clue.company)
						$("#edit-call").val(result_data.clue.appellation)//
						$("#edit-surname").val(result_data.clue.fullname)
						$("#edit-job").val(result_data.clue.job)
						$("#edit-email").val(result_data.clue.email)
						$("#edit-phone").val(result_data.clue.phone)
						$("#edit-website").val(result_data.clue.website)
						$("#edit-mphone").val(result_data.clue.mphone)
						$("#edit-status").val(result_data.clue.state)//
						$("#edit-source").val(result_data.clue.source)//
						$("#edit-describe").text(result_data.clue.description)
						$("#edit-contactSummary").val(result_data.clue.contactSummary)
						$("#edit-nextContactTime").val(result_data.clue.nextContactTime)
						$("#edit-address").text(result_data.clue.address)

						$("#edit-clueOwner").html(html)
						$("#edit-clueOwner").val(result_data.clue.owner)//

						$("#editClueModal").modal("show")
					}
				})
			}else {
				alert("请选择一条需要更改的信息")
			}
		})

		$("#addbtn").click(function () {
			$.ajax({
				url:"clue/getUserList.action",
				dataType:"json",
				type:"get",
				success:function (result_data) {
					//{"userList":userList}
					html ="";
					$.each(result_data,function (i,n) {
						html+="<option value='"+n.id+"'>"+n.name+"</option>"
					})
					$("#create-owner").html(html)
					$("#create-owner").val("${user.id}");
				}
			})
			$("#createClueModal").modal("show")
		})

		$("#deletebtn").click(function () {
			if (confirm("删除选中的信息？")){
				var $xz=$("input[name=xz]:checked")
				var parm="";
				if ($xz.length!==0){
					//可能选择了一条或多条信息
					for (i=0;i<$xz.length;i++){
						parm+="ids="+$($xz[i]).val();
						if (i<$xz.length-1){
							parm+="&";
						}
					}

					$.ajax({
						url:"clue/delete.action",
						data:parm,
						dataType:"json",
						type:"post",
						success:function (result_data) {
							/*
                                {"success":true/false,"msg":String s}
                            */
							if (result_data.success){
								alert("删除成功")
								pageList(1,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
							}else {
								alert(result_data.msg)
							}
							pageList(1,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));

						}
					})
				}else {
					alert("请选择要删除的信息")
				}
			}
		})

		$("#create-save").click(function(){
			$.ajax({
				url:"clue/save.action",
				type: "post",
				dataType: "json",
				data:{
						fullname:$.trim($("#create-fullname").val()),
						appellation:$.trim($("#create-appellation").val()),
						owner:$.trim($("#create-owner").val()),
						company:$.trim($("#create-company").val()),
						job:$.trim($("#create-job").val()),
						email:$.trim($("#create-email").val()),
						phone:$.trim($("#create-phone").val()),
						website:$.trim($("#create-website").val()),
						mphone:$.trim($("#create-mphone").val()),
						state:$.trim($("#create-state").val()),
						source:$.trim($("#create-source").val()),
						description:$.trim($("#create-description").val()),
						contactSummary:$.trim($("#create-contactSummary").val()),
						nextContactTime:$.trim($("#create-nextContactTime").val()),
						address:$.trim($("#create-address").val())
				},
				success:function (result_data) {
					//{success:true/false}
					if (result_data.success){
						$("#create-job").val("")
						$("#create-owner").val("")
						$("#create-mphone").val("")
						$("#create-state").val("")
						$("#create-source").val("")
						$("#create-description").val("")
						$("#create-contactSummary").val("")
						$("#create-nextContactTime").val("")
						$("#create-company").val("")
						$("#create-appellation").val("")
						$("#create-fullname").val("")
						$("#create-email").val("")
						$("#create-phone").val("")
						$("#create-website").val("")
						$("#create-address").val("")
						$("#createClueModal").modal("hide")
					}else {
						alert("保存失败")
					}
                    pageList(1,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
				}
			})
		})

		$("#getbtn").click(function (){
			/*
            只有点击查询按钮，才能确定查询条件
                做法，将搜索文本域中的value值先存入隐藏域。
        */
			$("#hidden-fullname").val($.trim($("#fullname").val()))
			$("#hidden-source").val($.trim($("#source").val()))
			$("#hidden-state").val($.trim($("#state").val()))
			$("#hidden-owner").val($.trim($("#owner").val()))
			$("#hidden-mphone").val($.trim($("#mphone").val()))
			$("#hidden-phone").val($.trim($("#phone").val()))
			$("#hidden-company").val($.trim($("#company").val()))
            pageList(1,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
		})
		pageList(1,4)
		owner()
	});
	function owner(){
		$.ajax({
			url:"clue/getUserList.action",
			dataType:"json",
			type:"get",
			success:function (result_data) {
				//{"userList":userList}
				html ="<option/>";
				$.each(result_data,function (i,n) {
					html+="<option value='"+n.id+"'>"+n.name+"</option>"
				})
				$("#owner").html(html)
			}
		})
	}
	function pageList(pageNo,pageSize){
        $("#fullname").val($.trim($("#hidden-fullname").val()))
        $("#source").val($.trim($("#hidden-source").val()))
        $("#state").val($.trim($("#hidden-state").val()))
        $("#owner").val($.trim($("#hidden-owner").val()))
        $("#mphone").val($.trim($("#hidden-mphone").val()))
        $("#phone").val($.trim($("#hidden-phone").val()))
        $("#company").val($.trim($("#hidden-company").val()))

		$.ajax({
			url:"clue/pageList.action",
			type:"get",
            dataType:"json",
			data: {
				pageNo:pageNo,
				pageSize:pageSize,
				fullname:$("#fullname").val(),
				company:$("#company").val(),
				owner:$("#owner").val(),
				source:$("#source").val(),
				state:$("#state").val(),
				mphone:$("#mphone").val(),
				phone:$("#phone").val()
			},
			success:function (result_data) {
				/*
					{vo,{dataList,total}}
				*/
				html="";
				$.each(result_data.dataList,function (i,n) {
					html+='<tr>';
					html+='<td><input type="checkbox" name="xz" value="'+n.id+'"/></td>'
					html+='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'clue/detail.action?id='+n.id+'\';">'+n.fullname+'</a></td>'
					html+='<td>'+n.company+'</td>'
					html+='<td>'+n.phone+'</td>'
					html+='<td>'+n.mphone+'</td>'
					html+='<td>'+n.source+'</td>'
					html+='<td>'+n.owner+'</td>'
					html+='<td>'+n.state+'</td></tr>'
				})
				$("#clue-tbody").html(html);

                var totalPages=result_data.total%pageSize==0?result_data.total/pageSize:parseInt(result_data.total/pageSize)+1
				$("#cluePage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: result_data.total, // 总记录条数

					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,
					//点击分页组件触发
					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});
			}
		})
	}
</script>
</head>
<body>
    <input type="hidden" id="hidden-source"/>
    <input type="hidden" id="hidden-state"/>
    <input type="hidden" id="hidden-owner"/>
    <input type="hidden" id="hidden-fullname"/>
    <input type="hidden" id="hidden-mphone"/>
    <input type="hidden" id="hidden-phone"/>
    <input type="hidden" id="hidden-company"/>
	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">

								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
									<c:forEach items="${appellation}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
								  <option></option>
									<c:forEach items="${clueState}" var="c">
										<option value="${c.value}">${c.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
									<c:forEach items="${source}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 102%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 102%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
							</div>
						</div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="create-save">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input type="hidden" id="edit-id"/>
						<div class="form-group">
							<label for="edit-clueOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-clueOwner">

								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-call" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-call">
									<option></option>
									<c:forEach items="${appellation}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-surname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
							<label for="edit-status" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-status">
								  <option></option>
									<c:forEach items="${clueState}" var="c">
										<option value="${c.value}">${c.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach items="${source}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 102%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="edit-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 102%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" id="update-btn" class="btn btn-primary" data-dismiss="modal">更新</button>
				</div>
			</div>
		</div>
	</div>
	

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text"  id="company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="source">
					  	  <option></option>
						  <c:forEach items="${source}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon" >所有者</div>
						<select class="form-control" id="owner">

						</select>
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="state">
					  	<option></option>
						  <c:forEach items="${clueState}" var="a">
							  <option value="${a.value}">${a.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="getbtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" id="addbtn" class="btn btn-primary"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" id="editbtn" class="btn btn-default" data-toggle="modal"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" id="deletebtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clue-tbody">
<%--						<tr>--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/clue/detail.jsp';">李四先生</a></td>--%>
<%--							<td>动力节点</td>--%>
<%--							<td>010-84846003</td>--%>
<%--							<td>12345678901</td>--%>
<%--							<td>广告</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td>已联系</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/clue/detail.jsp';">李四先生</a></td>--%>
<%--                            <td>动力节点</td>--%>
<%--                            <td>010-84846003</td>--%>
<%--                            <td>12345678901</td>--%>
<%--                            <td>广告</td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>已联系</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 60px;">
				<div id="cluePage"></div>
<%--				<div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">共<b>50</b>条记录</button>--%>
<%--				</div>--%>
<%--				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
<%--					<div class="btn-group">--%>
<%--						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
<%--							10--%>
<%--							<span class="caret"></span>--%>
<%--						</button>--%>
<%--						<ul class="dropdown-menu" role="menu">--%>
<%--							<li><a href="#">20</a></li>--%>
<%--							<li><a href="#">30</a></li>--%>
<%--						</ul>--%>
<%--					</div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
<%--				</div>--%>
<%--				<div style="position: relative;top: -88px; left: 285px;">--%>
<%--					<nav>--%>
<%--						<ul class="pagination">--%>
<%--							<li class="disabled"><a href="#">首页</a></li>--%>
<%--							<li class="disabled"><a href="#">上一页</a></li>--%>
<%--							<li class="active"><a href="#">1</a></li>--%>
<%--							<li><a href="#">2</a></li>--%>
<%--							<li><a href="#">3</a></li>--%>
<%--							<li><a href="#">4</a></li>--%>
<%--							<li><a href="#">5</a></li>--%>
<%--							<li><a href="#">下一页</a></li>--%>
<%--							<li class="disabled"><a href="#">末页</a></li>--%>
<%--						</ul>--%>
<%--					</nav>--%>
<%--				</div>--%>
			</div>
			
		</div>
		
	</div>
</body>
</html>