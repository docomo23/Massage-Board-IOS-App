
package db.mysql;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import db.DBConnection;
import entity.Post;

// This is a singleton pattern.
public class MySQLConnection implements DBConnection {
	private static MySQLConnection instance;

	public static DBConnection getInstance() {
		if (instance == null) {
			instance = new MySQLConnection();
		}
		return instance;
	}

	private Connection conn = null;

	private MySQLConnection() {
		try {
			// Forcing the class representing the MySQL driver to load and
			// initialize.
			// The newInstance() call is a work around for some broken Java
			// implementations.
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection(MySQLDBUtil.URL);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	public void close() {
		if (conn != null) {
			try {
				conn.close();
			} catch (Exception e) { /* ignored */
			}
		}
	}

	@Override
	public void writePost(Post post) {
		try {
			// First, insert into items table
			String sql = "INSERT IGNORE INTO posts VALUES (?,?,?,?)";
			PreparedStatement statement = conn.prepareStatement(sql);
			statement.setString(1, post.getUser());
			statement.setString(2, post.getMessage());
			statement.setDouble(3, post.getLat());
			statement.setDouble(4, post.getLon());
			statement.execute();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

	@Override
	public List<Post> loadPosts(double lat, double lon, int range) {
		List<Post> posts = new ArrayList<>();

		try {
			String sql = "SELECT * from posts";
			PreparedStatement statement = conn.prepareStatement(sql);
			// statement.setString(1, itemId);
			ResultSet rs = statement.executeQuery();

			while (rs.next()) {
				posts.add(new Post(rs.getString("user"), rs.getString("message"), rs.getDouble("lat"),
						rs.getDouble("lon")));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return posts;
	}

}
