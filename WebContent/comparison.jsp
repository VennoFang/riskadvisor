<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Risk Advisor</title>
<%@  include file="./templates/includes.jsp"%></head>
<body>
	<%@  include file="./templates/header.jsp"%>
	<!-- Main part -->
	<div class="container">
		<h3>Compare the financial risks of two companies.</h3>
		<form class="form-horizontal" role="form">
			<div class="form-group">
				<div class="col-sm-4">
					<label for="companyA" class="control-label">Company A</label> <input
						type="text" class="form-control" id="companyA"
						placeholder="Enter the symbol of the first company." />
				</div>
				<div class="col-sm-4">
					<label for="companyB" class="control-label">Company B</label> <input
						type="text" class="form-control" id="companyB"
						placeholder="Enter the symbol of the second company." />
				</div>
				<div class="form-group">
				<div class="col-sm-4">
					<label for="year" class="control-label">Year</label> 
						<select id="year" class="form-control">
							<option>2014</option>
							<option>2013</option>
							<option>2012</option>
							<option>2011</option>
						</select>
					</div>
				</div>
				<div class="col-sm-4"></div>
			</div>
			<button type="button" class="btn btn-primary">Compare</button>
		</form>
	</div>

	<div id="chartContainer" style="height: 300px; width: 100%;"></div>
	<%@  include file="./templates/footer.jsp"%>
	<script>
	var url = location.href;
	var host = url.substring(0, url.lastIndexOf("/"));	
		$('button').on('click', function(event) {
			event.preventDefault();
			var A = $('#companyA').val();
			var B = $('#companyB').val();
			var year = $('#year').val();
			var categoryurl = host+"/api/category/";
			var categoryA = categoryurl + A + "?year="+year;
			var categoryB = categoryurl + B + "?year="+year;
			//for sync
			var finished = 0;
			var dataA = null;
			var dataB = null;
			$.ajax({
				url : categoryA,
				success : function(dataA) {
					$.ajax({
						url: categoryB,
						success:function(dataB){
							showComparison(dataA, dataB, A, B);
						}
					});
				}
			});
		});
		function showComparison(dataA, dataB, A, B) {
			var keys = [];
			keys = gatherKeys(dataA,keys);
			keys = gatherKeys(dataB,keys);
			var dpA = convert(dataA,keys);
			var dpB = convert(dataB,keys);
			var chart = new CanvasJS.Chart("chartContainer", {
				title : {
					text : "Financial Risk Comparison"
				},
				data : [ {
					legendText : A,
					type : "stackedBar",
					showInLegend: "true",
					dataPoints : dpA
				}, {
					legendText : B,
					type : "stackedBar",
					showInLegend: "true",
					dataPoints : dpB
				} ]
			});

			chart.render();
		}
		function gatherKeys(data,keys) {
			// append unique keys from the data set
			for (key in data) {
				if (data[key] <= 0) {
					continue;
				}
				else if (keys.indexOf(key) < 0)
		        {
			        keys.push(key);
				}				
			}
			// return the updated keys array
			return keys;
		}
		//convert a key=>value into x:? y:?
		function convert(data,keys) {
			var dataPoints = [];
			for (var i = 0; i < keys.length; i++) {
				var value = 0;
				if (data[keys[i]] <= 0) {
					value = 0;
				}
				else 
					value = data[keys[i]];
				dataPoints.push({
					label : keys[i],
					y : value
				});
			}
			return dataPoints;
		}
	</script>
</body>
</html>