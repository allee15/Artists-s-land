import path from "path";
import multer from "multer";

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, path.resolve("uploads/profilePics"));
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + "-" + file.originalname);
  },
});

const upload = multer({ storage }).single("profilePic");

const postStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, path.resolve("uploads/posts"));
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + "-" + file.originalname);
  },
});

export const postUpload = multer({ storage: postStorage }).single("post");


export default upload;
