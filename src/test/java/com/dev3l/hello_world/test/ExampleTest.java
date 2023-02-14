package com.dev3l.hello_world.test;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import org.junit.Test;

import com.dev3l.hello_world.App;
import com.dev3l.hello_world.Example;

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
		System.out.println(actualMessage)
	}

	@Test
	public void testSubtractNumbers() {
	    App app = new App();
	    int result = app.subtractNumbers(3, 2);
	    assertEquals(2, result);
		System.out.println(result)
	}

}
public class Example {
    private String message;
    
    public Example() {
        // Default message
        this.message = "Hello, world!";
    }
    
    public Example(String message) {
        this.message = message;
    }
    
    public String getMessage() {
        return this.message;
    }
}


