package com.seeree.orderapp;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ValidateProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String prodName = req.getParameter("name");
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        if (prodName == null || prodName.trim().isEmpty()) {
            out.write("{\"found\":false}");
            return;
        }

        String sql = "SELECT ProdID, ProdRate, ProdQty FROM Product_Master WHERE ProdName = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, prodName.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int prodId = rs.getInt("ProdID");
                    double rate = rs.getDouble("ProdRate");
                    int qty = rs.getInt("ProdQty");
                    out.write("{\"found\":true,\"prodId\":" + prodId
                            + ",\"rate\":" + rate
                            + ",\"qty\":" + qty + "}");
                } else {
                    out.write("{\"found\":false}");
                }
            }
        } catch (SQLException e) {
            out.write("{\"found\":false,\"error\":\"" + e.getMessage().replace("\"", "'") + "\"}");
        }
    }
}