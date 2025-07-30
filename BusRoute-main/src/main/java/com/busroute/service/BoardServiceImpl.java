package com.busroute.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.busroute.domain.BoardVO;
import com.busroute.domain.Criteria;

import com.busroute.mapper.BoardMapper;

import com.busroute.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Service
@AllArgsConstructor
public class BoardServiceImpl implements BoardService {
	
	private BoardMapper mapper;
	
	// paging ó�� X
	public List<BoardVO> list() {
		
		return mapper.list();
		
	}
	
	// paging ó�� O
	public List<BoardVO> getListWithPaging(Criteria cri){
		
		return mapper.getListWithPaging(cri);
	}
	
	// tbl_board ���̺� ��ü ����
	public int getTotalCount(Criteria cri) {
		
		return mapper.getTotalCount(cri);
	}
	
	// ��� ����Ʈ���� ������ Ŭ���Ͽ� �󼼳��� ȭ������ �̵� �޼ҵ�
	@Transactional
	public BoardVO get(int board_id) {
		// ��ȸ���� 1�� �����ϱ� ���� DataBase �۾�
		mapper.CountUpdate(board_id);
		// ������ Ŭ���ϸ� �󼼳����� select �ϱ� ���� DataBase �۾�
		return mapper.read(board_id);
	}
	
	// �Խ��ǹ�ȣ, ������ ����� ������ ������Ʈ ����
	public void modify(BoardVO board) {
		
		mapper.update(board);
	}
	
	// �Խ��� ����
	public void remove(int board_id) {
		
		mapper.delete(board_id);
	}
	
	public void register(BoardVO board) {
		
		mapper.insertSelectKey(board);
	}
	
	// 모든 게시글 is_pinned = false 로 변경
	public void unpinAll() {
	    mapper.unpinAll();
	}

	// 특정 게시글들만 is_pinned = true 로 변경
	public void pinBoards(List<Integer> boardIds) {
	    mapper.pinBoards(boardIds);
	}
	
	@Override
	public void unpinBoards(List<Integer> boardIds) {
	    for (Integer boardId : boardIds) {
	        mapper.updatePinStatus(boardId, false); // MyBatis 또는 JPA 기준
	    }
	}
	
}
