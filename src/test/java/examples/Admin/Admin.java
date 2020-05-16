package examples.Admin;

import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.Random;
import java.util.Set;
import java.util.concurrent.TimeUnit;

import javax.sound.midi.Synthesizer;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.openqa.selenium.By;
import org.openqa.selenium.Cookie;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.firefox.FirefoxOptions;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.phantomjs.PhantomJSDriver;
import org.openqa.selenium.remote.CapabilityType;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import com.intuit.karate.junit4.Karate;

@RunWith(Karate.class)
public class Admin {

	@SuppressWarnings("deprecation") @Test
	public static void main() throws InterruptedException {
		//Generate Driver for user 1
		
		String OSName=System.getProperty("os.name");	
		
		WebDriver driver1;
		Set<Cookie> allCookies;
		if(OSName.contains("Mac")) {
			 DesiredCapabilities capabilities = DesiredCapabilities.chrome();
		        ChromeOptions options = new ChromeOptions();
		        options.addArguments("--incognito");
		        capabilities.setCapability(ChromeOptions.CAPABILITY, options);
			//System.setProperty("webdriver.chrome.driver", "src//test//java//drivers//windows//drivermac//chromedriver");

			System.out.println("[OS: ]"+OSName);
			driver1= new ChromeDriver(capabilities);
			allCookies = driver1.manage().getCookies();
			System.out.println("instamce created ");
		}else{
			   System.setProperty("webdriver.chrome.driver", "src//test//java//drivers//linux//chromedriver");
			   
					ChromeOptions chromeOptions = new ChromeOptions();
					chromeOptions.addArguments("--no-sandbox");
					 chromeOptions.addArguments("test-type");
					 chromeOptions.addArguments("–-disable-web-security");
					System.setProperty("webdriver.chrome.args", "--disable-logging");
					System.setProperty("webdriver.chrome.silentOutput", "true");
					 chromeOptions.addArguments("--profile-directory=Default");
					 chromeOptions.addArguments("--disable-dev-shm-usage"); // overcome limited resource problems
					 chromeOptions.addArguments("start-maximized"); // open Browser in maximized mode
					 chromeOptions.addArguments("disable-infobars"); // disabling infobars
					 chromeOptions.addArguments("--disable-extensions"); // disabling extensions
					 chromeOptions.addArguments("--ignore-certificate-errors");
					 chromeOptions.addArguments("–-allow-running-insecure-content");
					 chromeOptions.addArguments("--dns-prefetch-disable");
					 chromeOptions.addArguments("--silent");
			         chromeOptions.addArguments("--disable-notifications");
					 chromeOptions.setCapability(CapabilityType.ACCEPT_SSL_CERTS, true);
					 chromeOptions.setCapability(CapabilityType.PAGE_LOAD_STRATEGY, "none");
					 chromeOptions.addArguments("--headless");
					 chromeOptions.addArguments("--disable-gpu");
				
				
			
//			FirefoxOptions options = new FirefoxOptions();
//			System.setProperty("webdriver.gecko.driver", "src//test//java//drivers//linux//geckodriver");
//			   System.out.println("[OS Driver 1: ]" + OSName);
			   driver1 = new ChromeDriver(chromeOptions);
//			   driver1 = new FirefoxDriver();
//			   System.out.println("setting driver");
		    
			   allCookies = driver1.manage().getCookies();
		}
		
		//Generate Driver for user 2
		String OSName2=System.getProperty("os.name");		
		WebDriver driver2;
		Set<Cookie> allCookies2;
		if(OSName2.contains("Mac")) {
			 DesiredCapabilities capabilities = DesiredCapabilities.chrome();
		        ChromeOptions options = new ChromeOptions();
		        options.addArguments("--headless");
		        options.addArguments("--incognito");
		        options.addArguments("--no-sandbox"); // required when running as root user. otherwise you would get no sandbox errors. 
		        capabilities.setCapability(ChromeOptions.CAPABILITY, options);
//			System.setProperty("webdriver.chrome.driver", "src//test//java//drivers//windows//driverrmac//chromedriver");

			System.out.println("[OS: ]"+OSName);
			driver2= new ChromeDriver(capabilities);
			 allCookies2 = driver2.manage().getCookies();
			System.out.println("instamce created ");
		}else{
			   System.setProperty("webdriver.chrome.driver", "src//test//java//drivers//linux//chromedriver");
			   DesiredCapabilities capabilities = DesiredCapabilities.chrome();
			   ChromeOptions chromeOptions = new ChromeOptions();
				chromeOptions.addArguments("--no-sandbox");
				 chromeOptions.addArguments("test-type");
				 chromeOptions.addArguments("--incognito");
				// chromeOptions.addArguments("–-disable-web-security");
			//	String tmpProfilePath = System.getProperty("user.dir") + "/target/tmpChromeProfile/";
			//	String timeStamp = String.valueOf(Calendar.getInstance().getTimeInMillis());
			//	String chrome_user_dir = tmpProfilePath + timeStamp + "-" + String.valueOf(100000 + new Random().nextInt(900000));
			//	chromeOptions.addArguments("--user-data-dir=" + chrome_user_dir);
				System.setProperty("webdriver.chrome.args", "--disable-logging");
				System.setProperty("webdriver.chrome.silentOutput", "true");
				 chromeOptions.addArguments("--profile-directory=Default");
				 
				 chromeOptions.addArguments("--ignore-certificate-errors");
				 chromeOptions.addArguments("–-allow-running-insecure-content");
				 chromeOptions.addArguments("--dns-prefetch-disable");
				 chromeOptions.addArguments("--silent");
		         chromeOptions.addArguments("--disable-notifications");
				 chromeOptions.setCapability(CapabilityType.ACCEPT_SSL_CERTS, true);
				 chromeOptions.setCapability(CapabilityType.PAGE_LOAD_STRATEGY, "none");
				 chromeOptions.addArguments("--headless");
			
			
//			   System.out.println("[OS: ]" + OSName);
		 capabilities.setCapability(ChromeOptions.CAPABILITY, chromeOptions);
			   driver2 = new ChromeDriver(capabilities);
//			   System.out.println("setting driver");
//			FirefoxOptions options2 = new FirefoxOptions();
//			System.setProperty("webdriver.gecko.driver", "src//test//java//drivers//linux//geckodriver");
			   System.out.println("[OS Driver 2: ]" + OSName);
//			   driver1 = new ChromeDriver();
//			   driver2 = new FirefoxDriver();
			   allCookies2 = driver2.manage().getCookies();
			
		}
	
		// login with user 1 and create application with a group
		loginThroughSSOForUser1(driver1);

		System.out.println("Finished UI Task ");
	
	}

	public static void loginThroughSSOForUser1(WebDriver driver1) throws InterruptedException {
		WebDriverWait wait = new WebDriverWait(driver1, 15);
		System.out.println("Inside function");
		String storeUrL = "https://publishr-dev-dev-a878-16-ams10-nonp.cloud.random.com/publisher/";
		// launch Chrome and direct it to the Base URL
		driver1.manage().window().maximize();
		driver1.get(storeUrL);
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		// click signin 
		//driver1.findElement(By.xpath("//*[@id=\"btn-login\"]")).click();
		// click on SSO
		System.out.println("Signing in with SSO ");

		WebElement signin = wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//*[@id=\"icon-2\"]/img")));
		signin.click();
		//driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		//driver1.findElement(By.xpath("//*[@id=\"icon-2\"]/img")).click();
		Thread.sleep(6000);
		// end user name
	
		WebElement Category_Body = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("i0116")));
		 Category_Body.sendKeys("user@random.com");
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		// click next
		driver1.findElement(By.id("idSIButton9")).click();
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		// enter password
		driver1.findElement(By.id("passwordInput")).sendKeys("test");
		Thread.sleep(2000);
		// click submit
		driver1.findElement(By.id("submitButton")).click();
       // handle pop up
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
	
	}


}