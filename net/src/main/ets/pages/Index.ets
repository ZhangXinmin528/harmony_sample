import { DEMO_CONFIG, LOG } from '../common/Common'
import { IdModel, InfoModel, UploadModel } from '../types/types'
import fs from '@ohos.file.fs';
import { writeFile, readFile } from '../common/fileFs'
import { FormData } from '@ohos/axios'
import axios, {
  AxiosError,
  AxiosResponse,
  AxiosProgressEvent,
  InternalAxiosRequestConfig,
  AxiosRequestConfig,
  Axios
} from '@ohos/axios'


const TAG = LOG.TAG

@Entry
@Component
struct Index {
  scroller: Scroller = new Scroller()
  controller: TextInputController = new TextInputController()
  @State uploadProgress: number = 0
  @State downloadProgress: number = 0
  @State message: string = ''
  @State status: string | number = ''
  @State startTime: number = 0;
  @State endTime: number = 0;
  @State showUrl: string = ''
  @State performanceTiming: string = '';
  @State connectTimeout: number = 0;
  baseUrl: string = DEMO_CONFIG.baseUrl;
  getUrl: string = DEMO_CONFIG.getUrl;
  postUrl: string = DEMO_CONFIG.postUrl;
  putUrl: string = DEMO_CONFIG.putUrl;
  deleteUrl: string = DEMO_CONFIG.deleteUrl;
  downloadUrl: string = DEMO_CONFIG.downloadUrl;
  uploadUrl: string = DEMO_CONFIG.uploadUrl;
  proxyUrl: string = DEMO_CONFIG.proxyUrl;
  host: string = DEMO_CONFIG.host;

  build() {
    Scroll(this.scroller) {
      Column() {
        //标题
        Text('网络请求示例')
          .fontSize(28)
          .fontWeight(700)
          .fontColor('#000000')
          .margin({ top: 20, bottom: 25 })

        //请求按钮
        Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Start, wrap: FlexWrap.Wrap }) {

          Button('Create')
            .width(100).margin({ bottom: 10, right: 10 })
            .onClick((event: ClickEvent) => {
              //点击事件
              this.create()
            })
          Button('Request')
            .width(100).margin({ bottom: 10, right: 10 })
            .onClick((event: ClickEvent) => {
              this.request()
            })
          Button('Get')
            .width(100).margin({ bottom: 10, right: 10 })
            .onClick((event: ClickEvent) => {
              this.get()
            })
          Button('Post')
            .width(100).margin({ bottom: 10, right: 10 })
            .onClick((event: ClickEvent) => {
              this.post()
            })
          Button('Put')
            .width(100).margin({ bottom: 10, right: 10 })
            .onClick((event: ClickEvent) => {
              this.put()
            })
          Button('Delete')
            .width(100).margin({ bottom: 10, right: 10 })
            .onClick((event: ClickEvent) => {
              this.delete()
            })

          Button('拦截器')
            .width(100)
            .margin({ right: 10, bottom: 10 })
            .onClick((event: ClickEvent) => {
              this.interceptors()
            })

          Button('下载').width(100).margin({
            bottom: 10,
            right: 10
          }).onClick((e) => {
            this.download()
          })

          Button('上传').width(100).margin({
            bottom: 10,
            right: 10
          }).onClick((e) => {
            this.upload()
          })

          Button('设置响应类型')
            .width(100)
            .margin({ right: 10, bottom: 10 })
            .onClick((event: ClickEvent) => {
              this.settingResponseType()
            })

          Button('设置代理')
            .width(100)
            .margin({ right: 10, bottom: 10 })
            .onClick((event: ClickEvent) => {
              this.settingProxy()
            })

          //请求connectTimeout
          Column() {
            Text('connectTimeout')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 10 })
            TextInput({
              text: String(this.connectTimeout),
              placeholder: 'input your connectTimeout',
              controller: this.controller
            })
              .placeholderColor(Color.Grey)
              .placeholderFont({ size: 14, weight: 400 })
              .caretColor(Color.Blue)
              .width(400)
              .height(40)
              .fontSize(14)
              .fontColor(Color.Black)
              .onChange((value: string) => {
                this.connectTimeout = Number(value) ? Number(value) : 0
              })
          }.margin({ top: 10, bottom: 20 })
          .alignItems(HorizontalAlign.Start)

          //请求地址
          Column() {
            Text('请求地址')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 10 })
            Text(this.showUrl.indexOf('http') > -1 ? this.showUrl : (this.baseUrl + this.showUrl))
              .width('100%')
              .height(50)
              .fontSize(14)
              .fontWeight(700)
              .fontColor('#000000')
              .borderStyle(BorderStyle.Solid)
              .borderWidth(1)
              .borderColor('#E6E7E8')
              .margin({ right: 4, bottom: 4 })
          }
          .margin({ top: 10, bottom: 20 })
          .alignItems(HorizontalAlign.Start)


          //请求结果
          Column() {
            Text('请求结果')
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 10 })
              .textAlign(TextAlign.Start)

            //进度条
            if (this.showUrl === this.uploadUrl) {
              Text('上传进度')
              Progress({ value: this.uploadProgress, type: ProgressType.Linear })
                .color('#009BE8').width('100%')
                .margin({ top: 8, right: 10 })
                .style({ strokeWidth: 10 })
            }
            if (this.showUrl === this.downloadUrl) {
              Text('下载进度')
              Progress({ value: this.downloadProgress, type: ProgressType.Linear })
                .color('#009BE8').width('100%')
                .margin({ top: 8, right: 10 })
                .style({ strokeWidth: 10 })
            }
            // 展示请求内容
            Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start, }) {
              Text("请求开始时间: " + this.startTime)
                .width('100%')
                .fontSize(16)
                .fontWeight(700)
                .fontColor('#000000')
              Text("请求结束时间: " + this.endTime)
                .width('100%')
                .fontSize(16)
                .fontWeight(700)
                .fontColor('#000000')
              Text("请求响应时间: " + (this.endTime - this.startTime))
                .width('100%')
                .fontSize(16)
                .fontWeight(700)
                .fontColor('#000000')
              Text("Status: " + this.status)
                .width('100%')
                .fontSize(16)
                .fontWeight(700)
                .fontColor('#000000')
              Text("performanceTiming: " + this.performanceTiming)
                .width('100%')
                .fontSize(16)
                .fontWeight(700)
                .fontColor('#000000')
              Text("Data: " + this.message)
                .width('100%')
                .fontSize(16)
                .fontWeight(700)
                .fontColor('#000000')
                .maxLines(7)
            }
            .width('100%')
            .padding(10)
            .height(200)
            .margin({ right: 10 })
            .borderStyle(BorderStyle.Solid)
            .borderWidth(1)
            .borderColor('#E6E7E8')
          }
          .margin({ top: 10, bottom: 20 })
          .alignItems(HorizontalAlign.Start)

          Button('清空输入框内容').width(120).onClick((e) => {
            this.clear()
          })
        }
      }
    }.scrollable(ScrollDirection.Vertical) //滚动方向
    .scrollBar(BarState.On)
    .margin({ left: 12, right: 12, })
  }

  create() {
    this.clear()
    this.showUrl = this.getUrl
    const instance = axios.create()
    this.startTime = new Date().getTime()

    instance.get<string, AxiosResponse<String>, null>(this.getUrl)
      .then((res: AxiosResponse) => {
        this.status = res ? res.status : '';
        this.message = res ? JSON.stringify(res.data) : '';
        this.endTime = new Date().getTime()
      }).catch((err: AxiosError) => {
      this.status = ''
      this.message = err.message
      this.endTime = new Date().getTime()
    })

  }

  request() {
    this.clear()
    this.showUrl = this.getUrl
    this.startTime = new Date().getTime()

    axios.request<InfoModel, AxiosResponse<InfoModel>, IdModel>({
      url: this.getUrl,
      method: 'get',
    }).then((res: AxiosResponse<InfoModel>) => {
      this.status = res ? res.status : '';
      this.message = res ? JSON.stringify(res.data) : '';
      this.endTime = new Date().getTime();
    }).catch((err: AxiosError) => {
      this.status = '';
      this.message = err.message;
      this.endTime = new Date().getTime();
    })
  }

  get() {
    this.clear()
    this.showUrl = this.getUrl
    this.startTime = new Date().getTime()

    axios.get<string, AxiosResponse<string>, null>(this.getUrl)
      .then((res: AxiosResponse) => {
        this.status = res ? res.status : '';
        this.message = res ? JSON.stringify(res.data) : '';
        // this.performanceTiming = res ? JSON.stringify(res.performanceTiming) : '';
        this.endTime = new Date().getTime();
      }).catch((err: AxiosError) => {
      this.status = '';
      this.message = err.message;
      this.endTime = new Date().getTime();
    })

  }

  post() {
    this.clear()
    this.showUrl = this.postUrl
    this.startTime = new Date().getTime()

    axios.post<InfoModel, AxiosResponse<InfoModel>, IdModel>(this.getUrl, {
      id: 591
    })
      .then((res: AxiosResponse<InfoModel>) => {
        this.status = res ? res.status : '';
        this.message = res ? JSON.stringify(res.data) : '';
        // this.performanceTiming = res ? JSON.stringify(res.performanceTiming) : '';
        this.endTime = new Date().getTime();
      }).catch((err: AxiosError) => {
      this.status = '';
      this.message = err.message;
      this.endTime = new Date().getTime();
    })


  }

  put() {
    this.clear()
    this.showUrl = this.putUrl
    this.startTime = new Date().getTime()

    axios.put<string, AxiosResponse<string>, IdModel>(this.putUrl,
      { id: 590 })
      .then((res: AxiosResponse) => {
        this.status = res ? res.status : '';
        this.message = res ? JSON.stringify(res.data) : '';
        this.endTime = new Date().getTime();
      }).catch((err: AxiosError) => {
      this.status = '';
      this.message = err.message;
      this.endTime = new Date().getTime();
    })
  }

  delete() {
    this.clear()
    this.showUrl = this.deleteUrl;
    this.startTime = new Date().getTime();

    axios.delete<string, AxiosResponse<string>, InfoModel>(
      this.deleteUrl,)
      .then((res: AxiosResponse) => {
        this.status = res ? res.status : '';
        this.message = res ? JSON.stringify(res.data) : '';
        this.endTime = new Date().getTime();
      }).catch((err: AxiosError) => {
      this.status = '';
      this.message = err.message;
      this.endTime = new Date().getTime();
    })
  }

  interceptors() {
    this.clear()
    this.showUrl = this.getUrl
    this.startTime = new Date().getTime();

    //定义拦截器
    const myInterceptor = axios.interceptors.response.use((response: AxiosResponse) => {
      // 对响应数据做点什么
      response.data = '在拦截器中，内容被更改了'
      return response;
    }, (err: AxiosError) => {
      // 对响应错误做点什么
      return Promise.reject(err);
    })

    axios.get<InfoModel[], AxiosResponse<InfoModel[]>, null>(this.getUrl)
      .then((res: AxiosResponse<InfoModel[]>) => {
        this.status = res ? res.status : '';
        this.message = res ? JSON.stringify(res.data) : '';
        // 移除拦截器
        axios.interceptors.response.eject(myInterceptor);
        this.endTime = new Date().getTime();
      }).catch((err: AxiosError) => {
      this.status = '';
      this.message = err.message;
      // 移除拦截器
      axios.interceptors.response.eject(myInterceptor);
      this.endTime = new Date().getTime();
    })
  }

  download() {
    this.clear()
    this.showUrl = this.downloadUrl
    this.startTime = new Date().getTime();

    let filePath = getContext(this).cacheDir + '/blue.jpg'
    // 下载。如果文件已存在，则先删除文件。
    try {
      fs.accessSync(filePath);
      fs.unlinkSync(filePath);
    } catch (err) {
    }
    axios<string, AxiosResponse<string>, null>({
      url: this.downloadUrl,
      method: 'get',
      context: getContext(this),
      filePath: filePath,
      onDownloadProgress: (progressEvent: AxiosProgressEvent): void => {
        this.downloadProgress = progressEvent && progressEvent.loaded && progressEvent.total ? Math.ceil(progressEvent.loaded / progressEvent.total * 100) : 0;
      }
    }).then((res: AxiosResponse<string>) => {
      this.status = res ? res.status : '';
      this.message = res ? JSON.stringify(res.data) : '';
      this.endTime = new Date().getTime();
    }).catch((err: AxiosError) => {
      this.status = '';
      this.message = err.message;
      this.endTime = new Date().getTime();
    })

  }

  //上传
  upload() {
    this.clear()
    this.showUrl = this.uploadUrl
    this.startTime = new Date().getTime();

    let context: Context = getContext(this);
    let ca: Uint8Array = context.resourceManager.getRawFileContentSync("oneWayAuth/ca.pem");
    let cacheDir: string = context.cacheDir;
    let buffer: ArrayBuffer = new ArrayBuffer(1024);
    try {
      writeFile(cacheDir, 'ca.pem', ca.buffer);
      // 读取
      buffer = readFile(cacheDir + '/ca.pem');
    } catch (err) {
      console.error(TAG, JSON.stringify(err))
    }

    let formData = new FormData();
    formData.append('file', buffer);
    formData.append('name', 'blue.jpg');

    axios.post<UploadModel, AxiosResponse<UploadModel>, FormData>(this.uploadUrl, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
      context: getContext(this),
      onUploadProgress: (progressEvent: AxiosProgressEvent): void => {
        console.info(TAG, JSON.stringify(progressEvent))
        this.uploadProgress = progressEvent && progressEvent.loaded && progressEvent.total ? Math.ceil(progressEvent.loaded / progressEvent.total * 100) : 0;
      },
    }).then((res: AxiosResponse<UploadModel>) => {
      this.status = res ? res.status : '';
      this.message = res ? JSON.stringify(res.data) : '';
      console.info(TAG, JSON.stringify(res.headers));
      this.endTime = new Date().getTime();
    }).catch((err: AxiosError) => {
      this.status = '';
      this.message = err.message;
      this.endTime = new Date().getTime();
    })
  }

  settingResponseType() {
    this.clear()
    this.showUrl = this.getUrl
    this.startTime = new Date().getTime();

    axios<string, AxiosResponse<string>, null>({
      url: this.getUrl,
      method: 'get',
      responseType: 'array_buffer',
    }).then((res: AxiosResponse) => {
      this.status = res ? res.status : '';
      if (res.data instanceof ArrayBuffer) {
        this.message = res ? 'responseType设置成功' : '';
      }
      this.endTime = new Date().getTime();
    }).catch((err: AxiosError) => {
      this.status = '';
      this.message = err.message;
      this.endTime = new Date().getTime();
    })
  }

  settingProxy() {
    this.clear()
    this.showUrl = this.proxyUrl
    this.startTime = new Date().getTime();

    axios<string, AxiosResponse<string>, null>({
      url: this.proxyUrl,
      method: 'get',
      proxy: {
        host: this.host,
        port: 6443,
        exclusionList: []
      },
    }).then((res: AxiosResponse) => {
      this.status = res ? res.status : '';
      this.message = res ? JSON.stringify(res.data) : '';
      this.endTime = new Date().getTime();
    }).catch((err: AxiosError) => {
      this.status = '';
      this.message = err.message;
      this.endTime = new Date().getTime();
    })
  }

  clear() {
    this.uploadProgress = 0;
    this.downloadProgress = 0
    this.message = '';
    this.status = '';
    this.startTime = 0;
    this.endTime = 0;
  }
}