package com.dev3l.hello_world.test;

import org.junit.Assert;
import org.junit.Test;

public class ExampleTest {
	@Test
	public void exampleTest() {
		Assert.assertTrue(true);
	}
	
	@Test
	public void testAddNumbersWithNegativeNumbers() {
	    App app = new App();
	    int result = app.addNumbers(-2, 3);
	    assertEquals(1, result);
	}	
}
