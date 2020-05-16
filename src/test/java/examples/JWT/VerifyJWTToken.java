package examples.JWT;

import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.concurrent.TimeUnit;

import javax.sound.midi.Synthesizer;

import org.junit.runner.RunWith;
import org.openqa.selenium.By;
import org.openqa.selenium.Cookie;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.phantomjs.PhantomJSDriver;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.support.ui.Select;

import com.intuit.karate.junit4.Karate;

@RunWith(Karate.class)
public class VerifyJWTToken {

 public static String main() throws InterruptedException {
  //Generate Driver for user 1

  String OSName = System.getProperty("os.name");

  WebDriver driver1;
  Set < Cookie > allCookies;
  if (OSName.contains("Windows")) {
   DesiredCapabilities capabilities = DesiredCapabilities.chrome();
   ChromeOptions options = new ChromeOptions();
   options.addArguments("--incognito");
   capabilities.setCapability(ChromeOptions.CAPABILITY, options);
   System.setProperty("webdriver.chrome.driver", "src//test//java//drivers//windows//chromedriver.exe");

   System.out.println("[OS: ]" + OSName);
   driver1 = new ChromeDriver(capabilities);
   allCookies = driver1.manage().getCookies();
   System.out.println("instamce created ");
  } else {
   System.setProperty("phantomjs.binary.path", "src//test//java//drivers//linux//phantomjs");
   System.out.println("[OS: ]" + OSName);
   DesiredCapabilities cap;
   driver1 = new PhantomJSDriver();
   allCookies = driver1.manage().getCookies();
  }


  // login with user 1 and create application with a group
  String JWT = loginThroughSSOForUser1(driver1);


  System.out.println("Finished UI Task ");
return JWT;

 }

 public static String loginThroughSSOForUser1(WebDriver driver1) throws InterruptedException {

	 String storeUrL = "https://apistore-dev-dev-a878-14-ams10-nonp.cloud.random.com/store/";
		// launch Chrome and direct it to the Base URL
		driver1.manage().window().maximize();
		driver1.get(storeUrL);
		 driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		// click signin 
		driver1.findElement(By.id("btn-login")).click();
		Thread.sleep(5000);
		// click on SSO
	
		driver1.findElement(By.xpath("//*[@id=\"icon-2\"]/img")).click();
		Thread.sleep(5000);
		// end user name
		driver1.findElement(By.name("loginfmt")).sendKeys("user@random.com");

		 Thread.sleep(3000);
		// click next
		driver1.findElement(By.id("idSIButton9")).click();
		Thread.sleep(5000);
	
		// enter password
		driver1.findElement(By.id("passwordInput")).sendKeys("test");
		Thread.sleep(5000);
		

		// click submit
		driver1.findElement(By.id("submitButton")).click();
    //andle pop up
		 driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		String parentWindowHandler = driver1.getWindowHandle(); // Store your parent window
		String subWindowHandler = null;
		Set<String> handles = driver1.getWindowHandles(); // get all window handles
		Iterator<String> iterator = handles.iterator();
		while (iterator.hasNext()) {
			subWindowHandler = iterator.next();
		}
		driver1.switchTo().window(subWindowHandler); // switch to popup window
		driver1.findElement(By.id("idSIButton9")).click();
		driver1.switchTo().window(parentWindowHandler); // switch back to parent window
		 driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		
		 // find API
		driver1.findElement(By.xpath("//*[@id=\"query\"]")).sendKeys("Regtest_JWT");
		driver1.findElement(By.xpath("//*[@id=\"searchAPI\"]")).click();
		 driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		 
		 
		// click on API
		//driver1.findElement(By.xpath("/html/body/div[1]/div/div[2]/div[2]/div/div[2]/div/div[1]/div/div[2]/h4/a")).click();
		driver1.findElement(By.xpath("/html/body/div[1]/div/div[2]/div[2]/div/div[2]/div/div/div/div[2]/h4/a")).click();
		 driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		
		// click on slsect application
		driver1.findElement(By.xpath("//*[@id=\"application-selection-list\"]/div/button/span[1]")).click();
		 driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		 
		// sleect gerrt
		driver1.findElement(By.xpath("//*[@id=\"application-selection-list\"]/div/div/ul/li[5]/a/span[1]/strong")).click();
		 driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		
		 // click tier
		 driver1.findElement(By.xpath("/html/body/div[1]/div/div[2]/div[2]/div/div[2]/div[1]/div/div[3]/form/div[2]/div/button")).click();
		 driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		 
		// selet tier
		driver1.findElement(By.xpath("/html/body/div[1]/div/div[2]/div[2]/div/div[2]/div[1]/div/div[3]/form/div[2]/div/div/ul/li[5]/a/span[1]/strong")).click();
		 driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		 
		// subscribe
		driver1.findElement(By.xpath("//*[@id=\"subscribe-button\"]")).click();
		 driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		 Thread.sleep(3000);
		// pop up 

		 parentWindowHandler = driver1.getWindowHandle(); // Store your parent window
		   subWindowHandler = null;

		   handles = driver1.getWindowHandles(); // get all window handles
		  Iterator < String > iterator1 = handles.iterator();
		  while (iterator1.hasNext()) {
		   subWindowHandler = iterator1.next();
		  }
		  driver1.switchTo().window(subWindowHandler); // switch to popup window
		  driver1.findElement(By.xpath("//*[@id=\"messageModal\"]/div/div/div[3]/a[2]")).click();
		  driver1.switchTo().window(parentWindowHandler); // switch back to parent window
		  driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);

		 
		//click on API console
		driver1.findElement(By.xpath("//*[@id=\"1\"]/a")).click();
		 driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
			((JavascriptExecutor) driver1).executeScript("window.scrollTo(0,document.body.scrollHeight)");
			 driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		 
		// click on get 
		driver1.findElement(By.xpath("//*[@id=\"default_get_poker\"]/div[1]/h3/span[1]")).click();
		 driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		((JavascriptExecutor) driver1).executeScript("window.scrollTo(0,document.body.scrollHeight)");
		 driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
			
		// click on try it out
		driver1.findElement(By.xpath("//*[@id=\"default_get_poker_content\"]/form/div[3]/input")).click();
		 driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		 ((JavascriptExecutor) driver1).executeScript("window.scrollTo(0,document.body.scrollHeight)");
		 driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
			 Thread.sleep(10000);
		 
		// print token
		 String JWT = driver1.findElement(By.xpath("//*[@id=\"default_get_poker_content\"]/div[3]/div[4]/pre/code")).getText();
		System.out.println("token: " + JWT);
		  driver1.close();
		return JWT;

 }
}