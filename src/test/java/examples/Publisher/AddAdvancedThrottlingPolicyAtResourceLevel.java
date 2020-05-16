package examples.Publisher;

import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.concurrent.TimeUnit;

import javax.sound.midi.Synthesizer;

import org.junit.runner.RunWith;
import org.openqa.selenium.By;
import org.openqa.selenium.Cookie;
import org.openqa.selenium.Dimension;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.phantomjs.PhantomJSDriver;
import org.openqa.selenium.remote.CapabilityType;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.support.ui.Select;

import com.intuit.karate.junit4.Karate;

@RunWith(Karate.class)
public class AddAdvancedThrottlingPolicyAtResourceLevel {

 public static void main(String Title) throws InterruptedException {
  //Generate Driver for user 1

  String OSName = System.getProperty("os.name");

  WebDriver driver1;
  Set < Cookie > allCookies;
  if (OSName.contains("Mac")) {
   DesiredCapabilities capabilities = DesiredCapabilities.chrome();
   ChromeOptions options = new ChromeOptions();
   options.addArguments("--incognito");
   capabilities.setCapability(ChromeOptions.CAPABILITY, options);
 //  System.setProperty("webdriver.chrome.driver", "src//test//java//drivers//windows//chromedriver.exe");

   System.out.println("[OS: ]" + OSName);
   driver1 = new ChromeDriver(capabilities);
   allCookies = driver1.manage().getCookies();
   System.out.println("Instance created ");
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
  loginThroughSSOForUser1(driver1,Title);


  System.out.println("Finished UI Task ");

 }

 public static void loginThroughSSOForUser1(WebDriver driver1, String Title) throws InterruptedException {

  String storeUrL = "https://publishr-dev-dev-a878-16-ams10-nonp.cloud.random.com/publisher/";
  // launch Chrome and direct it to the Base URL
  driver1.manage().window().maximize();
  driver1.get(storeUrL);
  Thread.sleep(3000);
  driver1.findElement(By.id("username")).sendKeys("admin");
  Thread.sleep(3000);
  driver1.findElement(By.id("password")).sendKeys("bananaM1lkshake");
  Thread.sleep(3000);
  driver1.findElement(By.xpath("//*[@id=\"loginForm\"]/div[4]/div[2]/button")).click();
  driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);

  // search API by name
  driver1.findElement(By.xpath("//*[@id=\"listing\"]/div[2]/div/div[1]/div/form/div[1]/div/div/input[1]")).sendKeys(Title);
  driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);

  // click on search
  driver1.findElement(By.xpath("//*[@id=\"search\"]")).click();
  driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);

  // Click on API
  driver1.findElement(By.xpath("//*[@id=\"listing\"]/div[2]/div/div[4]/div/div/div/div[2]/h4/a")).click();

  // Edit API
  driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
  driver1.findElement(By.xpath("//*[@id=\"navbar\"]/ul/li[2]/a")).click();
  driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);


//manage 
 driver1.findElement(By.xpath("//*[@id=\"item-add\"]/div[2]/div[1]/div[3]/div/div[1]/ol/li[3]/a/span[2]")).click();
 driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
 // ((JavascriptExecutor) driver1).executeScript("window.scrollTo(0,document.body.scrollHeight)");

  //bullet
  driver1.findElement(By.xpath("//*[@id=\"manage_form\"]/div[1]/div[2]/div[2]/div/div[5]/div/label[1]/span")).click();
  driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
  
  // Select resource level policy for resources 
  driver1.findElement(By.xpath("//*[@id=\"manage_form\"]/div[1]/div[2]/div[2]/div/div[5]/div/label[2]/span")).click();
  driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
  
  // click on select resource
  driver1.findElement(By.xpath("//*[@id=\"resource-policy-select\"]/a")).click();
  driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);

  // get number of resources
  Dimension tableSize  = driver1.findElement(By.xpath("//*[@id=\"resource_policy_modal\"]/div/div/div[2]/table/tbody")).getSize();
  System.out.println("Size of the table " + tableSize);
  driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
  
  // save and publish
  Thread.sleep(5000);
  driver1.findElement(By.xpath("//*[@id=\"publish_api\"]")).click();
  driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
  Thread.sleep(6000);
  String parentWindowHandler = driver1.getWindowHandle(); // Store your parent windo
  String subWindowHandler = null;

  Set < String > handles = driver1.getWindowHandles(); // get all window handles
  Iterator < String > iterator = handles.iterator();
  while (iterator.hasNext()) {
   subWindowHandler = iterator.next();
  }
  driver1.switchTo().window(subWindowHandler); // switch to popup window
  driver1.findElement(By.xpath("//*[@id=\"publish-success\"]/div/div/div[3]/div/a[2]")).click();
  driver1.switchTo().window(parentWindowHandler); // switch back to parent window
  driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);

  // logout
  driver1.findElement(By.xpath("/html/body/header/div/ul/li[3]/a/span[2]")).click();
  Thread.sleep(2000);
  driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
  driver1.findElement(By.xpath("/html/body/header/div/ul/li[3]/ul/li[3]/a")).click();
  Thread.sleep(2000);
  driver1.close();
 }
}