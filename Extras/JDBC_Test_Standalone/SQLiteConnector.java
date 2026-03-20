import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class SQLiteConnector {
    public static void main(String[] args) {
        Connection conn = null;
        try {
            // This will create campusassist.db in your folder if it doesn't exist
            String url = "jdbc:sqlite:campusassist.db";
            conn = DriverManager.getConnection(url);
            if (conn != null) {
                System.out.println("✅ Connected to SQLite successfully!");
            }
        } catch (SQLException e) {
            System.out.println("❌ Connection failed: " + e.getMessage());
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException ex) {
                System.out.println("⚠️ Failed to close connection: " + ex.getMessage());
            }
        }
    }
}
