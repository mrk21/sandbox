export const Detail = ({ id }) => {
  return (
    <div>
      <p>detail: { id }</p>
    </div>
  );
};
Detail.getInitialProps = async (params) => {
  return { id: params.query.id };
};
export default Detail;
