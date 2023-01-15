//Funcion para sumar la PPT mensual (devuelve una lista de imagenes)


//var ROIs = ee.Geometry.Point(-56.4534, -11.2812).buffer(1e5);
var ROIs = Amazonforest;
print(ROIs)
var LAIs = ee.ImageCollection('MODIS/006/MCD15A3H')
          .filterDate('2003-01-01', '2020-12-31')
//         .filter(ee.Filter.calendarRange(1,12,'month'))
          .select('Lai');

var EVIs = ee.ImageCollection('MODIS/006/MOD13A1')
          .filterDate('2003-01-01', '2020-12-31')
//          .filter(ee.Filter.calendarRange(1,12,'month'))
          .select('EVI');
          
var years = ee.List.sequence(2003, 2020);

var LAIs_mean = years.map(function(y) {
  // Filter to 1 month.
  var LAI_mean = LAIs.filter(ee.Filter.calendarRange(y, y, 'year')).max();
  var year = ee.Image.constant(y).uint16().rename('year');
return LAI_mean.addBands(year).set('year', y);
});


var LAIs_mean = ee.ImageCollection(LAIs_mean)


var EVIs_mean = years.map(function(y) {
  var EVI_mean = EVIs.filter(ee.Filter.calendarRange(y, y, 'year')).max();
  var year = ee.Image.constant(y).uint16().rename('year');
return EVI_mean.addBands(year).set('year', y);
});


var EVIs_mean = ee.ImageCollection(EVIs_mean)


print(LAIs_mean)
print(EVIs_mean)

var trend_LAI = LAIs_mean.select(['year', 'Lai'])
  .reduce(ee.Reducer.linearFit());
  
  var trend_EVI = EVIs_mean.select(['year', 'EVI'])
  .reduce(ee.Reducer.linearFit());

//var areas = trend_LAI.select('scale').lt(0)//.and(trend_EVI.select('scale').gt(0)).rename('scale').multiply(trend_EVI.divide(10000).subtract(trend_LAI.divide(70)))


// forest to crop
var LCs = ee.ImageCollection('MODIS/006/MCD12Q1')
          .filterDate('2001-01-01', '2020-12-31')
          .select('LC_Type1');

var years = ee.List.sequence(2006, 2014);

var LCs_f2c = years.map(function(y) {
  // Filter to 1 month. ee.Number(y).add(-1)
  var LC_1 = LCs.filter(ee.Filter.calendarRange(ee.Number(y).add(-1), ee.Number(y).add(-1), 'year')).first();
  var LC_2 = LCs.filter(ee.Filter.calendarRange(y, y, 'year')).first();
  LC_1 = LC_1.eq(2);
return LC_1.and(LC_2.eq(12).or(LC_2.eq(10)).or(LC_2.eq(9)));
});


var years = ee.List.sequence(2001, 2005);

var LC_before = years.map(function(y) {
  // Filter to 1 month. ee.Number(y).add(-1)
  var LC_1 = LCs.filter(ee.Filter.calendarRange(y, y, 'year')).first();
  LC_1 = LC_1.eq(2).or(LC_1.eq(3)).or(LC_1.eq(4)).or(LC_1.eq(1)).or(LC_1.eq(5))
return LC_1;
});


var years = ee.List.sequence(2015, 2018);

var LC_after = years.map(function(y) {
  // Filter to 1 month. ee.Number(y).add(-1)
  var LC_1 = LCs.filter(ee.Filter.calendarRange(y, y, 'year')).first();
  LC_1 = LC_1.eq(12);//.or(LC_1.eq(10))//.or(LC_1.eq(9));
return LC_1;
});


var LCs_forest = LCs.map(function(LC) {

 return LC.eq(2).or(LC.eq(3)).or(LC.eq(4)).or(LC.eq(1))
});

var LCs_crop = LCs.map(function(LC) {

// return LC.eq(10) for grassland
 return LC.eq(12) // for cropland
});

var LC_all = LCs_forest.reduce(ee.Reducer.or()).and(LCs_crop.reduce(ee.Reducer.or()));

//Map.addLayer(LC_all, {},'LC')


var LCs_f2c = ee.ImageCollection(LCs_f2c);
var LC_before = ee.ImageCollection(LC_before);
var LC_after = ee.ImageCollection(LC_after);


print(1)

var areas =LCs_f2c.max().eq(1).and(LC_before.sum().eq(5)).and(LC_after.sum().eq(4)).rename('scale');
var areas =(LC_before.sum().eq(5)).and(LC_after.sum().eq(4)).rename('scale');
print(1)
var LAIs_mean = LAIs_mean.map(function(image) { var image_n = image.select('Lai').subtract(LAIs_mean.select('Lai').mean()).divide(LAIs_mean.select('Lai').mean()).rename('Lai_n')
  return image.addBands(image_n).updateMask(areas).clip(ROIs)});
var EVIs_mean = EVIs_mean.map(function(image) { var image_n = image.select('EVI').subtract(EVIs_mean.select('EVI').mean()).divide(EVIs_mean.select('EVI').mean()).rename('EVI_n')
  return image.addBands(image_n).updateMask(areas).clip(ROIs)});
var LCs = LCs.map(function(image) {return image.updateMask(areas).clip(ROIs)});



var points = areas.selfMask().stratifiedSample({numPoints:100000, region:ROIs, geometries: true, scale: 500} )
// We need a unique id for each point. We take the feature id and set it as
// a property so we can refer to each point easily
var points = points.map(function(feature) {
  return ee.Feature(feature.geometry(), {'id': feature.id()})
})

print(points)
// Show the farm locations in green
Map.addLayer(ROIs, {color: 'red'}, 'Amazon')
Map.addLayer(points, {color: 'green'}, 'LUCC Locations')



Map.addLayer(areas,  {min: 0, max: 1, bands: ['scale']},'LCs')


/////////Export Point data////////////////

// Empty Collection to fill
var ft = ee.FeatureCollection(ee.List([]))

var fill = function(img, ini) {
  // type cast
  var inift = ee.FeatureCollection(ini)

  // gets the values for the points in the current img
  var ft2 = img.reduceRegions(points, ee.Reducer.first(),500)

  // gets the date of the img
 // var date = img.date().format()

  // writes the date in each feature
  //var ft3 = ft2.map(function(f){return f.set("date", date)})

  // merges the FeatureCollections
  return inift.merge(ft2)
}


// Iterates over the ImageCollection
var newft =ee.FeatureCollection(EVIs_mean.iterate(fill, ft));


Export.table.toDrive({collection:newft,
  folder: 'LUCC_AMAZON',
  fileFormat: 'CSV',
description:'all_points_EVI_new'})


var newft =ee.FeatureCollection(LAIs_mean.iterate(fill, ft));


Export.table.toDrive({collection:newft,
  folder: 'LUCC_AMAZON',
  fileFormat: 'CSV',
description:'all_points_LAI_new'})


///////////////////////////

trend_LAI = trend_LAI.updateMask(areas).select('scale')
trend_EVI = trend_EVI.updateMask(areas).select('scale')

/*
// Pre-define some customization options.
var options = {
  title: 'Trend of LAI',
  fontSize: 20,
  hAxis: {title: 'LAI'},
  vAxis: {title: 'count of LAI'},
  series: {
    0: {color: 'blue'}},
  maxPixels: 1e14
};

// Make the histogram, set the options.
var histogram = ui.Chart.image.histogram(trend_LAI, ROIs, 500)
    .setSeriesNames(['LAI'])
    .setOptions(options);
// Display the histogram.
print(histogram);

// Pre-define some customization options.
var options = {
  title: 'EVI',
  fontSize: 20,
  hAxis: {title: 'Trend of EVI'},
  vAxis: {title: 'count of EVI'},
  series: {
    0: {color: 'red'}},
  maxPixels: 1e14
};

// Make the histogram, set the options.
var histogram = ui.Chart.image.histogram(trend_EVI, ROIs, 500)
    .setSeriesNames(['EVI'])
    .setOptions(options);
// Display the histogram.
print(histogram);
*/

var hist = trend_LAI.reduceRegion({
  reducer: ee.Reducer.autoHistogram(),
  geometry: ROIs,
  scale: 500,
  bestEffort: true,
});

var histArray = ee.Array(hist.get('scale'));
var binBottom = histArray.slice(1, 0, 1).project([0]);
var nPixels = histArray.slice(1, 1, null).project([0]);
var histColumnFromArray = ui.Chart.array.values({
  array:nPixels,
  axis: 0,
  xLabels: binBottom})
  .setChartType('ColumnChart');
print(histColumnFromArray);


var hist = trend_EVI.reduceRegion({
  reducer: ee.Reducer.autoHistogram(),
  geometry: ROIs,
  scale: 500,
  bestEffort: true,
});

var histArray = ee.Array(hist.get('scale'));
var binBottom = histArray.slice(1, 0, 1).project([0]);
var nPixels = histArray.slice(1, 1, null).project([0]);
var histColumnFromArray = ui.Chart.array.values({
  array:nPixels,
  axis: 0,
  xLabels: binBottom})
  .setChartType('ColumnChart');
print(histColumnFromArray);

// Display the results.
//Map.addLayer(areas, //min: 0, max: 1
//  {min: 0, max: 1, bands: ['scale']}, 'areas');
  
  
  // Plot a time series at one ROI point.
var COLOR = {
  ROI: 'ff0000'
};




var COLOR = {
  FOREST: 'ff0000',
  PASTURE: '0000ff'
};

var forest = ee.Feature(    // San Francisco.  -55.2596, -11.5061 -55.72357, -11.492),
    ee.Geometry.Point(-54.9392, -12.0798),
    {label: 'Site1'});
var pasture = ee.Feature(  // Tahoe National Forest.
    ee.Geometry.Point(-54.9351, -12.0852),
    {label: 'Site2'});

    
    

//40.0329	-105.5464 -63.2419, -16.6914
//-57.2702, -12.3417
//var ROIs = ee.Feature(    // San Francisco. 
//    ee.Geometry.Point(-51.45, -1.75),
//     ee.Geometry.Point(-54.89, -3.02),
//    {label: {'Foresr','Pasture'}});
Map.setCenter(-51.45, -1.75 , 5)
//Map.addLayer(ROIs, {color: COLOR.ROI});


var Regions = new ee.FeatureCollection([ROIs]);


var LAITimeSeries= ui.Chart.image.seriesByRegion({
imageCollection  : LAIs_mean,
regions          : ROIs,
reducer          : ee.Reducer.mean(),//stdDev
band             : 'Lai_n',
scale            : 500,
xProperty        : 'year',
seriesProperty   : 'label'
});
LAITimeSeries.setChartType('ScatterChart');
LAITimeSeries.setOptions({
  title: 'MODIS Lai over time',
  vAxis: {
    title: 'Lai'
  },
  lineWidth: 1,
  pointSize: 4,
  series: {
    0: {color: COLOR.FOREST},
    1: {color: COLOR.PASTURE}
  }
});

print(LAITimeSeries);




var EVITimeSeries = ui.Chart.image.seriesByRegion({
  imageCollection: EVIs_mean,
  regions: ROIs,
  reducer: ee.Reducer.mean(),
  band: 'EVI_n',
  scale: 500,
  xProperty: 'year',
  seriesProperty: 'label'
});
EVITimeSeries.setChartType('ScatterChart');
EVITimeSeries.setOptions({
  title: 'MODIS EVI over time',
  vAxis: {
    title: 'EVI'
  },
  lineWidth: 1,
  pointSize: 4,
  series: {
    0: {color: COLOR.FOREST},
    1: {color: COLOR.PASTURE}
  }
});

print(EVITimeSeries);


// Plot a time series of a band's value in regions of the American West.

var LCTimeSeries = ui.Chart.image.seriesByRegion({
  imageCollection: LCs,
  regions: Regions,
  reducer: ee.Reducer.mean(),
  band: 'LC_Type1',
  scale: 500,
  xProperty: 'system:time_start',
  seriesProperty: 'label'
});
LCTimeSeries.setChartType('ScatterChart');
LCTimeSeries.setOptions({
  title: 'MODIS LCs',
  vAxis: {
    title: 'LC_Type1'
  },
  lineWidth: 1,
  pointSize: 4,
  series: {
    0: {color: COLOR.FOREST},
    1: {color: COLOR.PASTURE}
  }
});

print(LCTimeSeries);



// before 2005
var LAI_before = ee.ImageCollection('MODIS/006/MOD15A2H')
          .filterDate('2001-01-01', '2005-12-31')
          .filter(ee.Filter.calendarRange(1,2,'month'))
          .select('Lai_500m').mean();

var EVI_before = ee.ImageCollection('MODIS/006/MOD13A1')
          .filterDate('2001-01-01', '2005-12-31')
          .filter(ee.Filter.calendarRange(1,2,'month'))
          .select('EVI').mean();

// after 2015
var LAI_after = ee.ImageCollection('MODIS/006/MOD15A2H')
          .filterDate('2015-01-01', '2020-12-31')
          .filter(ee.Filter.calendarRange(1,2,'month'))
          .select('Lai').mean();

var EVI_after = ee.ImageCollection('MODIS/006/MOD13A1')
          .filterDate('2015-01-01', '2020-12-31')
          .filter(ee.Filter.calendarRange(1,2,'month'))
          .select('EVI').mean();
          
//var filters = LAI_before.subtract(LAI_after).gt(5).and(EVI_before.subtract(EVI_after).lt(-200)).rename("scale")

//var filters_all = filters.eq(1).and(LC_all.eq(1)).rename("scale");
//Map.addLayer(filters, //min: 0, max: 1
 // {min: 0, max: 1, bands: ['scale']}, 'trend');
  
 // Map.addLayer(filters_all, //min: 0, max: 1
//  {min: 0, max: 1, bands: ['scale']}, 'trend_LC');
