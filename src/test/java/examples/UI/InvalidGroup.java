package examples.UI;

import java.sql.Driver;
import java.util.Iterator;
import java.util.List;
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

import com.intuit.karate.junit4.Karate;

@RunWith(Karate.class)
public class InvalidGroup {

	public static void main(String groupName) throws InterruptedException {
		
		setInvalidUser(groupName);

		System.out.println("Finished UI Task for invalid groups");
	}

	public static void setInvalidUser(String groupName) throws InterruptedException {
		
				String OSName=System.getProperty("os.name");	
				
				WebDriver driver4;
				Set<Cookie> allCookies;
				if(OSName.contains("Mac")) {
					 DesiredCapabilities capabilities = DesiredCapabilities.chrome();
				        ChromeOptions options = new ChromeOptions();
				        options.addArguments("--incognito");
				        capabilities.setCapability(ChromeOptions.CAPABILITY, options);
					//System.setProperty("webdriver.chrome.driver", "src//test//java//drivers//windows//chromedriver.exe");

					System.out.println("[OS: ]"+OSName);
					driver4= new ChromeDriver(capabilities);
					allCookies = driver4.manage().getCookies();
					System.out.println("instamce created ");
				}else{
					System.setProperty("phantomjs.binary.path", "src//test//java//drivers//linux//chromedriver");
					System.out.println("[OS: ]"+OSName);
					DesiredCapabilities cap;
					driver4 = new ChromeDriver();	
					allCookies = driver4.manage().getCookies();
				}
				
		String storeUrL = "https://apistore-dev-dev-a878-14-ams10-nonp.cloud.random.com/store/";
		// launch Chrome and direct it to the Base URL
		driver4.manage().window().maximize();
		driver4.get(storeUrL);
		Thread.sleep(3000);
		// click signin 
		driver4.findElement(By.id("btn-login")).click();
		// click on SSO
		Thread.sleep(3000);
		driver4.findElement(By.xpath("//*[@id=\"icon-2\"]/img")).click();
		Thread.sleep(5000);
		// end user name
		driver4.findElement(By.name("loginfmt")).sendKeys("user@random.com");
		Thread.sleep(2000);
		// click next
		driver4.findElement(By.id("idSIButton9")).click();
		Thread.sleep(5000);
		// enter password
		driver4.findElement(By.id("passwordInput")).sendKeys("test");
		Thread.sleep(2000);
		// click submit
		driver4.findElement(By.id("submitButton")).click();
		Thread.sleep(5000);
       //handle pop up
		String parentWindowHandler = driver4.getWindowHandle(); // Store your parent window
		String subWindowHandler = null;
		Set<String> handles = driver4.getWindowHandles(); // get all window handles
		Iterator<String> iterator = handles.iterator();
		while (iterator.hasNext()) {
			subWindowHandler = iterator.next();
		}
		driver4.switchTo().window(subWindowHandler); // switch to popup window
		driver4.findElement(By.id("idSIButton9")).click();
		driver4.switchTo().window(parentWindowHandler); // switch back to parent window
		Thread.sleep(10000);
		// click on application tab
		driver4.findElement(By.xpath("//*[@id=\"left-sidebar\"]/nav/ul/li[2]/a/span")).click();
		Thread.sleep(3000);
		// click on Add Application
		driver4.findElement(By.xpath("//*[@id=\"navbar\"]/ul/li/a")).click();
		Thread.sleep(3000);
		//Send Application name
		driver4.findElement(By.id("application-name")).sendKeys(groupName);
		// Add group
		WebElement element = driver4.findElement(By.xpath("//*[@id=\"appAddForm\"]/div[2]/div/div"));
		Actions Action = new Actions(driver4);
		Action.moveToElement(element);
		Action.click();
		Action.sendKeys("DevTeam");
		Action.sendKeys(Keys.ENTER);
		Action.sendKeys("Dev Team");
		Action.sendKeys(Keys.ENTER);
		//Action.sendKeys("124%^$^rubbish//.,;[]");
		Action.sendKeys("124%^$^rubbish//");
		Action.sendKeys(Keys.ENTER);
		Action.sendKeys(" ");
		Action.sendKeys(Keys.ENTER);
		Action.build().perform();
		Thread.sleep(10000);
		//click add to add application
		driver4.findElement(By.id("application-add-button")).click();
		Thread.sleep(3000);
		((JavascriptExecutor)driver4).executeScript("window.scrollTo(0,document.body.scrollHeight)");
		Thread.sleep(3000);
		driver4.close();

	}

}