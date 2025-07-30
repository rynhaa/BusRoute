package com.busroute.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.busroute.domain.BoardVO;
import com.busroute.domain.Criteria;

public interface BoardMapper {
	
	// �Խ��� ����Ʈ ��� �޼ҵ�(pageing ó���� �ȵǾ� �ִ°�)
	public List<BoardVO> list();	// VO �� �ִ� ������ �־��.
	
	// �Խ��� ����Ʈ ��� �޼ҵ� (pageing ó���� �Ǿ��ִ°�)
	public List<BoardVO> getListWithPaging(Criteria cri);
	
	// tbl_board ���̺� ��ü ����
	public int getTotalCount(Criteria cri);
	
	// ��� ����Ʈ���� ������ Ŭ���ϸ� �� ���� ȭ�� �̵�
	public BoardVO read(int board_id);

	// ��� ����Ʈ���� ������ Ŭ���ϸ� ��ȸ�� 1 �� ����.
	public void CountUpdate(int board_id);
	
	// �Խ��ǹ�ȣ, ������ ����� ������ ������Ʈ �ϱ� ���� mapper
	public void update(BoardVO board);
	
	// �Խ��� ����
	public void delete(int board_id);
	
	// �۾��� ��ư Ŭ��
	public void insert(BoardVO board);

	public void insertSelectKey(BoardVO board);
	
	// 모든 게시글 is_pinned = false 로 변경
	public void unpinAll();

	// 특정 게시글들만 is_pinned = true 로 변경
	public void pinBoards(List<Integer> boardIds);

	void updatePinStatus(@Param("boardId") int boardId, @Param("pinned") boolean pinned);

}
