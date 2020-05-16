package examples thServer;

import com.intuit.karate.junit4.Karate;

import java.util.Iterator;
import java.util.Set;
import java.util.concurrent.TimeUnit;

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

@RunWith(Karate.class)
public class authServer {
	public static boolean main() throws InterruptedException {
	
		  createApplication();
		  Boolean ApplicationDeleted=secondlogin();
		return ApplicationDeleted;
		  
	}
	
	public static void createApplication() throws InterruptedException {
		String OSName = System.getProperty("os.name");

		  WebDriver driver1;
		  Set <Cookie> allCookies;
		  if (OSName.contains("Windows")) {
		   ChromeOptions options = new ChromeOptions();
		   options.addArguments("--incognito");
		   System.setProperty("webdriver.chrome.driver", "src//test//java//drivers//windows//chromedriver.exe");

		   System.out.println("[OS: ]" + OSName);
		   driver1 = new ChromeDriver();
		   allCookies = driver1.manage().getCookies();
		   System.out.println("instamce created ");
		  } else {
		   System.setProperty("phantomjs.binary.path", "src//test//java//drivers//linux//chromedriver");
		   System.out.println("[OS: ]" + OSName);
		   DesiredCapabilities cap;
		   driver1 = new PhantomJSDriver();
		   allCookies = driver1.manage().getCookies();
		  }
		String storeUrL = "https://apistore-dev-dev-a878-14-ams10-nonp.cloud.random.com/store/";
		// launch Chrome and direct it to the Base URL
		driver1.manage().window().maximize();
		driver1.get(storeUrL);
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		// click signin 
		driver1.findElement(By.id("btn-login")).click();
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		
		// click on SSO
		driver1.findElement(By.xpath("//*[@id=\"icon-2\"]/img")).click();
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		Thread.sleep(8000);
		// end user name
		driver1.findElement(By.name("loginfmt")).sendKeys("user@random.com");
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		
		// click next
		driver1.findElement(By.id("idSIButton9")).click();
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		
		// enter password
		driver1.findElement(By.id("passwordInput")).sendKeys("test");
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		
		// click submit
		driver1.findElement(By.id("submitButton")).click();
		
       //handle pop up
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
		
		// click on application tab
		driver1.findElement(By.xpath("//*[@id=\"left-sidebar\"]/nav/ul/li[2]/a/span")).click();
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		
		// click on Add Application
		driver1.findElement(By.xpath("//*[@id=\"navbar\"]/ul/li/a")).click();
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		
		//Send Application name
		driver1.findElement(By.id("application-name")).sendKeys("SSOUserTest");
		// Add group
		WebElement element = driver1.findElement(By.xpath("//*[@id=\"appAddForm\"]/div[2]/div/div"));
		Actions Action = new Actions(driver1);
		Action.moveToElement(element);
		Action.click();
		Action.sendKeys("DevTeamBeta");
		Action.sendKeys(Keys.ENTER);
		Action.build().perform();
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		
		//click add to add application
		driver1.findElement(By.id("application-add-button")).click();
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		((JavascriptExecutor)driver1).executeScript("window.scrollTo(0,document.body.scrollHeight)");
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		// generate production keys
		driver1.findElement(By.id("actionLink-productionKeys")).click();
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		((JavascriptExecutor) driver1).executeScript("window.scrollTo(0,document.body.scrollHeight)");
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		driver1.findElement(By.xpath("//*[@id=\"production\"]/div[2]/div/form/button")).click();
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
//		// sandbox keys
//    	driver1.findElement(By.xpath("//*[@id=\"sandbox-keys-tab\"]/a")).click();
//    	Thread.sleep(5000);
//    	driver1.findElement(By.xpath("//*[@id=\"sandbox\"]/div/div/form/button")).click();
//    	Thread.sleep(5000);
		
		
		
		//logout
		driver1.findElement(By.linkText("user@random.com")).click();
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		
		//signout
		driver1.findElement(By.xpath("//*[@id=\"logout-link\"]")).click();
		driver1.close();
	
	}
	
	public static boolean secondlogin() throws InterruptedException {
		String OSName = System.getProperty("os.name");

		  WebDriver driver1;
		  Set <Cookie> allCookies;
		  if (OSName.contains("Windows")) {
		   ChromeOptions options = new ChromeOptions();
		   options.addArguments("--incognito");
		   System.setProperty("webdriver.chrome.driver", "src//test//java//drivers//windows//chromedriver.exe");

		   System.out.println("[OS: ]" + OSName);
		   driver1 = new ChromeDriver();
		   allCookies = driver1.manage().getCookies();
		   System.out.println("instamce created ");
		  } else {
		   System.setProperty("phantomjs.binary.path", "src//test//java//drivers//linux//chromedriver");
		   System.out.println("[OS: ]" + OSName);
		   DesiredCapabilities cap;
		   driver1 = new PhantomJSDriver();
		   allCookies = driver1.manage().getCookies();
		  }
		  String storeUrL = "https://apistore-dev-dev-a878-14-ams10-nonp.cloud.random.com/store/";
			// launch Chrome and direct it to the Base URL
			driver1.manage().window().maximize();
			driver1.get(storeUrL);
			driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
			// click signin 
			driver1.findElement(By.id("btn-login")).click();
			driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
			
			// click on SSO
			driver1.findElement(By.xpath("//*[@id=\"icon-2\"]/img")).click();
			driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
			Thread.sleep(3000);
			// end user name
			driver1.findElement(By.name("loginfmt")).sendKeys("user@random.com");
			driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
			
			// click next
			driver1.findElement(By.id("idSIButton9")).click();
			driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
			
			// enter password
			driver1.findElement(By.id("passwordInput")).sendKeys("test");
			driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
			
			// click submit
			driver1.findElement(By.id("submitButton")).click();
			
	       //handle pop up
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
			
			// click on application tab
			driver1.findElement(By.xpath("//*[@id=\"left-sidebar\"]/nav/ul/li[2]/a/span")).click();
			driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
			
			//delete Application
			Boolean ApplicationDeleted = false;
			driver1.findElement(By.xpath("//*[@id=\"application-table\"]/tbody/tr[5]/td[5]/a[3]/span[2]")).click();
			String parentWindowHandler1 = driver1.getWindowHandle(); // Store your parent window
			String subWindowHandler1 = null;

			Set<String> handles1 = driver1.getWindowHandles(); // get all window handles
			Iterator<String> iterator1 = handles1.iterator();
			while (iterator1.hasNext()) {
				subWindowHandler1 = iterator.next();
			}
			driver1.switchTo().window(subWindowHandler1); // switch to popup window
			driver1.findElement(By.xpath("//*[@id=\"btn-primary\"]")).click();
			ApplicationDeleted=true;
			driver1.switchTo().window(parentWindowHandler1); // switch back to parent window
			return ApplicationDeleted;
			
	}
	
}
