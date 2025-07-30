package com.busroute.service;

import java.util.List;

import com.busroute.domain.Criteria;

import com.busroute.domain.BoardVO;

public interface BoardService {
	
	public List<BoardVO> list();
	
	public List<BoardVO> getListWithPaging(Criteria cri);
	
	public int getTotalCount(Criteria cri);
	
	public BoardVO get(int board_id);
	
	public void modify(BoardVO board);
	
	public void remove(int board_id);
	
	public void register(BoardVO board);

	// 모든 게시글 is_pinned = false 로 변경
	public void unpinAll();

	// 특정 게시글들만 is_pinned = true 로 변경
	public void pinBoards(List<Integer> boardIds);
	
	public void unpinBoards(List<Integer> boardIds);
}
