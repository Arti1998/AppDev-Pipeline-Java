package com.dev3l.hello_world.test;

import static net.sourceforge.jwebunit.junit.JWebUnit.*;

import net.sourceforge.jwebunit.junit.JWebUnitRunner;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;


@RunWith(JWebUnitRunner.class)
public class ExampleTest {
	
	
	 @Test
	  public void testWebPage() {
	    beginAt("/index.jsp"); // replace with the path to your web app's index page

	    // Test the title
	    assertTitleEquals("Hello World! First Java Pipeline");

	    // Test the body
	    assertTextPresent("Hello World! First Java Pipeline V0.1");
	    assertTextPresent("Now with Arti K-CI-CD!New Change");

	    // Test the image
	    //assertElementPresent("img");
	    //assertElementPresentAttribute("img", "src", "https://octodex.github.com/images/spidertocat.png");
	    //assertElementPresentAttribute("img", "alt", "Spidertocat");
	    //assertElementPresentAttribute("img", "class", "img-responsive center-block");
	    //assertElementPresentAttribute("img", "style", "width:250px");

	    // Test the header
	    assertElementPresent("h2");
	    assertTextPresent("Hello World! First Java Pipeline V0.1");
	  }

}
