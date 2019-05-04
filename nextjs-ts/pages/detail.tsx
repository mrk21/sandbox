import { NextDocumentContext } from 'next/document';

type DetailInitialProps = {
  id: string;
}

type DetailProps = DetailInitialProps & {

}

export const Detail = ({ id }: DetailProps) => {
  return (
    <div>
      <p>detail: { id }</p>
    </div>
  );
};

Detail.getInitialProps = async (context: NextDocumentContext): Promise<DetailInitialProps> => {
  const { id } = context.query;
  if (typeof id !== 'string') throw new TypeError(`invalid value: ${JSON.stringify(id)}`);
  return { id };
};

export default Detail;
