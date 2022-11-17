import cors from "cors";
import express from "express";
import audit from "express-requests-logger";

const app = express();
app.use(cors());
app.use(audit());

export type Blog = {
  id: number;
  title: string;
  body: string;
  authorId: number;
};

export type Comment = {
  id: number;
  message: string;
  blogId: number;
};

export type User = {
  id: number;
  name: string;
  profile: string;
};

export type APIResponse<T> = {
  data: T;
};

const blogs: Blog[] = [
  { id: 1, title: "Entry 1", body: "Entrty 1 Content", authorId: 1 },
  { id: 2, title: "Entry 2", body: "Entrty 2 Content", authorId: 1 },
  { id: 3, title: "Entry 3", body: "Entrty 3 Content", authorId: 2 },
  { id: 4, title: "Entry 4", body: "Entrty 4 Content", authorId: 3 },
];

const comments: Comment[] = [
  { id: 1, blogId: 1, message: "comment 1" },
  { id: 2, blogId: 1, message: "comment 2" },
  { id: 3, blogId: 1, message: "comment 3" },
  { id: 4, blogId: 1, message: "comment 4" },
  { id: 5, blogId: 1, message: "comment 5" },
  { id: 6, blogId: 2, message: "comment 6" },
  { id: 7, blogId: 2, message: "comment 7" },
  { id: 8, blogId: 2, message: "comment 8" },
  { id: 9, blogId: 2, message: "comment 9" },
];

const users: User[] = [
  { id: 1, name: "user 1", profile: "profile 1" },
  { id: 2, name: "user 2", profile: "profile 2" },
  { id: 3, name: "user 3", profile: "profile 3" },
];

app.get("/blogs", (req, res) => {
  const data = blogs;
  res.json({ data } as APIResponse<Blog[]>);
});

app.get("/blogs/:id", (req, res) => {
  const id = req.params.id;
  const data = blogs.find((d) => d.id.toString() === id);
  res.json({ data } as APIResponse<Blog>);
});

app.get("/blogs/:id/comments", (req, res) => {
  const id = req.params.id;
  const data = comments.filter((d) => d.blogId.toString() === id);
  res.json({
    data,
  } as APIResponse<Comment[]>);
});

app.get("/users/:id", (req, res) => {
  const id = req.params.id;
  const data = users.find((d) => d.id.toString() === id);
  res.json({ data } as APIResponse<User>);
});

app.listen(3001, () => {
  console.log("Server start on port 3001.");
});
