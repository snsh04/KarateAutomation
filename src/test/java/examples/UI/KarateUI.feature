Feature: Browser automation

Background:
  * configure driver = { type: 'chrome' }
  # * configure driver = { type: 'chromedriver', showDriverLog: true }
  # * configure driver = { type: 'geckodriver', showDriverLog: true }
  # * configure driver = { type: 'safaridriver' }
  # * configure driver = { type: 'mswebdriver' }

@UITesting
Scenario: Analytics Test
  Given driver 'https://apistore-dev-dev-a878-14-ams10-nonp.cloud.random.com/store/'
  * driver.click("//input[@name='/html/body/div[1]/div/div[1]/nav/ul/li[4]/a/span']")
  * driver.waitUntil()
 # * driver.close()