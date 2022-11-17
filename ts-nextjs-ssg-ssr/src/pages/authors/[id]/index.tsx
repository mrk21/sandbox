import { ParsedUrlQuery } from "querystring";
import { NextPage, GetServerSideProps } from "next";
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
      <h1>{author.name}</h1>
      <p>{author.profile}</p>
    </div>
  );
};
export default AuthorDetail;

// SSR
export const getServerSideProps: GetServerSideProps<Props, Params> = async (
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
