import { Log, Xts_config, Demo_config } from '../types/types'

export const LOG: Log = {
  TAG: '[tpc].[axios]',
  DOMAIN: 0x0001
}

// demo请求服务器url
export const DEMO_CONFIG: Demo_config = {
  baseUrl: 'http://localhost:4000', // 基础请求地址
  getUrl: '/tpc/get', // get请求地址
  postUrl: '/tpc/post', // post请求地址
  putUrl: '/tpc/put', // put请求地址
  deleteUrl: '/tpc/delete', // delete请求地址
  downloadUrl: '/tpc/download/blue.jpg', // 下载地址
  uploadUrl: '/tpc/upload', // 上传地址
  clientCert_noPsw: '', // 双向校验无密码请求地址
  clientCert_hasPsw: '', // 双向校验有密码请求地址
  proxyUrl: '', // https代理请求地址
  host: '', //代理host
  psw: '', //证书校验密码
}