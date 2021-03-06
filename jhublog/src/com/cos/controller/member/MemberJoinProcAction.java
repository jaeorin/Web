package com.cos.controller.member;

import java.io.IOException;
import java.time.LocalDate;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cos.controller.Action;
import com.cos.dao.MemberDAO;
import com.cos.domain.Member;
import com.cos.util.MyUtils;
import com.cos.util.SHA256;

public class MemberJoinProcAction implements Action {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String url = "main.jsp";
		String userId = request.getParameter("userId");
		String userPassword = request.getParameter("userPassword");
		String userEmail = request.getParameter("userEmail");
		String userPhone = request.getParameter("userPhone");
		String userGender = request.getParameter("userGender");
		String userAddr = request.getParameter("roadFullA18ddr");

		String salt = "cos";
		userPassword = SHA256.getEncrypt(userPassword, salt);
		
		Member member = new Member();
		
		member.setUserId(userId);
		member.setUserPassword(userPassword);
		member.setUserEmail(userEmail);
		member.setUserPhone(userPhone);
		member.setUserGender(userGender);
		member.setUserState(1);
		member.setCreateDate(LocalDate.now());
		member.setUpdateDate(LocalDate.now());
		member.setUserAddr(userAddr);
		
		MemberDAO memberDAO = MemberDAO.getInstance();
		int result = memberDAO.save(member);
		
		if(result == 1) {
			RequestDispatcher dis = request.getRequestDispatcher(url);
			dis.forward(request, response);
		}else if(result == 0) {
			MyUtils.script("DB오류", response);
		}else if(result == -1) {
			MyUtils.script("서버오류", response);
		}
		
	}

}
