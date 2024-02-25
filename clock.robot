*** Settings ***
Library    AppiumLibrary
Library    BuiltIn

*** Keywords ***
Open Clock App
    Open Application    
    ...    remote_url=http://appium:4723
    ...    platformName=Android
    ...    deviceName=1aaa0c0e
    ...    appPackage=com.android.deskclock
    ...    appActivity=com.android.deskclock.DeskClockTabActivity
    ...    automationName=UiAutomator2

Delete All Timers
    Long Press    
    ...    locator=//androidx.recyclerview.widget.RecyclerView[@resource-id="android:id/list"]/android.widget.RelativeLayout[1]
    
    Click Element    
    ...    locator=//androidx.recyclerview.widget.RecyclerView[@resource-id="android:id/list"]/android.widget.RelativeLayout[2]
    
    Click Element    
    ...    locator=//androidx.recyclerview.widget.RecyclerView[@resource-id="android:id/list"]/android.widget.RelativeLayout[3]

    Click Element    
    ...    locator=accessibility_id=Excluir


Setup Alarm
    [Arguments]    ${days_of_week}    ${label}
    Setup Alarm Hour

    ${hour}    Get Element Attribute    
    ...    locator=com.android.deskclock:id/hour    
    ...    attribute=text

    ${minute}    Get Element Attribute    
    ...    locator=com.android.deskclock:id/minute    
    ...    attribute=text
    
    Setup Alarm Days Of Week    days_of_week=${days_of_week}

    # Enable vibration
    Click Element    locator=com.android.deskclock:id/checkbox

    Click Element    locator=com.android.deskclock:id/edit_label

    Setup Alarm Label    label=${label}

    #Add alarm
    Click Element    locator=android:id/button2

    ${timer}    Create Dictionary    
    ...    hour=${hour}    
    ...    minute=${minute}
    ...    days_of_week=${days_of_week}
    ...    label=${label}

    RETURN    ${timer}


Setup Alarm Hour
    Swipe    start_x=${316}    start_y=${669}    offset_x=${316}    offset_y=${372}
    Swipe    start_x=${755}    start_y=${352}    offset_x=${761}    offset_y=${976}

Setup Alarm Days Of Week
    [Arguments]    ${days_of_week}
    Click Element    locator=com.android.deskclock:id/repeat
    Wait Until Element Is Visible    locator=com.android.deskclock:id/parentPanel
    Click Element    locator=//android.widget.CheckedTextView[@resource-id="android:id/text1" and @text='${days_of_week}']
Setup Alarm Label
    [Arguments]    ${label}
    Click Element    locator=com.android.deskclock:id/alarm_label

    ${is_keyboard_shown} =    Is Keyboard Shown
    Should Be True    condition=${is_keyboard_shown}    

    Input Text Into Current Element    text=${label}

    Click Element    locator=android:id/button1
Verify Alarm Setup
    [Arguments]    ${setup}

    ${alarm_element}    Set Variable    //android.widget.TextView[@text='${setup}[label]']//..

    Wait Until Element Is Visible    locator=${alarm_element}

    ${is_alarm_active}    Get Element Attribute    locator=${alarm_element}//android.widget.CheckBox[@resource-id="com.android.deskclock:id/clock_onoff"]    attribute=checkable
    
    Should Be True    condition='${is_alarm_active}' == 'true'

    ${hour_without_decimals}=    Evaluate    int(${setup}[hour])
    ${minute_without_decimals}=  Evaluate    int(${setup}[minute])
    IF  ${hour_without_decimals} < 10
        ${hour_without_decimals}    Set Variable    0${hour_without_decimals}
    END
    IF  ${minute_without_decimals} < 10
        ${minute_without_decimals}    Set Variable    0${minute_without_decimals}
    END
    

    Wait Until Element Is Visible     locator=${alarm_element}//android.widget.TextView[@resource-id="com.android.deskclock:id/time_display" and @text="${hour_without_decimals}:${minute_without_decimals}"]

    Wait Until Element Is Visible     locator=${alarm_element}//android.widget.TextView[@resource-id="com.android.deskclock:id/days_of_week" and @text="${setup}[days_of_week]"]


*** Test Cases ***
Should exclude all timers
    Open Clock App

    Wait Until Page Contains Element    
    ...    locator=android:id/list

    Delete All Timers
    
    Wait Until Page Contains Element    
    ...    locator=com.android.deskclock:id/alarm_blank_page_lite

Should add a new timer
    Open Clock App

    Click Element    locator=com.android.deskclock:id/end_btn2
    ${setup}    Setup Alarm    days_of_week=Diariamente    label=New Alarm
    
    Verify Alarm Setup    setup=${setup}
    