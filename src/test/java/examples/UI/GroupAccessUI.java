package examples.UI;

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
public class GroupAccessUI {

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
	//	System.setProperty("webdriver.chrome.driver", "src//test//java//drivers//windows//chromedriver");

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
			//System.setProperty("webdriver.chrome.driver", "src//test//java//drivers//windows//chromedriver.exe");

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
		
		// login wuth user 2 and access the shared application 
		loginAndCheckAppForUser2(driver2);
		
		//Verify permissions and key generation before and after owner does it.
		keyGenerationByUser1(allCookies, driver1);
		
		//First time key generation by owner
		keyGenerationAccess(allCookies2, driver2);
		
		//Delete the App
		DeleteApplication(allCookies, driver1);

		System.out.println("Finished UI Task ");
	
	}

	public static void loginThroughSSOForUser1(WebDriver driver1) throws InterruptedException {
		System.out.println("Inside function");
		String storeUrL = "https://apistore-dev-dev-a878-14-ams10-nonp.cloud.random.com/store/";
		// launch Chrome and direct it to the Base URL
		driver1.manage().window().maximize();
		driver1.get(storeUrL);
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		// click signin 
		driver1.findElement(By.id("btn-login")).click();
		// click on SSO
		//driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
	//	driver1.findElement(By.xpath("//*[@id=\"icon-2\"]/img")).click();
		Thread.sleep(6000);
		// end user name
		WebDriverWait wait = new WebDriverWait(driver1, 15);
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
		// click on application tab
		driver1.findElement(By.xpath("//*[@id=\"left-sidebar\"]/nav/ul/li[2]/a/span")).click();
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		// click on Add Application
		driver1.findElement(By.xpath("//*[@id=\"navbar\"]/ul/li/a")).click();
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		//Send Application name
		driver1.findElement(By.id("application-name")).sendKeys("Apple");
		// Add group
		WebElement element = driver1.findElement(By.xpath("//*[@id=\"appAddForm\"]/div[2]/div/div"));
		Actions Action = new Actions(driver1);
		Action.moveToElement(element);
		Action.click();
		Action.sendKeys("DevTeamBeta");
		Action.sendKeys(Keys.ENTER);
		Action.build().perform();
		Thread.sleep(10000);
		//click add to add application
		driver1.findElement(By.id("application-add-button")).click();
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		((JavascriptExecutor)driver1).executeScript("window.scrollTo(0,document.body.scrollHeight)");
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
	}

	public static String loginAndCheckAppForUser3(WebDriver driver2) throws InterruptedException {

		String storeUrL = "https://apistore-dev-dev-a878-14-ams10-nonp.cloud.random.com/store/";

		// launch Chrome and direct it to the Base URL
		driver2.manage().window().maximize();
		driver2.get(storeUrL);
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		driver2.findElement(By.id("btn-login")).click();
		// click on SSO
		Thread.sleep(3000);
		driver2.findElement(By.xpath("//*[@id=\"icon-2\"]/img")).click();
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		// end user name
		driver2.findElement(By.name("loginfmt")).sendKeys("user2@random.com");
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		// click next
		driver2.findElement(By.id("idSIButton9")).click();
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		// enter password
		driver2.findElement(By.id("passwordInput")).sendKeys("test");
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		// click submit
		driver2.findElement(By.id("submitButton")).click();
		Thread.sleep(3000);
		String parentWindowHandler = driver2.getWindowHandle(); // Store your parent window
		String subWindowHandler = null;
		Set<String> handles = driver2.getWindowHandles(); // get all window handles
		Iterator<String> iterator = handles.iterator();
		while (iterator.hasNext()) {
			subWindowHandler = iterator.next();
		}
		driver2.switchTo().window(subWindowHandler); // switch to popup window
		driver2.findElement(By.id("idSIButton9")).click();
		driver2.switchTo().window(parentWindowHandler); // switch back to parent window
		// Go to application bar
		Thread.sleep(5000);
		driver2.findElement(By.xpath("//*[@id=\"left-sidebar\"]/nav/ul/li[2]/a/span")).click();
		Thread.sleep(3000);
		//
		String appName = driver2.findElement(By.xpath("//*[@id=\"application-table\"]/tbody/tr[1]/td[1]")).getText();
		System.out.println("Appplciation name:  " + appName);
		String actionActionMatch = "Failure";
		if (appName.equals("user@random.com/Apple")) {
			System.out.println("Application successfully shared");
			String allowedActions = driver2.findElement(By.xpath("//*[@id=\"application-table\"]/tbody/tr[1]/td[5]"))
					.getText();
			System.out.println("Allowed Actions are :" + allowedActions);
			actionActionMatch = "Success";

		}
		driver2.findElement(By.xpath("//*[@id=\"application-table\"]/tbody/tr[1]/td[1]")).click();
		if (actionActionMatch.equals("Success")) {
			nokeyGenerationAccess(driver2);
		}
		return actionActionMatch;

	}
	
	public static String loginAndCheckAppForUser2(WebDriver driver2) throws InterruptedException {

		String storeUrL = "https://apistore-dev-dev-a878-14-ams10-nonp.cloud.random.com/store/";

		// launch Chrome and direct it to the Base URL
		driver2.get(storeUrL);
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		driver2.findElement(By.id("btn-login")).click();
		// click on SSO
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		driver2.findElement(By.xpath("//*[@id=\"icon-2\"]/img")).click();
		Thread.sleep(5000);
		// end user name
		driver2.findElement(By.name("loginfmt")).sendKeys("user2@random.com");
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		// click next
		driver2.findElement(By.id("idSIButton9")).click();
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		// enter password
		driver2.findElement(By.id("passwordInput")).sendKeys("test");
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		// click submit
		driver2.findElement(By.id("submitButton")).click();
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		String parentWindowHandler = driver2.getWindowHandle(); // Store your parent window
		String subWindowHandler = null;
		Set<String> handles = driver2.getWindowHandles(); // get all window handles
		Iterator<String> iterator = handles.iterator();
		while (iterator.hasNext()) {
			subWindowHandler = iterator.next();
		}
		driver2.switchTo().window(subWindowHandler); // switch to popup window
		driver2.findElement(By.id("idSIButton9")).click(); 
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		driver2.switchTo().window(parentWindowHandler); // switch back to parent window
		// Go to application bar
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		driver2.findElement(By.xpath("//*[@id=\"left-sidebar\"]/nav/ul/li[2]/a/span")).click();
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		String appName = driver2.findElement(By.xpath("//*[@id=\"application-table\"]/tbody/tr[1]/td[1]")).getText();
		System.out.println("Appplciation name:  " + appName);
		String actionActionMatch = "Failure";
		if (appName.equals("user@random.com/Apple")) {
			System.out.println("Application successfully shared");
			String allowedActions = driver2.findElement(By.xpath("//*[@id=\"application-table\"]/tbody/tr[1]/td[5]"))
					.getText();
			System.out.println("Allowed Actions are :" + allowedActions);
			actionActionMatch = "Success";

		}
		driver2.findElement(By.xpath("//*[@id=\"application-table\"]/tbody/tr[1]/td[1]")).click();
		if (actionActionMatch.equals("Success")) {
			nokeyGenerationAccess(driver2);
		}
		return actionActionMatch;

	}

	public static void nokeyGenerationAccess(WebDriver driver2) throws InterruptedException {
		driver2.findElement(By.id("actionLink-productionKeys")).click();
		((JavascriptExecutor)driver2).executeScript("window.scrollTo(0,document.body.scrollHeight)");
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		((JavascriptExecutor)driver2).executeScript("window.scrollTo(document.body.scrollHeight,0)");
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		Boolean isPresentProd = driver2.findElements(By.xpath("//*[@id=\"production\"]/div[2]/div/form/button"))
				.size() > 0;
		((JavascriptExecutor) driver2).executeScript("window.scrollTo(0,document.body.scrollHeight)");
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		((JavascriptExecutor)driver2).executeScript("window.scrollTo(document.body.scrollHeight,0)");
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		driver2.findElement(By.xpath("//*[@id=\"sandbox-keys-tab\"]/a")).click();
		Boolean isPresentSandbox = driver2.findElements(By.xpath("//*[@id=\"sandbox\"]/div/div/form/button"))
				.size() > 0;
		((JavascriptExecutor) driver2).executeScript("window.scrollTo(0,document.body.scrollHeight)");
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		if (isPresentProd == false && isPresentSandbox == false) {
			System.out.println("No Access granted yet");
		}

	}

	public static void keyGenerationByUser1(Set<Cookie> allCookies, WebDriver driver1) throws InterruptedException {
		for (Cookie cookie : allCookies) {
			driver1.manage().addCookie(cookie);
		}
		String storeUrL = "https://apistore-dev-dev-a878-14-ams10-nonp.cloud.random.com/store/";
		// launch Chrome and direct it to the Base URL
		driver1.get(storeUrL);
		driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);

		driver1.findElement(By.xpath("//*[@id=\"left-sidebar\"]/nav/ul/li[2]/a/span")).click();
		Thread.sleep(3000);
		driver1.findElement(By.xpath("//*[@id=\"application-table\"]/tbody/tr[1]/td[1]/a")).click();
		Thread.sleep(3000);
		driver1.findElement(By.id("actionLink-productionKeys")).click();
		Thread.sleep(3000);
		((JavascriptExecutor) driver1).executeScript("window.scrollTo(0,document.body.scrollHeight)");
		Thread.sleep(3000);
		driver1.findElement(By.xpath("//*[@id=\"production\"]/div[2]/div/form/button")).click();
		Thread.sleep(3000);
//    	driver1.findElement(By.xpath("//*[@id=\"sandbox-keys-tab\"]/a")).click();
//    	Thread.sleep(5000);
//    	driver1.findElement(By.xpath("//*[@id=\"sandbox\"]/div/div/form/button")).click();
//    	Thread.sleep(5000)

	}

	public static void keyGenerationAccess(Set<Cookie> allCookies2, WebDriver driver2) throws InterruptedException {
		for (Cookie cookie : allCookies2) {
			driver2.manage().addCookie(cookie);
		}
		String storeUrL = "https://apistore-dev-dev-a878-14-ams10-nonp.cloud.random.com/store/";
		// launch Chrome and direct it to the Base URL
		driver2.get(storeUrL);
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);

		driver2.findElement(By.xpath("//*[@id=\"left-sidebar\"]/nav/ul/li[2]/a/span")).click();
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		driver2.findElement(By.xpath("//*[@id=\"application-table\"]/tbody/tr[1]/td[1]")).click();
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		driver2.findElement(By.id("actionLink-productionKeys")).click();
		((JavascriptExecutor) driver2).executeScript("window.scrollTo(0,document.body.scrollHeight)");
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		((JavascriptExecutor)driver2).executeScript("window.scrollTo(document.body.scrollHeight,0)");
		Boolean isPresentProd = driver2.findElements(By.xpath("//*[@id=\"production\"]/div[2]/div/form/button"))
				.size() > 0;
		// driver2.findElement(By.xpath("//*[@id=\"sandbox-keys-tab\"]/a")).click();
		// Boolean isPresentSandbox =
		// driver2.findElements(By.xpath("//*[@id=\"sandbox\"]/div/div/form/button")).size()
		// > 0;
		if (isPresentProd == true) {
			System.out.println("Access Granted");
		}
		// subcribe
		driver2.findElement(By.xpath("//*[@id=\"left-sidebar\"]/nav/ul/li[2]/a/span")).click();
		// search an API
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		driver2.findElement(By.id("query")).sendKeys("JWT");
		driver2.findElement(By.id("searchAPI")).click();
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		// click API
		driver2.findElement(By.linkText("JWT")).click();
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		// subscribe
		driver2.findElement(By.xpath("//*[@id=\"application-selection-list\"]/div/button")).click();
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		driver2.findElement(By.xpath("//*[@id=\"application-selection-list\"]/div/div/ul/li[5]/a/span[1]")).click();
		driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		// tier
//		driver2.findElement(By.xpath("/html/body/div[1]/div/div[2]/div[2]/div/div[2]/div[1]/div/div[3]/form/div[2]/div/button")).click();
//		Thread.sleep(3000);
		//driver2.findElement(By.xpath("/html/body/div[1]/div/div[3]/div[2]/div/div[2]/div[1]/div/div[3]/form/div[2]/div/div/ul/li[5]")).click();
	//	driver2.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		// button subcribe
		driver2.findElement(By.xpath("//*[@id=\"subscribe-button\"]")).click();
		Thread.sleep(3000);
		String parentWindowHandler = driver2.getWindowHandle(); // Store your parent window
		String subWindowHandler = null;

		Set<String> handles = driver2.getWindowHandles(); // get all window handles
		Iterator<String> iterator = handles.iterator();
		while (iterator.hasNext()) {
			subWindowHandler = iterator.next();
		}
		driver2.switchTo().window(subWindowHandler); // switch to popup window
		driver2.findElement(By.id("btn-primary")).click();
		driver2.switchTo().window(parentWindowHandler); // switch back to parent window
		driver2.close();
	}

	public static void DeleteApplication(Set<Cookie> allCookies, WebDriver driver1) throws InterruptedException {
		for (Cookie cookie : allCookies) {
			driver1.manage().addCookie(cookie);
		}
		String storeUrL = "https://apistore-dev-dev-a878-14-ams10-nonp.cloud.random.com/store/";
		// launch Chrome and direct it to the Base URL
		driver1.get(storeUrL);
		Thread.sleep(3000);

		driver1.findElement(By.xpath("//*[@id=\"left-sidebar\"]/nav/ul/li[2]/a/span")).click();
		Thread.sleep(5000);
		driver1.findElement(By.xpath("//*[@id=\"application-table\"]/tbody/tr[1]/td[5]/a[3]/span[2]")).click();
		String parentWindowHandler = driver1.getWindowHandle(); // Store your parent window
		String subWindowHandler = null;

		Set<String> handles = driver1.getWindowHandles(); // get all window handles
		Iterator<String> iterator = handles.iterator();
		while (iterator.hasNext()) {
			subWindowHandler = iterator.next();
		}
		driver1.switchTo().window(subWindowHandler); // switch to popup window
		driver1.findElement(By.xpath("//*[@id=\"btn-primary\"]")).click();
		driver1.switchTo().window(parentWindowHandler); // switch back to parent window
		Thread.sleep(5000);
		driver1.close();

	}

}