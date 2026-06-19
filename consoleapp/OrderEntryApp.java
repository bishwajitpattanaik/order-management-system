import java.sql.*;
import java.util.Scanner;

public class OrderEntryApp {

    private static final String URL  = "jdbc:mysql://localhost:3306/seeree_assessment1_bishwajitpattanaik";
    private static final String USER = "root";
    private static final String PASS = "";

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        try (Connection conn = DriverManager.getConnection(URL, USER, PASS)) {
            System.out.println("Connected to database.\n");

            boolean continueEntry = true;
            while (continueEntry) {
                insertOrder(conn, sc);

                System.out.print("\nInsert another order? (y/n): ");
                String more = sc.nextLine().trim();
                continueEntry = more.equalsIgnoreCase("y");
                System.out.println();
            }

            System.out.println("Done. Exiting.");

        } catch (SQLException e) {
            System.out.println("Database connection failed: " + e.getMessage());
        } finally {
            sc.close();
        }
    }

    private static void insertOrder(Connection conn, Scanner sc) {

        int prodId = -1;
        double rate = 0;
        int availableQty = 0;

        while (prodId == -1) {
            System.out.print("Enter Product Name: ");
            String prodName = sc.nextLine().trim();

            String sql = "SELECT ProdID, ProdRate, ProdQty FROM Product_Master WHERE ProdName = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, prodName);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        prodId = rs.getInt("ProdID");
                        rate = rs.getDouble("ProdRate");
                        availableQty = rs.getInt("ProdQty");
                        System.out.println("Product found. Rate = " + rate
                                + " | Available Qty = " + availableQty);
                    } else {
                        System.out.println("Product not found in Product_Master. Try again.");
                    }
                }
            } catch (SQLException ex) {
                System.out.println("DB error: " + ex.getMessage());
                return;
            }
        }

        int qty = -1;
        while (qty == -1) {
            System.out.print("Enter Order Qty: ");
            String qtyInput = sc.nextLine().trim();
            try {
                int entered = Integer.parseInt(qtyInput);
                if (entered <= 0) {
                    System.out.println("Quantity must be greater than zero.");
                } else if (entered > availableQty) {
                    System.out.println("Order qty exceeds available stock (" + availableQty + "). Try again.");
                } else {
                    qty = entered;
                }
            } catch (NumberFormatException e) {
                System.out.println("Enter a valid number.");
            }
        }

        double orderValue = qty * rate;

        String insertSql = "INSERT INTO Order_Master (OrderDate, ProdID, ProdRate, OrderQty, OrderValue) "
                          + "VALUES (CURDATE(), ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, prodId);
            ps.setDouble(2, rate);
            ps.setInt(3, qty);
            ps.setDouble(4, orderValue);
            ps.executeUpdate();

            int newOrderId = -1;
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) newOrderId = keys.getInt(1);
            }

            try (PreparedStatement ups = conn.prepareStatement(
                    "UPDATE Product_Master SET ProdQty = ProdQty - ? WHERE ProdID = ?")) {
                ups.setInt(1, qty);
                ups.setInt(2, prodId);
                ups.executeUpdate();
            }

            System.out.println("Order saved successfully!");
            System.out.println("OrderID = " + newOrderId + " | OrderValue = " + orderValue);

        } catch (SQLException ex) {
            System.out.println("Insert failed: " + ex.getMessage());
        }
    }
}




//written by Bishwajit Pattanaik
//Java Full Stack Course 
//Oct-2025 batch