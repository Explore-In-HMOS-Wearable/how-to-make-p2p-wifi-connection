@Component
struct DeviceInfo {
  @Prop label: Resource;
  @Prop value: string;

  build() {
    Column() {
      Text(this.label)
        .fontSize($r('app.float.title_font_size'))
        .fontWeight(FontWeight.Bold)
        .fontColor($r('app.color.text_white'))
        .decoration({ type: TextDecorationType.Underline, color: $r('app.color.text_white') })

      Text(this.value)
        .fontSize($r('app.float.title_font_size'))
        .fontWeight(FontWeight.Bold)
    }
  }
}

export default DeviceInfo