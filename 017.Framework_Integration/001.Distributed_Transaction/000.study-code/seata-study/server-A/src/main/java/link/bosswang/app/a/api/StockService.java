package link.bosswang.app.a.api;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@FeignClient(value = "seata-stu-b", path = "/stock")
public interface StockService {


    @RequestMapping(value = "/reduce")
    public abstract String reduce(@RequestParam("itemId") String itemId);
}