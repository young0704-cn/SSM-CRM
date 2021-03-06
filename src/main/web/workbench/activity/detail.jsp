<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

        $("#remarkBody").on("mouseover",".remarkDiv",function(){
            $(this).children("div").children("div").show();
        })
        $("#remarkBody").on("mouseout",".remarkDiv",function(){
            $(this).children("div").children("div").hide();
        })

        $("#detail-sc-btn").click(function () {
            $.ajax({
                url:"activity/delete.action",
                data:{
                    "ids":"${activity.id}"
                },
                dataType:"json",
                type:"post",
                success:function (result_data) {
                    /*
                        {"success":true/false,"msg":String s}
                    */
                    if (result_data.success){
                        alert("删除成功")
                    }else {
                        alert(result_data.msg)
                    }
                    window.location.href="workbench/activity/index.jsp"
                }
            })
        })

        $("#detail-gx-btn").click(function () {
            if (confirm("确定更新？")){
                $.ajax({
                    url:"activity/update.action",
                    dataType:"json",
                    type:"post",
                    data:{
                        id:"${activity.id}",
                        owner:$("#edit-marketActivityOwner").val(),
                        name:$.trim($("#edit-marketActivityName").val()),
                        startDate: $("#edit-startTime").val(),
                        endDate: $("#edit-endTime").val(),
                        cost:$.trim($("#edit-cost").val()),
                        description: $.trim($("#edit-describe").val())
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
                        window.location.href="activity/detail.action?id=${activity.id}";
                    }
                })
            }
        })

        $("#detail-bj-btn").click(function () {
            $(".time").datetimepicker({
                minView: "month",
                language:  'zh-CN',
                format: 'yyyy-mm-dd',
                autoclose: true,
                todayBtn: true,
                pickerPosition: "bottom-left"
            });

            $.ajax({
                url:"activity/edit.action",
                data:{
                    "id":"${activity.id}"
                },
                dataType:"json",
                type:"get",
                success:function(result_data){
                    /*
                        {uList,activity}
                    */
                    var html=""
                    $.each(result_data.uList,function (i,n) {
                        html+="<option value='"+n.id+"'>"+n.name+"</option>"
                    })
                    $("#edit-id").val(result_data.activity.id)
                    $("#edit-marketActivityName").val(result_data.activity.name)
                    $("#edit-startTime").val(result_data.activity.startDate)
                    $("#edit-endTime").val(result_data.activity.endDate)
                    $("#edit-describe").val(result_data.activity.description)
                    $("#edit-cost").val(result_data.activity.cost)
                    $("#edit-marketActivityOwner").html(html)
                    $("#edit-marketActivityOwner").val(result_data.activity.owner)

                    $("#editActivityModal").modal("show")
                }
            })
        })

        $("#saveRemark").click(function () {
            if ($.trim($("#remark").val()).length>0){
                $.ajax({
                    url:"activity/saveRemark.action",
                    dataType:"json",
                    type:"post",
                    data:{
                        "remark":$.trim($("#remark").val()),
                        "activityId":"${activity.id}"
                    },
                    success:function (result_data) {
                        if (result_data.success){
                            $.each(result_data.ar,function (i,n) {
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

        $("#updateRemarkBtn").click(function () {
            $.ajax({
                url:"activity/updateRemark.action",
                data:{
                    "id":$("#remarkId").val(),
                    "noteContent":$("#noteContent").val()
                },
                dataType:"json",
                type:"post",
                success:function (result_data) {
                    /*  {success:"",ar:""}
                    */
                    if (result_data.success){
                        $.each(result_data.ar,function (i, n) {
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
	});
    function deleteRemark(id){
        $.ajax({
            url: "activity/deleteRemark.action",
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
            url:"activity/remarkList.action",
            data:{
                "activityId":"${activity.id}"
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
                    html+='<font color="gray">市场活动</font> <font color="gray">-</font> <b>${activity.name}</b> <small style="color: gray;"> '+(n.editFlag==0?n.createTime:n.editTime)+'来自'+(n.editFlag==0?n.createBy:n.editBy)+'</small>';
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

    <!-- 修改市场活动的模态窗口 -->
    <div class="modal fade" id="editActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改市场活动</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-marketActivityOwner">

                                </select>
                            </div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="hidden" id="edit-id"/>
                                <input type="text" class="form-control" id="edit-marketActivityName">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-startTime"  readonly>
                            </div>
                            <label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control time" id="edit-endTime" readonly>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-cost">
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-describe" class="col-sm-2 control-label">描述</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-describe"></textarea>
                            </div>
                        </div>

                    </form>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button type="button" id="detail-gx-btn" class="btn btn-primary" data-dismiss="modal">更新</button>
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
			<h3>市场活动-${activity.name} <small>${activity.startDate} ~ ${activity.endDate}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
            <button type="button" id="detail-bj-btn" class="btn btn-default" data-toggle="modal" data-target="#editActivityModal"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" id="detail-sc-btn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>

		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">开始日期</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.startDate}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">结束日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${activity.endDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">成本</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${activity.cost}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${activity.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${activity.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>${activity.description}</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 30px; left: 40px;" id="remarkBody">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<!-- 备注1 -->
<%--		<div class="remarkDiv" style="height: 60px;">--%>
<%--			<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">--%>
<%--			<div style="position: relative; top: -40px; left: 40px;" >--%>
<%--				<h5>哎呦！</h5>--%>
<%--				<font color="gray">市场活动</font> <font color="gray">-</font> <b>发传单</b> <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>--%>
<%--				<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--					&nbsp;&nbsp;&nbsp;&nbsp;--%>
<%--					<a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: #E6E6E6;"></span></a>--%>
<%--				</div>--%>
<%--			</div>--%>
<%--		</div>--%>


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
	<div style="height: 200px;"></div>
</body>
</html>