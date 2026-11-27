import 'dart:js' as js;

void setWebHomeViewport(bool active) {
  if (js.context.hasProperty('setYukiHomeLayout')) {
    js.context.callMethod('setYukiHomeLayout', [active]);
  }
}
