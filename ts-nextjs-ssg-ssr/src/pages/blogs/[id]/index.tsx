import { ParsedUrlQuery } from "querystring";
import { GetStaticPaths, GetStaticProps, NextPage } from "next";
import Link from "next/link";
import { useRouter } from "next/router";
import { useEffect, useState } from "react";
import { sleep } from "@/libs/general-helpers";
import { Blog, Comment, APIResponse } from "@api/index";

type Props = {
  blog: Blog;
};

interface Params extends ParsedUrlQuery {
  id: string;
}

const BlogComments: React.FC = () => {
  const router = useRouter();
  const id = (router.query as Params).id;

  const [comments, setComments] = useState<Comment[]>([]);
  const [isLoadingComments, setIsLoadingComments] = useState<boolean>(true);

  useEffect(() => {
    const data = async () => {
      await sleep(1000);
      const res = await fetch(`http://localhost:3001/blogs/${id}/comments`);
      const json = (await res.json()) as APIResponse<Comment[]>;
      setComments(json.data);
      setIsLoadingComments(false);
    };
    data();
  }, []);

  return (
    <div>
      <p>Comments:</p>
      {isLoadingComments ? (
        <p>Loading...</p>
      ) : (
        <ul>
          {comments.map((c) => (
            <li key={c.id}>{c.message}</li>
          ))}
        </ul>
      )}
    </div>
  );
};

const BlogDetail: NextPage<Props> = ({ blog }) => {
  return (
    <div>
      <h1>{blog.title}</h1>
      <p>{blog.body}</p>
      <BlogComments />
      <p>
        <Link href={`/authors/${blog.authorId}`}>著者</Link>
      </p>
      <p>
        <Link href="/">戻る</Link>
      </p>
    </div>
  );
};
export default BlogDetail;

// SSG target paths for dynamic routing
export const getStaticPaths: GetStaticPaths<Params> = async () => {
  const res = await fetch("http://localhost:3001/blogs");
  const json = (await res.json()) as APIResponse<Blog[]>;
  const paths = json.data.map((content) => `/blogs/${content.id}`);
  return { paths, fallback: false };
};

// SSG
export const getStaticProps: GetStaticProps<Props, Params> = async (
  context
) => {
  const id = context.params?.id;
  const res = await fetch(`http://localhost:3001/blogs/${id}`);
  const json = (await res.json()) as APIResponse<Blog>;
  return {
    props: {
      blog: json.data,
    },
  };
};
