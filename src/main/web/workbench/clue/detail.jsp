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

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});

		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});

		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});

		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});

		$("#remarkBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#remarkBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})

		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});

		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});

		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked)
		})

		//$().on(触发事件,选择器,回调函数)	全选框根据复选框情况变更				$("input[name=xz]").click(function () {}语法不能监听动态生成的元素
		$("#activityList-body").on("click",$("input[name=xz]"),function () {
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
						remarkList()
					}
				})
			}
		})
		$("#saveRemark").click(function (){
			if ($.trim($("#remark").val()).length>0){
				$.ajax({
					url:"clue/saveRemark.action",
					dataType:"json",
					type:"post",
					data:{
						"noteContent":$.trim($("#remark").val()),
						"clueId":"${clue.id}"
					},
					success:function (result_data) {
						if (result_data.success){
							$.each(result_data.cr,function (i,n) {
								$("#"+n.id).remove()
							})
							$("#remark").val("")
							remarkList()
						}else {
							alert(result_data.msg)
						}
					}
				})
			}else {
				alert("请输入需要保存的内容")
			}
		})
		$("#aName").keydown(function (event) {
			if (event.keyCode===13){
				$.ajax({
					url:"clue/activityListCAR.action",
					dataType:"json",
					type:"get",
					data:{
						"id": $("#clueId").val(),
						aName:$.trim($("#aName").val())
					},
					success:function (result_data) {
						//{activity:[{市场活动1},{市场活动2},{市场活动3}]}
						html=""
						if (result_data.success){
							$.each(result_data.acList,function (i, n) {
								html+='<tr><td><input type="checkbox" name="xz" value="'+n.id+'"/></td>';
								html+='<td>'+n.name+'</td>';
								html+='<td>'+n.startDate+'</td>';
								html+='<td>'+n.endDate+'</td>';
								html+='<td>'+n.owner+'</td></tr>';
							})
							$("#activityList-body").html(html)
						}else{
							alert(result_data.msg);
						}
					}
				})
				return false//终止方法	当模态窗口回车后会强制刷新清空页面内容，因此需要return false
			}
		})
		$("#saveCAR").click(function () {
			clueId=$("#clueId").val();
			var $xz=$("input[name=xz]:checked")
			var ids=""
			if ($xz.length!==0){
				for (i=0;i<$xz.length;i++){
					ids+=$($xz[i]).val()
					if (i<$xz.length-1){
						ids+=",";
					}
				}
				$.ajax({
					url:"clue/saveCAR.action",
					type:"post",
					dataType:"json",
					data:{
						ids:ids,
						clueId:clueId
					},
					success:function (result_data) {
						//{success:true/false}
						if (result_data.success){

							$.each(result_data.cr,function (i, n) {
								$("#"+n.id).remove();
							})
							//取消全选框,取消模态窗口中内容,刷新关联活动下拉列表,隐藏模态窗口
							$("#qx").attr("checked",false);
							$("#activityList-body").html("")
							$("#aName").val("")
							$("#bundModal").modal("hide")
							window.location.href="clue/detail.action?id="+clueId
						}else {
							alert("关联失败，请重试")
						}
					}
				})
			}else {
				alert("请选择关联活动")
			}

		})
		$("#edit-btn").click(function(){
			$.ajax({
				url:"clue/edit.action",
				data:{
					"id":$("#clueId").val()
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
		})
        $("#deletebtn").click(function () {
            if (confirm("确认删除此线索？")){
                $.ajax({
                    url:"clue/delete.action",
                    data: {
                        ids:$("#clueId").val()
                    },
                    dataType:"json",
                    type:"post",
                    success:function (result_data) {
                        /*
                            {"success":true/false,"msg":String s}
                        */
                        if (result_data.success){
                            alert("删除成功")
                            window.location.href="workbench/clue/index.jsp"
                        }else {
                            alert(result_data.msg)
                        }
                    }
                })
            }
        })
		showActivityList();
	});
	function showActivityList(){
		$.ajax({
			url:"clue/showActivityList.action",
			dataType:"json",
			type:"get",
			data:{
				"id":$("#clueId").val(),
			},
			success:function (result_data) {
				//{activity:[{市场活动1},{市场活动2},{市场活动3}]}
				html=""
				$.each(result_data,function (i,n) {
					html+='<tr><td>'+n.name+'</td>';
					html+='<td>'+n.startDate+'</td>';
					html+='<td>'+n.endDate+'</td>';
					html+='<td>'+n.owner+'</td>';
					html+='<td><a href="javascript:void(0);"  style="text-decoration: none;" onclick="removeCAR(\''+n.id+'\')"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td></tr>';
				})
				$("#activity_clue-tbody").html(html)
			}
		})

		$("#updateRemarkBtn").click(function () {
			$.ajax({
				url:"clue/updateRemark.action",
				data:{
					"id":$("#remarkId").val(),
					"noteContent":$("#noteContent").val()
				},
				dataType:"json",
				type:"post",
				success:function (result_data) {
					/*  {success:"",cr:""}
                    */
					if (result_data.success){
						$.each(result_data.cr,function (i, n) {
							$("#"+n.id).remove();
						})
						$("#editRemarkModal").modal("hide")
						remarkList()
					}else {
						alert(result_data.msg)
					}
				}
			})
		})
		remarkList();
	}
	function removeCAR(id){
		$.ajax({
			url: "clue/deleteCAR.action",
			dataType: "json",
			type: "post",
			data: {
				id:id
			},
			success:function (result_data) {
				if (result_data.success){
					$.each(result_data.cr,function (i, n) {
						$("#"+n.id).remove();
					})
				}
				//{success:true/false}
				showActivityList()
			}
		})
	}
	function deleteRemark(id){
		$.ajax({
			url: "clue/deleteRemark.action",
			data: {
				"id":id,
			},
			dataType: "json",
			type: "post",
			success:function (result_data) {
				if (result_data.success){
					$("#"+id).remove()
				}else {
					alert(result_data.msg);
				}
			}
		})
	}
	function editRemark(id){
		$("#editRemarkModal").modal("show")
		$("#noteContent").val($("#edit"+id).html())
		$("#remarkId").val(id);
	}
	function remarkList(){
		$.ajax({
			url:"clue/remarkList.action",
			data:{
				"clueId":"${clue.id}"
			},
			dataType:"json",
			type:"get",
			success:function (result_data) {
				html="";
				$.each(result_data,function (i,n){
					html+='<div id="'+n.id+'" class="remarkDiv" style="height: 60px;">';
					html+='<img title="'+(n.editFlag==0?n.createBy:n.editBy)+'" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
					html+='<div style="position: relative; top: -40px; left: 40px;" >';
					html+='<h5 id="edit'+n.id+'">'+n.noteContent+'</h5>';
					html+='<font color="gray">线索</font> <font color="gray">-</font> <b>${clue.fullname}</b> <small style="color: gray;"> '+(n.editFlag==0?n.createTime:n.editTime)+'来自'+(n.editFlag==0?n.createBy:n.editBy)+'</small>';
					html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
					html+='<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #5bc0de;"></span></a>';
					html+='&nbsp;&nbsp;&nbsp;&nbsp;';
					html+='<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #5bc0de;"></span></a>';
					html+='</div>';
					html+='</div>';
					html+='</div>';
				})
				$("#remarkDiv").before(html)
			}
		})
	}
</script>

</head>
<body>

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" id="aName" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox" id="qx"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activityList-body">
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="saveCAR">关联</button>
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

	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal" >关闭</button>
					<button type="button" class="btn btn-primary" id="updateRemarkBtn" >更新</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${clue.fullname}<small>${clue.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<input type="hidden" id="clueId" value="${clue.id}">
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/clue/convert.jsp?id=${clue.id}&fullname=${clue.fullname}&appellation=${clue.appellation}&company=${clue.company}&owner=${clue.owner}';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			<button type="button" id="edit-btn" class="btn btn-default" data-toggle="modal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" id="deletebtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.fullname}&nbsp;${clue.appellation}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${clue.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${clue.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${clue.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 40px; left: 40px;" id="remarkBody">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveRemark">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="activity_clue-tbody">
<%--						<tr>--%>
<%--							<td>发传单</td>--%>
<%--							<td>2020-10-10</td>--%>
<%--							<td>2020-10-20</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>--%>
<%--						</tr>--%>
<%--						<tr>--%>
<%--							<td>发传单</td>--%>
<%--							<td>2020-10-10</td>--%>
<%--							<td>2020-10-20</td>--%>
<%--							<td>zhangsan</td>--%>
<%--							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>--%>
<%--						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" data-toggle="modal" data-target="#bundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>