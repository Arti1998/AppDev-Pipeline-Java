package com.dev3l.hello_world.test;
import static net.sourceforge.jwebunit.junit.JWebUnit.*;

import org.junit.Before;
import org.junit.Test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import com.dev3l.hello_world.App;
import com.dev3l.hello_world.Example;

public class ExampleTest {
	//@Test
	//    public void exampleTest() {
	//	Assert.assertTrue(true);
	//    }
	
	 @Test
	  public void testWebPage() {
	    beginAt("/index.jsp"); // replace with the path to your web app's index page

	    // Test the title
	    assertTitleEquals("Hello World! First Java Pipeline");

	    // Test the body
	    assertTextPresent("Hello World! First Java Pipeline V0.1");
	    assertTextPresent("Now with Arti K-CI-CD!New Change");

	    // Test the image
	    assertElementPresent("img");
	    assertElementPresentAttribute("img", "src", "https://octodex.github.com/images/spidertocat.png");
	    assertElementPresentAttribute("img", "alt", "Spidertocat");
	    assertElementPresentAttribute("img", "class", "img-responsive center-block");
	    assertElementPresentAttribute("img", "style", "width:250px");

	    // Test the header
	    assertElementPresent("h2");
	    assertTextPresent("Hello World! First Java Pipeline V0.1");
	  }

}
