package com.dev3l.hello_world.test;

import static org.junit.Assert.*;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Scanner;

import org.junit.Test;
import org.junit.Before;
import org.junit.*;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;


public class ExampleTest {
	
	
	 @Test
		public void testWebPageAgain() throws IOException {
		    // Read the content of the JSP file
		    String filePath = "src/main/webapp/index.jsp"; // replace with the actual file path
		    BufferedReader reader = new BufferedReader(new FileReader(filePath));
		    StringBuilder builder = new StringBuilder();
		    String line;
		    while ((line = reader.readLine()) != null) {
			builder.append(line);
		    }
		    reader.close();
		    String content = builder.toString();

		    // Check for the title, header, body, and image tags
		    assertTrue(content.contains("<title>Hello World! First Java Pipeline</title>"));
		    assertTrue(content.contains("<h2 class=\"text-center\">Hello World! First Java Pipeline V0.1</h2>"));
		    assertTrue(content.contains("<p class=\"text-center\">Now with Arti K-CI-CD!New Change</p>"));
		    assertTrue(content.contains("<img src=\"https://octodex.github.com/images/spidertocat.png\" alt=\"Spidertocat\""));
		}
	

}
