*** Settings ***
Library          SeleniumLibrary
Library          ExcelLibrary
Library          OperatingSystem

*** Variables ***
${URL}                      https://www.rpachallenge.com/
${BROWSER}                  Chrome
${DOWNLOAD_FOLDER}          C:\\SeleniumDownloadFolder
${EXCEL_PATH}               ${DOWNLOAD_FOLDER}\\challenge.xlsx
${DOWNLOAD_EXCEL_BUTTON}    xpath://a[text()=" Download Excel "]
${START_BUTTON}             xpath://button[text()="Start"]
${FIRST_NAME_INPUT}         xpath://input[@ng-reflect-name="labelFirstName"]
${LAST_NAME_INPUT}          xpath://input[@ng-reflect-name="labelLastName"]
${ADDRESS_INPUT}            xpath://input[@ng-reflect-name="labelAddress"]
${EMAIL_INPUT}              xpath://input[@ng-reflect-name="labelEmail"]
${PHONE_NUMBER_INPUT}       xpath://input[@ng-reflect-name="labelPhone"]
${COMPANY_NAME_INPUT}       xpath://input[@ng-reflect-name="labelCompanyName"]
${ROLE_IN_COMPANY_INPUT}    xpath://input[@ng-reflect-name="labelRole"]
${SUBMIT_BUTTON}            xpath://input[@value="Submit"]

*** Keywords ***
Setup
    Empty download folder
    Setup download folder
    go to   ${URL}
    set selenium implicit wait  5
    maximize browser window

TearDown
    close all browsers
    Empty download folder

Setup download folder
    ${chrome options}=  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
    ${prefs}  Create Dictionary     download.default_directory=${DOWNLOAD_FOLDER}
    call method  ${chrome options}  add_experimental_option  prefs  ${prefs}
    create webdriver  ${BROWSER}  chrome_options=${chrome options}

Empty download folder
    run keyword and ignore error    Empty Directory    ${DOWNLOAD_FOLDER}

Open excel
    [Arguments]     ${excel_path}
    open excel document     ${excel_path}   docid

Close all excels
    close all excel documents

Download excel
    wait until element is visible   ${DOWNLOAD_EXCEL_BUTTON}
    click element  ${DOWNLOAD_EXCEL_BUTTON}
    sleep   2
    ${files}  List Files In Directory   ${DOWNLOAD_FOLDER}
    length should be    ${files}    1

Start challenge
    click element   ${START_BUTTON}

Read data from excel
    Open excel  ${EXCEL_PATH}
    @{firstNames}=       read excel column   1    1   10
    @{lastNames}=        read excel column   2    1   10
    @{companyNames}=     read excel column   3    1   10
    @{rolesInCompany}=   read excel column   4    1   10
    @{addresses}=        read excel column   5    1   10
    @{emails}=           read excel column   6    1   10
    @{phoneNumbers}=     read excel column   7    1   10

    Close all excels

    Set Suite variable  @{FIRST_NAMES}        @{firstNames}
    Set Suite variable  @{LAST_NAMES}         @{lastNames}
    Set Suite variable  @{COMPANY_NAMES}      @{companyNames}
    Set Suite variable  @{ROLES_IN_COMPANY}   @{rolesInCompany}
    Set Suite variable  @{ADDRESSES}          @{addresses}
    Set Suite variable  @{EMAILS}             @{emails}
    Set Suite variable  @{PHONE_NUMBERS}      @{phoneNumbers}

Fill input forms with data
    FOR     ${index}    IN RANGE    10
        input text      ${FIRST_NAME_INPUT}       ${FIRST_NAMES}[${index}]
        input text      ${LAST_NAME_INPUT}        ${LAST_NAMES}[${index}]
        input text      ${COMPANY_NAME_INPUT}     ${COMPANY_NAMES}[${index}]
        input text      ${ROLE_IN_COMPANY_INPUT}  ${ROLES_IN_COMPANY}[${index}]
        input text      ${ADDRESS_INPUT}          ${ADDRESSES}[${index}]
        input text      ${EMAIL_INPUT}            ${EMAILS}[${index}]
        input text      ${PHONE_NUMBER_INPUT}     ${PHONE_NUMBERS}[${index}]
        click element   ${SUBMIT_BUTTON}
    END


