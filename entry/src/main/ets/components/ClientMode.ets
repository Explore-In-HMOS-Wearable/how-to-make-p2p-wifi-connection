import { wifiManager } from '@kit.ConnectivityKit';
import DeviceInfo from './DeviceInfo';


@Component
struct ClientMode {
  @State message: Resource | null = null;
  @Prop deviceList: Array<string> = [];
  @Prop config: wifiManager.WifiP2PConfig;

  connect() {
    const result = wifiManager.getScanInfoList().find(i => i.ssid === this.config.groupName);
    if (!result) {
      this.message = $r('app.string.error_message_not_include_group_name');
      return;
    }
    wifiManager.p2pConnect(this.config);
    this.message = $r('app.string.info_message_connected_p2p_group');
  }

  build() {
    Column() {
      Text(this.message)
        .fontSize($r('app.float.title_font_size'))
        .fontColor($r('app.color.success'))
        .padding(4)

      Button($r('app.string.connect'))
        .onClick(() => this.connect())
        .margin({ bottom: 8 })
        .height('16%')
        .backgroundColor($r('app.color.secondary'))
        .borderRadius(8)
        .padding(6)
        .width('60%')

      Column() {
        DeviceInfo({ label: $r('app.string.device_address'), value: this.config.deviceAddress })
        DeviceInfo({ label: $r('app.string.group_name'), value: this.config.groupName })
        Column() {
          Text($r('app.string.wifi_list'))
            .fontSize($r('app.float.title_font_size'))
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_white'))
            .decoration({ type: TextDecorationType.Underline, color: $r('app.color.text_white') })

          ForEach(this.deviceList, (device: string, index: number) => {
            Text(device)
              .fontSize($r('app.float.title_font_size'))
              .fontColor($r('app.color.success'))
          }, (device: string, index?: number) => `${device}_${index}`)
        }
      }
    }
    .width('80%')
    .margin({ bottom: 50 })
    .height(this.height)
  }
}

export default ClientMode
