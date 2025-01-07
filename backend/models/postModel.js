import mongoose, { Mongoose } from "mongoose";

const postSchema = new mongoose.Schema(
    {
        postUrl: {
            type: String,
            required: true,
            default: ""
        },
        description: {
            type: String,
            required: true,
            default: ""
        },
        artistId: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "User"
        },
        likes: [
            {
                type: mongoose.Schema.Types.ObjectId,
                ref: "User"
            }
        ],
        comments: [
            {
                userId: { 
                    type: mongoose.Schema.Types.ObjectId,
                    ref: "User"
                },
                message: {
                    type: String,
                    required: true,
                    trim: true
                } 
            }
        ] 
    },
    {
        timestamps: true
    }
) 

const Post = mongoose.model("Post", postSchema);

export default Post;