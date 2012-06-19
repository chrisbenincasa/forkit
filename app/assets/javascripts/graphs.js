function generatePieGraph(ingredients)
{
  var ingredientsMap = {},
      count = [],
      sortable = [],
      name = ''
  for(var i in ingredients)
  {
    for(var j in ingredients[i])
    {
      name = ingredients[i][j].name
      if(ingredientsMap[name] === undefined)
      {
        ingredientsMap[name] = 1;
      } else {
        ingredientsMap[name]++;
      }
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

function populatePieChart(count)
{
  var options = {w:250,h:250,color: d3.scale.category20c()}
  var vis = d3.select(".top_ingredients")
      .append("svg:svg").data([count])
      .attr("width", options.w)
      .attr("height", options.h)
      .append("svg:g")
      .attr("transform", "translate(" + options.w/2 + "," + options.w/2 + ")")
  
  var arc = d3.svg.arc()
      .outerRadius(options.w/2);

  var pie = d3.layout.pie()
      .value(function(d) {return d.count; });

  var arcs = vis.selectAll("g.slice")
      .data(pie)
      .enter().append("svg:g")
      .attr("class", "slice");

  arcs.append("svg:path")
      .attr("fill", function(d, i) { return options.color(i); } )
      .attr("d", arc);

  arcs.append("svg:text")
      .attr("transform", function(d) {
        d.innerRadius = 0;
        d.outerRadius = options.w/2;
        return "translate(" + arc.centroid(d) + ")";
      })
      .attr("text-anchor", "middle")
      .text(function(d, i) { return count[i].name });

}