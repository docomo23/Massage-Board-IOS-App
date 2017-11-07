package rpc;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import db.DBConnection;
import db.DBConnectionFactory;
import entity.Post;

/**
 * Servlet implementation class UserPosts
 */
@WebServlet("/post")
public class WritePost extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private DBConnection conn = DBConnectionFactory.getDBConnection();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public WritePost() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
				JSONObject input = RpcHelper.readJsonObject(request);
				if (input.has("user") && input.has("lat")&& input.has("lon")) {
					String user = (String) input.get("user");
					Double lat =  (Double) input.get("lat");
					Double lon = (Double) input.get("lon");
					String message = "user leaves no message";
					if (input.has("message"))
						message = (String) input.get("message");
					conn.writePost(new Post(user, message, lat, lon));
					RpcHelper.writeJsonObject(response,
							new JSONObject().put("status", "OK"));
				} else {
					RpcHelper.writeJsonObject(response,
							new JSONObject().put("status", "InvalidParameter"));
				}
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
	}
