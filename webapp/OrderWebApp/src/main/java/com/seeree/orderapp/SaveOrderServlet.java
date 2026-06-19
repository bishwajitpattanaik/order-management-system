package com.seeree.orderapp;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SaveOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();

        int prodId;
        int qty;

        try {
            prodId = Integer.parseInt(req.getParameter("prodId"));
            qty = Integer.parseInt(req.getParameter("qty"));
        } catch (NumberFormatException e) {
            out.write("{\"success\":false,\"message\":\"Invalid product or quantity.\"}");
            return;
        }

        if (qty <= 0) {
            out.write("{\"success\":false,\"message\":\"Quantity must be greater than zero.\"}");
            return;
        }

        try (Connection conn = DBUtil.getConnection()) {

            // Re-check current rate & stock server-side (source of truth, not trusting client)
            double rate;
            int availableQty;

            String checkSql = "SELECT ProdRate, ProdQty FROM Product_Master WHERE ProdID = ?";
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setInt(1, prodId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        out.write("{\"success\":false,\"message\":\"Product not found.\"}");
                        return;
                    }
                    rate = rs.getDouble("ProdRate");
                    availableQty = rs.getInt("ProdQty");
                }
            }

            if (qty > availableQty) {
                out.write("{\"success\":false,\"message\":\"Order qty exceeds available stock (" + availableQty + ").\"}");
                return;
            }

            double orderValue = qty * rate;

            String insertSql = "INSERT INTO Order_Master (OrderDate, ProdID, ProdRate, OrderQty, OrderValue) "
                              + "VALUES (CURDATE(), ?, ?, ?, ?)";

            int newOrderId = -1;

            try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, prodId);
                ps.setDouble(2, rate);
                ps.setInt(3, qty);
                ps.setDouble(4, orderValue);
                ps.executeUpdate();

                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) newOrderId = keys.getInt(1);
                }
            }

            // Deduct ordered qty from stock
            try (PreparedStatement ups = conn.prepareStatement(
                    "UPDATE Product_Master SET ProdQty = ProdQty - ? WHERE ProdID = ?")) {
                ups.setInt(1, qty);
                ups.setInt(2, prodId);
                ups.executeUpdate();
            }

            out.write("{\"success\":true,\"orderId\":" + newOrderId + ",\"orderValue\":" + orderValue + "}");

        } catch (SQLException e) {
            out.write("{\"success\":false,\"message\":\"" + e.getMessage().replace("\"", "'") + "\"}");
        }
    }
}
