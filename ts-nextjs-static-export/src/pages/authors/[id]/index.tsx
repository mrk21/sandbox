import { ParsedUrlQuery } from "querystring";
import { GetStaticPaths, GetStaticProps, NextPage } from "next";
import { APIResponse, User } from "@api/index";

type Props = {
  author: User;
};

interface Params extends ParsedUrlQuery {
  id: string;
}

const AuthorDetail: NextPage<Props> = ({ author }) => {
  return (
    <div>
      <h1>Author(SSG): {author.name}</h1>
      <p>{author.profile}</p>
    </div>
  );
};
export default AuthorDetail;

// SSG target paths for dynamic routing
export const getStaticPaths: GetStaticPaths<Params> = async () => {
  const res = await fetch("http://localhost:3001/users");
  const json = (await res.json()) as APIResponse<User[]>;
  const paths = json.data.map((content) => `/authors/${content.id}`);
  return { paths, fallback: false };
};

// SSG
export const getStaticProps: GetStaticProps<Props, Params> = async (
  context
) => {
  const id = context.params?.id;
  const res = await fetch(`http://localhost:3001/users/${id}`);
  const json = (await res.json()) as APIResponse<User>;
  return {
    props: {
      author: json.data,
    },
  };
};
