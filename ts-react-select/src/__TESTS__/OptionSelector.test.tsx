import { render, screen } from '@testing-library/react';
import selectEvent from 'react-select-event';
import OptionSelector, { Option, OptionSelectorProps, getReactSelectInputElement, options } from '../OptionSelector';

function literal<T>(value: T) { return value }

describe('getReactSelectElement()', () => {
  describe('when element is null', () => {
    it('throws an error', () => {
      expect(() => getReactSelectInputElement(null)).toThrow('Element is null');
    });
  });

  describe('when element is not OptionSelector', () => {
    it('throws an error', () => {
      const el = document.createElement('div');
      expect(() => getReactSelectInputElement(el)).toThrow('Element is not OptionSelector');
    });
  });

  describe("when element's inputId is empty", () => {
    it('throws an error', () => {
      const el = document.createElement('div');
      el.dataset.testid = 'OptionSelector';
      expect(() => getReactSelectInputElement(el)).toThrow('InputId is empty');
    });
  });

  describe("when element's input element not found", () => {
    it('throws an error', () => {
      const el = document.createElement('div');
      el.dataset.testid = 'OptionSelector';
      el.dataset.inputid = 'inputId';
      expect(() => getReactSelectInputElement(el)).toThrow('input element not found');
    });
  });

  describe('when element is valid', () => {
    it('returns input element', () => {
      const el = document.createElement('div');
      el.dataset.testid = 'OptionSelector';
      el.dataset.inputid = 'inputId';
      const input = document.createElement('input');
      input.id = 'inputId';
      el.appendChild(input);
      expect(getReactSelectInputElement(el)).toBe(input);
    });
  });
});

describe('<OptionSelector />', () => {
  describe('when specified title prop', () => {
    describe('when selected value', () => {
      it('calls onChange() prop with selected value', async () => {
        let option: Option | undefined = undefined;
        const onChange = jest.fn(literal<OptionSelectorProps['onChange']>((newOption) => {
          option = newOption;
        }));

        render(<OptionSelector title="option" value={option} onChange={onChange} />);

        await selectEvent.select(
          screen.getByLabelText('option:'),
          [options[1].label]
        );

        expect(onChange).toHaveBeenCalledTimes(1);
        expect(option).toBe(options[1]);
      });
    });
  });

  describe('when did not specify title prop', () => {
    describe('when selected value', () => {
      it('calls onChange() prop with selected value', async () => {
        let option: Option | undefined = undefined;
        const onChange = jest.fn(literal<OptionSelectorProps['onChange']>((newOption) => {
          option = newOption;
        }));

        render(<OptionSelector value={option} onChange={onChange} />);

        await selectEvent.select(
          getReactSelectInputElement(screen.getByTestId('OptionSelector')),
          [options[1].label]
        );

        expect(onChange).toHaveBeenCalledTimes(1);
        expect(option).toBe(options[1]);
      });
    });
  });
});
