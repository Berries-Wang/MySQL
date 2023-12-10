package com.berries.wang;

import com.berries.wang.service.CaseInsensitiveSummarizeDataMakeService;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@ComponentScan("com.berries.wang")
@SpringBootApplication
@EnableTransactionManagement
@EnableJpaRepositories
public class MySQLSTUApplication {
    public static void main(String[] args) {
        ApplicationContext applicationContext = SpringApplication.run(MySQLSTUApplication.class);
        System.out.println("=====> MySQLSTUApplication started");

        CaseInsensitiveSummarizeDataMakeService dataMakeService = applicationContext.getBean(CaseInsensitiveSummarizeDataMakeService.class);
        // dataMakeService.makeCaseInsensitiveSummarizeData();
        dataMakeService.makeGroupByDate();
    }
}
