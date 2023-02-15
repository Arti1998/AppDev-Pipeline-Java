package com.dev3l.hello_world.test;

import static org.junit.Assert.*;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Scanner;

import org.junit.Test;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
//import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.edge.EdgeDriver;

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
	
	 private WebDriver driver;

	 @Before
	    public void setUp() {
		// Configure the WebDriver to use Chrome
		//System.setProperty("webdriver.chrome.driver", "path/to/chromedriver.exe");
		//driver = new ChromeDriver();
		    
		// Configure the WebDriver to use Microsoft Edge
		//System.setProperty("webdriver.edge.driver", "C:/msedgedriver.exe");
		//driver = new EdgeDriver();
		WebDriverManager.edgedriver().setup();
   	        driver = new EdgeDriver();


	    }
	
	 @Test
	    public void testWebPageAgain() {
		// Navigate to the web page
		driver.get("http://localhost:7171/index.jsp");

		// Test the title
		String title = driver.getTitle();
		Assert.assertEquals("Hello World! First Java Pipeline", title);

		// Test the body
		String bodyText = driver.findElement(By.tagName("body")).getText();
		Assert.assertTrue(bodyText.contains("Hello World! First Java Pipeline V0.1"));
		Assert.assertTrue(bodyText.contains("Now with Arti K-CI-CD!New Change"));

		// Test the image
		Assert.assertTrue(driver.findElement(By.tagName("img")).isDisplayed());
		Assert.assertEquals("https://octodex.github.com/images/spidertocat.png", driver.findElement(By.tagName("img")).getAttribute("src"));
		Assert.assertEquals("Spidertocat", driver.findElement(By.tagName("img")).getAttribute("alt"));
		Assert.assertEquals("img-responsive center-block", driver.findElement(By.tagName("img")).getAttribute("class"));
		Assert.assertEquals("width:250px", driver.findElement(By.tagName("img")).getAttribute("style"));

		// Test the header
		String headerText = driver.findElement(By.tagName("h2")).getText();
		Assert.assertEquals("Hello World! First Java Pipeline V0.1", headerText);
	    }
	
	   @After
	    public void tearDown() {
		driver.quit();
	    }

}
