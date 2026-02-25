package com.example.verygoodcore.vgv;

import androidx.test.platform.app.InstrumentationRegistry;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import pl.leancode.patrol.PatrolJUnitRunner;

@RunWith(Parameterized.class)
public class MainActivityTest {

    @Parameterized.Parameters(name = "{0}")
    public static Object[] getTestCases() {
        return PatrolJUnitRunner.Companion.listDartTests(
            InstrumentationRegistry.getInstrumentation()
        );
    }

    public final String dartTestName;

    public MainActivityTest(String dartTestName) {
        this.dartTestName = dartTestName;
    }

    @Test
    public void runDartTest() {
        PatrolJUnitRunner.Companion.runDartTest(
            InstrumentationRegistry.getInstrumentation(),
            dartTestName
        );
    }
}
