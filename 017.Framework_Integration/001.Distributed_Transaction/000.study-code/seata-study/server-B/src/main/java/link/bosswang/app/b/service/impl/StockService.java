package link.bosswang.app.b.service.impl;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

public interface StockService {


    public abstract String reduce(String itemId);
}
