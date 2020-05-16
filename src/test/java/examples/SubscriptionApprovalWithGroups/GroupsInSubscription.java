package examples.SubscriptionApprovalWithGroups;

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
public class GroupsInSubscription {

 public static boolean main(String ApplicationName, String groups, String wso2username, String wso2password) throws InterruptedException {
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
   System.out.println("instamce created ");
  } else {
   System.setProperty("webdriver.chrome.driver", "src//test//java//drivers//linux//chromedriver");
   System.out.println("[OS: ]" + OSName);
   DesiredCapabilities cap;
   driver1 = new PhantomJSDriver();
   allCookies = driver1.manage().getCookies();
  }


  // login with user 1 and create application with a group
  Boolean Flag = loginToManger(driver1, ApplicationName, groups,wso2username,wso2password);


  System.out.println("Finished UI Task ");
return Flag;


 }

 public static Boolean loginToManger(WebDriver driver1, String ApplicationName,String groups,String wso2username, String wso2password) throws InterruptedException {

  String apiManager = "https://manager-int-dev-dev-a878-15-ams10-nonp.cloud.random.com/admin/site/pages/login.jag";
  // launch Chrome and direct it to the Base URL
  driver1.manage().window().maximize();
  driver1.get(apiManager);
  Thread.sleep(3000);
  driver1.findElement(By.id("username")).sendKeys(wso2username);
  Thread.sleep(3000);
  driver1.findElement(By.id("pass")).sendKeys(wso2password);
  Thread.sleep(3000);
  driver1.findElement(By.id("loginButton")).click();
  driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
  Thread.sleep(3000);
 
  // Click on subscription Approval
  driver1.findElement(By.xpath("//*[@id=\"left-sidebar\"]/div/div/ul/li[1]/ul/li[3]/a")).click();
  driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);

  // Search by application name 
  driver1.findElement(By.xpath("//*[@id=\"subscription-tasks_filter\"]/label/input")).sendKeys(ApplicationName);;
  driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);

  // Get Texts for the approval
  String approvalRequest = driver1.findElement(By.xpath("//*[@id=\"desc0\"]")).getText();
  Boolean flag=true;
  
  // Validate groups in the subscription requests 
  if(approvalRequest.contains(groups))
  {
	  System.err.println("Groups added : " + groups);
	  System.out.println("Groups present in subscription request");
	  
  }
  else
  {
	  System.err.println("Groups not added : " + groups);
	  System.out.println("Groups not present in subscription request");
	  flag=false;
  }
 
  driver1.close();
  return flag;
 }
}