package link.bosswang.app.b.config;


import io.seata.spring.annotation.GlobalTransactionScanner;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.util.StringUtils;

import javax.annotation.Resource;

@Configuration
public class SeataConfig {
    @Resource
    private ApplicationContext applicationContext;
    /**
     * 初始化GlobalTransactionScanner
     */
//    @Bean
//    public GlobalTransactionScanner globalTransactionScanner() {
//        String applicationName = this.applicationContext.getEnvironment().getProperty("spring.application.name");
//        String txServiceGroup = this.seataProperties.getTxServiceGroup();
//        if (StringUtils.isEmpty(txServiceGroup)) {
//            txServiceGroup = applicationName + "-fescar-service-group";
//            this.seataProperties.setTxServiceGroup(txServiceGroup);
//        }
//
//        return new GlobalTransactionScanner(applicationName, txServiceGroup);
//    }
}
