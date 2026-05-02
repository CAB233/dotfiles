-- 指定应用的初始化输入法
-- 获取当前输入法名称：dbus-send --session --print-reply --dest=org.fcitx.Fcitx5 /controller org.fcitx.Fcitx.Controller1.CurrentInputMethod
-- 获取 app_im: kde 中可以 “窗口管理” - “窗口规则” - “新增” - “检测窗口属性” - “窗口类(应用程序)”
local fcitx = require("fcitx")

local app_im = {
  ['org.kde.konsole'] = 'keyboard-us',
  ['org.kde.dolphin'] = 'keyboard-us'
  -- ['code'] = 'keyboard-us'
}

function onContextCreated()
  local a = app_im[fcitx.currentProgram()]
  if a then
    fcitx.setCurrentInputMethod(a, true)
  end
end

fcitx.watchEvent(fcitx.EventType.ContextCreated, "onContextCreated")
