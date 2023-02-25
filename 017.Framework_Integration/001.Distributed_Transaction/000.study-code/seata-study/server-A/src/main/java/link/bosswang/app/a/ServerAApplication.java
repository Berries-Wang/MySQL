package link.bosswang.app.a;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.openfeign.EnableFeignClients;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@SpringBootApplication
@EnableTransactionManagement
@EnableFeignClients
public class ServerAApplication {
    public static void main(String[] args) {
        SpringApplication.run(ServerAApplication.class);
        System.out.println("=====> Server-A started");
    }
}
