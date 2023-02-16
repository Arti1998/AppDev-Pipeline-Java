package com.dev3l.hello_world.test;

import static org.junit.Assert.*;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Scanner;

import org.junit.Test;

import org.junit.Before;

import org.junit.*;


public class ExampleTest {
	
	@Test
	  public void testWebPage() throws IOException {
	    // Make a request to the web page and get the response
	    URL url = new URL("http://localhost:8085/JavaApp/"); // replace with the URL of your web app
	    HttpURLConnection con = (HttpURLConnection) url.openConnection();
	    con.setRequestMethod("GET");
	    int responseCode = con.getResponseCode();
	    assertEquals(200, responseCode); // check that the response code is 200 OK

	    // Read the response content and check for the title, body, image, and header
	    Scanner scanner = new Scanner(con.getInputStream());
	    String responseBody = scanner.useDelimiter("\\A").next();
	    scanner.close();

	    assertTrue(responseBody.contains("<title>Hello World! First Java Pipeline</title>")); // check for the title tag
	    assertTrue(responseBody.contains("<h2 class=\"text-center\">Hello World! First Java Pipeline V0.1</h2>")); // check for the header
	    assertTrue(responseBody.contains("<p class=\"text-center\">Now with Arti K-CI-CD!New Change</p>")); // check for the body
	    assertTrue(responseBody.contains("<img src=\"https://octodex.github.com/images/spidertocat.png\" alt=\"Spidertocat\"")); // check for the image
	  }
		
	 
	

}
