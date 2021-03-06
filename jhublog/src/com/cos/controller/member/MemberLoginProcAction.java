package com.cos.controller.member;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.cos.controller.Action;
import com.cos.dao.MemberDAO;
import com.cos.util.MyUtils;
import com.cos.util.SHA256;

public class MemberLoginProcAction implements Action {
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String url = "main.jsp";

		String userId = request.getParameter("userId");
		
		//userPassword를 암호화해서 select하기
		String userPassword = SHA256.getEncrypt(request.getParameter("userPassword"), "cos");
		String idSave = request.getParameter("idSave");

		if (idSave != null) {
			if (idSave.equals("on")) {
				Cookie cookie = new Cookie("cookieId", userId);
				cookie.setMaxAge(3600); // 3600초
				response.addCookie(cookie);
			}
		} else {
			Cookie cookie = new Cookie("cookieId", null);
			cookie.setMaxAge(0); // 3600초
			response.addCookie(cookie);
		}

		MemberDAO memberDAO = MemberDAO.getInstance();

		int result = memberDAO.findByUserIdAndUserPassword(userId, userPassword);
		int adminCheck = memberDAO.adminCheck(userId);

		if (result == 1 && adminCheck == 0) {
			// 로그인 완료(세션)
			HttpSession session = request.getSession();
			session.setAttribute("userId", userId);
			session.setAttribute("admin", "관리자");
			
			// main.jsp로 이동
			RequestDispatcher dis = request.getRequestDispatcher(url);
			dis.forward(request, response);
			
		} else if (result == 1 && adminCheck == 1) {
			HttpSession session = request.getSession();
			session.setAttribute("userId", userId);
			session.setAttribute("admin", "회원");
			
			RequestDispatcher dis = request.getRequestDispatcher(url);
			dis.forward(request, response);
			
		} else if (result == 0) {
			// 로그인 실패
			MyUtils.script("아이디 혹은 비밀번호가 일치하지 않습니다.", response);
		} else {
			// 서버오류
			MyUtils.script("서버에러", response);
		}

	}

}
