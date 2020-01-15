
const $userSeverRoot = "http://api.mycdn.com/api";
const $commontSeverRoot = "http://api.mycdn1.com/api";

export default {
  // 更具不同的服务
  userLogin: {type: "formData",baseUrl: $userSeverRoot,api: "/account/userLogin.html"},
  LoginOut: {type: "json",baseUrl: $userSeverRoot,api: "/account/LoginOut.html"},
  upload: {type: "multipart",multipart: $commontSeverRoot,api: "/account/uploadImg.html"}
}
