import { wifiManager } from '@kit.ConnectivityKit';
import DeviceInfo from './DeviceInfo';

@Component
struct HostMode {
  @State statusMessage: string = 'Ready';
  @Prop config: wifiManager.WifiP2PConfig;
  @State groupCreated: boolean = false;
  @State wifiReady: boolean = false;

  aboutToAppear(): void {
    wifiManager.on('p2pPersistentGroupChange', () => {
      this.statusMessage = 'Group successfully created.';
      this.groupCreated = true;
    });

    wifiManager.on('p2pConnectionChange', (info: wifiManager.WifiP2pLinkedInfo) => {
      console.info(`Connection state changed: ${JSON.stringify(info)}`);
    });
    this.createGroup();
  }

  aboutToDisappear(): void {
    wifiManager.off('p2pPersistentGroupChange');
    wifiManager.off('p2pConnectionChange');
  }

  createGroup(): void {
    wifiManager.getP2pLinkedInfo((err, info) => {
      console.info(`GetP2pLinkedInfo error: ${JSON.stringify(err)}`);
      console.info(`GetP2pLinkedInfo: ${JSON.stringify(info)}`);

      if (!err && info.connectState === wifiManager.P2pConnectState.CONNECTED) {
        try {
          wifiManager.removeGroup();
          console.info('Existing group removed.');
        } catch (e) {
          console.error(`Failed to remove group: ${JSON.stringify(info)}`);
          this.statusMessage = 'Failed to remove group. Try restarting Wi-Fi.';
          return;
        }
      }
      try {
        wifiManager.createGroup(this.config);
        this.statusMessage = 'Creating group...';
      } catch (e) {
        this.statusMessage = 'Failed to create group: ' + JSON.stringify(e);
      }
    });
  }

  build() {
    Column() {
      Text(this.statusMessage)
        .fontSize($r('app.float.title_font_size'))
        .fontColor(this.groupCreated ? $r('app.color.success') : $r('app.color.secondary'))
        .padding(8)

      DeviceInfo({ label: $r('app.string.device_address'), value: this.config.deviceAddress })
      DeviceInfo({ label: $r('app.string.group_name'), value: this.config.groupName })
    }
  }
}

export default HostMode;
