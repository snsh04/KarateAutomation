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
public class Implicit {

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
 String Response = loginThroughSSOForUser1(driver1);


  System.out.println("Finished UI Task ");
return Response;


 }

 public static String loginThroughSSOForUser1(WebDriver driver1) throws InterruptedException {

	 String AuthenticatedURL = "https://auth-dev-dev-a878-13-ams10-nonp.cloud.random.com/authenticationendpoint/login.do?client_id=cCRq7fkCkv_4ZlY_FmfGHSd1RK8a&commonAuthCallerPath=%2Foauth2%2Fauthorize&forceAuth=false&nonce=nz88nhcj8jkdj22it3n5ae&passiveAuth=false&redirect_uri=https%3A%2F%2Foidc-demo-implicit-dev-a878-21-ams10-nonp.cloud.random.com%2F&response_type=id_token+token&scope=openid&tenantDomain=carbon.super&sessionDataKey=1378c4d6-fecf-491c-9e3e-e4cc532deb5f&relyingParty=cCRq7fkCkv_4ZlY_FmfGHSd1RK8a&type=oidc&sp=admin_oidctestingjwt_PRODUCTION&isSaaSApp=false&authenticators=OpenIDConnectAuthenticator%3Arandom+SSO%3BBasicAuthenticator%3ALOCAL%3ALOCAL";
		// launch Chrome and direct it to the Base URL	
		driver1.manage().window().maximize();
		driver1.get(AuthenticatedURL);
		 driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		 
		// click on SSO
		driver1.findElement(By.xpath("//*[@id=\"icon-2\"]/img")).click();
		 driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
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
		
		 //click approve
		 driver1.findElement(By.id("approve")).click();
		 driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
		 
//		 //click API
//		 driver1.findElement(By.xpath("/html/body/app-root/div/app-root/div/div/p[2]/button")).click();
//		 driver1.manage().timeouts().implicitlyWait(10, TimeUnit.SECONDS);
//		 
//		 String response = driver1.findElement(By.xpath("/html/body/app-root/div/app-root/div/div/p[4]/text()")).getText();
		
		 String url = driver1.getCurrentUrl();
		  driver1.close();
		return url;

 }
}