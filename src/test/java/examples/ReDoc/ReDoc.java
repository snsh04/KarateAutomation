package examples.ReDoc;

import com.intuit.karate.junit4.Karate;

import java.util.Iterator;
import java.util.Set;
import java.util.concurrent.TimeUnit;

import org.junit.runner.RunWith;
import org.openqa.selenium.By;
import org.openqa.selenium.Cookie;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.remote.CapabilityType;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

@RunWith(Karate.class)
public class ReDoc {
	 public static void main() throws InterruptedException {
		  //Generate Driver for user 1

		  String OSName = System.getProperty("os.name");

		  WebDriver driver1;
		  Set < Cookie > allCookies;
		  if (OSName.contains("Mac")) {
		   DesiredCapabilities capabilities = DesiredCapabilities.chrome();
		   ChromeOptions options = new ChromeOptions();
		   options.addArguments("--incognito");
		   capabilities.setCapability(ChromeOptions.CAPABILITY, options);
		  // System.setProperty("webdriver.chrome.driver", "src//test//java//drivers//windows//chromedriver.exe");

		   System.out.println("[OS: ]" + OSName);
		   driver1 = new ChromeDriver(capabilities);
		   allCookies = driver1.manage().getCookies();
		   System.out.println("instance created ");
		  } else {
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
		 driver1 = new ChromeDriver(chromeOptions);

		 allCookies = driver1.manage().getCookies();
		  }


		  // login with user 1 and create application with a group
		  loginToPublisher(driver1);


		  System.out.println("Finished UI Task ");

		 }
	 
	 public static void loginToPublisher(WebDriver driver1) throws InterruptedException {
		 WebDriverWait wait=new WebDriverWait(driver1, 30);
		 WebElement element;
	  String pubUrL = "https://publishr-dev-dev-a878-16-ams10-nonp.cloud.random.com/publisher/";

	  // launch Chrome and direct it to the Base URL
	  driver1.manage().window().maximize();
	  driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
	  driver1.get(pubUrL);
	  System.out.println("Fetchung URL");
	  // input username
	  driver1.findElement(By.id("username")).sendKeys("regtest_buss@random.com");


	  // input password
	  driver1.findElement(By.id("password")).sendKeys("admin");

	  // click signin
	element= wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//*[@id=\"loginForm\"]/div[4]/div[2]/button")));
	  element.click();
	  System.out.println("Clicked signin ");

	  // click add new API
		element= wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//*[@id=\"top-menu-api-add\"]/a")));
	  element.click();
	  System.out.println("clicked on add new API ");

	  // click on soap option
	  element= wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("headingTwo")));
	  element.click();
	  System.out.println("clicked soap option");

	  //inout wsdl
	  element= wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("wsdl-url")));
	  element.sendKeys("https://soap-demo-dev-12-dev-a878-34-ams10-nonp.cloud.random.com/ws/countries.wsdl");
	  System.out.println("inserted wsdl");

	  // click start creating
	  element= wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("startFromExistingSOAPEndpoint")));
	  element.click();
	  System.out.println("clicked creating  ");

	  //enter name
	  element= wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("name")));
	  element.sendKeys("SOAPReDoc");
	  System.out.println("entered the name ");

	  // enter context
	  element= wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("context")));
	  element.sendKeys("/test/countrySOAPReDoc");
	  System.out.println("context added ");

	  // enter version
	  element= wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("version")));
	  element.sendKeys("v1");
	  System.out.println("version added ");

	  //test URI
	  element= wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//*[@id=\"api_designer\"]/div/div/div/div/button")));
	  element.click();
	  System.out.println("URI tested ");

	  // save
	  //element= wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("saveBtn")));
	  //element.click();
	  //System.out.println("clicked save ");


	  // implement
	  element= wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("go_to_implement")));
	  element.click();
	  System.out.println("clicked implement ");

	  // click manage tab
	  element= wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("headingOne")));
	  element.click();
	  System.out.println("clicked on manage tab ");

	  //endpoint type
	  element= wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//*[@id=\"endpoint_type\"]/option[2]")));
	  element.click();
	  System.out.println("selected endpoint type ");

	  // prod url
	  element= wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("endpoint-input")));
	  element.sendKeys("https://soap-demo-dev-12-dev-a878-34-ams10-nonp.cloud.random.com/ws");
	  System.out.println("added prod url ");

	  // manage
	  element= wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("go_to_manage")));
	  element.click();
	  System.out.println("clicked manage ");

	  //select tier
	  element= wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//*[@id=\"Bronze_Auto-Approved\"]/span")));
	  element.click();
	  System.out.println("selected tier ");

	  // save api
	  element= wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("save_api")));
	  element.click();
	  System.out.println("saved API ");

	  // save and publish
	  element= wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("publish_api")));
	  element.click();
		System.out.println("Saved and published ");

		  String parentWindowHandler = driver1.getWindowHandle(); // Store your parent window
		  String subWindowHandler = null;

		  Set < String > handles = driver1.getWindowHandles(); // get all window handles
		  Iterator < String > iterator = handles.iterator();
		  while (iterator.hasNext()) {
		   subWindowHandler = iterator.next();
		  }
		  driver1.switchTo().window(subWindowHandler); // switch to popup window
		  element= wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//*[@id=\"publish-success\"]/div/div/div[3]/div/a[2]")));
		  element.click();
			System.out.println("Overview pane ");
		  driver1.switchTo().window(parentWindowHandler); // switch back to parent window
		  driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);




	 }


}