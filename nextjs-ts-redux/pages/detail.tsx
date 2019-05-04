import { Dispatch, Action } from 'redux';
import { RootState } from '../store';
import { connect } from 'react-redux';
import { incrementCount, decrementCount } from "../actions/countActions";
import { GetInitialProps } from '../lib/withRedux';

type DetailInitialProps = {
  id: string;
};

type DetailPropsFromState = {
  count: number;
};

type DetailPropsFromAction = {
  incrementCount: () => Action;
  decrementCount: () => Action;
};

type DetailProps = DetailInitialProps & DetailPropsFromState & DetailPropsFromAction;

export const Detail = ({ id, incrementCount, decrementCount, count }: DetailProps) => {
  return (
    <div>
      <p>detail: { id }</p>
      <button onClick={ incrementCount } className="home__button">increment store value: { count }</button>
      <button onClick={ decrementCount } className="home__button">decrement store value: { count }</button>
    </div>
  );
};

const getInitialProps: GetInitialProps<DetailInitialProps> = async (context) => {
  const { id } = context.query;
  if (typeof id !== 'string') throw new TypeError(`invalid value: ${JSON.stringify(id)}`);
  return { id };
};

const mapStateToProps = (state: RootState): DetailPropsFromState => {
  return {
    count: state.count.count,
  };
};

const mapDispatchToProps = (dispatch: Dispatch): DetailPropsFromAction => ({
  incrementCount: () => dispatch(incrementCount()),
  decrementCount: () => dispatch(decrementCount()),
});

Detail.getInitialProps = getInitialProps;
export default connect(mapStateToProps, mapDispatchToProps)(Detail);
