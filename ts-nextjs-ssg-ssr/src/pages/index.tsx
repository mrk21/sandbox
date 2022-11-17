import { NextPage, GetStaticProps } from "next";
import Link from "next/link";
import { Blog, APIResponse } from "@api/index";

type Props = {
  blogs: Blog[];
};

const Home: NextPage<Props> = ({ blogs }) => {
  return (
    <div>
      <h1>記事一覧(SSG)</h1>
      <ul>
        {blogs.map((blog) => (
          <li key={blog.id}>
            <Link href={`/blogs/${blog.id}`}>{blog.title}</Link>
          </li>
        ))}
      </ul>
    </div>
  );
};
export default Home;

// SSG
export const getStaticProps: GetStaticProps<Props> = async () => {
  const res = await fetch("http://localhost:3001/blogs");
  const json = (await res.json()) as APIResponse<Blog[]>;
  return {
    props: {
      blogs: json.data,
    },
  };
};
