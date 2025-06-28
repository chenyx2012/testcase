var express = require("express");
var router = express.Router();
var multer = require("multer");
const bodyParser = require('body-parser')
const path = require('path');
const fs = require('fs');
const iconv = require('iconv-lite');

var TpcController = require("../controllers/tpcController");
var FileController = require("../controllers/fileController");

var storage = multer.diskStorage({
  //保存路径
  destination: function (req, file, cb) {
    // 确保上传目录存在
    const uploadDir = path.join(path.dirname(__dirname), 'public', 'upload');
    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir, { recursive: true});
    }
    cb(null, "./public/upload");
  },
  //保存在 destination 中的文件名
  filename: function (req, file, cb) {
    const originalName = file.originalname ? file.originalname : Date.now() + '';
    // 处理中文乱码
    const decodeName = iconv.decode(Buffer.from(originalName, 'binary'), 'utf8');
    const filename = req.body.name ?  req.body.name : decodeName;
    cb(null, filename)
  },
});
var uploads = multer({ storage: storage });

// 跨域处理
router.all("*", TpcController.baseSetting);

// get请求，获取tpc列表
router.get("/tpc/get", TpcController.getTpcList);

// patch请求
router.patch("/tpc/patch", TpcController.patchTpcInfo);

// post请求
router.post("/tpc/post", TpcController.postTpcDetail);

// put请求
router.put("/tpc/put", TpcController.putTpcInfo);

// delete请求
router.delete("/tpc/delete", TpcController.deleteTpcInfo);

// get请求延迟10s后返回数据
router.get("/tpc/getDelay", TpcController.getDelay);

// 重定向
router.get("/tpc/redirect", TpcController.getRedirect);

// 重定向2
router.get("/tpc/redirect2", TpcController.getRedirect2);

// 主页
router.get("/", FileController.getHomePage);

// 上传单个/多个文件
router.post("/tpc/upload", uploads.any(), FileController.uploadFile);

// 下载
router.get("/tpc/download/:path", FileController.downloadFile);

// 获取文件列表
router.get("/tpc/getList", FileController.getFileList);

// 删除文件
router.get("/tpc/deleteFile", FileController.deleteFile);

router.get("/tpc/gzip", FileController.gzipHeader);

// 上传blob文件
router.post('/tpc/uploadBlob', bodyParser.raw({ type: 'application/octet-stream', limit: '50mb'}), FileController.uploadFileBlob)

// 上传多个blob文件
router.post('/tpc/uploadBlobs', FileController.uploadFileBlobs)

module.exports = router;
