/*function generatePieGraph(ingredients)
{
  var ingredientsMap = {},
      count = [],
      sortable = [],
      name = ''
  for(var i in ingredients)
  {
    name = ingredients[i].name
    if (ingredientsMap[name] === undefined)
    {
      ingredientsMap[name] = 1;
    } else {
      ingredientsMap[name]++;
    }
  }

  for(var key in ingredientsMap) sortable.push([key, ingredientsMap[key]])

  sortable.sort(function(a,b){
    a=a[1];
    b=b[1];
    return a > b ? -1 : (a < b ? 1 : 0)
  });

  for(var i = 0; i < sortable.slice(0,4).length; i++)
  {
    count.push({name: sortable[i][0], count: sortable[i][1]})
  }
  populatePieChart(count)
}

var arc;

function populatePieChart(count)
{
  var options = {w:250,h:250,color: d3.scale.category20c()}
  var vis = d3.select(".top_ingredients")
      .append("svg:svg").data([count])
      .attr("width", options.w)
      .attr("height", options.h)
      .append("svg:g")
      .attr("transform", "translate(" + options.w/2 + "," + options.w/2 + ")")
  
  arc = d3.svg.arc()
      .outerRadius(options.w/2);

  var pie = d3.layout.pie()
      .value(function(d) {return d.count; });

  var arcs = vis.selectAll("g.slice")
      .data(pie)
      .enter().append("svg:g")
      .attr("class", "slice");

  arcs.append("svg:path")
      .attr("fill", function(d, i) { return options.color(i); } )
      .transition()
      .duration(2000)
      .attrTween('d', tweenPie)

  arcs.append("svg:text")
      .transition().delay(2000)
      .attr("transform", function(d) {
        d.innerRadius = 0;
        d.outerRadius = options.w/2;
        return "translate(" + arc.centroid(d) + ")";
      })
      .attr("text-anchor", "middle")
      .text(function(d, i) { return count[i].name });
}

function tweenPie(b) {
  b.innerRadius = 0;
  var i = d3.interpolate({startAngle: 0, endAngle: 0}, b);
  return function(t) {
    return arc(i(t));
  };
}*/

Raphael.fn.pieChart = function (cx, cy, r, values, labels, stroke) {
    var paper = this,
        rad = Math.PI / 180,
        hues = [0, 0.3, 0.6, 0.9, 1.2, 1.5],
        chart = this.set();
    function sector(cx, cy, r, startAngle, endAngle, params) {
        var x1 = cx + r * Math.cos(-startAngle * rad),
            x2 = cx + r * Math.cos(-endAngle * rad),
            y1 = cy + r * Math.sin(-startAngle * rad),
            y2 = cy + r * Math.sin(-endAngle * rad);
        return paper.path(["M", cx, cy, "L", x1, y1, "A", r, r, 0, +(endAngle - startAngle > 180), 0, x2, y2, "z"]).attr(params);
    }
    var angle = 0,
        total = 0,
        start = 0,
        index = 0,
        process = function (j) {
            var value = values[j],
                angleplus = 360 * value / total,
                popangle = angle + (angleplus / 2),
                color = Raphael.hsb(hues[start], .75, 1),
                ms = 500,
                delta = 30,
                bcolor = Raphael.hsb(hues[start], 1, .9),
                p = sector(cx, cy, r, angle, angle + angleplus, {fill: "90-" + bcolor + "-" + color, stroke: stroke, "stroke-width": 2}),
                txt = paper.text(cx + (r + delta + 10) * Math.cos(-popangle * rad), cy + (r + delta + 5) * Math.sin(-popangle * rad), labels[j]).attr({fill: '#000', stroke: "none", "font-size": 18});
            p.mouseover(function () {
                p.stop().animate({transform: "s1.1 1.1 " + cx + " " + cy}, ms, "elastic");
                //txt.stop().animate({opacity: 1}, ms - 300, "linear");
            }).mouseout(function () {
                p.stop().animate({transform: ""}, ms, "bounce");
                //txt.stop().animate({opacity: 0}, ms);
            }).click(function(e){
                label = $(e.target.nextSibling.childNodes[0]).text().toLowerCase();
                window.location = '/ingredients/'+label;
            });
            angle += angleplus;
            chart.push(p);
            chart.push(txt);
            index++;
            start++;
        };
    for (var i = 0, ii = values.length; i < ii; i++) {
        total += values[i];
    }
    for (i = 0; i < ii; i++) {
        process(i);
    }
    console.log(chart)
    for(i = 0; i < chart.length; i++)
    {
      chart[i].attrs.class = 'test1';
    }
    return chart;
};

function generatePieGraph(ingredients)
{
  var ingredientsMap = {},
      values = [],
      labels = [],
      sortable = [],
      name = ''
  for(var i in ingredients)
  {
    name = ingredients[i].name
    if (ingredientsMap[name] === undefined)
    {
      ingredientsMap[name] = 1;
    } else {
      ingredientsMap[name]++;
    }
  }

  for(var key in ingredientsMap) sortable.push([key, ingredientsMap[key]])

  sortable.sort(function(a,b){
    a=a[1];
    b=b[1];
    return a > b ? -1 : (a < b ? 1 : 0)
  });

  for(var i = 0; i < sortable.slice(0,6).length; i++)
  {
    values.push(sortable[i][1])
    labels.push(sortable[i][0])
  }

  Raphael('ingredients_graph', 450, 325).pieChart(225, 150, 125, values, labels, '#fff')

}