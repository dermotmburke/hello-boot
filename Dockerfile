FROM java
ADD /target/hello-boot.jar //
ENTRYPOINT ["java", "-jar", "/hello-boot.jar"]
