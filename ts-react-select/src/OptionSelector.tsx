import { useCallback } from 'react'
import Select, { Props as SelectProps } from 'react-select'

export type Option = {
  value: string;
  label: string;
}

// eslint-disable-next-line react-refresh/only-export-components
export const options: Option[] = [
  { value: '1', label: 'Option 1' },
  { value: '2', label: 'Option 2' },
  { value: '3', label: 'Option 3' },
];

type OnChangeSelect = Required<SelectProps<Option, false>>['onChange'];

export type OptionSelectorProps = {
  value: Option | undefined;
  onChange: (option: Option | undefined) => void;
};

function* inputIdGenerator(): Generator<string, string, string> {
  let id = 1;
  while (true) {
    yield `option_selector_${id++}`;
  }
}
const inputIdIterator = inputIdGenerator();

// eslint-disable-next-line react-refresh/only-export-components
export function getReactSelectInputElement(el: HTMLElement | undefined | null): HTMLInputElement {
  if (!el) throw new Error('Element is null');
  if (el.dataset.testid !== 'OptionSelector') throw new Error('Element is not OptionSelector');
  if (typeof el.dataset.inputid === 'undefined') throw new Error('InputId is empty');
  const input = el.querySelector<HTMLInputElement>(`#${el.dataset.inputid}`);
  if (!input) throw new Error('input element not found');
  return input;
}

export default function OptionSelector({ value, onChange }: OptionSelectorProps) {
  const onChangeSelect = useCallback<OnChangeSelect>((option) => {
    onChange(option || undefined);
  }, [onChange]);

  const inputId = inputIdIterator.next().value;

  return (
    <div data-inputid={inputId} data-testid="OptionSelector">
      <label htmlFor={inputId}>Select an option:</label>
      <Select
        value={value}
        options={options}
        onChange={onChangeSelect}
        inputId={inputId}
      />
    </div>
  )
}
