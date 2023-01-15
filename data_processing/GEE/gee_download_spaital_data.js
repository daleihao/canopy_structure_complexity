var regions = 
    ee.Geometry.Polygon(
        [[[-180, 90],
          [-180, -90],
          [180, -90],
          [180, 90]]], null, false);
//land boundary
var land_region = ee.FeatureCollection('USDOS/LSIB_SIMPLE/2017');
// Collect the T1 Surface Reflectance
// A function to remove snow pixels
var maskSnow = function(image) {
   //Select the QA band.
   var date = image.date().format("yyyy-MM-dd")
   var image_tmp = modisMCD43A2.filterDate(date).first();
  var QA = image_tmp.select('Snow_BRDF_Albedo')
   //Make a mask to get bit 10, the internal_cloud_algorithm_flag bit.
  //var bitMask = 1 << 10;
   //Return an image masking out cloudy areas.
  return image.updateMask(QA.eq(0))
}

////////////define function
// A function to compute NDVI.
var NDVI = function(image) {
  return image.expression('float(b("Nadir_Reflectance_Band2") - b("Nadir_Reflectance_Band1")) / (b("Nadir_Reflectance_Band1") + b("Nadir_Reflectance_Band2"))');
};

var NIRv = function(image) {
  return image.expression('float(b("Nadir_Reflectance_Band2") - b("Nadir_Reflectance_Band1")) / (b("Nadir_Reflectance_Band1") + b("Nadir_Reflectance_Band2")) * float(b("Nadir_Reflectance_Band2")) * 0.0001');
};

var Red = function(image) {
  return image.expression('b("Nadir_Reflectance_Band1") * 0.0001');
};

var NIR = function(image) {
  return image.expression('b("Nadir_Reflectance_Band2") * 0.0001');
};

var NIR_NIRv = function(image) {
  return image.expression('float(b("Nadir_Reflectance_Band2")) * 0.0001 - float(b("Nadir_Reflectance_Band2") - b("Nadir_Reflectance_Band1")) / (b("Nadir_Reflectance_Band1") + b("Nadir_Reflectance_Band2")) * float(b("Nadir_Reflectance_Band2")) * 0.0001');
};
// A function to compute EVI.
var EVI = function(image) {
  //gets the date of the image
  var date = image.date().format("yyyy-MM-dd")
  //places date on the image
  image = image.set("date", date);
  return image.expression('2.5 * ((nir - red) * 0.0001) / ((nir + 6 * red - 7.5 * blue) *0.0001 + 1)',
    {
        red: image.select('Nadir_Reflectance_Band1'),    // 620-670nm, RED
        nir: image.select('Nadir_Reflectance_Band2'),    // 841-876nm, NIR
        blue: image.select('Nadir_Reflectance_Band3')    // 459-479nm, BLUE
  
    }).copyProperties(image,["date"]);
};

// A function to compute EVI.
var DVI = function(image) {
  //gets the date of the image
  var date = image.date().format("yyyy-MM-dd")
  //places date on the image
  image = image.set("date", date);
  return image.expression('(nir-red)*0.0001',
    {
        red: image.select('Nadir_Reflectance_Band1'),    // 620-670nm, RED
        nir: image.select('Nadir_Reflectance_Band2'),    // 841-876nm, NIR
        blue: image.select('Nadir_Reflectance_Band3')    // 459-479nm, BLUE
  
    }).copyProperties(image,["date"]);
};

// A function to compute EVI.
var EVI2 = function(image) {
  //gets the date of the image
  var date = image.date().format("yyyy-MM-dd")
  //places date on the image
  image = image.set("date", date);
  return image.expression('2.5 * ((nir - red) * 0.0001) / ((nir + 2.4 * red) *0.0001 + 1)',
    {
        red: image.select('Nadir_Reflectance_Band1'),    // 620-670nm, RED
        nir: image.select('Nadir_Reflectance_Band2')    // 459-479nm, BLUE
  
    }).copyProperties(image,["date"]);
};


for (var year=2003;year<2004;year++)
{
  
var mcd43a4 = ee.ImageCollection('MODIS/006/MCD43A4')
   .filterDate(ee.Date.fromYMD(year,1,1), ee.Date.fromYMD(year,2,1));
var modisMCD43A2 = ee.ImageCollection('MODIS/006/MCD43A2')
   .filterDate(ee.Date.fromYMD(year,1,1), ee.Date.fromYMD(year,2,1));


var mcd43a4 = mcd43a4.map(maskSnow)

// Get NDVI and EVI
var EVImap = mcd43a4.map(EVI)
var NDVImap = mcd43a4.map(NDVI)
var NIRvmap = mcd43a4.map(NIRv)
var EVI2map = mcd43a4.map(EVI2)
var DVImap = mcd43a4.map(DVI)
var Redmap = mcd43a4.map(Red)
var NIR_NIRvmap = mcd43a4.map(NIR_NIRv)

var NIRmap = mcd43a4.map(NIR)
// scatter plot
//combine data
var EVIs = EVImap.mean().rename('EVIs')
var NDVIs = NDVImap.mean().rename('NDVIs')
var NIRvs = NIRvmap.mean().rename('NIRvs')
var EVI2s = EVI2map.mean().rename('EVI2s')
var DVIs = DVImap.mean().rename('DVIs')
var NIRs = NIRmap.mean().rename('NIRs')
var Reds = Redmap.mean().rename('Reds')
var nir_nirvs = NIR_NIRvmap.mean().rename('nir_nirvs')

Export.image.toDrive({
  image: nir_nirvs,
  description: 'nir_nirvs_'+ year.toString(),
  dimensions: "3600x1800",
  folder: 'yearly_variation',
  fileFormat: 'GeoTIFF',
  maxPixels:1e10,
  region: regions,
  crs: 'EPSG:4326'
});
print()
Export.image.toDrive({
  image: NIRs,
  description: 'NIRs_'+ year.toString(),
  dimensions: "3600x1800",
  folder: 'yearly_variation',
  fileFormat: 'GeoTIFF',
  maxPixels:1e10,
  region: regions,
  crs: 'EPSG:4326'
});

Export.image.toDrive({
  image: Reds,
  description: 'Reds_'+ year.toString(),
  dimensions: "3600x1800",
  folder: 'yearly_variation',
  fileFormat: 'GeoTIFF',
  maxPixels:1e10,
  region: regions,
  crs: 'EPSG:4326'
});

Export.image.toDrive({
  image: EVIs,
  description: 'EVIs_'+ year.toString(),
  dimensions: "3600x1800",
  folder: 'yearly_variation',
  fileFormat: 'GeoTIFF',
  maxPixels:1e10,
  region: regions,
  crs: 'EPSG:4326'
});

Export.image.toDrive({
  image: NDVIs,
  description: 'NDVIs_'+ year.toString(),
  dimensions: "3600x1800",
  folder: 'yearly_variation',
  fileFormat: 'GeoTIFF',
  maxPixels:1e10,
  region: regions,
  crs: 'EPSG:4326'
});
Export.image.toDrive({
  image: NIRvs,
  description: 'NIRvs_'+ year.toString(),
  dimensions: "3600x1800",
  folder: 'yearly_variation',
  fileFormat: 'GeoTIFF',
  maxPixels:1e10,
  region: regions,
  crs: 'EPSG:4326'
});
Export.image.toDrive({
  image: EVI2s,
  description: 'EVI2s_'+ year.toString(),
  dimensions: "3600x1800",
  folder: 'yearly_variation',
  fileFormat: 'GeoTIFF',
  maxPixels:1e10,
  region: regions,
  crs: 'EPSG:4326'
});
Export.image.toDrive({
  image: DVIs,
  description: 'DVIs_'+ year.toString(),
  dimensions: "3600x1800",
  folder: 'yearly_variation',
  fileFormat: 'GeoTIFF',
  maxPixels:1e10,
  region: regions,
  crs: 'EPSG:4326'
});
}
/*
var VIs = NIRvs.addBands([EVIs, NDVIs, EVI2s, DVIs]);
// plot sampled features as a scatter chart
// sample N points from the 2-band image
var values = VIs.sample({ region: testRegion, scale: 500, numPixels: 5000, geometries: false}) 
//var values = VIs.sampleRegions(land_region, null, 10000)

var chart = ui.Chart.feature.byFeature(values, 'NIRvs', ['EVIs','EVI2s','NDVIs','DVIs'])
  .setChartType('ScatterChart')
  .setOptions({ pointSize: 2, width: 300, height: 300, titleX: 'NIRv', titleY: 'other VIs',
     trendlines: { 0: {showR2: true, visibleInLegend: true} , 
                    1: {showR2: true, visibleInLegend: true},
                     2: {showR2: true, visibleInLegend: true},
                      3: {showR2: true, visibleInLegend: true}
       
     }
  })
   
print(chart) 
*/

// other ways 



// I'm trying to get a lineal regression from scatterplot of two bands in GEE, but i don't how to do It. I was trying to apply over the example of scatterplot available in GEE docs.

// Get a dictionary with band names as keys, pixel lists as values.
//var NIRv_array = NIRvs.reduceRegion(ee.Reducer.toList(), testRegion, 500);
//var EVI_array = EVIs.reduceRegion(ee.Reducer.toList(), testRegion, 500);
//var EVI2_array = EVI2s.reduceRegion(ee.Reducer.toList(), testRegion, 500);

// Convert the band data to plot on the y-axis to arrays.
//var y1 = ee.Array(EVI_array.get('EVIs'));
//var y2 = ee.Array(EVI2_array.get('EVI2s'));
// Concatenate the y-axis data by stacking the arrays on the 1-axis.
//var yValues = ee.Array.cat([y1, y2], 1);

// The band data to plot on the x-axis is a List.
//var xValues = NIRv_array.get('NIRvs');

// Make a band correlation chart.
//var chart = ui.Chart.array.values(yValues, 0, xValues)
  //  .setSeriesNames(['EVIs', 'EVI2s'])
    //.setOptions({
      //title: 'MODIS NIRv vs. other VIs',
      //hAxis: {'title': 'NIRvs'},
      //vAxis: {'title': '{other VIs}'},
      //pointSize: 3,
      //trendlines: { 0: {showR2: true, visibleInLegend: true} , 
        //            1: {showR2: true, visibleInLegend: true}}
//});

// Print the chart.
//print(chart);

//print('Linear fit output B4 vs B5',ee.Array.cat([xValues, y1], 1).reduce(ee.Reducer.linearFit(),[0],1));
//print('Linear fit output B4 vs B6',ee.Array.cat([xValues, y2], 1).reduce(ee.Reducer.linearFit(),[0],1));
//print('Linear fit output B5 vs B6',ee.Array.cat([y1, y2], 1).reduce(ee.Reducer.linearFit(),[0],1));

/*

// Get a palette: a list of hex strings
var palettes = require('users/gena/packages:palettes');
var palette = palettes.misc.jet[7];
var ndviVis = {
  min: 0.0,
  max: 0.3,
  palette: palette
};

// plot
Map.setCenter(6.746, 46.529, 2);
Map.addLayer(NIR_NIRvmap.mean(), ndviVis, 'Red');

///////////////////////////////////
// add legend

var legend = ui.Panel({
style: {
position: 'bottom-right',
padding: '4px 10px'
}
});
 
// Create legend title
var legendTitle = ui.Label({
value: 'NIR-NIRv',
style: {
fontWeight: 'bold',
fontSize: '18px',
margin: '0 0 4px 0',
padding: '0'
}
});
 
// Add the title to the panel
legend.add(legendTitle);
 
// create the legend image
var lon = ee.Image.pixelLonLat().select('latitude');
var gradient = lon.multiply((ndviVis.max-ndviVis.min)/100.0).add(ndviVis.min);
var legendImage = gradient.visualize(ndviVis);
 
// create text on top of legend
var panel = ui.Panel({
widgets: [
ui.Label(ndviVis['max'])
],
});
 
legend.add(panel);
 
// create thumbnail from the image
var thumbnail = ui.Thumbnail({
image: legendImage,
params: {bbox:'0,0,10,100', dimensions:'10x200'},
style: {padding: '1px', position: 'bottom-center'}
});
 
// add the thumbnail to the legend
legend.add(thumbnail);
 
// create text on top of legend
var panel = ui.Panel({
widgets: [
ui.Label(ndviVis['min'])
],
});
 
legend.add(panel);
 
Map.add(legend);

*/
