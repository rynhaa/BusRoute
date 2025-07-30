package com.busroute.domain;

import com.busroute.domain.Criteria;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
	
	private int startPage;
	private int endPage;
	private boolean prev,next;
	
	private int total;
	private Criteria cri;		// �˻� Ŭ����
	
	public PageDTO(Criteria cri, int total) { 
		
		this.cri = cri;
		this.total = total;
		
		// 1�������϶� 1 / 10 = 0.1 �� �Ǵµ� int �۾����� 1�̵� 1 * 10 = 10 
		// 3�������϶� 3 / 10 = 0.3 �� �Ǵµ� int �۾����� 1�̵� 1 * 10 = 10 (9�������� ��������)
		// 11�������϶� 11 / 10 = 1.1�̵Ǹ�, int �۾����� 2���� 2 * 10 = 20 (11 ~ 20�� ����)
		this.endPage = (int)(Math.ceil(cri.getPageNum() / 10.0)) * 10;
		
		
		this.startPage = this.endPage - 9;
		
		// ���� ��Ż 123���� �Խù��� �ִٸ� 123 * 1 / 10 �� �۾��̵Ǹ� Math.ceil �� ������ +1
		// 123 * 1 = 123 / 10 = 12.3 ����ȯ int �� �Ҽ����� �����µ� Math.ceil ȿ���� 13�� ��
		int realEnd = (int)(Math.ceil((total * 1.0 / cri.getAmount())));
		
		if(realEnd < this.endPage) {
			this.endPage = realEnd;
		}
		
		this.prev = this.startPage > 1;
		
		this.next = this.endPage < realEnd;
	}
}
