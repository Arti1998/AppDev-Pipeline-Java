package com.dev3l.hello_world.test;

import org.junit.Assert;
import org.junit.Test;

public class ExampleTest {
	@Test
	public void exampleTest() {
		Assert.assertTrue(true);
	}
		
	@Test
	public void testGetMessageWithNull() {
	    Example example = new Example(null);
	    String actualMessage = example.getMessage();
	    assertNotNull(actualMessage);
	}

	@Test
	public void testSubtractNumbers() {
	    App app = new App();
	    int result = app.subtractNumbers(3, 2);
	    assertEquals(2, result);
	}



}
public class Example {
    private String message;
    
    public Example(String message) {
        this.message = message;
    }
    
    public String getMessage() {
        return this.message;
    }
}

