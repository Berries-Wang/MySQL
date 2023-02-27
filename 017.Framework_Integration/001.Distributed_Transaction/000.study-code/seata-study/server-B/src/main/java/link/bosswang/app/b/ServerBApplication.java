package link.bosswang.app.b;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.context.ApplicationContext;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@SpringBootApplication
@EnableTransactionManagement
@EnableFeignClients
@EnableJpaRepositories
public class ServerBApplication {
    public static void main(String[] args) {
        ApplicationContext applicationContext = SpringApplication.run(ServerBApplication.class);
        System.out.println("=====> Server-B started");
    }
}
