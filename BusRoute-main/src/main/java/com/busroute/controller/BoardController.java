package com.busroute.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.busroute.domain.Criteria;
import com.busroute.domain.PageDTO;
import com.busroute.service.BoardService;
import com.busroute.domain.BoardVO;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor		
public class BoardController {
	
	private BoardService service;
	
	@GetMapping("/list") 
	public void list(Criteria cri, Model model) {
		
		
		model.addAttribute("list", service.getListWithPaging(cri));
		int total = service.getTotalCount(cri);
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	}
	
	@GetMapping("/admin/list")
	public void adminlist(Criteria cri, Model model) {
		
		
		model.addAttribute("list", service.getListWithPaging(cri));
		int total = service.getTotalCount(cri);
		model.addAttribute("pageMaker", new PageDTO(cri, total));
	}

	
	@GetMapping("/admin/read")
	public void get(@RequestParam("board_id") int board_id, Model model) {
		
		
		
		model.addAttribute("board", service.get(board_id));
		
	}
	
    @GetMapping("/admin/write")
    public void write(HttpSession session) {
    	session.setAttribute("writer_id","관리자"); 
    }
    
	
	@PostMapping("/admin/write")
	public String writepost(BoardVO board, HttpSession session) {

		String writer_id = (String)session.getAttribute("writer_id");
		board.setWriter_id(writer_id);
		
		service.register(board);	// insert
		
		
		return "redirect:/board/admin/list";
	}
	
	@GetMapping("/admin/modify")
	public void modify(@RequestParam("board_id") int board_id, Model model) {
		
		model.addAttribute("board", service.get(board_id));
		
	}
	
	
	@PostMapping("/admin/modify")
	public String modifypost(BoardVO board, RedirectAttributes rttr) {
		
		service.modify(board);	// update
		
		
		rttr.addAttribute("board_id", board.getBoard_id());
		
		return "redirect:/board/admin/list";
	}
	
	
	@GetMapping("/admin/remove")
	public String remove(@RequestParam("board_id") int board_id) {
		
		service.remove(board_id);	// delete
		
		
		return "redirect:/board/admin/list";
		
	}
	
	@PostMapping("/admin/deleteSelected")
	public String deleteSelected(@RequestParam("boardIds") List<Integer> boardIds, RedirectAttributes rttr) {
	    for (Integer id : boardIds) {
	        service.remove(id); // 또는 boardMapper.delete(id)
	    }
	    rttr.addFlashAttribute("message", boardIds.size() + "건 삭제되었습니다.");
	    return "redirect:/board/admin/list";
	}
	
	
	@PostMapping("/admin/pinSelected")
	public String pinSelected(@RequestParam("boardIds") List<Integer> boardIds, RedirectAttributes rttr) {
	    if (boardIds == null || boardIds.isEmpty()) {
	        rttr.addFlashAttribute("errorMsg", "게시글을 선택하세요.");
	        return "redirect:/board/admin/list";
	    }

	    // 1) 기존 고정 해제
	    service.unpinAll();

	    // 2) 선택 게시글 고정 처리
	    service.pinBoards(boardIds);

	    rttr.addFlashAttribute("msg", "상단 고정이 완료되었습니다.");
	    return "redirect:/board/admin/list";
	}
	
	
	@PostMapping("/admin/unpinSelected")
	public String unpinSelected(@RequestParam("boardIds") List<Integer> boardIds, RedirectAttributes rttr) {
	    if (boardIds == null || boardIds.isEmpty()) {
	        rttr.addFlashAttribute("errorMsg", "게시글을 선택하세요.");
	        return "redirect:/board/admin/list";
	    }

	    service.unpinBoards(boardIds); // 선택된 게시글만 고정 해제

	    rttr.addFlashAttribute("msg", "선택된 게시글의 상단 고정이 해제되었습니다.");
	    return "redirect:/board/admin/list";
	}
	
}
