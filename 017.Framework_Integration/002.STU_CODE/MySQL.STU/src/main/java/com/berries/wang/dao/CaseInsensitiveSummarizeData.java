package com.berries.wang.dao;

import lombok.Data;
import lombok.ToString;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;
import java.util.Date;

@Entity
@Data
@ToString
@Table(name = "case_insensitive_summarize_data")
public class CaseInsensitiveSummarizeData implements Serializable {
    @Id
    private Long id;
    private Date gmtCreate;
    private Date gmtModified;
    private String a;/*utf8mb4*/
    private String b;/*utf8mb4_bin*/
    private String c;/*utf8mb4*/
    private String d;/*utf8mb4_bin*/
}
