package com.busroute.domain;

public class BoardingDTO {
    // 날짜: "YYYY-MM-DD" 형태로 일별 데이터 표현
    private String date;

    // 해당 날짜의 탑승 인원 합계 (예측 데이터)
    private Integer boarding;

    public BoardingDTO() {}

    public BoardingDTO(String date, Integer boarding) {
        this.date = date;
        this.boarding = boarding;
    }

    // getter, setter
    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public Integer getBoarding() {
        return boarding;
    }

    public void setBoarding(Integer boarding) {
        this.boarding = boarding;
    }

    @Override
    public String toString() {
        return "BoardingDTO{" +
                "date='" + date + '\'' +
                ", boarding=" + boarding +
                '}';
    }
}
