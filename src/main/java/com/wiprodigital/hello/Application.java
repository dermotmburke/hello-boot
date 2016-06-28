package com.wiprodigital.hello;

import static springfox.documentation.builders.PathSelectors.regex;

import java.util.Map;
import java.util.HashMap;

import io.swagger.annotations.*;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Configuration
@EnableAutoConfiguration
@SpringBootApplication
@Controller
@EnableSwagger2
public class Application {

    @ApiOperation(value = "getGreeting", nickname = "getGreeting")
    @ApiResponses(value = {
            @ApiResponse(code = 200, message = "Success", response = Map.class),
            @ApiResponse(code = 401, message = "Unauthorized"),
            @ApiResponse(code = 403, message = "Forbidden"),
            @ApiResponse(code = 404, message = "Not Found"),
            @ApiResponse(code = 500, message = "Failure")})
    @RequestMapping(value = "/api", method = RequestMethod.GET, produces = "application/json")
	@ResponseBody
	public Map<String, String> getGreeting() {
        Map<String, String> map = new HashMap<String, String>();
        map.put("greeting", "Howdy");
        return map;
    }

    public static void main(String[] args) throws Exception {
		SpringApplication.run(Application.class, args);
	}

    @Bean
    public Docket api() {
        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
                .select()
                .paths(regex("/api.*"))
                .build();
    }

    private ApiInfo apiInfo() {
        return new ApiInfoBuilder()
                .title("hello-boot")
                .description("Hello Boot Sample Application")
                .contact("Dermot Burke")
                .license("Apache License Version 2.0")
                .version("2.0")
                .build();
    }

}
