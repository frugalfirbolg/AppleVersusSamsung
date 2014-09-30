//= require d3
var manufacturerJSON;
var carrierJSON;
var priceJSON;

function loadData(){
  $.getJSON("/phones/manufacturer.json", function(data){
    manufacturerJSON = data;
    initChart(manufacturerJSON, 'manufacturer');
  });
  $.getJSON("/phones/carrier.json", function(data){
    carrierJSON = data;
    initChart(carrierJSON, 'carrier');
  });
  $.getJSON("/phones/price.json", function(data){
    priceJSON = data;
    initChart(priceJSON, 'price');
  });
}

function initChart(dataset, tag){
  var w = $('.container').width();
  var h = w / 3;
  var chartMargin = 20;

  var colors = ["#377EB8", "#AFAFAF"];

  var series = 2; // Apple and Samsung

  var x0Scale = d3.scale.ordinal()
          .domain(d3.range(dataset.length))
          .rangeRoundBands([0, w], 0.05);
  var x1Scale = d3.scale.ordinal()
          .domain(d3.range(dataset.length))
          .rangeRoundBands([0, w], 0.05);

  var yScale = d3.scale.linear()
          .domain([0, d3.max(dataset, function(d) {
            if (d.Apple > d.Samsung) {
              return d.Apple;
            } else {
              return d.Samsung;
            }
          })])
          .range([h,0]);

  //Clear chart
  d3.select("#"+tag+"-chart svg").remove();

  //SVG element
  var svg = d3.select("#"+tag+"-chart")
			.append("svg")
			.attr("width", w)
			.attr("height", h);



  var sets = svg.selectAll(".set")
    .data(dataset)
    .enter().append("g")
            .attr("class","set")
     .attr("transform",function(d,i){
         return "translate(" + x0Scale(i) + ",0)"
     });

  sets.append("rect")
      .attr("class","apple")
      .attr("fill", colors[1])
      .attr("width", x0Scale.rangeBand()/2)
      .attr("y", h)
      .attr("height", function(d){
          return h - yScale(d.Apple);
      })
      .on("mouseover", function(d,i) {
        //Create x value from data index
        var xPosition = parseFloat(x0Scale(i) + x0Scale.rangeBand() / dataset.length);
        var yPosition = yScale(d.Apple);
        //Update Tooltip Position & value
        d3.select("#tooltip")
            .style("left", xPosition + "px")
            .style("top", yPosition + "px")
            .select("#rank")
            .text(d.Apple);
        d3.select("#tooltip").classed("hidden", false);
      })
      .on("mouseout", function() {
          //Remove the tooltip
          d3.select("#tooltip").classed("hidden", true);
      })
      .transition()
      .attr("y", function(d) {
          return yScale(d.Apple) - chartMargin;
      })
      .duration(1000);

  sets.append("rect")
      .attr("class","samsung")
      .attr("width", x0Scale.rangeBand()/2)
      .attr("y", h)
      .attr("x", x0Scale.rangeBand()/2)
      .attr("height", function(d){
          return h - yScale(d.Samsung);
      })
      .attr("fill", colors[0])
      .on("mouseover", function(d,i) {
        //Create x value from data index
        var xPosition = parseFloat(x0Scale(i) + (x0Scale.rangeBand() *1.5) / dataset.length);
        var yPosition = yScale(d.Samsung);
        //Update Tooltip Position & value
        d3.select("#tooltip")
            .style("left", xPosition + "px")
            .style("top", yPosition + "px")
            .select("#rank")
            .text(d.Samsung);
        d3.select("#tooltip").classed("hidden", false);
      })
      .on("mouseout", function() {
          //Remove the tooltip
          d3.select("#tooltip").classed("hidden", true);
      })
      .transition()
      .attr("y", function(d) {
          return yScale(d.Samsung) - chartMargin;
      })
      .duration(1000);

  // Labels
  sets.append("text")
    .attr("x", x0Scale.rangeBand()/3)
    .attr("y", function(d) { return h - chartMargin/4; })
    .text( function (d,i) {
      return d.label; })
    .attr("font-family", "sans-serif")
    .attr("font-size", "20px")
    .attr("fill", "black");

  //Apple values
  sets.append("text")
    .attr("x", x0Scale.rangeBand()/5)
    .attr("y", function(d) { var y = yScale(d.Apple) + h/25;
                            if (y < chartMargin) {
                              return chartMargin + h/25
                            } else {return y} })
    .text( function (d,i) {
      return d.Apple; })
    .attr("font-family", "sans-serif")
    .attr("font-size", "20px")
    .attr("fill", "white");

  //Samsung values
  sets.append("text")
    .attr("x", x0Scale.rangeBand()/1.5)
    .attr("y", function(d) { var y = yScale(d.Samsung) + h/25;
                            if (y < chartMargin) {
                              return chartMargin + h/25
                            } else {return y}  })
    .text( function (d,i) {
      return d.Samsung; })
    .attr("font-family", "sans-serif")
    .attr("font-size", "20px")
    .attr("fill", "white");
}
