package link.bosswang.app.b.controller;


import link.bosswang.app.b.service.impl.StockService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;

@RequestMapping(value = "/stock")
@Controller
public class StockController {

    @Resource
    private StockService stockService;

    @RequestMapping(value = "/reduce", method = RequestMethod.GET)
    @ResponseBody
    public String reduce(@RequestParam("itemId") String itemId) {
        return stockService.reduce(itemId);
    }
}
