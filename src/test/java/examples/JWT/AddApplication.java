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

import com.intuit.karate.junit4.Karate;

@RunWith(Karate.class)
public class AddApplication {

	public static void main() throws InterruptedException {
		//Generate Driver for user 1
		
		String OSName=System.getProperty("os.name");	
		
		WebDriver driver1;
		Set<Cookie> allCookies;
		if(OSName.contains("Windows")) {
			 DesiredCapabilities capabilities = DesiredCapabilities.chrome();
		        ChromeOptions options = new ChromeOptions();
		        options.addArguments("--incognito");
		        capabilities.setCapability(ChromeOptions.CAPABILITY, options);
			System.setProperty("webdriver.chrome.driver", "src//test//java//drivers//windows//chromedriver.exe");

			System.out.println("[OS: ]"+OSName);
			driver1= new ChromeDriver(capabilities);
			allCookies = driver1.manage().getCookies();
			System.out.println("instamce created ");
		}else{
			System.setProperty("phantomjs.binary.path", "src//test//java//drivers//linux//phantomjs");
			System.out.println("[OS: ]"+OSName);
			DesiredCapabilities cap;
			driver1 = new PhantomJSDriver();	
			allCookies = driver1.manage().getCookies();
		}
		
		// login with user 1 and create application with a group
		loginThroughSSOForUser1(driver1);
		

		
		//Verify permissions and key generation before and after owner does it.
		keyGenerationByUser1(driver1);
		
		
		

		System.out.println("Finished UI Task ");
	
	}

	public static void loginThroughSSOForUser1(WebDriver driver1) throws InterruptedException {

		String storeUrL = "https://apistore-dev-dev-a878-14-ams10-nonp.cloud.random.com/store/";
		// launch Chrome and direct it to the Base URL
		driver1.manage().window().maximize();
		driver1.get(storeUrL);
		Thread.sleep(3000);
		// click signin 
		driver1.findElement(By.id("btn-login")).click();
		// click on SSO
		Thread.sleep(3000);
		driver1.findElement(By.xpath("//*[@id=\"icon-2\"]/img")).click();
		Thread.sleep(5000);
		// end user name
		driver1.findElement(By.name("loginfmt")).sendKeys("user@random.com");
		Thread.sleep(2000);
		// click next
		driver1.findElement(By.id("idSIButton9")).click();
		Thread.sleep(5000);
		// enter password
		driver1.findElement(By.id("passwordInput")).sendKeys("test");
		Thread.sleep(2000);
		// click submit
		driver1.findElement(By.id("submitButton")).click();
       //andle pop up
		Thread.sleep(5000);
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
		Thread.sleep(10000);
		// click on application tab
		driver1.findElement(By.xpath("//*[@id=\"left-sidebar\"]/nav/ul/li[2]/a/span")).click();
		Thread.sleep(3000);
		// click on Add Application
		driver1.findElement(By.xpath("//*[@id=\"navbar\"]/ul/li/a")).click();
		Thread.sleep(3000);
		//Send Application name
		driver1.findElement(By.id("application-name")).sendKeys("JWTTokenApp");
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
		Thread.sleep(3000);
		((JavascriptExecutor)driver1).executeScript("window.scrollTo(0,document.body.scrollHeight)");
		Thread.sleep(3000);
		
		driver1.findElement(By.id("actionLink-productionKeys")).click();
		Thread.sleep(5000);
		((JavascriptExecutor) driver1).executeScript("window.scrollTo(0,document.body.scrollHeight)");
		Thread.sleep(3000);
		//driver1.findElement(By.xpath("//*[@id=\"production\"]/div[2]/div/form/button")).click();
		Thread.sleep(5000);
	//	keyGenerationByUser1(allCookies,driver1);
	}


	public static void keyGenerationByUser1(WebDriver driver1) throws InterruptedException {
		
		String storeUrL = "https://apistore-dev-dev-a878-14-ams10-nonp.cloud.random.com/store/";
		// launch Chrome and direct it to the Base URL
		driver1.get(storeUrL);
		Thread.sleep(3000);

		driver1.findElement(By.xpath("//*[@id=\"left-sidebar\"]/nav/ul/li[2]/a/span")).click();
		Thread.sleep(5000);
		driver1.findElement(By.xpath("//*[@id=\"application-table_filter\"]/label/input")).sendKeys("JWTTokenApp");
		Thread.sleep(5000);
		
		driver1.findElement(By.xpath("//*[@id=\"application-table\"]/tbody/tr/td[1]/a")).click();
		Thread.sleep(5000);
		driver1.findElement(By.id("actionLink-productionKeys")).click();
		Thread.sleep(5000);
		((JavascriptExecutor) driver1).executeScript("window.scrollTo(0,document.body.scrollHeight)");
		
		Thread.sleep(3000);
		
		driver1.findElement(By.xpath("//*[@id=\"production\"]/div[2]/div/div[2]/input")).sendKeys("https://oidc-demo-implicit-dev-a878-21-ams10-nonp.cloud.random.com");
Thread.sleep(3000);
driver1.findElement(By.xpath("//*[@id=\"production\"]/div/div/button")).click();
Thread.sleep(2000);
driver1.findElement(By.xpath("//*[@id=\"production\"]/div/div/div[4]/div/div/div[3]/label/span")).click();
Thread.sleep(3000);
		driver1.findElement(By.xpath("//*[@id=\"production\"]/div[2]/div/form/button")).click();
		Thread.sleep(5000);
//    	driver1.findElement(By.xpath("//*[@id=\"sandbox-keys-tab\"]/a")).click();
//    	Thread.sleep(5000);
//    	driver1.findElement(By.xpath("//*[@id=\"sandbox\"]/div/div/form/button")).click();
//    	Thread.sleep(5000);
		

	}


}