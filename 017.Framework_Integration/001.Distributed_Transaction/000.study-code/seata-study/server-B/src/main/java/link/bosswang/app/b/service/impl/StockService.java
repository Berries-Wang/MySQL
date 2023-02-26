package link.bosswang.app.b.service.impl;

import org.springframework.web.bind.annotation.RequestParam;

public interface StockService {


    public abstract String reduce(@RequestParam("itemId") String itemId);
}