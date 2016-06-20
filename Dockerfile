FROM java
ADD /target/hello-boot-1.0.7.jar //
ENTRYPOINT ["java", "-jar", "/hello-boot-1.0.7.jar"]
