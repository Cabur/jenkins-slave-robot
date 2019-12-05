*** Settings ***
Library    Selenium2Library

Suite Teardown    Close All Browsers
Test Setup  Open Chrome

*** Keywords ***

Open Chrome
    ${chrome_options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    Call Method    ${chrome_options}    add_argument    --disable-extensions
    Call Method    ${chrome_options}    add_argument    --headless
    Call Method    ${chrome_options}    add_argument    --disable-gpu
    Call Method    ${chrome_options}    add_argument    --no-sandbox
    Create Webdriver    Chrome    chrome_options=${chrome_options}

*** Test Cases ***
CNN Test
    Go To	http://www.cnn.com
    Page Should Contain	TRENDING

