import { Dispatch, Action } from 'redux';
import { connect } from 'react-redux';
import { RootState } from '../store';
import { incrementCount, decrementCount } from "../actions/countActions";
import { GetInitialProps } from '../lib/withRedux';

type DetailPropsFromNext = {
  id: string;
};

type DetailPropsFromState = {
  count: number;
};

type DetailPropsFromAction = {
  incrementCount: (value?: number) => Action;
  decrementCount: (value?: number) => Action;
};

type DetailProps = DetailPropsFromNext & DetailPropsFromState & DetailPropsFromAction;

export const Detail = ({ id, incrementCount, decrementCount, count }: DetailProps) => {
  return (
    <div>
      <p>detail: { id }</p>
      <button onClick={ () => incrementCount() } className="home__button">increment store value: { count }</button>
      <button onClick={ () => decrementCount() } className="home__button">decrement store value: { count }</button>
    </div>
  );
};

const getInitialProps: GetInitialProps<DetailPropsFromNext> = async (context) => {
  const { id } = context.query;
  if (typeof id !== 'string') throw new TypeError(`invalid value: ${JSON.stringify(id)}`);
  const actions = mapDispatchToProps(context.store.dispatch);
  actions.incrementCount(10);
  return { id };
};

const mapStateToProps = (state: RootState): DetailPropsFromState => {
  return {
    count: state.count.count,
  };
};

const mapDispatchToProps = (dispatch: Dispatch): DetailPropsFromAction => ({
  incrementCount: (value?: number) => dispatch(incrementCount(value)),
  decrementCount: (value?: number) => dispatch(decrementCount(value)),
});

Detail.getInitialProps = getInitialProps;
export default connect(mapStateToProps, mapDispatchToProps)(Detail);
