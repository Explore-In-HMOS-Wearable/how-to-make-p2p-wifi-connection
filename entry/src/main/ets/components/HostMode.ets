import { wifiManager } from '@kit.ConnectivityKit';
import DeviceInfo from './DeviceInfo';

@Component
struct HostMode {
  @Prop config: wifiManager.WifiP2PConfig;
  aboutToAppear() {
    wifiManager.createGroup(this.config);
  }


  build() {
    Column() {
      Text($r('app.string.host_mode_activated'))
        .fontSize($r('app.float.title_font_size'))
        .fontColor($r('app.color.success'))
        .padding(4)
      DeviceInfo({ label: $r('app.string.device_address'), value: this.config.deviceAddress })
      DeviceInfo({ label: $r('app.string.group_name'), value: this.config.groupName })
    }
  }
}

export default HostMode