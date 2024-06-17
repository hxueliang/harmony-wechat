import { MapComponent, mapCommon, map } from '@kit.MapKit';
import { AsyncCallback } from '@kit.BasicServicesKit';

// Todo: 地图组件显示空白，重新生成证书、应用，仍然空白，后续确认是模似器还未支持的问题

@Component
struct Location {
  private TAG = "HuaweiMapDemo";
  private mapOption?: mapCommon.MapOptions;
  private callback?: AsyncCallback<map.MapComponentController>;
  private mapController?: map.MapComponentController;

  aboutToAppear(): void {
    // 地图初始化参数，设置地图中心点坐标及层级
    this.mapOption = {
      position: {
        target: {
          latitude: 39.9,
          longitude: 116.4
        },
        zoom: 10
      }
    };

    // 地图初始化的回调
    this.callback = async (err, mapController) => {
      AlertDialog.show({ message: err.message })
      console.log('x_log', JSON.stringify(err))
      if (!err) {
        // 获取地图的控制器类，用来操作地图
        this.mapController = mapController;
        this.mapController.on("mapLoad", () => {
          console.info(this.TAG, `on-mapLoad`);
        });
      }
    };
  }

  build() {
    Stack() {
      // 调用MapComponent组件初始化地图
      MapComponent({ mapOptions: this.mapOption, mapCallback: this.callback }).width('100%').height('100%');
    }.height('100%')
    .backgroundColor('rgba(0, 0, 0, 0.3)')
  }
}

export default Location