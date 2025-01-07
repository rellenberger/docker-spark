A dockerfile for configuring a Python based Apache Spark image. A docker compose file to bring up two services based on this image; one master and one worker.
Two storage volumes are bound to the local machine; ./book_data:/opt/spark/data and ./spark_apps:/opt/spark/apps
