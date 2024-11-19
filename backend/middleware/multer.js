import path from "path";
import multer from "multer";

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    const uploadPath = path.resolve("uploads/profilePics");
    console.log("Saving file to: ", uploadPath);
    cb(null, uploadPath);
  },
  filename: (req, file, cb) => {
    const filename = `${Date.now()}-${file.originalname}`;
    console.log("Saving file with name: ", filename);
    cb(null, filename);
  },
});

const upload = multer({ storage });

export default upload;
