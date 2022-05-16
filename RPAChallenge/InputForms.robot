*** Settings ***
Library          SeleniumLibrary
Resource         ../RPAChallenge/resources.robot
Suite Setup      Setup
Suite Teardown   TearDown


*** Test Cases ***
FillInputsWithCorrectData
    Download excel
    Read data from excel
    Start challenge
    Fill input forms with data

