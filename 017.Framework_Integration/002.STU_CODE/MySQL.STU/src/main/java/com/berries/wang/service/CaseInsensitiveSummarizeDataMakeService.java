package com.berries.wang.service;

import com.berries.wang.dao.CaseInsensitiveSummarizeData;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.UUID;

@Service
public class CaseInsensitiveSummarizeDataMakeService {

    @Resource
    private CaseInsensitiveSummarizeDataMakeService caseInsensitiveSummarizeDataMakeService;

    @Resource
    private JdbcTemplate jdbcTemplate;

    public void makeCaseInsensitiveSummarizeData() {
        System.out.println("数据开始创建...");
        int count = 0;
        while (count < 100000) {
            CaseInsensitiveSummarizeData data = new CaseInsensitiveSummarizeData();
            String uuid = UUID.randomUUID().toString().replace("-", "");
            data.setA(uuid + "A");
            data.setB(uuid + 'B');
            data.setC(uuid + "C");
            data.setD(uuid + 'D');
            caseInsensitiveSummarizeDataMakeService.makeCaseInsensitiveSummarizeData(data);


            CaseInsensitiveSummarizeData data2 = new CaseInsensitiveSummarizeData();
            data2.setA(uuid + "a");
            data2.setB(uuid + 'b');
            data2.setC(uuid + "c");
            data2.setD(uuid + 'd');
            caseInsensitiveSummarizeDataMakeService.makeCaseInsensitiveSummarizeData(data2);

            count++;
        }

        System.out.println("数据创建完成");
    }

    @Transactional
    public void makeCaseInsensitiveSummarizeData(CaseInsensitiveSummarizeData data) {
        jdbcTemplate.update(String.format("INSERT INTO case_insensitive_summarize_data(gmt_create,gmt_modified,a,b,c,d) VALUES(NOW(),NOW(),'%s','%s','%s','%s');", data.getA(), data.getB(), data.getC(), data.getD()));
    }
}
