package entity;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * class for holding all the information for a post, and some convenient methods
 *
 */
public class Post {
	private String user;
	private double lat;
	private double lon;
	private String message;

	public Post(String user, String message, double lat, double lon) {
		this.user = user;
		this.lat = lat;
		this.lon = lon;
		this.message = message;
	}

	public String getUser() {
		return user;
	}

	public double getLat() {
		return lat;
	}

	public double getLon() {
		return lon;
	}

	public String getMessage() {
		return message;
	}

	public JSONObject toJSONObject() {
		JSONObject obj = new JSONObject();
		try {
			obj.put("user", user);
			obj.put("message", message);
			obj.put("lat", lat);
			obj.put("lon", lon);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return obj;
	}

}
