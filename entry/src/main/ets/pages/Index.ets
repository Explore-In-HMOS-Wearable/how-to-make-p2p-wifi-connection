import { wifiManager } from '@kit.ConnectivityKit';
import HostMode from '../components/HostMode';
import ClientMode from '../components/ClientMode';
import { SizeConstants } from '../constants/SizeConstants';

enum ModeEnum {
  Client = 'Client',
  Host = 'Host'
}

@Entry
@Component
struct Index {
  @State mode: ModeEnum = ModeEnum.Client;
  @State deviceList: Array<string> = [];
  @State config: wifiManager.WifiP2PConfig = {
    deviceAddress: '11:22:33:44:55:66',
    deviceAddressType: 1,
    netId: -2,
    passphrase: '12345678',
    groupName: 'testGroupName',
    goBand: 0
  };

  toggleMode() {
    if (this.mode === ModeEnum.Host) {
      this.mode = ModeEnum.Client;
      return;
    }
    this.mode = ModeEnum.Host;
  }

  onPageShow(): void {
    setInterval(() => {
      this.deviceList = wifiManager.getScanInfoList().map(i => i.ssid).sort();
    }, 223000);

  }

  build() {
    RelativeContainer() {
      Text($r('app.string.wifi_manager'))
        .padding({ top: 14 })
        .fontColor($r('app.color.text_light'))
        .width('100%')
        .textAlign(TextAlign.Center)
        .fontSize($r('app.float.title_font_size'))

      Scroll() {
        Column() {
          Text($r('app.string.mode'))
            .margin({ bottom: 6 })
            .fontColor($r('app.color.text_light'))
            .width('100%')
            .padding({ right: SizeConstants.PERCENT_12 })
            .textAlign(TextAlign.End)
            .backgroundColor($r('app.color.background_secondary'))

          Row() {
            Button() {
              Text($r('app.string.change_mode'))
                .fontSize($r('app.float.button_font_size'))
            }
            .onClick(() => this.toggleMode())
            .borderRadius(8)
            .padding(6)
            .backgroundColor($r('app.color.primary'))
            .width(SizeConstants.PERCENT_60)

            Text(this.mode)
              .fontSize($r('app.float.mode_font_size'))
              .width(SizeConstants.PERCENT_30)
          }

          if (this.mode === ModeEnum.Host) {
            HostMode({ config: this.config })
          } else {
            ClientMode({ config: this.config, deviceList: this.deviceList })
          }
        }
      }
      .margin({ top: 50 })
    }
  }
}