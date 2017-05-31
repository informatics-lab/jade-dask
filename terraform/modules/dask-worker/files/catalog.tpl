<?xml version="1.0" encoding="UTF-8"?>
<catalog xmlns="http://www.unidata.ucar.edu/namespaces/thredds/InvCatalog/v1.0"
         xmlns:xlink="http://www.w3.org/1999/xlink"
         name="Unidata THREDDS Data Server"
         version="1.0.6">

  <service name="mogreps" base="" serviceType="compound">
    <service name="OpenDAP" serviceType="OpenDAP" base="/thredds/dodsC/" />
  </service>

  <datasetScan name="S3 Mogreps G" collectionType="TimeSeries" ID="mogreps/g/S3"
          path="mogreps/g/S3" location="s3://mogreps-g-sample2" serviceName="mogreps">
    <crawlableDatasetImpl className="thredds.crawlabledataset.s3.CrawlableDatasetAmazonS3"/>
  </datasetScan>

</catalog>
