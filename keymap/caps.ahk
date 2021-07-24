﻿#NoEnv
#SingleInstance Force
#UseHook
#MaxHotkeysPerInterval 200
#WinActivateForce               ; 解决「 winactivate 最小化的窗口时不会把窗口放到顶层(被其他窗口遮住) 」
#include keymap/functions.ahk

SetBatchLines -1
ListLines Off
process, Priority,, A
SetWorkingDir %A_ScriptDir%  
SendMode Input

SetMouseDelay, 0  ; 发送完一个鼠标后不会 sleep
SetDefaultMouseSpeed, 0
coordmode, mouse, screen
settitlematchmode, 2

time_enter_repeat = T0.2
delay_before_repeat = T0.01
fast_one := 110     
fast_repeat := 70
slow_one :=  10     
slow_repeat := 13

Menu, Tray, Icon, exe.ico
processPath := getProcessPath()
SetWorkingDir, %processPath%


CoordMode, Mouse, Screen
; 多显示器不同缩放比例导致的问题,  https://www.autohotkey.com/boards/viewtopic.php?f=14&t=13810
DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
return

RAlt::LCtrl
+capslock::toggleCapslock()

*capslock::
    CapslockMode := true
    keywait capslock
    CapslockMode := false
    if (A_PriorKey == "CapsLock" && A_TimeSinceThisHotkey < 450) {
        enterHotString()
    }
    return




*j::
    JMode := true
    keywait `j
    JMode := false
    if (A_PriorKey == "j" && A_TimeSinceThisHotkey < 350)
            send  {blind}`j
    return



*`;::
    hotstring("Reset")
    PunctuationMode := true
    keywait `; 
    PunctuationMode := false
    if (A_PriorKey == ";" && A_TimeSinceThisHotkey < 350)
        EnterHotstringMode()
    return


*3::
    DigitMode := true
    keywait 3 
    DigitMode := false
    if (A_PriorKey == "3" && A_TimeSinceThisHotkey < 350)
        send {blind}3 
    return

#if JMode
*capslock::return
*capslock up::return
    ^l::return
    +k::return
    *k::
        send {blind}{Rshift down}
        keywait k
        send {Rshift up}
        return
    *l::
        send {blind}{Lctrl down}
        keywait l
        send {Lctrl up}
        return

*W::send {blind}+{tab}
*Z::send {blind}{appskey}
*C::send {blind}{backspace}
*V::send {blind}{delete}
*D::send {blind}{down}
*G::send {blind}{end}
*X::send {blind}{esc}
*A::send {blind}{home}
*I::send {blind}{insert}
*S::send {blind}{left}
*T::send {blind}{pgdn}
*Q::send {blind}{pgup}
*F::send {blind}{right}
*R::send {blind}{tab}
*E::send {blind}{up}

*space::send  {blind}{enter}
    


#if PunctuationMode
*U::send {blind}$
*R::send {blind}&
*Q::send {blind}(
*I::send {blind}*
*M::send {blind}-
*C::send {blind}.
*N::send {blind}/
*A::send {blind}:
*S::send {blind}<
*D::send {blind}=
*F::send {blind}>
*Y::send {blind}@
*Z::send {blind}\
*X::send {blind}_
*B::send {blind}`%
*H::send {blind}`;
*K::send {blind}``
*G::send {blind}{!}
*W::send {blind}{#}
*J::send {blind}{+}
*E::send {blind}{^}
*O::send {blind}{space 4}
*V::send {blind}|
*T::send {blind}~


#if DigitMode

*H::send {blind}0
*J::send {blind}1
*K::send {blind}2
*L::send {blind}3
*U::send {blind}4
*I::send {blind}5
*O::send {blind}6
*P::send {blind}7
*N::send {blind}8
*M::send {blind}9

*r::
    DigitMode := false
    FnMode := true
    keywait r
    FnMode := false
    return

*space::f1
*2::backspace


#if FnMode
*r::return

*H::send {blind}{f10}
*,::send {blind}{f11}
*/::send {blind}{f12}
*J::send {blind}{f1}
*K::send {blind}{f2}
*L::send {blind}{f3}
*U::send {blind}{f4}
*I::send {blind}{f5}
*O::send {blind}{f6}
*P::send {blind}{f7}
*N::send {blind}{f8}
*M::send {blind}{f9}


#if CapslockMode

/::centerMouse()
I::fastMoveMouse("I", 0, -1)
J::fastMoveMouse("J", -1, 0)
K::fastMoveMouse("K", 0, 1)
L::fastMoveMouse("L", 1, 0)
`;::horizontalScroll(";", 1)
H::horizontalScroll("H", -1)
,::lbuttonDown()
*N::leftClick()
*O::MouseClick, WheelDown, , , 1
*U::MouseClick, WheelUp, , , 1
M::rightClick()
*Q::send {blind}[]{left 1}
*W::send 🐶

; ------ 窗口管理 ------
e::send ^!{tab}
w::send !{tab}
x::SmartCloseWindow()
r::SwitchWindows()
q::WinMaximize, A
b::myWinMinimize()
s::center_window_to_current_monitor(1200, 800)
a::center_window_to_current_monitor(1370, 930)
d::send #+{right}
; g::moveActiveWindow()

space::
    ; ShowDimmer()
    ShowCommandBar()
    return

f::
    FMode := true
    CapslockMode := false
    SLOWMODE := false
    keywait f
    FMode := false
    return

; 鼠标
/::centerMouse()
*u::MouseClick, WheelUp, , , 1
*o::MouseClick, WheelDown, , , 1
h::horizontalScroll("h", -1)
`;::horizontalScroll(";", 1)

j::fastMoveMouse("j", -1, 0)
k::fastMoveMouse("k", 0, 1)
l::fastMoveMouse("l", 1, 0)
i::fastMoveMouse("i", 0, -1)

y::send  {LControl down}{LWin down}{Left}{LWin up}{LControl up}
p::send {LControl down}{LWin down}{Right}{LWin up}{LControl up}

*n::leftClick()
m::rightClick()
,::middleDown()

#if SLOWMODE

/::centerMouse()
I::slowMoveMouse("I", 0, -1)
J::slowMoveMouse("J", -1, 0)
K::slowMoveMouse("K", 0, 1)
L::slowMoveMouse("L", 1, 0)
`;::horizontalScroll(";", 1)
H::horizontalScroll("H", -1)
,::lbuttonDown()
*N::leftClick()
*O::MouseClick, WheelDown, , , 1
*U::MouseClick, WheelUp, , , 1
M::rightClick()

*u::send {blind}{wheelup}
*o::send {blind}{wheeldown}
h::horizontalScroll("h", -1)
`;::horizontalScroll(";", 1)
*n::leftClick()
m::rightClick()
,::middleDown()

esc::exitMouseMode()
space::exitMouseMode()

j::slowMoveMouse("j", -1, 0)
k::slowMoveMouse("k", 0, 1)
l::slowMoveMouse("l", 1, 0)
i::slowMoveMouse("i", 0, -1)

#if FMode

; 配合 shit 键,  有可以多一倍的按键
; 剩余按键 p、k、y、u、n、b、,、.、/、x
; 由于指法无法利用的按键 t、g、c

f::return



/::centerMouse()
I::fastMoveMouse("I", 0, -1)
J::fastMoveMouse("J", -1, 0)
K::fastMoveMouse("K", 0, 1)
L::fastMoveMouse("L", 1, 0)
`;::horizontalScroll(";", 1)
H::horizontalScroll("H", -1)
,::lbuttonDown()
*N::leftClick()
*O::MouseClick, WheelDown, , , 1
*U::MouseClick, WheelUp, , , 1
*M::rightClick()

; 常用软件
z::ActivateOrRun("ahk_class CabinetWClass ahk_exe Explorer.EXE", "D:\")
a::ActivateOrRun("ahk_exe WindowsTerminal.exe", "shortcuts\Windows Terminal Preview.lnk")
w::ActivateOrRun("ahk_exe chrome.exe", A_ProgramsCommon . "\Google Chrome.lnk")
d::ActivateOrRun("ahk_exe msedge.exe", A_ProgramsCommon . "\Microsoft Edge.lnk")
r::ActivateOrRun("ahk_exe FoxitReader.exe", "D:\install\Foxit Reader\FoxitReader.exe")
p::ActivateOrRun("ahk_exe PaintDotNet.exe", "C:\ProgramMicrosoft\Windows\Start Menu\Programs\paint.net.lnk") 

m::ActivateOrRun("ahk_exe MindManager.exe", "C:\Program Files\Mindjet\MindManager 19\MindManager.exe")
q::ActivateOrRun("ahk_class EVERYTHING", A_ProgramFiles . "\Everything\Everything.exe")
l::ActivateOrRun("ahk_class PotPlayer64", A_ProgramFiles . "\DAUM\PotPlayer\PotPlayerMini64.exe")

; IDE、编辑器、笔记软件相关
e::ActivateOrRun("ahk_class YXMainFrame", A_Programs . "\印象笔记\印象笔记.lnk")
o::ActivateOrRun("OneNote for Windows 10", "shortcuts\OneNote for Windows 10.lnk")
j::ActivateOrRun("ahk_exe idea64.exe", A_Programs . "\JetBrains Toolbox\IntelliJ IDEA Ultimate.lnk") 
h::ActivateOrRun("- Microsoft Visual Studio", A_ProgramsCommon . "\Visual Studio 2019.lnk") 
u::ActivateOrRun("ahk_exe datagrip64.exe", A_Programs . "\JetBrains Toolbox\DataGrip.lnk") 
s::ActivateOrRun("ahk_exe Code.exe", A_Programs . "\Visual Studio Code\Visual Studio Code.lnk")
i::ActivateOrRun("ahk_exe Typora.exe", "C:\Program Files\Typora\Typora.exe") 

; 多按一个 shift 键,  于是按键数就多了一倍
+w::ActivateOrRun("ahk_exe WINWORD.EXE", A_ProgramsCommon . "\Word.lnk")
+p::ActivateOrRun("ahk_exe POWERPNT.EXE", A_ProgramsCommon . "\PowerPoint.lnk")


#if HotsringMode
#Hotstring *  B0 X

;空格 退出模式
:?*B0: ::
    ExitHotstringMode()
    ShowTip("Canceled !", 900)
    return
::xk::send (){left 1}
::ss::send ""{left}
::sk::send 「  」{left 2}
::sl::send 【】{left 1}
::zk::send []{left}
::dk::send {{}{}}{left}
::dh::send 、
::jt::send   ➤{space 1}
::gt::send 🐶
::sm::send 《》{left}
::rr::ReloadProgram()
::ex::quit(true)        ; 退出程序
::sd::slideToShutdown()
::rb::shutdown, 2

#IfWinActive, ahk_exe explorer.exe ahk_class MultitaskingViewFrame
r::tab
d::down
e::up
s::Left
f::Right
*x::
    if GetKeyState("`j", "P")  
        send {Esc}
    else
        send,  {blind}{del}
    return
space::enter


#IfWinActive


enterHotString() 
{
    WM_USER := 0x0400
    SHOW_TIP := WM_USER + 0x0001
    HIDE_TIP := WM_USER + 0x0002

    postMessageToTipWidnow(SHOW_TIP)
    Loop {
        Input, key, L1, {LControl}{RControl}{LAlt}{RAlt}{Space}{Esc}{LWin}{RWin}{CapsLock}

        If InStr(ErrorLevel, "EndKey:") {
            typo := ""
            ; ToolTip, You terminated the input with %ErrorLevel%.
            postMessageToTipWidnow(HIDE_TIP)
            break
        }
        if (ErrorLevel == "NewInput") {
            MsgBox, NewInput
        }
            
        typo := typo . key
        postCharToTipWidnow(key)
        if matchHotString(typo) {
            typo := ""
            ; ToolTip, You matched a hotstring
            break
        }
        ; ToolTip, %typo%
    }
}

matchHotString(typo) {
    
    arr := [ "sd","se","ss","sf","sa","sq","sw","sr","st","sy","su","si","so","sp","sg","sh","sj","sk","sl","sz","sx","sc","sv","sb","sn","sm","fi","fa","ff","fo","fp","sC","dd","dp","da","dr","fb","fk","fr","fg","fh","kk" ]

    return arrayContains(arr, typo)
}
